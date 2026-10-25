import 'dart:io';

import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/config/app_config.dart';
import '../../core/utils/random_indexes.dart';
import '../filters/media_filter.dart';
import 'gallery_photo.dart';
import 'gallery_service.dart';

class PhotoManagerGalleryService implements GalleryService {
  // Ask for images + videos once so premium filters don't re-prompt later.
  static const _permissionOption = PermissionRequestOption(
    androidPermission: AndroidPermission(
      type: RequestType.common,
      mediaLocation: false,
    ),
  );

  final _assets = <String, AssetEntity>{};

  // Videos at or above this size count as "large".
  static const largeVideoBytes = 50 * 1024 * 1024;

  // Large videos (oldest first) with their sizes; found by one scan.
  Future<List<(AssetEntity, int)>>? _largeVideos;

  // LRU of in-flight or finished thumbnail loads, keyed by "id@size".
  final _thumbnails = <String, Future<Uint8List?>>{};

  @override
  Future<GalleryAccess> checkAccess() async {
    final state = await PhotoManager.getPermissionState(
      requestOption: _permissionOption,
    );
    return _toAccess(state);
  }

  @override
  Future<GalleryAccess> requestAccess() async {
    final state = await PhotoManager.requestPermissionExtend(
      requestOption: _permissionOption,
    );
    return _toAccess(state);
  }

  @override
  Future<void> openSettings() => PhotoManager.openSetting();

  @override
  Future<List<GalleryPhoto>> randomPhotos(int count) async {
    final paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
    );
    if (paths.isEmpty) return const [];

    // One parallel fetch per random index; never load the whole gallery.
    final all = paths.first;
    final total = await all.assetCountAsync;
    final pages = await Future.wait([
      for (final index in pickRandomIndexes(total, count))
        all.getAssetListRange(start: index, end: index + 1),
    ]);
    return [
      for (final page in pages)
        if (page.isNotEmpty) _remember(page.first),
    ];
  }

  @override
  Future<int> count(MediaFilter filter) async {
    if (filter.category == MediaCategory.largeVideos) {
      return (await _scanLargeVideos()).length;
    }
    return await (await _path(filter))?.assetCountAsync ?? 0;
  }

  @override
  Future<List<GalleryPhoto>> page(
    MediaFilter filter, {
    required int start,
    required int size,
  }) async {
    if (filter.category == MediaCategory.largeVideos) {
      final videos = await _scanLargeVideos();
      return [
        for (final (asset, _) in videos.skip(start).take(size))
          _remember(asset),
      ];
    }
    final path = await _path(filter);
    if (path == null) return const [];
    final assets = await path.getAssetListRange(
      start: start,
      end: start + size,
    );
    return [for (final asset in assets) _remember(asset)];
  }

  @override
  Future<CategorySummary> summary(MediaFilter filter) async {
    if (filter.category == MediaCategory.largeVideos) {
      final videos = await _scanLargeVideos();
      return CategorySummary(
        count: videos.length,
        bytes: videos.fold(0, (sum, video) => sum + video.$2),
      );
    }
    final path = await _path(filter);
    if (path == null) return CategorySummary.empty;
    final total = await path.assetCountAsync;
    var bytes = 0;
    for (var start = 0; start < total; start += _scanPage) {
      final assets = await path.getAssetListRange(
        start: start,
        end: start + _scanPage,
      );
      bytes += (await Future.wait(assets.map(_sizeOf))).fold(0, _sum);
    }
    return CategorySummary(count: total, bytes: bytes);
  }

  static const _scanPage = 200;
  static int _sum(int a, int b) => a + b;

  Future<int> _sizeOf(AssetEntity asset) async {
    try {
      return await asset.fileSize;
    } on Exception {
      return 0;
    }
  }

  // Oldest first so stale items surface before recent ones.
  static final _oldestFirst = FilterOptionGroup(
    orders: [const OrderOption(type: OrderOptionType.createDate, asc: true)],
  );

  Future<AssetPathEntity?> _path(MediaFilter filter) async {
    switch (filter.category) {
      case MediaCategory.screenshots:
        return _smartAlbum(
          RequestType.image,
          PMDarwinAssetCollectionSubtype.smartAlbumScreenshots,
          androidName: 'screenshot',
        );
      case MediaCategory.screenRecordings:
        // iOS 18+ has a smart album; Android keeps them in a named folder.
        return _smartAlbum(
          RequestType.video,
          PMDarwinAssetCollectionSubtype.smartAlbumScreenRecordings,
          androidName: 'screen',
        );
      case MediaCategory.dateRange:
        final range = filter.range!;
        final paths = await PhotoManager.getAssetPathList(
          onlyAll: true,
          type: RequestType.image,
          filterOption: FilterOptionGroup(
            createTimeCond: DateTimeCond(
              min: range.start,
              max: DateTime(range.end.year, range.end.month, range.end.day + 1),
            ),
            orders: _oldestFirst.orders,
          ),
        );
        return paths.firstOrNull;
      case MediaCategory.largeVideos:
        throw StateError('Large videos are scanned, not a single album');
    }
  }

  Future<AssetPathEntity?> _smartAlbum(
    RequestType type,
    PMDarwinAssetCollectionSubtype darwinSubtype, {
    required String androidName,
  }) async {
    if (Platform.isIOS) {
      final paths = await PhotoManager.getAssetPathList(
        hasAll: false,
        type: type,
        filterOption: _oldestFirst,
        pathFilterOption: PMPathFilter(
          darwin: PMDarwinPathFilter(
            type: const [PMDarwinAssetCollectionType.smartAlbum],
            subType: [darwinSubtype],
          ),
        ),
      );
      return paths.firstOrNull;
    }
    final paths = await PhotoManager.getAssetPathList(
      hasAll: false,
      type: type,
      filterOption: _oldestFirst,
    );
    return paths
        .where((path) => path.name.toLowerCase().contains(androidName))
        .firstOrNull;
  }

  Future<List<(AssetEntity, int)>> _scanLargeVideos() {
    return _largeVideos ??= () async {
      final paths = await PhotoManager.getAssetPathList(
        onlyAll: true,
        type: RequestType.video,
        filterOption: _oldestFirst,
      );
      final all = paths.firstOrNull;
      if (all == null) return const <(AssetEntity, int)>[];
      final total = await all.assetCountAsync;
      final found = <(AssetEntity, int)>[];
      for (var start = 0; start < total; start += _scanPage) {
        final assets = await all.getAssetListRange(
          start: start,
          end: start + _scanPage,
        );
        final sizes = await Future.wait(assets.map(_sizeOf));
        for (var i = 0; i < assets.length; i++) {
          if (sizes[i] >= largeVideoBytes) found.add((assets[i], sizes[i]));
        }
      }
      return found;
    }();
  }

  @override
  Future<Uint8List?> thumbnail(String id, int size) {
    final key = '$id@$size';
    final cached = _thumbnails.remove(key);
    if (cached != null) return _thumbnails[key] = cached;

    final load = _loadThumbnail(id, size);
    _thumbnails[key] = load;
    if (_thumbnails.length > AppConfig.thumbnailCacheSize) {
      _thumbnails.remove(_thumbnails.keys.first);
    }
    // Don't cache failures; a later rebuild can retry.
    load.then(
      (bytes) {
        if (bytes == null) _thumbnails.remove(key);
      },
      onError: (Object _) {
        _thumbnails.remove(key);
      },
    );
    return load;
  }

  Future<Uint8List?> _loadThumbnail(String id, int size) async {
    final asset = await _asset(id);
    return asset?.thumbnailDataWithSize(ThumbnailSize.square(size));
  }

  @override
  Future<int?> fileSize(String id) async {
    try {
      return await (await _asset(id))?.fileSize;
    } on Exception {
      return null;
    }
  }

  @override
  Future<List<String>> deletePhotos(List<String> ids) async {
    if (Platform.isAndroid) {
      // Android 11+: system trash keeps photos restorable for 30 days.
      try {
        final assets = [for (final id in ids) ?await _asset(id)];
        final trashed = await PhotoManager.editor.android.moveToTrash(assets);
        trashed.forEach(_forget);
        return trashed;
      } on PlatformException {
        // Android 10 and below have no trash; fall through to delete.
      }
    }
    // iOS moves deleted photos to "Recently Deleted".
    final deleted = await PhotoManager.editor.deleteWithIds(ids);
    deleted.forEach(_forget);
    return deleted;
  }

  GalleryPhoto _remember(AssetEntity asset) {
    _assets[asset.id] = asset;
    return GalleryPhoto(
      id: asset.id,
      createdAt: asset.createDateTime,
      duration: asset.type == AssetType.video ? asset.videoDuration : null,
    );
  }

  void _forget(String id) {
    _assets.remove(id);
    _largeVideos = null;
    _thumbnails.removeWhere((key, _) => key.startsWith('$id@'));
  }

  Future<AssetEntity?> _asset(String id) async {
    final cached = _assets[id];
    if (cached != null) return cached;
    final asset = await AssetEntity.fromId(id);
    if (asset != null) _assets[id] = asset;
    return asset;
  }

  static GalleryAccess _toAccess(PermissionState state) => switch (state) {
    PermissionState.authorized => GalleryAccess.granted,
    PermissionState.limited => GalleryAccess.limited,
    PermissionState.notDetermined => GalleryAccess.undetermined,
    PermissionState.denied ||
    PermissionState.restricted => GalleryAccess.denied,
  };
}

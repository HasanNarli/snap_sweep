import 'dart:io';

import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/config/app_config.dart';
import '../../core/utils/random_indexes.dart';
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
    return GalleryPhoto(id: asset.id, createdAt: asset.createDateTime);
  }

  void _forget(String id) {
    _assets.remove(id);
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

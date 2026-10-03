import 'dart:io';

import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';

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

    // Fetch one asset per random index; never load the whole gallery.
    final all = paths.first;
    final total = await all.assetCountAsync;
    final photos = <GalleryPhoto>[];
    for (final index in pickRandomIndexes(total, count)) {
      final page = await all.getAssetListRange(start: index, end: index + 1);
      if (page.isEmpty) continue;
      final asset = page.first;
      _assets[asset.id] = asset;
      photos.add(GalleryPhoto(id: asset.id, createdAt: asset.createDateTime));
    }
    return photos;
  }

  @override
  Future<Uint8List?> thumbnail(String id, int size) async {
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
        return await PhotoManager.editor.android.moveToTrash(assets);
      } on PlatformException {
        // Android 10 and below have no trash; fall through to delete.
      }
    }
    // iOS moves deleted photos to "Recently Deleted".
    final deleted = await PhotoManager.editor.deleteWithIds(ids);
    deleted.forEach(_assets.remove);
    return deleted;
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

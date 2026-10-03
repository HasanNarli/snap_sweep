import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'gallery_photo.dart';

enum GalleryAccess {
  granted,
  limited,
  denied,
  undetermined;

  bool get canBrowse => this == granted || this == limited;
}

// Platform gallery access; faked in tests.
abstract interface class GalleryService {
  Future<GalleryAccess> checkAccess();
  Future<GalleryAccess> requestAccess();
  Future<void> openSettings();
  Future<List<GalleryPhoto>> randomPhotos(int count);
  Future<Uint8List?> thumbnail(String id, int size);
  Future<int?> fileSize(String id);
}

// Overridden in main() with the real implementation.
final galleryServiceProvider = Provider<GalleryService>(
  (ref) => throw UnimplementedError('galleryServiceProvider not overridden'),
);

import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../filters/media_filter.dart';
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

  // Premium filters: oldest first, paged so the gallery is never loaded whole.
  Future<int> count(MediaFilter filter);
  Future<List<GalleryPhoto>> page(
    MediaFilter filter, {
    required int start,
    required int size,
  });
  Future<CategorySummary> summary(MediaFilter filter);

  Future<Uint8List?> thumbnail(String id, int size);
  Future<int?> fileSize(String id);

  // Shows the system confirmation; returns ids actually removed.
  Future<List<String>> deletePhotos(List<String> ids);
}

// Overridden in main() with the real implementation.
final galleryServiceProvider = Provider<GalleryService>(
  (ref) => throw UnimplementedError('galleryServiceProvider not overridden'),
);

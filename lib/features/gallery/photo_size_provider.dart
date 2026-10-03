import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'gallery_service.dart';

// File size in bytes; null when the platform can't tell.
final photoSizeProvider = FutureProvider.autoDispose.family<int?, String>(
  (ref, id) => ref.read(galleryServiceProvider).fileSize(id),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../gallery/gallery_service.dart';
import 'media_filter.dart';

// Count and size per category for home; invalidated after a cleanup.
final categorySummaryProvider = FutureProvider.autoDispose
    .family<CategorySummary, MediaFilter>(
      (ref, filter) => ref.read(galleryServiceProvider).summary(filter),
    );

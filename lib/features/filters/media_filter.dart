import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show DateTimeRange;

enum MediaCategory { screenshots, largeVideos, screenRecordings, dateRange }

// What a premium session swipes through; null means the free daily mix.
@immutable
class MediaFilter {
  const MediaFilter(this.category, {this.range})
    : assert(category != MediaCategory.dateRange || range != null);

  const MediaFilter.dateRange(DateTimeRange this.range)
    : category = MediaCategory.dateRange;

  final MediaCategory category;
  final DateTimeRange? range;

  @override
  bool operator ==(Object other) =>
      other is MediaFilter &&
      other.category == category &&
      other.range == range;

  @override
  int get hashCode => Object.hash(category, range);
}

// Item count and total bytes of a category, shown on home.
@immutable
class CategorySummary {
  const CategorySummary({required this.count, required this.bytes});

  static const empty = CategorySummary(count: 0, bytes: 0);

  final int count;
  final int bytes;
}

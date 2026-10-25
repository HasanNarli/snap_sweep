import 'package:flutter/foundation.dart';

@immutable
class GalleryPhoto {
  const GalleryPhoto({
    required this.id,
    required this.createdAt,
    this.duration,
  });

  final String id;
  final DateTime createdAt;

  // Set for videos only.
  final Duration? duration;

  bool get isVideo => duration != null;

  @override
  bool operator ==(Object other) => other is GalleryPhoto && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

import 'package:flutter/foundation.dart';

@immutable
class GalleryPhoto {
  const GalleryPhoto({required this.id, required this.createdAt});

  final String id;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) => other is GalleryPhoto && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

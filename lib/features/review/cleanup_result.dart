import 'package:flutter/foundation.dart';

@immutable
class CleanupResult {
  const CleanupResult({required this.photosDeleted, required this.bytesFreed});

  final int photosDeleted;
  final int bytesFreed;
}

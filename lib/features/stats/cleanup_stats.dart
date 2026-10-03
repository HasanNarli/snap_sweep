import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/preferences.dart';

@immutable
class CleanupStats {
  const CleanupStats({required this.photosDeleted, required this.bytesFreed});

  final int photosDeleted;
  final int bytesFreed;
}

// Lifetime totals shown on home.
final cleanupStatsProvider =
    NotifierProvider<CleanupStatsNotifier, CleanupStats>(
      CleanupStatsNotifier.new,
    );

class CleanupStatsNotifier extends Notifier<CleanupStats> {
  static const _photosKey = 'stats_photos_deleted';
  static const _bytesKey = 'stats_bytes_freed';

  @override
  CleanupStats build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return CleanupStats(
      photosDeleted: prefs.getInt(_photosKey) ?? 0,
      bytesFreed: prefs.getInt(_bytesKey) ?? 0,
    );
  }

  Future<void> record({required int photos, required int bytes}) async {
    final next = CleanupStats(
      photosDeleted: state.photosDeleted + photos,
      bytesFreed: state.bytesFreed + bytes,
    );
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_photosKey, next.photosDeleted);
    await prefs.setInt(_bytesKey, next.bytesFreed);
    state = next;
  }
}

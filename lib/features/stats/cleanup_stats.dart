import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/clock.dart';
import '../../core/storage/preferences.dart';

@immutable
class CleanupStats {
  const CleanupStats({
    required this.photosDeleted,
    required this.bytesFreed,
    required this.sessions,
    required this.bytesThisWeek,
  });

  final int photosDeleted;
  final int bytesFreed;
  final int sessions;
  final int bytesThisWeek;

  int get averagePhotoBytes =>
      photosDeleted == 0 ? 0 : bytesFreed ~/ photosDeleted;
}

// Lifetime totals shown on home.
final cleanupStatsProvider =
    NotifierProvider<CleanupStatsNotifier, CleanupStats>(
      CleanupStatsNotifier.new,
    );

class CleanupStatsNotifier extends Notifier<CleanupStats> {
  static const _photosKey = 'stats_photos_deleted';
  static const _bytesKey = 'stats_bytes_freed';
  static const _sessionsKey = 'stats_sessions';
  // Daily entries "yyyy-mm-dd|bytes" for the weekly figure; last 30 days.
  static const _logKey = 'stats_daily_log';

  DateTime _now() => ref.read(clockProvider)();

  @override
  CleanupStats build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return CleanupStats(
      photosDeleted: prefs.getInt(_photosKey) ?? 0,
      bytesFreed: prefs.getInt(_bytesKey) ?? 0,
      sessions: prefs.getInt(_sessionsKey) ?? 0,
      bytesThisWeek: _weekTotal(prefs.getStringList(_logKey) ?? const []),
    );
  }

  Future<void> record({required int photos, required int bytes}) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final log = _appendToLog(prefs.getStringList(_logKey) ?? const [], bytes);
    final next = CleanupStats(
      photosDeleted: state.photosDeleted + photos,
      bytesFreed: state.bytesFreed + bytes,
      sessions: state.sessions + 1,
      bytesThisWeek: _weekTotal(log),
    );
    await prefs.setInt(_photosKey, next.photosDeleted);
    await prefs.setInt(_bytesKey, next.bytesFreed);
    await prefs.setInt(_sessionsKey, next.sessions);
    await prefs.setStringList(_logKey, log);
    state = next;
  }

  List<String> _appendToLog(List<String> log, int bytes) {
    final today = dayKey(_now());
    final entries = {
      for (final line in log)
        if (line.split('|') case [final day, final value])
          day: int.tryParse(value) ?? 0,
    };
    entries[today] = (entries[today] ?? 0) + bytes;
    final cutoff = dayKey(_now().subtract(const Duration(days: 30)));
    return [
      for (final MapEntry(:key, :value) in entries.entries)
        if (key.compareTo(cutoff) > 0) '$key|$value',
    ];
  }

  int _weekTotal(List<String> log) {
    final cutoff = dayKey(_now().subtract(const Duration(days: 7)));
    var total = 0;
    for (final line in log) {
      if (line.split('|') case [final day, final value]
          when day.compareTo(cutoff) > 0) {
        total += int.tryParse(value) ?? 0;
      }
    }
    return total;
  }
}

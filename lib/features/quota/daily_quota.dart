import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/clock.dart';
import '../../core/config/app_config.dart';
import '../../core/storage/preferences.dart';

@immutable
class DailyQuota {
  const DailyQuota({required this.day, required this.used, this.bonus = 0});

  final String day;
  final int used;

  // Extra swipes earned today (rewarded ads, phase 6).
  final int bonus;

  int get limit => AppConfig.freeDailySwipes + bonus;
  int get remaining => (limit - used).clamp(0, limit);
  bool get isExhausted => remaining == 0;
}

final dailyQuotaProvider = NotifierProvider<DailyQuotaNotifier, DailyQuota>(
  DailyQuotaNotifier.new,
);

// One swipe = one decision. Undo refunds it. Resets at local midnight.
class DailyQuotaNotifier extends Notifier<DailyQuota> {
  static const _dayKey = 'quota_day';
  static const _usedKey = 'quota_used';
  static const _bonusKey = 'quota_bonus';

  @override
  DailyQuota build() {
    final listener = AppLifecycleListener(onResume: ensureToday);
    ref.onDispose(listener.dispose);

    final prefs = ref.read(sharedPreferencesProvider);
    final today = _today();
    if (prefs.getString(_dayKey) != today) {
      return DailyQuota(day: today, used: 0);
    }
    return DailyQuota(
      day: today,
      used: prefs.getInt(_usedKey) ?? 0,
      bonus: prefs.getInt(_bonusKey) ?? 0,
    );
  }

  // Rolls over to a fresh quota after midnight.
  void ensureToday() {
    final today = _today();
    if (state.day != today) _save(DailyQuota(day: today, used: 0));
  }

  void consume() {
    ensureToday();
    _save(DailyQuota(day: state.day, used: state.used + 1, bonus: state.bonus));
  }

  void refund() {
    ensureToday();
    if (state.used == 0) return;
    _save(DailyQuota(day: state.day, used: state.used - 1, bonus: state.bonus));
  }

  String _today() => dayKey(ref.read(clockProvider)());

  void _save(DailyQuota quota) {
    state = quota;
    ref.read(sharedPreferencesProvider)
      ..setString(_dayKey, quota.day)
      ..setInt(_usedKey, quota.used)
      ..setInt(_bonusKey, quota.bonus);
  }
}

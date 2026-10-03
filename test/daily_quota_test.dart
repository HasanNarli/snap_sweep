import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snap_sweep/features/quota/daily_quota.dart';

import 'helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestClock clock;

  Future<ProviderContainer> create({
    Map<String, Object> prefs = const {},
  }) async {
    final container = ProviderContainer(
      overrides: await testOverrides(prefs: prefs, clock: clock),
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() => clock = TestClock());

  test('starts with the full daily limit', () async {
    final container = await create();
    expect(container.read(dailyQuotaProvider).remaining, 15);
  });

  test('consume and refund adjust the remaining count', () async {
    final container = await create();
    final quota = container.read(dailyQuotaProvider.notifier);
    quota
      ..consume()
      ..consume()
      ..consume()
      ..refund();
    expect(container.read(dailyQuotaProvider).remaining, 13);
  });

  test('usage persists for the same day', () async {
    final container = await create(
      prefs: {'quota_day': '2026-10-04', 'quota_used': 9},
    );
    expect(container.read(dailyQuotaProvider).remaining, 6);
  });

  test('yesterday\'s usage is ignored on startup', () async {
    final container = await create(
      prefs: {'quota_day': '2026-10-03', 'quota_used': 15},
    );
    expect(container.read(dailyQuotaProvider).remaining, 15);
  });

  test('rolls over at midnight while running', () async {
    final container = await create();
    final quota = container.read(dailyQuotaProvider.notifier);
    for (var i = 0; i < 15; i++) {
      quota.consume();
    }
    expect(container.read(dailyQuotaProvider).isExhausted, isTrue);

    clock.now = DateTime(2026, 10, 5, 0, 1);
    quota.ensureToday();
    expect(container.read(dailyQuotaProvider).remaining, 15);
  });

  test('never goes below zero or refunds past zero', () async {
    final container = await create();
    final quota = container.read(dailyQuotaProvider.notifier)..refund();
    expect(container.read(dailyQuotaProvider).used, 0);
    for (var i = 0; i < 20; i++) {
      quota.consume();
    }
    expect(container.read(dailyQuotaProvider).remaining, 0);
  });
}

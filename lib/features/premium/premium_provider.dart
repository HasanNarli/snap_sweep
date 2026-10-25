import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import 'purchase_service.dart';

// Whether premium features are unlocked. Starts locked and updates once the
// store answers, so launch never waits on the network.
final premiumProvider = NotifierProvider<PremiumNotifier, bool>(
  PremiumNotifier.new,
);

class PremiumNotifier extends Notifier<bool> {
  @override
  bool build() {
    // Test flag from env/local.json; release builds ignore it.
    if (AppConfig.forcePremium && !kReleaseMode) return true;

    final service = ref.read(purchaseServiceProvider);
    final subscription = service.premiumChanges.listen(_set);
    ref.onDispose(subscription.cancel);
    unawaited(service.isPremium().then(_set));
    return false;
  }

  void _set(bool premium) {
    if (ref.mounted) state = premium;
  }

  Future<PurchaseOutcome> buy(PremiumPlan plan) async {
    final outcome = await ref.read(purchaseServiceProvider).buy(plan);
    if (outcome == PurchaseOutcome.purchased) _set(true);
    return outcome;
  }

  Future<bool> restore() async {
    final restored = await ref.read(purchaseServiceProvider).restore();
    if (restored) _set(true);
    return restored;
  }
}

// Store plans for the paywall; refetched each time it opens.
final premiumPlansProvider = FutureProvider.autoDispose<List<PremiumPlan>>(
  (ref) => ref.read(purchaseServiceProvider).plans(),
);

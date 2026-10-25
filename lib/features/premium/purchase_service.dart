import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PlanKind { yearly, lifetime }

// A store product the paywall can sell; prices come localized from the store.
@immutable
class PremiumPlan {
  const PremiumPlan({
    required this.id,
    required this.kind,
    required this.price,
    this.pricePerMonth,
  });

  final String id;
  final PlanKind kind;
  final String price;

  // Yearly plans only, e.g. "₺41,58".
  final String? pricePerMonth;
}

enum PurchaseOutcome { purchased, cancelled, failed }

// App Store / Google Play purchases; faked in tests.
abstract interface class PurchaseService {
  Future<bool> isPremium();

  // Fires when a renewal, expiry or another device changes the entitlement.
  Stream<bool> get premiumChanges;

  // Empty when the store can't be reached or nothing is configured.
  Future<List<PremiumPlan>> plans();

  Future<PurchaseOutcome> buy(PremiumPlan plan);

  // True when an earlier purchase was found.
  Future<bool> restore();
}

// Overridden in main() with the real implementation.
final purchaseServiceProvider = Provider<PurchaseService>(
  (ref) => throw UnimplementedError('purchaseServiceProvider not overridden'),
);

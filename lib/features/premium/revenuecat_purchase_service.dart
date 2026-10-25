import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'purchase_service.dart';

// RevenueCat on top of StoreKit / Play Billing. Without an API key (see
// env/local.example.json) it stays unconfigured: free tier, no plans.
class RevenueCatPurchaseService implements PurchaseService {
  static const _entitlement = 'premium';
  static const _iosKey = String.fromEnvironment('REVENUECAT_IOS_KEY');
  static const _androidKey = String.fromEnvironment('REVENUECAT_ANDROID_KEY');

  final _changes = StreamController<bool>.broadcast();
  final _packages = <String, Package>{};
  bool _configured = false;

  Future<void> init() async {
    final key = Platform.isIOS ? _iosKey : _androidKey;
    if (key.isEmpty) return;
    await Purchases.configure(PurchasesConfiguration(key));
    _configured = true;
    Purchases.addCustomerInfoUpdateListener(
      (info) => _changes.add(_hasPremium(info)),
    );
  }

  @override
  Stream<bool> get premiumChanges => _changes.stream;

  @override
  Future<bool> isPremium() async {
    if (!_configured) return false;
    try {
      return _hasPremium(await Purchases.getCustomerInfo());
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<List<PremiumPlan>> plans() async {
    if (!_configured) return const [];
    try {
      final offering = (await Purchases.getOfferings()).current;
      if (offering == null) return const [];
      return [
        if (offering.annual case final annual?) _plan(annual, PlanKind.yearly),
        if (offering.lifetime case final lifetime?)
          _plan(lifetime, PlanKind.lifetime),
      ];
    } on PlatformException {
      return const [];
    }
  }

  @override
  Future<PurchaseOutcome> buy(PremiumPlan plan) async {
    final package = _packages[plan.id];
    if (package == null) return PurchaseOutcome.failed;
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      return _hasPremium(result.customerInfo)
          ? PurchaseOutcome.purchased
          : PurchaseOutcome.failed;
    } on PlatformException catch (e) {
      return PurchasesErrorHelper.getErrorCode(e) ==
              PurchasesErrorCode.purchaseCancelledError
          ? PurchaseOutcome.cancelled
          : PurchaseOutcome.failed;
    }
  }

  @override
  Future<bool> restore() async {
    if (!_configured) return false;
    try {
      return _hasPremium(await Purchases.restorePurchases());
    } on PlatformException {
      return false;
    }
  }

  PremiumPlan _plan(Package package, PlanKind kind) {
    _packages[package.identifier] = package;
    final product = package.storeProduct;
    return PremiumPlan(
      id: package.identifier,
      kind: kind,
      price: product.priceString,
      pricePerMonth: kind == PlanKind.yearly
          ? product.pricePerMonthString
          : null,
    );
  }

  static bool _hasPremium(CustomerInfo info) =>
      info.entitlements.active.containsKey(_entitlement);
}

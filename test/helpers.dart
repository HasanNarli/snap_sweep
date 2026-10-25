import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_sweep/app.dart';
import 'package:snap_sweep/core/clock.dart';
import 'package:snap_sweep/core/storage/preferences.dart';
import 'package:snap_sweep/features/filters/media_filter.dart';
import 'package:snap_sweep/features/gallery/gallery_access_provider.dart';
import 'package:snap_sweep/features/gallery/gallery_photo.dart';
import 'package:snap_sweep/features/gallery/gallery_service.dart';
import 'package:snap_sweep/features/premium/purchase_service.dart';

class FakeGalleryService implements GalleryService {
  FakeGalleryService({
    this.access = GalleryAccess.undetermined,
    this.accessOnRequest = GalleryAccess.granted,
    int photoCount = 3,
  }) : photos = [
         for (var i = 0; i < photoCount; i++)
           GalleryPhoto(id: 'photo-$i', createdAt: DateTime(2026, 1, i + 1)),
       ];

  GalleryAccess access;
  GalleryAccess accessOnRequest;
  final List<GalleryPhoto> photos;
  int openSettingsCalls = 0;

  @override
  Future<GalleryAccess> checkAccess() async => access;

  @override
  Future<GalleryAccess> requestAccess() async => access = accessOnRequest;

  @override
  Future<void> openSettings() async => openSettingsCalls++;

  @override
  Future<List<GalleryPhoto>> randomPhotos(int count) async =>
      photos.take(count).toList();

  // Photos per premium category; date ranges filter [photos].
  final categories = <MediaCategory, List<GalleryPhoto>>{};

  // Every page request as "start+size".
  final pageRequests = <String>[];

  List<GalleryPhoto> _matching(MediaFilter filter) {
    final range = filter.range;
    if (range == null) return categories[filter.category] ?? const [];
    return [
      for (final photo in photos)
        if (!photo.createdAt.isBefore(range.start) &&
            photo.createdAt.isBefore(range.end.add(const Duration(days: 1))))
          photo,
    ];
  }

  @override
  Future<int> count(MediaFilter filter) async => _matching(filter).length;

  @override
  Future<List<GalleryPhoto>> page(
    MediaFilter filter, {
    required int start,
    required int size,
  }) async {
    pageRequests.add('$start+$size');
    return _matching(filter).skip(start).take(size).toList();
  }

  @override
  Future<CategorySummary> summary(MediaFilter filter) async {
    final count = _matching(filter).length;
    return CategorySummary(count: count, bytes: count * 2 * 1024 * 1024);
  }

  // Every thumbnail request, in order.
  final thumbnailRequests = <String>[];

  @override
  Future<Uint8List?> thumbnail(String id, int size) async {
    thumbnailRequests.add(id);
    return null;
  }

  @override
  Future<int?> fileSize(String id) async => 2 * 1024 * 1024;

  // Simulates the user cancelling the system dialog.
  bool cancelDelete = false;
  final deletedIds = <String>[];

  @override
  Future<List<String>> deletePhotos(List<String> ids) async {
    if (cancelDelete) return const [];
    deletedIds.addAll(ids);
    return ids;
  }
}

// Fixed "now" for tests: a Sunday morning.
final testNow = DateTime(2026, 10, 4, 10);

// Settable clock for day-rollover tests.
class TestClock {
  DateTime now = testNow;
  DateTime call() => now;
}

Future<List<Override>> testOverrides({
  FakeGalleryService? gallery,
  bool onboarded = false,
  Map<String, Object> prefs = const {},
  TestClock? clock,
  bool premium = false,
  FakePurchaseService? purchases,
}) async {
  final fake = gallery ?? FakeGalleryService(access: GalleryAccess.granted);
  final time = clock ?? TestClock();
  SharedPreferences.setMockInitialValues({
    'onboarding_done': onboarded,
    ...prefs,
  });
  final instance = await SharedPreferences.getInstance();
  return [
    sharedPreferencesProvider.overrideWithValue(instance),
    galleryServiceProvider.overrideWithValue(fake),
    initialGalleryAccessProvider.overrideWithValue(fake.access),
    clockProvider.overrideWithValue(time.call),
    purchaseServiceProvider.overrideWithValue(
      purchases ?? FakePurchaseService(premium: premium),
    ),
  ];
}

Widget testApp(List<Override> overrides) =>
    ProviderScope(overrides: overrides, child: const SnapSweepApp());

class FakePurchaseService implements PurchaseService {
  FakePurchaseService({this.premium = false, this.ownsEarlierPurchase = false});

  bool premium;
  bool ownsEarlierPurchase;

  // What the next buy() returns.
  PurchaseOutcome nextOutcome = PurchaseOutcome.purchased;
  List<PremiumPlan> available = const [
    PremiumPlan(
      id: 'yearly',
      kind: PlanKind.yearly,
      price: '₺499,99',
      pricePerMonth: '₺41,67',
    ),
    PremiumPlan(id: 'lifetime', kind: PlanKind.lifetime, price: '₺999,99'),
  ];
  final bought = <String>[];

  @override
  Future<bool> isPremium() async => premium;

  @override
  Stream<bool> get premiumChanges => const Stream.empty();

  @override
  Future<List<PremiumPlan>> plans() async => available;

  @override
  Future<PurchaseOutcome> buy(PremiumPlan plan) async {
    bought.add(plan.id);
    if (nextOutcome == PurchaseOutcome.purchased) premium = true;
    return nextOutcome;
  }

  @override
  Future<bool> restore() async => premium = premium || ownsEarlierPurchase;
}

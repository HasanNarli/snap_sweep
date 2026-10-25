import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/storage/preferences.dart';
import 'features/gallery/gallery_access_provider.dart';
import 'features/gallery/gallery_service.dart';
import 'features/gallery/photo_manager_gallery_service.dart';
import 'features/premium/purchase_service.dart';
import 'features/premium/revenuecat_purchase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final gallery = PhotoManagerGalleryService();
  final access = await gallery.checkAccess();
  final purchases = RevenueCatPurchaseService();
  await purchases.init();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        galleryServiceProvider.overrideWithValue(gallery),
        initialGalleryAccessProvider.overrideWithValue(access),
        purchaseServiceProvider.overrideWithValue(purchases),
      ],
      child: const SnapSweepApp(),
    ),
  );
}

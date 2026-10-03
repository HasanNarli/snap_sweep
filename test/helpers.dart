import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snap_sweep/app.dart';
import 'package:snap_sweep/core/storage/preferences.dart';
import 'package:snap_sweep/features/gallery/gallery_access_provider.dart';
import 'package:snap_sweep/features/gallery/gallery_photo.dart';
import 'package:snap_sweep/features/gallery/gallery_service.dart';

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

  @override
  Future<Uint8List?> thumbnail(String id, int size) async => null;

  @override
  Future<int?> fileSize(String id) async => 2 * 1024 * 1024;
}

Future<List<Override>> testOverrides({
  required FakeGalleryService gallery,
  bool onboarded = false,
}) async {
  SharedPreferences.setMockInitialValues({'onboarding_done': onboarded});
  final prefs = await SharedPreferences.getInstance();
  return [
    sharedPreferencesProvider.overrideWithValue(prefs),
    galleryServiceProvider.overrideWithValue(gallery),
    initialGalleryAccessProvider.overrideWithValue(gallery.access),
  ];
}

Widget testApp(List<Override> overrides) =>
    ProviderScope(overrides: overrides, child: const SnapSweepApp());

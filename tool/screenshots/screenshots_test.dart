// Renders README screenshots from the real app with sample photos.
// Run: flutter test tool/screenshots --update-goldens
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snap_sweep/app.dart';
import 'package:snap_sweep/features/gallery/gallery_photo.dart';
import 'package:snap_sweep/features/gallery/gallery_service.dart';
import 'package:snap_sweep/l10n/app_localizations.dart';

import '../../test/helpers.dart';

const _photoNames = ['rocket', 'cat', 'galaxies', 'coffee'];
const _outDir = '../../docs/screenshots';

// Gallery backed by the bundled sample photos, cycled to fill a session.
class _SampleGallery extends FakeGalleryService {
  _SampleGallery(this.bytes) : super(access: GalleryAccess.granted);

  final List<Uint8List> bytes;

  static const _sizes = [4.2, 3.1, 2.7, 5.6, 1.9, 3.8, 2.3, 4.9, 3.4];

  @override
  Future<List<GalleryPhoto>> randomPhotos(int count) async => [
    for (var i = 0; i < count; i++)
      GalleryPhoto(id: 'photo-$i', createdAt: DateTime(2025, 6 + i % 6, 3 + i)),
  ];

  @override
  Future<Uint8List?> thumbnail(String id, int size) async =>
      bytes[_index(id) % bytes.length];

  @override
  Future<int?> fileSize(String id) async =>
      (_sizes[_index(id) % _sizes.length] * 1024 * 1024).round();

  int _index(String id) => int.parse(id.split('-').last);
}

Future<void> _loadFonts() async {
  final inter = FontLoader('Inter');
  for (final weight in ['Light', 'Regular', 'Medium', 'SemiBold', 'Bold']) {
    inter.addFont(rootBundle.load('assets/fonts/Inter-$weight.ttf'));
  }
  await inter.load();
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await icons.load();
}

// Minimal iOS-style status bar so the top inset doesn't look empty.
class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final color = dark ? const Color(0xFFF2EFE9) : const Color(0xFF1A1A1A);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: 54,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 16, 28, 0),
          child: Row(
            children: [
              Text(
                '9:41',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const Spacer(),
              Icon(Icons.signal_cellular_alt_rounded, size: 18, color: color),
              const SizedBox(width: 5),
              Icon(Icons.wifi_rounded, size: 18, color: color),
              const SizedBox(width: 5),
              Icon(Icons.battery_full_rounded, size: 20, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  late List<Uint8List> photos;

  setUpAll(() async {
    await _loadFonts();
    photos = [
      for (final name in _photoNames)
        File('tool/screenshots/photos/$name.jpg').readAsBytesSync(),
    ];
  });

  // Stats that make the home screen look lived-in.
  final homePrefs = <String, Object>{
    'stats_photos_deleted': 248,
    'stats_bytes_freed': (1.24 * 1024 * 1024 * 1024).round(),
    'stats_sessions': 17,
    'stats_daily_log': [
      '2026-10-01|${180 * 1024 * 1024}',
      '2026-10-03|${132 * 1024 * 1024}',
    ],
    'quota_day': '2026-10-04',
    'quota_used': 6,
  };

  for (final dark in [false, true]) {
    for (final lang in ['en', 'tr']) {
      final suffix = '${lang}_${dark ? 'dark' : 'light'}';
      final l10n = lookupAppLocalizations(Locale(lang));

      Future<void> swipe(WidgetTester tester, List<bool> deletes) async {
        await tester.tap(find.text(l10n.homeStartCleaning));
        await _settle(tester);
        for (final delete in deletes) {
          await tester.tap(
            find.byTooltip(delete ? l10n.swipeDelete : l10n.swipeKeep),
          );
          await _settle(tester);
        }
      }

      Future<_SampleGallery> boot(
        WidgetTester tester, {
        bool onboarded = true,
        Map<String, Object> prefs = const {},
      }) async {
        tester.view
          ..physicalSize = const Size(393 * 2, 852 * 2)
          ..devicePixelRatio = 2
          ..padding = const FakeViewPadding(top: 59 * 2, bottom: 34 * 2)
          ..viewPadding = const FakeViewPadding(top: 59 * 2, bottom: 34 * 2);
        tester.platformDispatcher
          ..platformBrightnessTestValue = dark
              ? Brightness.dark
              : Brightness.light
          ..localesTestValue = [Locale(lang)]
          ..localeTestValue = Locale(lang);
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearAllTestValues);

        final gallery = _SampleGallery(photos);
        final overrides = await testOverrides(
          gallery: gallery,
          onboarded: onboarded,
          prefs: prefs,
        );
        await tester.pumpWidget(
          RepaintBoundary(
            child: Stack(
              textDirection: TextDirection.ltr,
              children: [
                ProviderScope(
                  overrides: overrides,
                  child: const SnapSweepApp(),
                ),
                _StatusBar(dark: dark),
              ],
            ),
          ),
        );
        await _settle(tester);
        return gallery;
      }

      testWidgets('onboarding $suffix', (tester) async {
        await boot(tester, onboarded: false);
        await _shoot(tester, 'onboarding_$suffix');
      });

      testWidgets('home $suffix', (tester) async {
        await boot(tester, prefs: homePrefs);
        await _shoot(tester, 'home_$suffix');
      });

      testWidgets('swipe $suffix', (tester) async {
        await boot(tester);
        await swipe(tester, [true, false, true, true, false, true]);
        await _shoot(tester, 'swipe_$suffix');
      });

      testWidgets('review $suffix', (tester) async {
        await boot(tester);
        await swipe(tester, [true, true, false, true, true, true, false, true]);
        await tester.tap(find.text(l10n.swipeFinish));
        await _settle(tester);
        await _shoot(tester, 'review_$suffix');
      });
    }
  }
}

// Lets thumbnails decode for real, then settles animations.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(() async {
      for (final element in find.byType(Image).evaluate()) {
        final image = element.widget as Image;
        await precacheImage(image.image, element);
      }
    });
    await tester.pumpAndSettle();
  }
}

Future<void> _shoot(WidgetTester tester, String name) async {
  // Hide transient snackbars/toasts timers from the test's pending check.
  await expectLater(
    find.byType(RepaintBoundary).first,
    matchesGoldenFile('$_outDir/$name.png'),
  );
  await tester.pump(const Duration(seconds: 2));
}

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

const _photoNames = ['rocket', 'cat', 'galaxies', 'coffee', 'galaxies_zoom'];
const _outDir = '../../docs/screenshots';
final _iOS = TargetPlatformVariant.only(TargetPlatform.iOS);

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

String _statusFont = 'Inter';

Future<void> _loadFonts() async {
  final inter = FontLoader('Inter');
  for (final weight in ['Light', 'Regular', 'Medium', 'SemiBold', 'Bold']) {
    inter.addFont(rootBundle.load('assets/fonts/Inter-$weight.ttf'));
  }
  await inter.load();
  // Apple's system font is used only if this Mac has it; never committed.
  final sf = File('/System/Library/Fonts/SFNS.ttf');
  if (sf.existsSync()) {
    final loader = FontLoader('SF Pro')
      ..addFont(Future.value(ByteData.sublistView(sf.readAsBytesSync())));
    await loader.load();
    _statusFont = 'SF Pro';
  }
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await icons.load();
}

// Logical iPhone 15 screen and the drawn device around it.
const _screen = Size(393, 852);
const _bezel = 12.0;
const _margin = 8.0;
const _screenRadius = 55.0;
final _canvas = Size(
  _screen.width + 2 * (_bezel + _margin),
  _screen.height + 2 * (_bezel + _margin),
);

// Drawn iPhone: body, side buttons, Dynamic Island, status bar, home bar.
class _Phone extends StatelessWidget {
  const _Phone({required this.dark, required this.child});

  final bool dark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const body = Color(0xFF2A2A2D);
    final ink = dark ? const Color(0xFFF2EFE9) : const Color(0xFF1A1A1A);
    Widget button(double top, double height, {required bool left}) =>
        Positioned(
          top: _margin + top,
          left: left ? _margin - 3 : null,
          right: left ? null : _margin - 3,
          child: Container(
            width: 6,
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3E),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          button(150, 34, left: true),
          button(210, 64, left: true),
          button(290, 64, left: true),
          button(250, 100, left: false),
          Positioned.fill(
            left: _margin,
            top: _margin,
            right: _margin,
            bottom: _margin,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: body,
                borderRadius: BorderRadius.circular(_screenRadius + _bezel),
                border: Border.all(color: const Color(0xFF55555A), width: 1.5),
              ),
            ),
          ),
          Positioned(
            left: _margin + _bezel,
            top: _margin + _bezel,
            width: _screen.width,
            height: _screen.height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_screenRadius),
              child: Stack(
                children: [
                  Positioned.fill(child: child),
                  _StatusBar(color: ink),
                  // Dynamic Island.
                  Positioned(
                    top: 11,
                    left: (_screen.width - 126) / 2,
                    child: Container(
                      width: 126,
                      height: 37,
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  // Home indicator.
                  Positioned(
                    bottom: 8,
                    left: (_screen.width - 134) / 2,
                    child: Container(
                      width: 134,
                      height: 5,
                      decoration: BoxDecoration(
                        color: ink,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// iOS status bar: time on the left, signal, Wi-Fi and battery on the right.
class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 59,
      child: Row(
        children: [
          SizedBox(
            width: 133,
            child: Center(
              child: Text(
                '9:41',
                style: TextStyle(
                  fontFamily: _statusFont,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  fontVariations: const [FontVariation('wght', 600)],
                  letterSpacing: -0.4,
                  color: color,
                ),
              ),
            ),
          ),
          const Spacer(),
          CustomPaint(size: const Size(18, 12), painter: _SignalPainter(color)),
          const SizedBox(width: 6),
          Icon(Icons.wifi_rounded, size: 18, color: color),
          const SizedBox(width: 6),
          CustomPaint(
            size: const Size(27, 13),
            painter: _BatteryPainter(color),
          ),
          const SizedBox(width: 30),
        ],
      ),
    );
  }
}

class _SignalPainter extends CustomPainter {
  const _SignalPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const barWidth = 3.0;
    final gap = (size.width - 4 * barWidth) / 3;
    for (var i = 0; i < 4; i++) {
      final height = size.height * (0.4 + 0.2 * i);
      final rect = Rect.fromLTWH(
        i * (barWidth + gap),
        size.height - height,
        barWidth,
        height,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(1)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_SignalPainter old) => old.color != color;
}

class _BatteryPainter extends CustomPainter {
  const _BatteryPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final bodyWidth = size.width - 3;
    final outline = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0.5, 0.5, bodyWidth - 1, size.height - 1),
        const Radius.circular(4),
      ),
      outline,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2.5, 2.5, bodyWidth - 5, size.height - 5),
        const Radius.circular(2.5),
      ),
      Paint()..color = color,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bodyWidth + 0.5, size.height / 2 - 2, 2, 4),
        const Radius.circular(1),
      ),
      Paint()..color = color.withValues(alpha: 0.4),
    );
  }

  @override
  bool shouldRepaint(_BatteryPainter old) => old.color != color;
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

  final l10n = lookupAppLocalizations(const Locale('en'));

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

  Future<void> boot(
    WidgetTester tester, {
    required bool dark,
    Map<String, Object> prefs = const {},
  }) async {
    tester.view
      ..physicalSize = _canvas * 2
      ..devicePixelRatio = 2;
    tester.platformDispatcher
      ..localesTestValue = const [Locale('en')]
      ..localeTestValue = const Locale('en');
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    final overrides = await testOverrides(
      gallery: _SampleGallery(photos),
      onboarded: true,
      prefs: prefs,
    );
    await tester.pumpWidget(
      RepaintBoundary(
        child: _Phone(
          dark: dark,
          child: MediaQuery(
            data: MediaQueryData(
              size: _screen,
              devicePixelRatio: 2,
              padding: const EdgeInsets.only(top: 59, bottom: 34),
              viewPadding: const EdgeInsets.only(top: 59, bottom: 34),
              platformBrightness: dark ? Brightness.dark : Brightness.light,
            ),
            child: ProviderScope(
              overrides: overrides,
              child: const SnapSweepApp(),
            ),
          ),
        ),
      ),
    );
    await _settle(tester);
  }

  testWidgets('home', (tester) async {
    await boot(tester, dark: false, prefs: homePrefs);
    await _shoot(tester, 'home');
  }, variant: _iOS);

  testWidgets('swipe', (tester) async {
    await boot(tester, dark: true);
    await swipe(tester, [true, false, true, true, false, true, false]);
    await _shoot(tester, 'swipe');
  }, variant: _iOS);

  testWidgets('review', (tester) async {
    await boot(tester, dark: false);
    await swipe(tester, [true, true, true, true, true, false]);
    await tester.tap(find.text(l10n.swipeFinish));
    await _settle(tester);
    await _shoot(tester, 'review');
  }, variant: _iOS);
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

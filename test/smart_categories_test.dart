import 'package:flutter_test/flutter_test.dart';
import 'package:snap_sweep/features/filters/media_filter.dart';
import 'package:snap_sweep/features/gallery/gallery_photo.dart';
import 'package:snap_sweep/features/gallery/gallery_service.dart';

import 'helpers.dart';

void main() {
  FakeGalleryService galleryWithScreenshots() =>
      FakeGalleryService(access: GalleryAccess.granted)
        ..categories[MediaCategory.screenshots] = [
          for (var i = 0; i < 120; i++)
            GalleryPhoto(id: 'shot-$i', createdAt: DateTime(2025, 1, 1)),
        ];

  Future<void> openHome(WidgetTester tester, {required bool premium}) async {
    await tester.pumpWidget(
      testApp(
        await testOverrides(
          gallery: galleryWithScreenshots(),
          onboarded: true,
          premium: premium,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Screenshots'), 200);
  }

  testWidgets('shows real counts and sizes', (tester) async {
    await openHome(tester, premium: false);
    expect(find.text('120 items • 240 MB'), findsOneWidget);
  });

  testWidgets('free users see the paywall', (tester) async {
    await openHome(tester, premium: false);
    await tester.tap(find.text('Screenshots'));
    await tester.pumpAndSettle();
    expect(find.text('SnapSweep Pro'), findsOneWidget);
  });

  testWidgets('premium opens the whole category', (tester) async {
    await openHome(tester, premium: true);
    await tester.tap(find.text('Screenshots'));
    await tester.pumpAndSettle();
    expect(find.text('1 of 120'), findsOneWidget);
    expect(find.text('Screenshots'), findsOneWidget);
  });
}

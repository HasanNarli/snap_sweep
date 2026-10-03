import 'package:flutter_test/flutter_test.dart';
import 'package:snap_sweep/features/gallery/gallery_service.dart';

import 'helpers.dart';

void main() {
  const today = '2026-10-04';

  testWidgets('swipes use the quota and undo refunds it', (tester) async {
    await tester.pumpWidget(testApp(await testOverrides(onboarded: true)));
    await tester.pumpAndSettle();
    expect(find.text('15 reviews available today'), findsOneWidget);

    await tester.tap(find.text('Start cleaning'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Keep'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Undo'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.text('14 reviews available today'), findsOneWidget);
    expect(find.text('14 / 15'), findsOneWidget);
  });

  testWidgets('batch is capped by what is left today', (tester) async {
    final gallery = FakeGalleryService(
      access: GalleryAccess.granted,
      photoCount: 10,
    );
    await tester.pumpWidget(
      testApp(
        await testOverrides(
          gallery: gallery,
          onboarded: true,
          prefs: {'quota_day': today, 'quota_used': 13},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Batch of 2'), findsOneWidget);

    await tester.tap(find.text('Start cleaning'));
    await tester.pumpAndSettle();
    expect(find.text('1 of 2'), findsOneWidget);
  });

  testWidgets('exhausted quota opens the out-of-swipes sheet', (tester) async {
    await tester.pumpWidget(
      testApp(
        await testOverrides(
          onboarded: true,
          prefs: {'quota_day': today, 'quota_used': 15},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('0 reviews available today'), findsOneWidget);
    expect(find.text('Get more'), findsOneWidget);

    await tester.tap(find.text('Start cleaning'));
    await tester.pumpAndSettle();
    expect(find.text("That's it for today"), findsOneWidget);
    // 10:00 -> midnight.
    expect(
      find.text('Your free reviews reset in 14h 0m. Want to keep going?'),
      findsOneWidget,
    );
    expect(find.text('Watch an ad for +10'), findsOneWidget);
    expect(find.text('Go unlimited with Pro'), findsOneWidget);
  });
}

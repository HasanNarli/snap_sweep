import 'package:flutter_test/flutter_test.dart';
import 'package:snap_sweep/features/gallery/gallery_service.dart';

import 'helpers.dart';

void main() {
  testWidgets('onboarding asks for access and lands on home', (tester) async {
    reduceMotion(tester);
    final gallery = FakeGalleryService();
    await tester.pumpWidget(testApp(await testOverrides(gallery: gallery)));
    await tester.pumpAndSettle();
    expect(find.text('Swipe to clean'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Start swiping'), findsOneWidget);
  });

  testWidgets('denied access shows the permission screen', (tester) async {
    reduceMotion(tester);
    final gallery = FakeGalleryService(accessOnRequest: GalleryAccess.denied);
    await tester.pumpWidget(testApp(await testOverrides(gallery: gallery)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Allow access to your photos'), findsOneWidget);

    // Still denied: falls back to system settings.
    await tester.tap(find.text('Allow access'));
    await tester.pumpAndSettle();
    expect(gallery.openSettingsCalls, 1);
  });

  testWidgets('returning user with access starts on home', (tester) async {
    final gallery = FakeGalleryService(access: GalleryAccess.limited);
    await tester.pumpWidget(
      testApp(await testOverrides(gallery: gallery, onboarded: true)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Start swiping'), findsOneWidget);
    expect(
      find.text('SnapSweep can only see the photos you selected.'),
      findsOneWidget,
    );
  });
}

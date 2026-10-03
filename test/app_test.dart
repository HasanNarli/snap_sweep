import 'package:flutter_test/flutter_test.dart';
import 'package:snap_sweep/features/gallery/gallery_service.dart';

import 'helpers.dart';

void main() {
  testWidgets('onboarding asks for access and lands on home', (tester) async {
    final gallery = FakeGalleryService();
    await tester.pumpWidget(testApp(await testOverrides(gallery: gallery)));
    await tester.pumpAndSettle();
    expect(find.text('Allow Photo Access'), findsOneWidget);

    await tester.tap(find.text('Allow Photo Access'));
    await tester.pumpAndSettle();

    expect(find.text('Start cleaning'), findsOneWidget);
  });

  testWidgets('denied access shows the permission screen', (tester) async {
    final gallery = FakeGalleryService(accessOnRequest: GalleryAccess.denied);
    await tester.pumpWidget(testApp(await testOverrides(gallery: gallery)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Allow Photo Access'));
    await tester.pumpAndSettle();
    expect(find.text('Allow access to your photos'), findsOneWidget);

    // Still denied: falls back to system settings.
    await tester.tap(find.text('Allow access'));
    await tester.pumpAndSettle();
    expect(gallery.openSettingsCalls, 1);
  });

  testWidgets('not now skips the prompt and shows the permission screen', (
    tester,
  ) async {
    final gallery = FakeGalleryService();
    await tester.pumpWidget(testApp(await testOverrides(gallery: gallery)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Not Now'));
    await tester.pumpAndSettle();
    expect(find.text('Allow access to your photos'), findsOneWidget);
  });

  testWidgets('returning user with access starts on home', (tester) async {
    final gallery = FakeGalleryService(access: GalleryAccess.limited);
    await tester.pumpWidget(
      testApp(await testOverrides(gallery: gallery, onboarded: true)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Start cleaning'), findsOneWidget);
    expect(
      find.text('SnapSweep can only see the photos you selected.'),
      findsOneWidget,
    );
  });
}

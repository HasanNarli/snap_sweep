import 'package:flutter_test/flutter_test.dart';
import 'package:snap_sweep/features/gallery/gallery_service.dart';

import 'helpers.dart';

void main() {
  Future<void> openSwipe(
    WidgetTester tester,
    FakeGalleryService gallery,
  ) async {
    await tester.pumpWidget(
      testApp(await testOverrides(gallery: gallery, onboarded: true)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start swiping'));
    await tester.pumpAndSettle();
  }

  testWidgets('buttons swipe through cards and undo', (tester) async {
    final gallery = FakeGalleryService(access: GalleryAccess.granted);
    await openSwipe(tester, gallery);
    expect(find.text('1/3'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('2/3'), findsOneWidget);
    expect(find.text('Finish'), findsOneWidget);

    await tester.tap(find.byTooltip('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('1/3'), findsOneWidget);
  });

  testWidgets('finishing the stack offers review', (tester) async {
    final gallery = FakeGalleryService(access: GalleryAccess.granted);
    await openSwipe(tester, gallery);

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Keep'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('All done!'), findsOneWidget);
    expect(find.text('2 photos marked for deletion.'), findsOneWidget);

    await tester.tap(find.text('Review (2)'));
    await tester.pumpAndSettle();
    expect(find.text('2 photos marked for deletion.'), findsOneWidget);
  });

  testWidgets('empty gallery shows a message', (tester) async {
    final gallery = FakeGalleryService(
      access: GalleryAccess.granted,
      photoCount: 0,
    );
    await openSwipe(tester, gallery);
    expect(find.text('No photos found in your gallery'), findsOneWidget);
  });
}

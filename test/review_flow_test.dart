import 'package:flutter_test/flutter_test.dart';
import 'package:snap_sweep/features/gallery/gallery_service.dart';
import 'package:snap_sweep/shared/widgets/photo_thumbnail.dart';

import 'helpers.dart';

void main() {
  // Marks photo-0 and photo-2 for deletion, keeps photo-1, opens review.
  Future<FakeGalleryService> openReview(WidgetTester tester) async {
    final gallery = FakeGalleryService(access: GalleryAccess.granted);
    await tester.pumpWidget(
      testApp(await testOverrides(gallery: gallery, onboarded: true)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start swiping'));
    await tester.pumpAndSettle();
    for (final tooltip in ['Delete', 'Keep', 'Delete']) {
      await tester.tap(find.byTooltip(tooltip));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Review 2'));
    await tester.pumpAndSettle();
    return gallery;
  }

  testWidgets('deletes selected photos and shows the result', (tester) async {
    final gallery = await openReview(tester);
    expect(find.text('Delete 2 photos  ·  4.0 MB'), findsOneWidget);

    // Tap the first tile to keep it.
    await tester.tap(find.byType(PhotoThumbnail).first);
    await tester.pumpAndSettle();
    expect(find.text('Delete 1 photo  ·  2.0 MB'), findsOneWidget);

    await tester.tap(find.text('Delete 1 photo  ·  2.0 MB'));
    await tester.pumpAndSettle();
    expect(gallery.deletedIds, ['photo-2']);
    expect(find.text('Nice and clean'), findsOneWidget);
    expect(find.text('2.0 MB'), findsOneWidget);
    expect(find.text('1 photo deleted'), findsOneWidget);

    // Lifetime stats reach home.
    await tester.tap(find.text('Back to home'));
    await tester.pumpAndSettle();
    expect(find.text('2.0 MB'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('cancelled system dialog keeps the user on review', (
    tester,
  ) async {
    final gallery = await openReview(tester);
    gallery.cancelDelete = true;

    await tester.tap(find.text('Delete 2 photos  ·  4.0 MB'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing was deleted.'), findsOneWidget);
    expect(find.text('Delete 2 photos  ·  4.0 MB'), findsOneWidget);
  });
}

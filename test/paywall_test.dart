import 'package:flutter_test/flutter_test.dart';
import 'package:snap_sweep/features/gallery/gallery_service.dart';
import 'package:snap_sweep/features/premium/purchase_service.dart';

import 'helpers.dart';

void main() {
  // Sheet content can sit below the fold in the default test window.
  Future<void> tapVisible(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text));
    await tester.pumpAndSettle();
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  Future<FakePurchaseService> openPaywall(
    WidgetTester tester, {
    FakePurchaseService? purchases,
  }) async {
    final store = purchases ?? FakePurchaseService();
    await tester.pumpWidget(
      testApp(
        await testOverrides(
          gallery: FakeGalleryService(access: GalleryAccess.granted),
          onboarded: true,
          purchases: store,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Upgrade'), 200);
    await tester.tap(find.text('Upgrade'));
    await tester.pumpAndSettle();
    return store;
  }

  testWidgets('shows both plans with store prices', (tester) async {
    await openPaywall(tester);
    expect(find.text('SnapSweep Pro'), findsOneWidget);
    expect(find.text('₺499,99'), findsOneWidget);
    expect(find.text('₺41,67 per month, billed yearly'), findsOneWidget);
    expect(find.text('₺999,99'), findsOneWidget);
  });

  testWidgets('buying the yearly plan unlocks Pro', (tester) async {
    final store = await openPaywall(tester);
    await tapVisible(tester, 'Continue');

    expect(store.bought, ['yearly']);
    expect(find.text('Welcome to Pro'), findsOneWidget);
    // The upgrade card is gone and the daily card is unlimited.
    expect(find.text('Upgrade'), findsNothing);
    expect(find.text('Unlimited reviews with Pro'), findsOneWidget);
  });

  testWidgets('picking lifetime buys lifetime', (tester) async {
    final store = await openPaywall(tester);
    await tapVisible(tester, 'Lifetime');
    expect(find.text('A one-time purchase. No subscription.'), findsOneWidget);

    await tapVisible(tester, 'Continue');
    expect(store.bought, ['lifetime']);
  });

  testWidgets('cancelling keeps the paywall open quietly', (tester) async {
    final store = FakePurchaseService()
      ..nextOutcome = PurchaseOutcome.cancelled;
    await openPaywall(tester, purchases: store);
    await tapVisible(tester, 'Continue');

    expect(find.text('SnapSweep Pro'), findsOneWidget);
    expect(
      find.text("The purchase didn't go through. Please try again."),
      findsNothing,
    );
  });

  testWidgets('a failed purchase says so', (tester) async {
    final store = FakePurchaseService()..nextOutcome = PurchaseOutcome.failed;
    await openPaywall(tester, purchases: store);
    await tapVisible(tester, 'Continue');
    expect(
      find.text("The purchase didn't go through. Please try again."),
      findsOneWidget,
    );
  });

  testWidgets('restore finds an earlier purchase', (tester) async {
    await openPaywall(
      tester,
      purchases: FakePurchaseService(ownsEarlierPurchase: true),
    );
    await tapVisible(tester, 'Restore purchases');
    expect(find.text('Welcome to Pro'), findsOneWidget);
  });

  testWidgets('no store plans shows a retry', (tester) async {
    final store = FakePurchaseService()..available = const [];
    await openPaywall(tester, purchases: store);
    expect(find.text("Purchases aren't available right now."), findsOneWidget);
    expect(find.text('Continue'), findsNothing);
  });
}

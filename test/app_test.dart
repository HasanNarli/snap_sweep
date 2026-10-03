import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snap_sweep/app.dart';

void main() {
  testWidgets('onboarding leads to home', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SnapSweepApp()));
    await tester.pumpAndSettle();
    expect(find.text('Swipe to clean'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Start swiping'), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
  });
}

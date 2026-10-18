import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/data/prefs/app_prefs.dart';

import 'helpers/pump_app.dart';

void main() {
  testWidgets('first launch shows the welcome page, then onboarding, then Home', (tester) async {
    await pumpPulseApp(tester);
    expect(find.text('Μάθε κάθε μέρα πόσα μπορείς να ξοδέψεις.'), findsOneWidget);
    expect(find.text('Παράλειψη'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('onboarding-welcome-start')));
    await settle(tester);
    expect(find.text('Πόσα μπαίνουν κάθε μήνα;'), findsOneWidget);

    await tester.tap(find.text('Παράλειψη'));
    await settle(tester);
    // Nothing recorded yet: Home shows its empty state.
    expect(find.text('ΞΟΔΕΥΤΗΚΑΝ'), findsOneWidget);
    expect(find.text('Πρώτα βήματα'), findsOneWidget);
  });

  testWidgets('theme toggle flips dark → light and persists', (tester) async {
    final prefs = MemoryAppPrefs(onboardingDone: true);
    await pumpPulseApp(tester, prefs: prefs);
    expect(tester.appBrightness, Brightness.dark);

    await tester.tap(find.bySemanticsLabel('Φωτεινό θέμα'));
    await settle(tester);
    expect(tester.appBrightness, Brightness.light);
    expect(prefs.themeMode, ThemeMode.light);
  });

  testWidgets('floating nav switches branches', (tester) async {
    await pumpPulseApp(tester, prefs: MemoryAppPrefs(onboardingDone: true));

    await tester.tap(find.bySemanticsLabel('Αναλύσεις'));
    await settle(tester);
    expect(find.text('Αναλύσεις'), findsWidgets);

    await tester.tap(find.bySemanticsLabel('Budgets'));
    await settle(tester);
    expect(find.textContaining('Δεν έχεις ορίσει όρια ακόμα'), findsOneWidget);
  });
}

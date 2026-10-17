import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/data/prefs/app_prefs.dart';

import 'helpers/pump_app.dart';

void main() {
  testWidgets('first launch shows onboarding, finishing it lands on Home', (tester) async {
    await pumpPulseApp(tester);
    expect(find.text('Πόσα μπαίνουν κάθε μήνα;'), findsOneWidget);

    await tester.tap(find.text('Ξεκίνα'));
    await tester.pumpAndSettle();
    expect(find.text('ΥΠΟΛΟΙΠΟ ΜΗΝΑ'), findsOneWidget);
  });

  testWidgets('theme toggle flips dark → light and persists', (tester) async {
    final prefs = MemoryAppPrefs(onboardingDone: true);
    await pumpPulseApp(tester, prefs: prefs);
    expect(tester.appBrightness, Brightness.dark);

    await tester.tap(find.bySemanticsLabel('Φωτεινό θέμα'));
    await tester.pumpAndSettle();
    expect(tester.appBrightness, Brightness.light);
    expect(prefs.themeMode, ThemeMode.light);
  });

  testWidgets('floating nav switches branches', (tester) async {
    await pumpPulseApp(tester, prefs: MemoryAppPrefs(onboardingDone: true));

    await tester.tap(find.bySemanticsLabel('Αναλύσεις'));
    await tester.pumpAndSettle();
    expect(find.text('Αναλύσεις'), findsWidgets);

    await tester.tap(find.bySemanticsLabel('Budgets'));
    await tester.pumpAndSettle();
    expect(find.text('Budgets — σύντομα'), findsOneWidget);
  });
}

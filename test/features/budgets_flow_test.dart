import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/app/router.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/db/demo_seed.dart';
import 'package:pulse/data/prefs/app_prefs.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = memoryDb());

  Future<ProviderContainer> boot(WidgetTester tester) => pumpPulseApp(
    tester,
    db: db,
    prefs: MemoryAppPrefs(onboardingDone: true),
    seed: (db) => seedDemoData(db, now: t0),
  );

  testWidgets('adding an expense updates the Home hero and allowance', (tester) async {
    await boot(tester);
    expect(find.bySemanticsLabel('€129,00'), findsOneWidget);
    expect(find.bySemanticsLabel('Σήμερα μπορείς €9'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-add')));
    await settle(tester);
    for (final k in ['2', '0']) {
      await tester.tap(find.byKey(ValueKey('key-$k')));
      await tester.pump();
    }
    await tester.tap(find.text('Σούπερ μάρκετ'));
    await tester.tap(find.byKey(const ValueKey('add-save')));
    await settle(tester);

    expect(find.bySemanticsLabel('€109,00'), findsOneWidget);
    expect(find.bySemanticsLabel('Σήμερα μπορείς €7'), findsOneWidget);
  });

  testWidgets('Budgets shows the summary and per-category state', (tester) async {
    final container = await boot(tester);
    container.read(routerProvider).go(Routes.budgets);
    await settle(tester);

    expect(find.text('4 από 5 εντός ορίου'), findsOneWidget);
    expect(find.bySemanticsLabel('Ξοδεύτηκαν €851,00 από €980,00'), findsOneWidget);
    expect(find.text('+€36'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Λογαριασμοί: 87%.*Κοντά στο όριο')), findsOneWidget);
  });

  testWidgets('new category with a limit appears in Budgets', (tester) async {
    final container = await boot(tester);
    container.read(routerProvider).go(Routes.budgets);
    await settle(tester);

    await tester.scrollUntilVisible(find.text('Νέα κατηγορία'), 200);
    await tester.tap(find.text('Νέα κατηγορία'));
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextField, 'π.χ. Κατοικίδιο'), 'Κατοικίδιο');
    await tester.enterText(find.widgetWithText(TextField, '€0'), '80');
    await tester.tap(find.bySemanticsLabel('Ροζ'));
    await tester.ensureVisible(find.text('Δημιουργία κατηγορίας'));
    await tester.pump();
    await tester.tap(find.text('Δημιουργία κατηγορίας'));
    await settle(tester);

    expect(find.text('Κατοικίδιο'), findsOneWidget);
    expect(find.text('5 από 6 εντός ορίου'), findsOneWidget);
    final row = (await tester.runAsync(() => db.select(db.categories).get()))!
        .firstWhere((c) => c.name == 'Κατοικίδιο');
    expect(row.monthlyLimitCents, 8000);
  });

  testWidgets('a used category is archived, not deleted', (tester) async {
    final container = await boot(tester);
    unawaited(container.read(routerProvider).push(Routes.categories));
    await settle(tester);

    await tester.tap(find.text('Ψυχαγωγία'));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('Διαγραφή κατηγορίας'));
    await settle(tester);

    expect(find.text('Η κατηγορία έχει κινήσεις, οπότε αρχειοθετήθηκε.'), findsOneWidget);
    final row = (await tester.runAsync(() => db.select(db.categories).get()))!.firstWhere((c) => c.id == DemoIds.fun);
    expect(row.archived, isTrue);
    await tester.pump(const Duration(seconds: 5));
  });
}

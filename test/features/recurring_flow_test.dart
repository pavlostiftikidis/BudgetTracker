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

  Future<ProviderContainer> openRecurring(WidgetTester tester) async {
    final container = await pumpPulseApp(
      tester,
      db: db,
      prefs: MemoryAppPrefs(onboardingDone: true),
      seed: (db) => seedDemoData(db, now: t0),
    );
    unawaited(container.read(routerProvider).push(Routes.recurring));
    await settle(tester);
    return container;
  }

  testWidgets('monthly total, share of income and live toggle', (tester) async {
    await openRecurring(tester);
    // Rent 650 + Netflix 13,99 + ΔΕΗ 68,40 + Spotify 10,99 + insurance 186/6.
    expect(find.text('€774,38'), findsOneWidget);
    expect(find.text('36% του εισοδήματος'), findsOneWidget);
    expect(find.text('6 ενεργά'), findsOneWidget);
    expect(find.textContaining('σε 2 μέρες'), findsOneWidget, reason: 'rent on the 20th');

    await tester.tap(find.bySemanticsLabel('Ενοίκιο: ενεργό'));
    await settle(tester);
    expect(find.text('€124,38'), findsOneWidget);
    expect(find.text('5 ενεργά'), findsOneWidget);
    final rent = (await tester.runAsync(() => db.recurringDao.byId(DemoIds.ruleRent)))!;
    expect(rent.active, isFalse);
  });

  testWidgets('a new rule due today becomes a transaction immediately', (tester) async {
    await openRecurring(tester);
    await tester.tap(find.text('Νέο επαναλαμβανόμενο'));
    await settle(tester);

    await tester.enterText(find.widgetWithText(TextField, 'Όνομα'), 'Internet');
    await tester.tap(find.bySemanticsLabel(RegExp('^Ποσό')));
    await settle(tester);
    for (final k in ['3', '0']) {
      await tester.tap(find.byKey(ValueKey('key-$k')));
      await tester.pump();
    }
    await tester.tap(find.text('Τέλος'));
    await settle(tester);

    // Move the first due date to today.
    await tester.ensureVisible(find.bySemanticsLabel(RegExp('^Επόμενη χρέωση')));
    await tester.tap(find.bySemanticsLabel(RegExp('^Επόμενη χρέωση')));
    await settle(tester);
    final picker = find.byType(DatePickerDialog);
    await tester.tap(find.descendant(of: picker, matching: find.text('18')));
    await tester.tap(find.descendant(of: picker, matching: find.byType(TextButton)).last);
    await settle(tester);

    await tester.ensureVisible(find.text('Αποθήκευση'));
    await tester.tap(find.text('Αποθήκευση'));
    await settle(tester);

    expect(find.text('Internet'), findsOneWidget);
    final txns = (await tester.runAsync(() => db.txnsDao.liveRows()))!;
    expect(txns.where((t) => t.title == 'Internet' && t.amountCents == 3000), hasLength(1));
  });
}

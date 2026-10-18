import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/app/router.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/widgets/swipeable_txn_tile.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/db/demo_seed.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/prefs/app_prefs.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

Future<List<TxnRow>> liveTxns(WidgetTester tester, AppDatabase db) async =>
    (await tester.runAsync(() => db.txnsDao.liveRows()))!;

void main() {
  late AppDatabase db;
  setUp(() => db = memoryDb());

  Future<ProviderContainer> boot(WidgetTester tester) => pumpPulseApp(
    tester,
    db: db,
    prefs: MemoryAppPrefs(onboardingDone: true),
    seed: (db) => seedDemoData(db, now: t0),
  );

  testWidgets('keypad + category + save creates an expense', (tester) async {
    await boot(tester);
    final before = (await liveTxns(tester, db)).length;

    await tester.tap(find.byKey(const ValueKey('nav-add')));
    await settle(tester);
    expect(find.text('ΝΕΟ ΕΞΟΔΟ'), findsOneWidget);

    for (final k in ['4', '2', 'Υποδιαστολή', '5']) {
      await tester.tap(find.byKey(ValueKey('key-$k')));
      await tester.pump();
    }
    await tester.tap(find.text('Εστίαση'));
    await tester.pump();
    expect(find.text('Αποθήκευση €42,50'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('add-save')));
    await settle(tester);

    final after = await liveTxns(tester, db);
    expect(after.length, before + 1);
    final created = after.firstWhere((t) => t.amountCents == 4250);
    expect(created.kind, TxnKind.expense);
    expect(created.categoryId, DemoIds.dining);
    expect(created.accountId, DemoIds.card, reason: 'expenses default to the card');
    expect(find.text('ΝΕΟ ΕΞΟΔΟ'), findsNothing, reason: 'modal closed');
  });

  testWidgets('saving without an amount shows a validation message', (tester) async {
    await boot(tester);
    await tester.tap(find.byKey(const ValueKey('nav-add')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('add-save')));
    await tester.pump();
    expect(find.text('Συμπλήρωσε ποσό μεγαλύτερο από 0.'), findsOneWidget);
  });

  testWidgets('swipe → Διαγραφή soft-deletes and Αναίρεση restores', (tester) async {
    final container = await boot(tester);
    unawaited(container.read(routerProvider).push(Routes.transactions));
    await settle(tester);

    final firstTile = find.byType(SwipeableTxnTile).first;
    await tester.drag(firstTile, const Offset(-300, 0));
    await settle(tester);
    await tester.tap(find.descendant(of: firstTile, matching: find.text('Διαγραφή')));
    await settle(tester);

    final deleted = (await tester.runAsync(() => db.select(db.txns).get()))!.where((t) => t.deletedAt != null);
    expect(deleted, hasLength(1));
    expect(find.textContaining('Διαγράφηκε:'), findsOneWidget);

    await tester.tap(find.text('Αναίρεση'));
    await settle(tester);
    final stillDeleted = (await tester.runAsync(() => db.select(db.txns).get()))!.where((t) => t.deletedAt != null);
    expect(stillDeleted, isEmpty);

    await tester.pump(const Duration(seconds: 6));
  });

  testWidgets('search narrows the list, ignoring accents and case', (tester) async {
    final container = await boot(tester);
    unawaited(container.read(routerProvider).push(Routes.transactions));
    await settle(tester);
    await tester.enterText(find.byType(TextField), 'σκλαβενιτης');
    await settle(tester);
    final titles = tester.widgetList<Text>(
      find.descendant(of: find.byType(SwipeableTxnTile), matching: find.byType(Text)),
    );
    expect(titles.where((t) => t.data == 'Σκλαβενίτης'), isNotEmpty);
    expect(titles.where((t) => t.data == 'Lidl'), isEmpty);
  });

  testWidgets('transfer sheet moves money without touching totals', (tester) async {
    final container = await boot(tester);
    unawaited(container.read(routerProvider).push(Routes.accounts));
    await settle(tester);
    await tester.tap(find.text('Μεταφορά').first);
    await settle(tester);
    for (final k in ['5', '0']) {
      await tester.tap(find.byKey(ValueKey('key-$k')));
      await tester.pump();
    }
    await tester.tap(find.text('Μεταφορά €50,00'));
    await settle(tester);

    final t = (await liveTxns(tester, db)).firstWhere((t) => t.amountCents == 5000);
    expect(t.kind, TxnKind.transfer);
    expect(t.accountId, DemoIds.checking);
    expect(t.toAccountId, DemoIds.savings);
    expect(t.categoryId, isNull);
    expect(Money(t.amountCents).format(), '€50,00');
  });
}

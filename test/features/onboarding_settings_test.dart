import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/app/router.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/core/utils/clock.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/db/demo_seed.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/prefs/app_prefs.dart';
import 'package:pulse/data/prefs/secure_flags.dart';
import 'package:pulse/features/settings/app_lock.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = memoryDb());

  testWidgets('onboarding: income, payday, limits and accounts are saved', (tester) async {
    final prefs = MemoryAppPrefs();
    await pumpPulseApp(tester, db: db, prefs: prefs);
    expect(find.text('ΒΗΜΑ 1 ΑΠΟ 3'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '3000');
    await tester.pump();
    expect(find.text('3.000'), findsOneWidget, reason: 'grouped as typed');
    await tester.tap(find.text('15η'));
    await tester.tap(find.byKey(const ValueKey('onboarding-next')));
    await settle(tester);

    expect(find.text('ΒΗΜΑ 2 ΑΠΟ 3'), findsOneWidget);
    // 3000 − (400 + 150 + 250 + 120 + 60) = 2020; +2×€10 on Εστίαση → 2000.
    expect(find.text('€2.020'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Αύξηση ορίου για Εστίαση'));
    await tester.tap(find.bySemanticsLabel('Αύξηση ορίου για Εστίαση'));
    await tester.pump();
    expect(find.text('€170'), findsOneWidget);
    expect(find.text('€2.000'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('onboarding-next')));
    await settle(tester);

    expect(find.text('ΒΗΜΑ 3 ΑΠΟ 3'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel(RegExp('^Μετρητά')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('onboarding-next')));
    await settle(tester);

    expect(prefs.onboardingDone, isTrue);
    expect(find.text('ΞΟΔΕΥΤΗΚΑΝ'), findsOneWidget);

    final settings = (await tester.runAsync(db.settingsDao.get))!;
    expect(settings.monthlyIncomeCents, 300000);
    expect(settings.paydayKind, PaydayKind.fifteenth);
    final cats = (await tester.runAsync(() => db.select(db.categories).get()))!;
    expect(cats, hasLength(9));
    expect(cats.firstWhere((c) => c.name == 'Εστίαση').monthlyLimitCents, 17000);
    final accounts = (await tester.runAsync(() => db.select(db.accounts).get()))!;
    expect(accounts.map((a) => a.type), unorderedEquals([AccountType.bank, AccountType.card, AccountType.cash]));
  });

  testWidgets('skipping onboarding still leaves a usable app', (tester) async {
    await pumpPulseApp(tester, db: db);
    await tester.tap(find.text('Παράλειψη'));
    await settle(tester);
    expect(find.text('Πρώτα βήματα'), findsOneWidget);
    final accounts = (await tester.runAsync(() => db.select(db.accounts).get()))!;
    expect(accounts, hasLength(2));
  });

  testWidgets('biometric lock: enabling asks first, the gate locks and unlocks', (tester) async {
    final flags = MemorySecureFlags();
    final auth = FakeBiometricAuth();
    final container = await pumpPulseApp(
      tester,
      db: db,
      prefs: MemoryAppPrefs(onboardingDone: true),
      secureFlags: flags,
      auth: auth,
    );
    unawaited(container.read(routerProvider).push(Routes.settings));
    await settle(tester);

    await tester.tap(find.bySemanticsLabel('Κλείδωμα με Face ID'));
    await settle(tester);
    expect(auth.prompts, 1);
    expect(flags.lock, isTrue);
    expect(find.text('Το Pulse είναι κλειδωμένο'), findsNothing, reason: 'not locked right after enabling');

    container.invalidate(appLockProvider);
    auth.succeed = false;
    await settle(tester);
    expect(find.text('Το Pulse είναι κλειδωμένο'), findsOneWidget);

    auth.succeed = true;
    await tester.tap(find.text('Ξεκλείδωμα'));
    await settle(tester);
    expect(find.text('Το Pulse είναι κλειδωμένο'), findsNothing);
  });

  testWidgets('no biometrics: the switch stays off and explains why', (tester) async {
    final flags = MemorySecureFlags();
    final container = await pumpPulseApp(
      tester,
      db: db,
      prefs: MemoryAppPrefs(onboardingDone: true),
      secureFlags: flags,
      auth: FakeBiometricAuth(available: false),
    );
    unawaited(container.read(routerProvider).push(Routes.settings));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('Κλείδωμα με Face ID'));
    await settle(tester);
    expect(flags.lock, isFalse);
    expect(find.text('Η συσκευή δεν υποστηρίζει βιομετρικό κλείδωμα.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('re-locks only after 30 s in the background', (tester) async {
    final clock = FixedClock(t0);
    final container = await pumpPulseApp(
      tester,
      db: db,
      prefs: MemoryAppPrefs(onboardingDone: true),
      secureFlags: MemorySecureFlags(lock: true),
      clock: clock,
    );
    expect(find.text('Το Pulse είναι κλειδωμένο'), findsNothing, reason: 'fake auth unlocked on open');

    final lock = container.read(appLockProvider.notifier)..onBackground();
    clock.fixed = t0.add(const Duration(seconds: 10));
    lock.onForeground();
    await settle(tester);
    expect(find.text('Το Pulse είναι κλειδωμένο'), findsNothing);

    lock.onBackground();
    clock.fixed = t0.add(const Duration(minutes: 2));
    lock.onForeground();
    await tester.pump();
    expect(find.text('Το Pulse είναι κλειδωμένο'), findsOneWidget);
  });

  testWidgets('reset deletes everything and returns to onboarding', (tester) async {
    final prefs = MemoryAppPrefs(onboardingDone: true);
    final container = await pumpPulseApp(
      tester,
      db: db,
      prefs: prefs,
      seed: (db) => seedDemoData(db, now: t0),
    );
    unawaited(container.read(routerProvider).push(Routes.settings));
    await settle(tester);

    await tester.ensureVisible(find.text('Επαναφορά δεδομένων'));
    await settle(tester);
    await tester.tap(find.text('Επαναφορά δεδομένων'));
    await settle(tester);
    await tester.tap(find.text('Επαναφορά'));
    await settle(tester);

    expect(prefs.onboardingDone, isFalse);
    expect(find.text('ΒΗΜΑ 1 ΑΠΟ 3'), findsOneWidget);
    expect(await tester.runAsync(() => db.select(db.txns).get()), isEmpty);
    expect(await tester.runAsync(() => db.select(db.accounts).get()), isEmpty);
  });
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/app/router.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/db/demo_seed.dart';
import 'package:pulse/data/prefs/app_prefs.dart';

import '../helpers/fixtures.dart';
import '../helpers/fonts.dart';
import '../helpers/pump_app.dart';

/// Every screen and the main sheets must lay out without overflow on a
/// small phone (360×640) and with text scaled to 1.3. Real fonts are
/// loaded so text metrics match the device.
void main() {
  setUpAll(loadAppFonts);

  const configs = [
    (size: Size(360, 640), scale: 1.0),
    (size: Size(360, 640), scale: 1.3),
    (size: Size(390, 844), scale: 1.3),
  ];

  for (final cfg in configs) {
    final tag = '${cfg.size.width.toInt()}×${cfg.size.height.toInt()} @${cfg.scale}';

    Future<(ProviderContainer, AppDatabase)> boot(
      WidgetTester tester, {
      bool onboarded = true,
      bool seed = true,
    }) async {
      final db = memoryDb();
      final container = await pumpPulseApp(
        tester,
        db: db,
        size: cfg.size,
        textScale: cfg.scale,
        prefs: MemoryAppPrefs(onboardingDone: onboarded),
        seed: seed ? (db) => seedDemoData(db, now: t0) : null,
      );
      return (container, db);
    }

    Future<void> visit(WidgetTester tester, ProviderContainer c, String route, {bool push = false}) async {
      final router = c.read(routerProvider);
      if (push) {
        unawaited(router.push(route));
      } else {
        router.go(route);
      }
      await settle(tester);
      expect(tester.takeException(), isNull, reason: '$route at $tag');
    }

    testWidgets('shell screens fit at $tag', (tester) async {
      final (c, _) = await boot(tester);
      for (final r in [Routes.home, Routes.insights, Routes.budgets]) {
        await visit(tester, c, r);
      }
    });

    testWidgets('secondary screens fit at $tag', (tester) async {
      final (c, db) = await boot(tester);
      for (final r in [
        Routes.transactions,
        Routes.accounts,
        Routes.categories,
        Routes.recurring,
        Routes.settings,
        Routes.add,
        Routes.addTransfer,
      ]) {
        await visit(tester, c, r, push: true);
        c.read(routerProvider).go(Routes.home);
        await settle(tester);
      }
      final first = (await tester.runAsync(() => db.txnsDao.liveRows()))!.first;
      await visit(tester, c, Routes.editTransaction(first.id), push: true);
    });

    testWidgets('empty home and onboarding fit at $tag', (tester) async {
      final (c, _) = await boot(tester, onboarded: false, seed: false);
      expect(tester.takeException(), isNull, reason: 'welcome page at $tag');
      await tester.tap(find.byKey(const ValueKey('onboarding-welcome-start')));
      await settle(tester);
      expect(tester.takeException(), isNull);
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.byKey(const ValueKey('onboarding-next')));
        await settle(tester);
        expect(tester.takeException(), isNull, reason: 'onboarding step ${i + 2} at $tag');
      }
      await tester.tap(find.byKey(const ValueKey('onboarding-next')));
      await settle(tester);
      expect(find.text('Πρώτα βήματα'), findsOneWidget);
      expect(tester.takeException(), isNull);
      c.read(routerProvider).go(Routes.budgets);
      await settle(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('sheets fit at $tag', (tester) async {
      final (c, _) = await boot(tester);

      await visit(tester, c, Routes.accounts, push: true);
      await tester.tap(find.text('Μεταφορά').first);
      await settle(tester);
      expect(tester.takeException(), isNull, reason: 'transfer sheet');
      Navigator.of(tester.element(find.byType(BottomSheet))).pop();
      await settle(tester);

      await tester.tap(find.text('Νέος'));
      await settle(tester);
      expect(tester.takeException(), isNull, reason: 'account sheet');
      Navigator.of(tester.element(find.byType(BottomSheet))).pop();
      await settle(tester);

      await visit(tester, c, Routes.categories, push: true);
      await tester.tap(find.bySemanticsLabel('Νέα κατηγορία').first);
      await settle(tester);
      expect(tester.takeException(), isNull, reason: 'category sheet');
      Navigator.of(tester.element(find.byType(BottomSheet))).pop();
      await settle(tester);

      await visit(tester, c, Routes.recurring, push: true);
      await tester.tap(find.text('Νέο επαναλαμβανόμενο'));
      await settle(tester);
      expect(tester.takeException(), isNull, reason: 'rule sheet');
    });
  }

  testWidgets('light theme fits on a small phone too', (tester) async {
    final container = await pumpPulseApp(
      tester,
      size: const Size(360, 640),
      textScale: 1.3,
      prefs: MemoryAppPrefs(onboardingDone: true, themeMode: ThemeMode.light),
      seed: (db) => seedDemoData(db, now: t0),
    );
    for (final r in [Routes.home, Routes.insights, Routes.budgets]) {
      container.read(routerProvider).go(r);
      await settle(tester);
      expect(tester.takeException(), isNull);
    }
  });
}

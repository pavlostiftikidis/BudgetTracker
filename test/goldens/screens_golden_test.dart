@Tags(['golden'])
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/app/router.dart';
import 'package:pulse/data/db/demo_seed.dart';
import 'package:pulse/data/prefs/app_prefs.dart';

import '../helpers/fixtures.dart';
import '../helpers/fonts.dart';
import '../helpers/pump_app.dart';

/// Pixel snapshots of the main screens with demo data, in both themes.
/// Regenerate with `flutter test --update-goldens --tags golden`.
void main() {
  setUpAll(loadAppFonts);

  Future<ProviderContainer> boot(WidgetTester tester, ThemeMode mode, {bool seed = true}) => pumpPulseApp(
    tester,
    prefs: MemoryAppPrefs(onboardingDone: true, themeMode: mode),
    seed: seed ? (db) => seedDemoData(db, now: t0) : null,
  );

  for (final mode in [ThemeMode.dark, ThemeMode.light]) {
    testWidgets('home ${mode.name}', (tester) async {
      await boot(tester, mode);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('home_${mode.name}.png'));
    });

    testWidgets('budgets ${mode.name}', (tester) async {
      final container = await boot(tester, mode);
      container.read(routerProvider).go(Routes.budgets);
      await settle(tester);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('budgets_${mode.name}.png'));
    });
  }

  testWidgets('home empty state', (tester) async {
    await boot(tester, ThemeMode.dark, seed: false);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('home_empty_dark.png'));
  });

  testWidgets('transactions dark', (tester) async {
    final container = await boot(tester, ThemeMode.dark);
    unawaited(container.read(routerProvider).push(Routes.transactions));
    await settle(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('transactions_dark.png'));
  });

  testWidgets('accounts dark', (tester) async {
    final container = await boot(tester, ThemeMode.dark);
    unawaited(container.read(routerProvider).push(Routes.accounts));
    await settle(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('accounts_dark.png'));
  });

  testWidgets('add dark', (tester) async {
    await boot(tester, ThemeMode.dark);
    await tester.tap(find.byKey(const ValueKey('nav-add')));
    await settle(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('add_dark.png'));
  });
}

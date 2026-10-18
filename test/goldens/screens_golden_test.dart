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

  testWidgets('insights dark', (tester) async {
    final container = await boot(tester, ThemeMode.dark);
    container.read(routerProvider).go(Routes.insights);
    await settle(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('insights_dark.png'));
  });

  testWidgets('recurring light', (tester) async {
    final container = await boot(tester, ThemeMode.light);
    unawaited(container.read(routerProvider).push(Routes.recurring));
    await settle(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('recurring_light.png'));
  });

  testWidgets('onboarding welcome dark', (tester) async {
    await pumpPulseApp(tester, prefs: MemoryAppPrefs());
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('onboarding_welcome_dark.png'));
  });

  testWidgets('onboarding welcome light', (tester) async {
    await pumpPulseApp(tester, prefs: MemoryAppPrefs(themeMode: ThemeMode.light));
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('onboarding_welcome_light.png'));
  });

  testWidgets('onboarding step 2 dark', (tester) async {
    await pumpPulseApp(tester, prefs: MemoryAppPrefs());
    await tester.tap(find.byKey(const ValueKey('onboarding-welcome-start')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('onboarding-next')));
    await settle(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('onboarding_limits_dark.png'));
  });

  testWidgets('onboarding step 1 light', (tester) async {
    await pumpPulseApp(tester, prefs: MemoryAppPrefs(themeMode: ThemeMode.light));
    await tester.tap(find.byKey(const ValueKey('onboarding-welcome-start')));
    await settle(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('onboarding_income_light.png'));
  });

  testWidgets('settings dark', (tester) async {
    final container = await boot(tester, ThemeMode.dark);
    unawaited(container.read(routerProvider).push(Routes.settings));
    await settle(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('settings_dark.png'));
  });

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

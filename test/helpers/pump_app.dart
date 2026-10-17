import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/app/app.dart';
import 'package:pulse/app/app_providers.dart';
import 'package:pulse/app/bootstrap.dart';
import 'package:pulse/core/utils/clock.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/prefs/app_prefs.dart';
import 'package:pulse/data/providers.dart';

import 'fixtures.dart';

/// Boots the full app on an in-memory database, in-memory prefs and a
/// fixed clock (18 Oct 2026, 12:00 unless given).
Future<ProviderContainer> pumpPulseApp(
  WidgetTester tester, {
  AppPrefs? prefs,
  AppDatabase? db,
  Clock? clock,
  Future<void> Function(AppDatabase db)? seed,
  List<Override> overrides = const [],
  Size size = const Size(390, 844),
  double textScale = 1,
}) async {
  await initLocale();
  tester.view
    ..physicalSize = size * 3
    ..devicePixelRatio = 3;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });

  final database = db ?? memoryDb();
  if (seed != null) await tester.runAsync(() => seed(database));

  final container = ProviderContainer(
    overrides: [
      appPrefsProvider.overrideWithValue(prefs ?? MemoryAppPrefs()),
      appDatabaseProvider.overrideWithValue(database),
      clockProvider.overrideWithValue(clock ?? FixedClock(t0)),
      ...overrides,
    ],
    retry: (_, _) => null,
  );
  addTearDown(() async {
    container.dispose();
    await database.close();
  });

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const PulseApp()),
  );
  await settle(tester);
  return container;
}

/// pumpAndSettle that also lets real database futures complete.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 5)));
    await tester.pumpAndSettle();
  }
}

extension PumpX on WidgetTester {
  /// Brightness of the theme currently applied under [MaterialApp].
  Brightness get appBrightness => Theme.of(element(find.byType(Scaffold).first)).brightness;
}

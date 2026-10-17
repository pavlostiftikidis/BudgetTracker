import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/app/app.dart';
import 'package:pulse/app/app_providers.dart';
import 'package:pulse/app/bootstrap.dart';
import 'package:pulse/data/prefs/app_prefs.dart';

/// Boots the full app with in-memory prefs and any extra overrides.
Future<ProviderContainer> pumpPulseApp(
  WidgetTester tester, {
  AppPrefs? prefs,
  List<Override> overrides = const [],
  Size size = const Size(390, 844),
}) async {
  await initLocale();
  tester.view
    ..physicalSize = size * 3
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final container = ProviderContainer(
    overrides: [
      appPrefsProvider.overrideWithValue(prefs ?? MemoryAppPrefs()),
      ...overrides,
    ],
    retry: (_, _) => null,
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const PulseApp()),
  );
  await tester.pumpAndSettle();
  return container;
}

extension PumpX on WidgetTester {
  /// Brightness of the theme currently applied under [MaterialApp].
  Brightness get appBrightness => Theme.of(element(find.byType(Scaffold).first)).brightness;
}

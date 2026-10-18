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
import 'package:pulse/data/prefs/secure_flags.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/features/settings/app_lock.dart';
import 'package:pulse/features/settings/settings_screen.dart';
import 'package:pulse/features/transactions/receipt_store.dart';

import 'fixtures.dart';

/// Boots the full app on an in-memory database, in-memory prefs and a
/// fixed clock (18 Oct 2026, 12:00 unless given).
Future<ProviderContainer> pumpPulseApp(
  WidgetTester tester, {
  AppPrefs? prefs,
  AppDatabase? db,
  Clock? clock,
  SecureFlags? secureFlags,
  BiometricAuth? auth,
  Future<void> Function(AppDatabase db)? seed,
  List<Override> overrides = const [],
  Size size = const Size(390, 844),
  double textScale = 1,
  bool reduceMotion = true,
}) async {
  await initLocale();
  tester.view
    ..physicalSize = size * 3
    ..devicePixelRatio = 3;
  tester.platformDispatcher
    ..textScaleFactorTestValue = textScale
    // Reduced motion: stops the blinking caret and other looping
    // animations so pumpAndSettle can settle (and covers that setting).
    ..accessibilityFeaturesTestValue = FakeAccessibilityFeatures(disableAnimations: reduceMotion);
  addTearDown(() {
    tester.view.reset();
    tester.platformDispatcher
      ..clearTextScaleFactorTestValue()
      ..clearAccessibilityFeaturesTestValue();
  });

  final database = db ?? memoryDb();
  if (seed != null) await tester.runAsync(() => seed(database));

  final container = ProviderContainer(
    overrides: [
      appPrefsProvider.overrideWithValue(prefs ?? MemoryAppPrefs()),
      appDatabaseProvider.overrideWithValue(database),
      clockProvider.overrideWithValue(clock ?? FixedClock(t0)),
      secureFlagsProvider.overrideWithValue(secureFlags ?? MemorySecureFlags()),
      biometricAuthProvider.overrideWithValue(auth ?? FakeBiometricAuth()),
      receiptStorageProvider.overrideWithValue(_NoReceipts()),
      ...overrides,
    ],
    retry: (_, _) => null,
  );
  addTearDown(() async {
    container.dispose();
    await database.close();
  });

  await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const PulseApp()));
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

/// Scripted biometric prompt.
class FakeBiometricAuth implements BiometricAuth {
  new({this.available = true, this.succeed = true});

  bool available;
  bool succeed;
  int prompts = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate(String reason) async {
    prompts++;
    return succeed;
  }
}

class _NoReceipts implements ReceiptStorage {
  @override
  Future<void> deleteAll() async {}
}

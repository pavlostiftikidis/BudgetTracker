import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/app/startup.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/prefs/app_prefs.dart';

import '../helpers/pump_app.dart';

/// A database whose settings table predates `display_name` but claims to be
/// up to date — the state a skipped migration would leave behind.
AppDatabase brokenDb() => AppDatabase(
  NativeDatabase.memory(
    setup: (raw) {
      raw
        ..execute(
          "CREATE TABLE settings (id INTEGER NOT NULL DEFAULT 1 PRIMARY KEY, monthly_income_cents INTEGER NOT NULL DEFAULT 0, payday_kind TEXT NOT NULL DEFAULT 'first', payday_day INTEGER NOT NULL DEFAULT 1, currency TEXT NOT NULL DEFAULT 'EUR')",
        )
        ..execute('CREATE TABLE accounts (id TEXT NOT NULL PRIMARY KEY)')
        ..execute('CREATE TABLE txns (id TEXT NOT NULL PRIMARY KEY, deleted_at INTEGER)')
        ..execute('CREATE TABLE recurring_rules (id TEXT NOT NULL PRIMARY KEY, active INTEGER, next_due_date INTEGER)')
        ..execute('PRAGMA user_version = 2');
    },
  ),
);

void main() {
  testWidgets('a failing startup shows an error with retry, not a blank screen', (tester) async {
    await pumpPulseApp(
      tester,
      db: brokenDb(),
      prefs: MemoryAppPrefs(),
      overrides: [seedDemoEnabledProvider.overrideWithValue(true)],
    );
    expect(find.text('Κάτι πήγε στραβά'), findsOneWidget);
    expect(find.text('Δοκίμασε ξανά'), findsOneWidget);
  });

  testWidgets('a failing view model shows an error on Home', (tester) async {
    await pumpPulseApp(tester, db: brokenDb(), prefs: MemoryAppPrefs(onboardingDone: true));
    expect(find.text('Κάτι πήγε στραβά'), findsOneWidget);
  });
}

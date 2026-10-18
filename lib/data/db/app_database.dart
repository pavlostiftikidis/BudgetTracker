import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/core/theme/keys.dart';
import 'package:pulse/data/db/app_database.steps.dart';
import 'package:pulse/data/db/daos.dart';
import 'package:pulse/data/db/tables.dart';
import 'package:pulse/data/models/enums.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Accounts, Categories, RecurringRules, Txns, SettingsEntries],
  daos: [AccountsDao, CategoriesDao, TxnsDao, RecurringDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  new(super.e);

  /// The on-device database file (`pulse.sqlite`).
  factory open() => AppDatabase(driftDatabase(name: 'pulse'));

  /// Bump together with a new `drift_schemas/` snapshot
  /// (`dart run drift_dev make-migrations`) and a step in [migration].
  /// v1: initial schema. v2: `settings.display_name`.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    // One step per released schema version, each covered by the generated
    // tests in test/drift/.
    onUpgrade: stepByStep(
      from1To2: (m, schema) async {
        // v2: optional display name for the Home avatar.
        await m.addColumn(schema.settings, schema.settings.displayName);
      },
    ),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Deletes every row (Ρυθμίσεις › Επαναφορά δεδομένων).
  Future<void> wipe() => transaction(() async {
    // Children before parents so foreign keys hold at every step.
    await delete(txns).go();
    await delete(recurringRules).go();
    await delete(categories).go();
    await delete(accounts).go();
    await delete(settingsEntries).go();
  });
}

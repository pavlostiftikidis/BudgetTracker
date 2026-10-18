// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test('v1 → v2 keeps every row and adds an empty display name', () async {
    const oldSettings = [
      v1.SettingsData(
        id: 1,
        monthlyIncomeCents: 215000,
        paydayKind: 'fifteenth',
        paydayDay: 15,
        currency: 'EUR',
      ),
    ];
    const expectedSettings = [
      v2.SettingsData(
        id: 1,
        monthlyIncomeCents: 215000,
        paydayKind: 'fifteenth',
        paydayDay: 15,
        currency: 'EUR',
      ),
    ];
    const oldAccounts = [
      v1.AccountsData(
        id: 'a',
        name: 'Τρεχούμενος',
        type: 'bank',
        openingBalanceCents: 120000,
        colorKey: 'sky',
        isCredit: 0,
        archived: 0,
        sortOrder: 0,
      ),
    ];
    const expectedAccounts = [
      v2.AccountsData(
        id: 'a',
        name: 'Τρεχούμενος',
        type: 'bank',
        openingBalanceCents: 120000,
        colorKey: 'sky',
        isCredit: 0,
        archived: 0,
        sortOrder: 0,
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch
          ..insertAll(oldDb.settings, oldSettings)
          ..insertAll(oldDb.accounts, oldAccounts);
      },
      validateItems: (newDb) async {
        expect(await newDb.select(newDb.settings).get(), expectedSettings);
        expect(await newDb.select(newDb.accounts).get(), expectedAccounts);
      },
    );
  });
}

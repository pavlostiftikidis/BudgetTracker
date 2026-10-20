import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/db/mappers.dart';
import 'package:pulse/data/models/models.dart';

abstract interface class BackupRepository {
  /// Every setting, account, category and rule, and the live transactions.
  Future<DataSnapshot> snapshot();

  /// Replaces all data with [data]. If any row is rejected (a broken
  /// reference, a value out of range), nothing changes.
  Future<void> replaceAll(DataSnapshot data);
}

class DriftBackupRepository implements BackupRepository {
  new(this._db);

  final AppDatabase _db;

  @override
  Future<DataSnapshot> snapshot() => _db.transaction(
    () async => DataSnapshot(
      settings: (await _db.settingsDao.get()).toModel(),
      accounts: [for (final r in await _db.select(_db.accounts).get()) r.toModel()],
      categories: [for (final r in await _db.select(_db.categories).get()) r.toModel()],
      recurringRules: [for (final r in await _db.select(_db.recurringRules).get()) r.toModel()],
      txns: [for (final r in await _db.txnsDao.liveRows()) r.toModel()],
    ),
  );

  @override
  Future<void> replaceAll(DataSnapshot data) => _db.replaceAll(
    settings: data.settings.toCompanion(),
    accountRows: [for (final a in data.accounts) a.toCompanion()],
    categoryRows: [for (final c in data.categories) c.toCompanion()],
    ruleRows: [for (final r in data.recurringRules) r.toCompanion()],
    txnRows: [for (final t in data.txns) t.toCompanion()],
  );
}

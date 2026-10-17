import 'package:pulse/core/period/dates.dart';
import 'package:pulse/core/utils/clock.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/db/mappers.dart';
import 'package:pulse/data/models/models.dart';

abstract interface class TxnRepository {
  /// Live transactions, newest first; within [range] when given.
  Stream<List<Txn>> watchTxns({DateRange? range});

  Stream<List<Txn>> watchRecent(int limit);

  /// Includes soft-deleted rows so an open editor can notice a delete.
  Stream<Txn?> watchById(String id);

  Future<Txn?> byId(String id);

  Stream<bool> watchHasAny();

  Future<void> add(Txn txn);

  /// Replaces the stored row; bumps `updatedAt`.
  Future<void> update(Txn txn);

  /// Marks as deleted; reversible with [restore] until purged.
  Future<void> softDelete(String id);

  Future<void> restore(String id);

  /// Hard-deletes rows soft-deleted before [cutoff]. Returns the count.
  Future<int> purgeDeletedBefore(DateTime cutoff);
}

class DriftTxnRepository implements TxnRepository {
  new(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  @override
  Stream<List<Txn>> watchTxns({DateRange? range}) =>
      _db.txnsDao.watchLive(range: range).map((rows) => [for (final r in rows) r.toModel()]);

  @override
  Stream<List<Txn>> watchRecent(int limit) =>
      _db.txnsDao.watchRecent(limit).map((rows) => [for (final r in rows) r.toModel()]);

  @override
  Stream<Txn?> watchById(String id) => _db.txnsDao.watchById(id).map((r) => r?.toModel());

  @override
  Future<Txn?> byId(String id) async => (await _db.txnsDao.byId(id))?.toModel();

  @override
  Stream<bool> watchHasAny() => _db.txnsDao.watchHasAny();

  @override
  Future<void> add(Txn txn) => _db.txnsDao.insertRow(txn.toCompanion());

  @override
  Future<void> update(Txn txn) => _db.txnsDao.replaceRow(txn.copyWith(updatedAt: _clock.now()).toCompanion());

  @override
  Future<void> softDelete(String id) => _db.txnsDao.setDeletedAt(id, _clock.now());

  @override
  Future<void> restore(String id) => _db.txnsDao.setDeletedAt(id, null);

  @override
  Future<int> purgeDeletedBefore(DateTime cutoff) => _db.txnsDao.purgeDeletedBefore(cutoff);
}

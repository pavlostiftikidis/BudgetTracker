import 'package:drift/drift.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/db/tables.dart';
import 'package:pulse/data/models/enums.dart';

part 'daos.g.dart';

/// Net money that moved through one account for one transaction kind.
/// `incoming` is set for the receiving side of transfers.
typedef AccountFlowRow = ({String accountId, TxnKind kind, bool incoming, int totalCents});

@DriftAccessor(tables: [Accounts, Txns])
class AccountsDao extends DatabaseAccessor<AppDatabase> with _$AccountsDaoMixin {
  new(super.attachedDatabase);

  Stream<List<AccountRow>> watchAll({bool includeArchived = false}) {
    final q = select(accounts)..orderBy([(a) => OrderingTerm.asc(a.sortOrder), (a) => OrderingTerm.asc(a.name)]);
    if (!includeArchived) q.where((a) => a.archived.equals(false));
    return q.watch();
  }

  Future<AccountRow?> byId(String id) => (select(accounts)..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<void> upsert(AccountsCompanion row) => into(accounts).insertOnConflictUpdate(row);

  Future<void> setArchived(String id, {required bool archived}) =>
      (update(accounts)..where((a) => a.id.equals(id))).write(AccountsCompanion(archived: Value(archived)));

  Future<void> deleteById(String id) => (delete(accounts)..where((a) => a.id.equals(id))).go();

  Future<bool> hasTxns(String id) async {
    final count = txns.id.count();
    final q = selectOnly(txns)
      ..addColumns([count])
      ..where(txns.accountId.equals(id) | txns.toAccountId.equals(id));
    return (await q.map((r) => r.read(count)).getSingle() ?? 0) > 0;
  }

  /// Sums of live (not soft-deleted) transactions per account and kind,
  /// plus the incoming side of transfers.
  Stream<List<AccountFlowRow>> watchFlows() {
    return customSelect(
      '''
      SELECT account_id AS account, kind, 0 AS incoming, SUM(amount_cents) AS total
        FROM txns WHERE deleted_at IS NULL GROUP BY account_id, kind
      UNION ALL
      SELECT to_account_id AS account, kind, 1 AS incoming, SUM(amount_cents) AS total
        FROM txns WHERE deleted_at IS NULL AND kind = 'transfer' AND to_account_id IS NOT NULL
        GROUP BY to_account_id
      ''',
      readsFrom: {txns},
    ).watch().map(
      (rows) => [
        for (final r in rows)
          (
            accountId: r.read<String>('account'),
            kind: TxnKind.values.byName(r.read<String>('kind')),
            incoming: r.read<int>('incoming') == 1,
            totalCents: r.read<int>('total'),
          ),
      ],
    );
  }
}

@DriftAccessor(tables: [Categories, Txns])
class CategoriesDao extends DatabaseAccessor<AppDatabase> with _$CategoriesDaoMixin {
  new(super.attachedDatabase);

  Stream<List<CategoryRow>> watchAll({bool includeArchived = false}) {
    final q = select(categories)..orderBy([(c) => OrderingTerm.asc(c.sortOrder), (c) => OrderingTerm.asc(c.name)]);
    if (!includeArchived) q.where((c) => c.archived.equals(false));
    return q.watch();
  }

  Future<List<CategoryRow>> all() => select(categories).get();

  Future<void> upsert(CategoriesCompanion row) => into(categories).insertOnConflictUpdate(row);

  Future<void> setArchived(String id, {required bool archived}) =>
      (update(categories)..where((c) => c.id.equals(id))).write(CategoriesCompanion(archived: Value(archived)));

  Future<void> deleteById(String id) => (delete(categories)..where((c) => c.id.equals(id))).go();

  /// Persists a new order; [ids] lists categories top to bottom.
  Future<void> reorder(List<String> ids) => batch((b) {
    for (var i = 0; i < ids.length; i++) {
      b.update(categories, CategoriesCompanion(sortOrder: Value(i)), where: (c) => c.id.equals(ids[i]));
    }
  });

  /// Number of transactions per category, soft-deleted ones included
  /// (they still reference it until purged).
  Stream<Map<String, int>> watchTxnCounts({bool includeDeleted = false}) {
    final count = txns.id.count();
    final q = selectOnly(txns)
      ..addColumns([txns.categoryId, count])
      ..where(txns.categoryId.isNotNull())
      ..groupBy([txns.categoryId]);
    if (!includeDeleted) q.where(txns.deletedAt.isNull());
    return q.watch().map((rows) => {for (final r in rows) r.read(txns.categoryId)!: r.read(count) ?? 0});
  }
}

@DriftAccessor(tables: [Txns])
class TxnsDao extends DatabaseAccessor<AppDatabase> with _$TxnsDaoMixin {
  new(super.attachedDatabase);

  SimpleSelectStatement<$TxnsTable, TxnRow> _live({DateRange? range}) {
    final q = select(txns)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.date), (t) => OrderingTerm.desc(t.createdAt)]);
    if (range != null) {
      q.where((t) => t.date.isBiggerOrEqualValue(range.start) & t.date.isSmallerThanValue(range.end));
    }
    return q;
  }

  Stream<List<TxnRow>> watchLive({DateRange? range}) => _live(range: range).watch();

  Future<List<TxnRow>> liveRows({DateRange? range}) => _live(range: range).get();

  Stream<List<TxnRow>> watchRecent(int limit) => (_live()..limit(limit)).watch();

  Stream<TxnRow?> watchById(String id) => (select(txns)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<TxnRow?> byId(String id) => (select(txns)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertRow(TxnsCompanion row) => into(txns).insert(row);

  /// Inserts unless a row with the same (rule, occurrence) exists.
  /// Returns whether a row was written.
  Future<bool> insertOccurrence(TxnsCompanion row) async {
    await into(txns).insert(row, mode: InsertMode.insertOrIgnore);
    return (await byId(row.id.value)) != null;
  }

  Future<void> replaceRow(TxnsCompanion row) => (update(txns)..where((t) => t.id.equals(row.id.value))).write(row);

  Future<int> setDeletedAt(String id, DateTime? at) =>
      (update(txns)..where((t) => t.id.equals(id))).write(TxnsCompanion(deletedAt: Value(at)));

  Future<int> purgeDeletedBefore(DateTime cutoff) =>
      (delete(txns)..where((t) => t.deletedAt.isNotNull() & t.deletedAt.isSmallerThanValue(cutoff))).go();

  Future<bool> hasAny() async {
    final count = txns.id.count();
    final q = selectOnly(txns)
      ..addColumns([count])
      ..where(txns.deletedAt.isNull());
    return (await q.map((r) => r.read(count)).getSingle() ?? 0) > 0;
  }

  Stream<bool> watchHasAny() {
    final count = txns.id.count();
    final q = selectOnly(txns)
      ..addColumns([count])
      ..where(txns.deletedAt.isNull());
    return q.map((r) => (r.read(count) ?? 0) > 0).watchSingle();
  }

  /// Date of the oldest live transaction, or null if there are none.
  Future<DateTime?> firstDate() {
    final first = txns.date.min();
    final q = selectOnly(txns)
      ..addColumns([first])
      ..where(txns.deletedAt.isNull());
    return q.map((r) => r.read(first)).getSingle();
  }

  Future<int> countForCategory(String categoryId) async {
    final count = txns.id.count();
    final q = selectOnly(txns)
      ..addColumns([count])
      ..where(txns.categoryId.equals(categoryId));
    return await q.map((r) => r.read(count)).getSingle() ?? 0;
  }
}

@DriftAccessor(tables: [RecurringRules])
class RecurringDao extends DatabaseAccessor<AppDatabase> with _$RecurringDaoMixin {
  new(super.attachedDatabase);

  Stream<List<RecurringRuleRow>> watchAll() => (select(
    recurringRules,
  )..orderBy([(r) => OrderingTerm.asc(r.nextDueDate), (r) => OrderingTerm.asc(r.title)])).watch();

  Future<RecurringRuleRow?> byId(String id) =>
      (select(recurringRules)..where((r) => r.id.equals(id))).getSingleOrNull();

  /// Active rules with an occurrence due before [end].
  Future<List<RecurringRuleRow>> dueBefore(DateTime end) =>
      (select(recurringRules)..where((r) => r.active.equals(true) & r.nextDueDate.isSmallerThanValue(end))).get();

  Future<void> upsert(RecurringRulesCompanion row) => into(recurringRules).insertOnConflictUpdate(row);

  Future<void> patch(String id, RecurringRulesCompanion changes) =>
      (update(recurringRules)..where((r) => r.id.equals(id))).write(changes);

  Future<void> deleteById(String id) => (delete(recurringRules)..where((r) => r.id.equals(id))).go();
}

@DriftAccessor(tables: [SettingsEntries])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  new(super.attachedDatabase);

  Stream<SettingsRow?> watch() => (select(settingsEntries)..where((s) => s.id.equals(1))).watchSingleOrNull();

  Future<SettingsRow?> get() => (select(settingsEntries)..where((s) => s.id.equals(1))).getSingleOrNull();

  Future<void> save(SettingsEntriesCompanion row) =>
      into(settingsEntries).insertOnConflictUpdate(row.copyWith(id: const Value(1)));
}

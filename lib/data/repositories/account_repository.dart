import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/utils/streams.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/db/mappers.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/domain/balances.dart';

abstract interface class AccountRepository {
  Stream<List<Account>> watchAccounts({bool includeArchived = false});

  /// Current balance per account id (archived ones included).
  Stream<Map<String, Money>> watchBalances();

  Future<void> save(Account account);

  /// Archives when the account has transactions, deletes it otherwise.
  /// Returns true if it was archived.
  Future<bool> archiveOrDelete(String id);
}

class DriftAccountRepository implements AccountRepository {
  new(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Account>> watchAccounts({bool includeArchived = false}) => _db.accountsDao
      .watchAll(includeArchived: includeArchived)
      .map((rows) => [for (final r in rows) r.toModel()]);

  @override
  Stream<Map<String, Money>> watchBalances() => combineLatest2(
    watchAccounts(includeArchived: true),
    _db.accountsDao.watchFlows(),
    balancesFromFlows,
  );

  @override
  Future<void> save(Account account) => _db.accountsDao.upsert(account.toCompanion());

  @override
  Future<bool> archiveOrDelete(String id) async {
    if (await _db.accountsDao.hasTxns(id)) {
      await _db.accountsDao.setArchived(id, archived: true);
      return true;
    }
    await _db.accountsDao.deleteById(id);
    return false;
  }
}

import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/core/utils/clock.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/repositories/account_repository.dart';
import 'package:pulse/data/repositories/backup_repository.dart';
import 'package:pulse/data/repositories/category_repository.dart';
import 'package:pulse/data/repositories/recurring_repository.dart';
import 'package:pulse/data/repositories/settings_repository.dart';
import 'package:pulse/data/repositories/txn_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
Clock clock(Ref ref) => const Clock();

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
AccountRepository accountRepository(Ref ref) => DriftAccountRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(Ref ref) => DriftCategoryRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
TxnRepository txnRepository(Ref ref) => DriftTxnRepository(ref.watch(appDatabaseProvider), ref.watch(clockProvider));

@Riverpod(keepAlive: true)
RecurringRepository recurringRepository(Ref ref) =>
    DriftRecurringRepository(ref.watch(appDatabaseProvider), ref.watch(clockProvider));

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) => DriftSettingsRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
BackupRepository backupRepository(Ref ref) => DriftBackupRepository(ref.watch(appDatabaseProvider));

// ---------------------------------------------------------------------------
// Shared streams. Feature view-models combine these; every number on screen
// is derived from them.

@Riverpod(keepAlive: true)
Stream<AppSettings> settings(Ref ref) => ref.watch(settingsRepositoryProvider).watch();

@Riverpod(keepAlive: true)
Stream<List<Account>> accounts(Ref ref) => ref.watch(accountRepositoryProvider).watchAccounts();

/// Archived ones too, for labelling old transactions.
@Riverpod(keepAlive: true)
Stream<List<Account>> allAccounts(Ref ref) => ref.watch(accountRepositoryProvider).watchAccounts(includeArchived: true);

@Riverpod(keepAlive: true)
Stream<Map<String, Money>> balances(Ref ref) => ref.watch(accountRepositoryProvider).watchBalances();

@Riverpod(keepAlive: true)
Stream<List<TxnCategory>> categories(Ref ref) => ref.watch(categoryRepositoryProvider).watchCategories();

/// Archived ones too, so old transactions can still show their category.
@Riverpod(keepAlive: true)
Stream<List<TxnCategory>> allCategories(Ref ref) =>
    ref.watch(categoryRepositoryProvider).watchCategories(includeArchived: true);

@Riverpod(keepAlive: true)
Stream<Map<String, int>> categoryTxnCounts(Ref ref) => ref.watch(categoryRepositoryProvider).watchTxnCounts();

@Riverpod(keepAlive: true)
Stream<List<RecurringRule>> recurringRules(Ref ref) => ref.watch(recurringRepositoryProvider).watchRules();

@Riverpod(keepAlive: true)
Stream<List<Txn>> allTxns(Ref ref) => ref.watch(txnRepositoryProvider).watchTxns();

@riverpod
Stream<List<Txn>> txnsInRange(Ref ref, DateRange range) => ref.watch(txnRepositoryProvider).watchTxns(range: range);

/// The [limit] most recent live transactions.
@riverpod
Stream<List<Txn>> recentTxns(Ref ref, int limit) => ref.watch(txnRepositoryProvider).watchRecent(limit);

@riverpod
Stream<Txn?> txnById(Ref ref, String id) => ref.watch(txnRepositoryProvider).watchById(id);

@Riverpod(keepAlive: true)
Stream<bool> hasTxns(Ref ref) => ref.watch(txnRepositoryProvider).watchHasAny();

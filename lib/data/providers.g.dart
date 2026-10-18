// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clock)
final clockProvider = ClockProvider._();

final class ClockProvider extends $FunctionalProvider<Clock, Clock, Clock> with $Provider<Clock> {
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<Clock> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Clock create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Clock value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Clock>(value));
  }
}

String _$clockHash() => r'30e71d378a201482bb785bc8babd9bfcb65538f7';

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AppDatabase>(value));
  }
}

String _$appDatabaseHash() => r'365ef3f215d780c29a21b6328f0b547a8363c6a6';

@ProviderFor(accountRepository)
final accountRepositoryProvider = AccountRepositoryProvider._();

final class AccountRepositoryProvider
    extends $FunctionalProvider<AccountRepository, AccountRepository, AccountRepository>
    with $Provider<AccountRepository> {
  AccountRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountRepositoryHash();

  @$internal
  @override
  $ProviderElement<AccountRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AccountRepository create(Ref ref) {
    return accountRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AccountRepository>(value));
  }
}

String _$accountRepositoryHash() => r'1738b5bf41e4251ceedab519b9ca7f869537541f';

@ProviderFor(categoryRepository)
final categoryRepositoryProvider = CategoryRepositoryProvider._();

final class CategoryRepositoryProvider
    extends $FunctionalProvider<CategoryRepository, CategoryRepository, CategoryRepository>
    with $Provider<CategoryRepository> {
  CategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CategoryRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  CategoryRepository create(Ref ref) {
    return categoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<CategoryRepository>(value));
  }
}

String _$categoryRepositoryHash() => r'537c6fc33bf30e1d12776c09770f0fc09d5db398';

@ProviderFor(txnRepository)
final txnRepositoryProvider = TxnRepositoryProvider._();

final class TxnRepositoryProvider extends $FunctionalProvider<TxnRepository, TxnRepository, TxnRepository>
    with $Provider<TxnRepository> {
  TxnRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'txnRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$txnRepositoryHash();

  @$internal
  @override
  $ProviderElement<TxnRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  TxnRepository create(Ref ref) {
    return txnRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TxnRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<TxnRepository>(value));
  }
}

String _$txnRepositoryHash() => r'1061b615cc59e626671013f1a136e9a5feffc89a';

@ProviderFor(recurringRepository)
final recurringRepositoryProvider = RecurringRepositoryProvider._();

final class RecurringRepositoryProvider
    extends $FunctionalProvider<RecurringRepository, RecurringRepository, RecurringRepository>
    with $Provider<RecurringRepository> {
  RecurringRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recurringRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recurringRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecurringRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  RecurringRepository create(Ref ref) {
    return recurringRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecurringRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<RecurringRepository>(value));
  }
}

String _$recurringRepositoryHash() => r'61022b820ef978ee306fdf568f6d3607d6ef5c04';

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends $FunctionalProvider<SettingsRepository, SettingsRepository, SettingsRepository>
    with $Provider<SettingsRepository> {
  SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SettingsRepository>(value));
  }
}

String _$settingsRepositoryHash() => r'0eda22c9c7a5e68c8661bf58b528d73264ef9a19';

@ProviderFor(settings)
final settingsProvider = SettingsProvider._();

final class SettingsProvider extends $FunctionalProvider<AsyncValue<AppSettings>, AppSettings, Stream<AppSettings>>
    with $FutureModifier<AppSettings>, $StreamProvider<AppSettings> {
  SettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsHash();

  @$internal
  @override
  $StreamProviderElement<AppSettings> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<AppSettings> create(Ref ref) {
    return settings(ref);
  }
}

String _$settingsHash() => r'3b6219f1439e57bfda762caba6bd092e11961fb0';

@ProviderFor(accounts)
final accountsProvider = AccountsProvider._();

final class AccountsProvider
    extends $FunctionalProvider<AsyncValue<List<Account>>, List<Account>, Stream<List<Account>>>
    with $FutureModifier<List<Account>>, $StreamProvider<List<Account>> {
  AccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountsHash();

  @$internal
  @override
  $StreamProviderElement<List<Account>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<Account>> create(Ref ref) {
    return accounts(ref);
  }
}

String _$accountsHash() => r'18dfebdc019d757dc1a1f24da2246e553ac2c6fa';

/// Archived ones too, for labelling old transactions.

@ProviderFor(allAccounts)
final allAccountsProvider = AllAccountsProvider._();

/// Archived ones too, for labelling old transactions.

final class AllAccountsProvider
    extends $FunctionalProvider<AsyncValue<List<Account>>, List<Account>, Stream<List<Account>>>
    with $FutureModifier<List<Account>>, $StreamProvider<List<Account>> {
  /// Archived ones too, for labelling old transactions.
  AllAccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allAccountsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allAccountsHash();

  @$internal
  @override
  $StreamProviderElement<List<Account>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<Account>> create(Ref ref) {
    return allAccounts(ref);
  }
}

String _$allAccountsHash() => r'6328790835e87d740680722c49548961b8de8a75';

@ProviderFor(balances)
final balancesProvider = BalancesProvider._();

final class BalancesProvider
    extends $FunctionalProvider<AsyncValue<Map<String, Money>>, Map<String, Money>, Stream<Map<String, Money>>>
    with $FutureModifier<Map<String, Money>>, $StreamProvider<Map<String, Money>> {
  BalancesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'balancesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$balancesHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, Money>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Map<String, Money>> create(Ref ref) {
    return balances(ref);
  }
}

String _$balancesHash() => r'f769939d5e816d783fcea736b8c1cfc5a125a28c';

@ProviderFor(categories)
final categoriesProvider = CategoriesProvider._();

final class CategoriesProvider
    extends $FunctionalProvider<AsyncValue<List<TxnCategory>>, List<TxnCategory>, Stream<List<TxnCategory>>>
    with $FutureModifier<List<TxnCategory>>, $StreamProvider<List<TxnCategory>> {
  CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $StreamProviderElement<List<TxnCategory>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<TxnCategory>> create(Ref ref) {
    return categories(ref);
  }
}

String _$categoriesHash() => r'0163a53c82e062b4a9920b17416e55b96d9deb45';

/// Archived ones too, so old transactions can still show their category.

@ProviderFor(allCategories)
final allCategoriesProvider = AllCategoriesProvider._();

/// Archived ones too, so old transactions can still show their category.

final class AllCategoriesProvider
    extends $FunctionalProvider<AsyncValue<List<TxnCategory>>, List<TxnCategory>, Stream<List<TxnCategory>>>
    with $FutureModifier<List<TxnCategory>>, $StreamProvider<List<TxnCategory>> {
  /// Archived ones too, so old transactions can still show their category.
  AllCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allCategoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allCategoriesHash();

  @$internal
  @override
  $StreamProviderElement<List<TxnCategory>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<TxnCategory>> create(Ref ref) {
    return allCategories(ref);
  }
}

String _$allCategoriesHash() => r'164e3833c25d1def2379415f314edd77cd004a1a';

@ProviderFor(categoryTxnCounts)
final categoryTxnCountsProvider = CategoryTxnCountsProvider._();

final class CategoryTxnCountsProvider
    extends $FunctionalProvider<AsyncValue<Map<String, int>>, Map<String, int>, Stream<Map<String, int>>>
    with $FutureModifier<Map<String, int>>, $StreamProvider<Map<String, int>> {
  CategoryTxnCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryTxnCountsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryTxnCountsHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, int>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, int>> create(Ref ref) {
    return categoryTxnCounts(ref);
  }
}

String _$categoryTxnCountsHash() => r'479d1d87558a158381b2068810205ec5515e8ede';

@ProviderFor(recurringRules)
final recurringRulesProvider = RecurringRulesProvider._();

final class RecurringRulesProvider
    extends $FunctionalProvider<AsyncValue<List<RecurringRule>>, List<RecurringRule>, Stream<List<RecurringRule>>>
    with $FutureModifier<List<RecurringRule>>, $StreamProvider<List<RecurringRule>> {
  RecurringRulesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recurringRulesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recurringRulesHash();

  @$internal
  @override
  $StreamProviderElement<List<RecurringRule>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<RecurringRule>> create(Ref ref) {
    return recurringRules(ref);
  }
}

String _$recurringRulesHash() => r'f8d10f31a2eb457e60b4e9c83d4c82e27c10df58';

@ProviderFor(allTxns)
final allTxnsProvider = AllTxnsProvider._();

final class AllTxnsProvider extends $FunctionalProvider<AsyncValue<List<Txn>>, List<Txn>, Stream<List<Txn>>>
    with $FutureModifier<List<Txn>>, $StreamProvider<List<Txn>> {
  AllTxnsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allTxnsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allTxnsHash();

  @$internal
  @override
  $StreamProviderElement<List<Txn>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<Txn>> create(Ref ref) {
    return allTxns(ref);
  }
}

String _$allTxnsHash() => r'3f5b7fb6f18f29f45201ba1a5cd674825f547480';

@ProviderFor(txnsInRange)
final txnsInRangeProvider = TxnsInRangeFamily._();

final class TxnsInRangeProvider extends $FunctionalProvider<AsyncValue<List<Txn>>, List<Txn>, Stream<List<Txn>>>
    with $FutureModifier<List<Txn>>, $StreamProvider<List<Txn>> {
  TxnsInRangeProvider._({required TxnsInRangeFamily super.from, required DateRange super.argument})
    : super(
        retry: null,
        name: r'txnsInRangeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$txnsInRangeHash();

  @override
  String toString() {
    return r'txnsInRangeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Txn>> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<List<Txn>> create(Ref ref) {
    final argument = this.argument as DateRange;
    return txnsInRange(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TxnsInRangeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$txnsInRangeHash() => r'eba92fae8a9402e1a8e6ecb82d493ea1c5f0dbb3';

final class TxnsInRangeFamily extends $Family with $FunctionalFamilyOverride<Stream<List<Txn>>, DateRange> {
  TxnsInRangeFamily._()
    : super(
        retry: null,
        name: r'txnsInRangeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TxnsInRangeProvider call(DateRange range) => TxnsInRangeProvider._(argument: range, from: this);

  @override
  String toString() => r'txnsInRangeProvider';
}

@ProviderFor(txnById)
final txnByIdProvider = TxnByIdFamily._();

final class TxnByIdProvider extends $FunctionalProvider<AsyncValue<Txn?>, Txn?, Stream<Txn?>>
    with $FutureModifier<Txn?>, $StreamProvider<Txn?> {
  TxnByIdProvider._({required TxnByIdFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'txnByIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$txnByIdHash();

  @override
  String toString() {
    return r'txnByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Txn?> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<Txn?> create(Ref ref) {
    final argument = this.argument as String;
    return txnById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TxnByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$txnByIdHash() => r'e31b3c3b48ef47fe09c0f5937ba70c252231915d';

final class TxnByIdFamily extends $Family with $FunctionalFamilyOverride<Stream<Txn?>, String> {
  TxnByIdFamily._()
    : super(
        retry: null,
        name: r'txnByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TxnByIdProvider call(String id) => TxnByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'txnByIdProvider';
}

@ProviderFor(hasTxns)
final hasTxnsProvider = HasTxnsProvider._();

final class HasTxnsProvider extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  HasTxnsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasTxnsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasTxnsHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return hasTxns(ref);
  }
}

String _$hasTxnsHash() => r'2d730d2d942f51097842b7be62a433a6da6d2cc8';

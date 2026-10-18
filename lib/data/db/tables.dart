import 'package:drift/drift.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/core/theme/keys.dart';
import 'package:pulse/data/models/enums.dart';

@DataClassName('AccountRow')
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  TextColumn get type => textEnum<AccountType>()();
  IntColumn get openingBalanceCents => integer().withDefault(const Constant(0))();
  TextColumn get colorKey => textEnum<ColorKey>()();
  BoolColumn get isCredit => boolean().withDefault(const Constant(false))();
  IntColumn get creditLimitCents => integer().nullable()();
  IntColumn get statementDay => integer().nullable()();
  TextColumn get last4 => text().nullable().withLength(min: 4, max: 4)();
  IntColumn get goalCents => integer().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('CategoryRow')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 40)();
  TextColumn get kind => textEnum<CategoryKind>()();
  TextColumn get colorKey => textEnum<ColorKey>()();
  TextColumn get iconKey => textEnum<IconKey>()();
  IntColumn get monthlyLimitCents => integer().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('RecurringRuleRow')
class RecurringRules extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 60)();
  TextColumn get kind => textEnum<TxnKind>()();
  // Drift's documented way to reference the column in its own CHECK.
  // ignore: recursive_getters
  IntColumn get amountCents => integer().check(amountCents.isBiggerThanValue(0))();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get note => text().nullable()();
  TextColumn get frequency => textEnum<Frequency>()();
  IntColumn get interval => integer().withDefault(const Constant(1))();
  IntColumn get dayOfMonth => integer().nullable()();
  IntColumn get weekday => integer().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get nextDueDate => dateTime()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TxnRow')
@TableIndex(name: 'txns_by_date', columns: {#date})
@TableIndex(name: 'txns_by_category', columns: {#categoryId})
class Txns extends Table {
  TextColumn get id => text()();
  TextColumn get kind => textEnum<TxnKind>()();
  // Drift's documented way to reference the column in its own CHECK.
  // ignore: recursive_getters
  IntColumn get amountCents => integer().check(amountCents.isBiggerThanValue(0))();
  @ReferenceName('outgoingTxns')
  TextColumn get accountId => text().references(Accounts, #id)();
  @ReferenceName('incomingTransfers')
  TextColumn get toAccountId => text().nullable().references(Accounts, #id)();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get title => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get recurringRuleId => text().nullable().references(RecurringRules, #id, onDelete: KeyAction.setNull)();
  TextColumn get occurrenceKey => text().nullable()();
  TextColumn get receiptPath => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  /// One transaction per recurring occurrence. Manual transactions have a
  /// NULL rule, and SQLite treats NULLs as distinct, so they never collide.
  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {recurringRuleId, occurrenceKey},
  ];
}

/// Single-row table (id = 1).
@DataClassName('SettingsRow')
class SettingsEntries extends Table {
  @override
  String get tableName => 'settings';

  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get monthlyIncomeCents => integer().withDefault(const Constant(0))();
  TextColumn get paydayKind => textEnum<PaydayKind>().withDefault(Constant(PaydayKind.first.name))();
  IntColumn get paydayDay => integer().withDefault(const Constant(1))();
  TextColumn get currency => text().withDefault(const Constant('EUR'))();
  TextColumn get displayName => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

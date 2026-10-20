// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Account _$AccountFromJson(Map<String, dynamic> json) => _Account(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$AccountTypeEnumMap, json['type']),
  openingBalanceCents: (json['openingBalanceCents'] as num?)?.toInt() ?? 0,
  colorKey: $enumDecodeNullable(_$ColorKeyEnumMap, json['colorKey']) ?? ColorKey.sky,
  isCredit: json['isCredit'] as bool? ?? false,
  creditLimitCents: (json['creditLimitCents'] as num?)?.toInt(),
  statementDay: (json['statementDay'] as num?)?.toInt(),
  last4: json['last4'] as String?,
  goalCents: (json['goalCents'] as num?)?.toInt(),
  archived: json['archived'] as bool? ?? false,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AccountToJson(_Account instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$AccountTypeEnumMap[instance.type]!,
  'openingBalanceCents': instance.openingBalanceCents,
  'colorKey': _$ColorKeyEnumMap[instance.colorKey]!,
  'isCredit': instance.isCredit,
  'creditLimitCents': instance.creditLimitCents,
  'statementDay': instance.statementDay,
  'last4': instance.last4,
  'goalCents': instance.goalCents,
  'archived': instance.archived,
  'sortOrder': instance.sortOrder,
};

const _$AccountTypeEnumMap = {
  AccountType.bank: 'bank',
  AccountType.card: 'card',
  AccountType.cash: 'cash',
  AccountType.savings: 'savings',
};

const _$ColorKeyEnumMap = {
  ColorKey.lime: 'lime',
  ColorKey.coral: 'coral',
  ColorKey.sky: 'sky',
  ColorKey.violet: 'violet',
  ColorKey.amber: 'amber',
  ColorKey.teal: 'teal',
  ColorKey.pink: 'pink',
  ColorKey.grey: 'grey',
};

_TxnCategory _$TxnCategoryFromJson(Map<String, dynamic> json) => _TxnCategory(
  id: json['id'] as String,
  name: json['name'] as String,
  kind: $enumDecode(_$CategoryKindEnumMap, json['kind']),
  colorKey: $enumDecode(_$ColorKeyEnumMap, json['colorKey']),
  iconKey: $enumDecode(_$IconKeyEnumMap, json['iconKey']),
  monthlyLimitCents: (json['monthlyLimitCents'] as num?)?.toInt(),
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
  archived: json['archived'] as bool? ?? false,
);

Map<String, dynamic> _$TxnCategoryToJson(_TxnCategory instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'kind': _$CategoryKindEnumMap[instance.kind]!,
  'colorKey': _$ColorKeyEnumMap[instance.colorKey]!,
  'iconKey': _$IconKeyEnumMap[instance.iconKey]!,
  'monthlyLimitCents': instance.monthlyLimitCents,
  'sortOrder': instance.sortOrder,
  'archived': instance.archived,
};

const _$CategoryKindEnumMap = {CategoryKind.expense: 'expense', CategoryKind.income: 'income'};

const _$IconKeyEnumMap = {
  IconKey.cart: 'cart',
  IconKey.food: 'food',
  IconKey.car: 'car',
  IconKey.home: 'home',
  IconKey.film: 'film',
  IconKey.heart: 'heart',
  IconKey.gift: 'gift',
  IconKey.plane: 'plane',
  IconKey.book: 'book',
  IconKey.shirt: 'shirt',
  IconKey.bolt: 'bolt',
  IconKey.salary: 'salary',
  IconKey.laptop: 'laptop',
  IconKey.tag: 'tag',
};

_Txn _$TxnFromJson(Map<String, dynamic> json) => _Txn(
  id: json['id'] as String,
  kind: $enumDecode(_$TxnKindEnumMap, json['kind']),
  amountCents: (json['amountCents'] as num).toInt(),
  accountId: json['accountId'] as String,
  date: DateTime.parse(json['date'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  toAccountId: json['toAccountId'] as String?,
  categoryId: json['categoryId'] as String?,
  title: json['title'] as String?,
  note: json['note'] as String?,
  recurringRuleId: json['recurringRuleId'] as String?,
  occurrenceKey: json['occurrenceKey'] as String?,
  receiptPath: json['receiptPath'] as String?,
  deletedAt: json['deletedAt'] == null ? null : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$TxnToJson(_Txn instance) => <String, dynamic>{
  'id': instance.id,
  'kind': _$TxnKindEnumMap[instance.kind]!,
  'amountCents': instance.amountCents,
  'accountId': instance.accountId,
  'date': instance.date.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'toAccountId': instance.toAccountId,
  'categoryId': instance.categoryId,
  'title': instance.title,
  'note': instance.note,
  'recurringRuleId': instance.recurringRuleId,
  'occurrenceKey': instance.occurrenceKey,
  'receiptPath': instance.receiptPath,
  'deletedAt': instance.deletedAt?.toIso8601String(),
};

const _$TxnKindEnumMap = {TxnKind.expense: 'expense', TxnKind.income: 'income', TxnKind.transfer: 'transfer'};

_RecurringRule _$RecurringRuleFromJson(Map<String, dynamic> json) => _RecurringRule(
  id: json['id'] as String,
  title: json['title'] as String,
  kind: $enumDecode(_$TxnKindEnumMap, json['kind']),
  amountCents: (json['amountCents'] as num).toInt(),
  accountId: json['accountId'] as String,
  frequency: $enumDecode(_$FrequencyEnumMap, json['frequency']),
  startDate: DateTime.parse(json['startDate'] as String),
  nextDueDate: DateTime.parse(json['nextDueDate'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  categoryId: json['categoryId'] as String?,
  note: json['note'] as String?,
  interval: (json['interval'] as num?)?.toInt() ?? 1,
  dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
  weekday: (json['weekday'] as num?)?.toInt(),
  active: json['active'] as bool? ?? true,
);

Map<String, dynamic> _$RecurringRuleToJson(_RecurringRule instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'kind': _$TxnKindEnumMap[instance.kind]!,
  'amountCents': instance.amountCents,
  'accountId': instance.accountId,
  'frequency': _$FrequencyEnumMap[instance.frequency]!,
  'startDate': instance.startDate.toIso8601String(),
  'nextDueDate': instance.nextDueDate.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'categoryId': instance.categoryId,
  'note': instance.note,
  'interval': instance.interval,
  'dayOfMonth': instance.dayOfMonth,
  'weekday': instance.weekday,
  'active': instance.active,
};

const _$FrequencyEnumMap = {
  Frequency.monthly: 'monthly',
  Frequency.everyNMonths: 'everyNMonths',
  Frequency.weekly: 'weekly',
  Frequency.yearly: 'yearly',
};

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  monthlyIncomeCents: (json['monthlyIncomeCents'] as num?)?.toInt() ?? 0,
  paydayKind: $enumDecodeNullable(_$PaydayKindEnumMap, json['paydayKind']) ?? PaydayKind.first,
  paydayDay: (json['paydayDay'] as num?)?.toInt() ?? 1,
  currency: json['currency'] as String? ?? 'EUR',
  displayName: json['displayName'] as String?,
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) => <String, dynamic>{
  'monthlyIncomeCents': instance.monthlyIncomeCents,
  'paydayKind': _$PaydayKindEnumMap[instance.paydayKind]!,
  'paydayDay': instance.paydayDay,
  'currency': instance.currency,
  'displayName': instance.displayName,
};

const _$PaydayKindEnumMap = {
  PaydayKind.first: 'first',
  PaydayKind.fifteenth: 'fifteenth',
  PaydayKind.last: 'last',
  PaydayKind.custom: 'custom',
};

_DataSnapshot _$DataSnapshotFromJson(Map<String, dynamic> json) => _DataSnapshot(
  settings: AppSettings.fromJson(json['settings'] as Map<String, dynamic>),
  accounts:
      (json['accounts'] as List<dynamic>?)?.map((e) => Account.fromJson(e as Map<String, dynamic>)).toList() ??
      const <Account>[],
  categories:
      (json['categories'] as List<dynamic>?)?.map((e) => TxnCategory.fromJson(e as Map<String, dynamic>)).toList() ??
      const <TxnCategory>[],
  recurringRules:
      (json['recurringRules'] as List<dynamic>?)
          ?.map((e) => RecurringRule.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <RecurringRule>[],
  txns: (json['txns'] as List<dynamic>?)?.map((e) => Txn.fromJson(e as Map<String, dynamic>)).toList() ?? const <Txn>[],
);

Map<String, dynamic> _$DataSnapshotToJson(_DataSnapshot instance) => <String, dynamic>{
  'settings': instance.settings.toJson(),
  'accounts': instance.accounts.map((e) => e.toJson()).toList(),
  'categories': instance.categories.map((e) => e.toJson()).toList(),
  'recurringRules': instance.recurringRules.map((e) => e.toJson()).toList(),
  'txns': instance.txns.map((e) => e.toJson()).toList(),
};

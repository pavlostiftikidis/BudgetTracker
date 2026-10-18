// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 60),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AccountType, String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<AccountType>($AccountsTable.$convertertype);
  static const VerificationMeta _openingBalanceCentsMeta = const VerificationMeta('openingBalanceCents');
  @override
  late final GeneratedColumn<int> openingBalanceCents = GeneratedColumn<int>(
    'opening_balance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ColorKey, String> colorKey = GeneratedColumn<String>(
    'color_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ColorKey>($AccountsTable.$convertercolorKey);
  static const VerificationMeta _isCreditMeta = const VerificationMeta('isCredit');
  @override
  late final GeneratedColumn<bool> isCredit = GeneratedColumn<bool>(
    'is_credit',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_credit" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _creditLimitCentsMeta = const VerificationMeta('creditLimitCents');
  @override
  late final GeneratedColumn<int> creditLimitCents = GeneratedColumn<int>(
    'credit_limit_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statementDayMeta = const VerificationMeta('statementDay');
  @override
  late final GeneratedColumn<int> statementDay = GeneratedColumn<int>(
    'statement_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _last4Meta = const VerificationMeta('last4');
  @override
  late final GeneratedColumn<String> last4 = GeneratedColumn<String>(
    'last4',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 4, maxTextLength: 4),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalCentsMeta = const VerificationMeta('goalCents');
  @override
  late final GeneratedColumn<int> goalCents = GeneratedColumn<int>(
    'goal_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    openingBalanceCents,
    colorKey,
    isCredit,
    creditLimitCents,
    statementDay,
    last4,
    goalCents,
    archived,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<AccountRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('opening_balance_cents')) {
      context.handle(
        _openingBalanceCentsMeta,
        openingBalanceCents.isAcceptableOrUnknown(data['opening_balance_cents']!, _openingBalanceCentsMeta),
      );
    }
    if (data.containsKey('is_credit')) {
      context.handle(_isCreditMeta, isCredit.isAcceptableOrUnknown(data['is_credit']!, _isCreditMeta));
    }
    if (data.containsKey('credit_limit_cents')) {
      context.handle(
        _creditLimitCentsMeta,
        creditLimitCents.isAcceptableOrUnknown(data['credit_limit_cents']!, _creditLimitCentsMeta),
      );
    }
    if (data.containsKey('statement_day')) {
      context.handle(_statementDayMeta, statementDay.isAcceptableOrUnknown(data['statement_day']!, _statementDayMeta));
    }
    if (data.containsKey('last4')) {
      context.handle(_last4Meta, last4.isAcceptableOrUnknown(data['last4']!, _last4Meta));
    }
    if (data.containsKey('goal_cents')) {
      context.handle(_goalCentsMeta, goalCents.isAcceptableOrUnknown(data['goal_cents']!, _goalCentsMeta));
    }
    if (data.containsKey('archived')) {
      context.handle(_archivedMeta, archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta, sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: $AccountsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      ),
      openingBalanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance_cents'],
      )!,
      colorKey: $AccountsTable.$convertercolorKey.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}color_key'])!,
      ),
      isCredit: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_credit'])!,
      creditLimitCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_limit_cents'],
      ),
      statementDay: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}statement_day']),
      last4: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}last4']),
      goalCents: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}goal_cents']),
      archived: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}archived'])!,
      sortOrder: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountType, String, String> $convertertype = const EnumNameConverter<AccountType>(
    AccountType.values,
  );
  static JsonTypeConverter2<ColorKey, String, String> $convertercolorKey = const EnumNameConverter<ColorKey>(
    ColorKey.values,
  );
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final String id;
  final String name;
  final AccountType type;
  final int openingBalanceCents;
  final ColorKey colorKey;
  final bool isCredit;
  final int? creditLimitCents;
  final int? statementDay;
  final String? last4;
  final int? goalCents;
  final bool archived;
  final int sortOrder;
  const AccountRow({
    required this.id,
    required this.name,
    required this.type,
    required this.openingBalanceCents,
    required this.colorKey,
    required this.isCredit,
    this.creditLimitCents,
    this.statementDay,
    this.last4,
    this.goalCents,
    required this.archived,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>($AccountsTable.$convertertype.toSql(type));
    }
    map['opening_balance_cents'] = Variable<int>(openingBalanceCents);
    {
      map['color_key'] = Variable<String>($AccountsTable.$convertercolorKey.toSql(colorKey));
    }
    map['is_credit'] = Variable<bool>(isCredit);
    if (!nullToAbsent || creditLimitCents != null) {
      map['credit_limit_cents'] = Variable<int>(creditLimitCents);
    }
    if (!nullToAbsent || statementDay != null) {
      map['statement_day'] = Variable<int>(statementDay);
    }
    if (!nullToAbsent || last4 != null) {
      map['last4'] = Variable<String>(last4);
    }
    if (!nullToAbsent || goalCents != null) {
      map['goal_cents'] = Variable<int>(goalCents);
    }
    map['archived'] = Variable<bool>(archived);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      openingBalanceCents: Value(openingBalanceCents),
      colorKey: Value(colorKey),
      isCredit: Value(isCredit),
      creditLimitCents: creditLimitCents == null && nullToAbsent ? const Value.absent() : Value(creditLimitCents),
      statementDay: statementDay == null && nullToAbsent ? const Value.absent() : Value(statementDay),
      last4: last4 == null && nullToAbsent ? const Value.absent() : Value(last4),
      goalCents: goalCents == null && nullToAbsent ? const Value.absent() : Value(goalCents),
      archived: Value(archived),
      sortOrder: Value(sortOrder),
    );
  }

  factory AccountRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $AccountsTable.$convertertype.fromJson(serializer.fromJson<String>(json['type'])),
      openingBalanceCents: serializer.fromJson<int>(json['openingBalanceCents']),
      colorKey: $AccountsTable.$convertercolorKey.fromJson(serializer.fromJson<String>(json['colorKey'])),
      isCredit: serializer.fromJson<bool>(json['isCredit']),
      creditLimitCents: serializer.fromJson<int?>(json['creditLimitCents']),
      statementDay: serializer.fromJson<int?>(json['statementDay']),
      last4: serializer.fromJson<String?>(json['last4']),
      goalCents: serializer.fromJson<int?>(json['goalCents']),
      archived: serializer.fromJson<bool>(json['archived']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>($AccountsTable.$convertertype.toJson(type)),
      'openingBalanceCents': serializer.toJson<int>(openingBalanceCents),
      'colorKey': serializer.toJson<String>($AccountsTable.$convertercolorKey.toJson(colorKey)),
      'isCredit': serializer.toJson<bool>(isCredit),
      'creditLimitCents': serializer.toJson<int?>(creditLimitCents),
      'statementDay': serializer.toJson<int?>(statementDay),
      'last4': serializer.toJson<String?>(last4),
      'goalCents': serializer.toJson<int?>(goalCents),
      'archived': serializer.toJson<bool>(archived),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  AccountRow copyWith({
    String? id,
    String? name,
    AccountType? type,
    int? openingBalanceCents,
    ColorKey? colorKey,
    bool? isCredit,
    Value<int?> creditLimitCents = const Value.absent(),
    Value<int?> statementDay = const Value.absent(),
    Value<String?> last4 = const Value.absent(),
    Value<int?> goalCents = const Value.absent(),
    bool? archived,
    int? sortOrder,
  }) => AccountRow(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    openingBalanceCents: openingBalanceCents ?? this.openingBalanceCents,
    colorKey: colorKey ?? this.colorKey,
    isCredit: isCredit ?? this.isCredit,
    creditLimitCents: creditLimitCents.present ? creditLimitCents.value : this.creditLimitCents,
    statementDay: statementDay.present ? statementDay.value : this.statementDay,
    last4: last4.present ? last4.value : this.last4,
    goalCents: goalCents.present ? goalCents.value : this.goalCents,
    archived: archived ?? this.archived,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  AccountRow copyWithCompanion(AccountsCompanion data) {
    return AccountRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      openingBalanceCents: data.openingBalanceCents.present ? data.openingBalanceCents.value : this.openingBalanceCents,
      colorKey: data.colorKey.present ? data.colorKey.value : this.colorKey,
      isCredit: data.isCredit.present ? data.isCredit.value : this.isCredit,
      creditLimitCents: data.creditLimitCents.present ? data.creditLimitCents.value : this.creditLimitCents,
      statementDay: data.statementDay.present ? data.statementDay.value : this.statementDay,
      last4: data.last4.present ? data.last4.value : this.last4,
      goalCents: data.goalCents.present ? data.goalCents.value : this.goalCents,
      archived: data.archived.present ? data.archived.value : this.archived,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('openingBalanceCents: $openingBalanceCents, ')
          ..write('colorKey: $colorKey, ')
          ..write('isCredit: $isCredit, ')
          ..write('creditLimitCents: $creditLimitCents, ')
          ..write('statementDay: $statementDay, ')
          ..write('last4: $last4, ')
          ..write('goalCents: $goalCents, ')
          ..write('archived: $archived, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    openingBalanceCents,
    colorKey,
    isCredit,
    creditLimitCents,
    statementDay,
    last4,
    goalCents,
    archived,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.openingBalanceCents == this.openingBalanceCents &&
          other.colorKey == this.colorKey &&
          other.isCredit == this.isCredit &&
          other.creditLimitCents == this.creditLimitCents &&
          other.statementDay == this.statementDay &&
          other.last4 == this.last4 &&
          other.goalCents == this.goalCents &&
          other.archived == this.archived &&
          other.sortOrder == this.sortOrder);
}

class AccountsCompanion extends UpdateCompanion<AccountRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<AccountType> type;
  final Value<int> openingBalanceCents;
  final Value<ColorKey> colorKey;
  final Value<bool> isCredit;
  final Value<int?> creditLimitCents;
  final Value<int?> statementDay;
  final Value<String?> last4;
  final Value<int?> goalCents;
  final Value<bool> archived;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.openingBalanceCents = const Value.absent(),
    this.colorKey = const Value.absent(),
    this.isCredit = const Value.absent(),
    this.creditLimitCents = const Value.absent(),
    this.statementDay = const Value.absent(),
    this.last4 = const Value.absent(),
    this.goalCents = const Value.absent(),
    this.archived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String name,
    required AccountType type,
    this.openingBalanceCents = const Value.absent(),
    required ColorKey colorKey,
    this.isCredit = const Value.absent(),
    this.creditLimitCents = const Value.absent(),
    this.statementDay = const Value.absent(),
    this.last4 = const Value.absent(),
    this.goalCents = const Value.absent(),
    this.archived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       colorKey = Value(colorKey);
  static Insertable<AccountRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? openingBalanceCents,
    Expression<String>? colorKey,
    Expression<bool>? isCredit,
    Expression<int>? creditLimitCents,
    Expression<int>? statementDay,
    Expression<String>? last4,
    Expression<int>? goalCents,
    Expression<bool>? archived,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (openingBalanceCents != null) 'opening_balance_cents': openingBalanceCents,
      if (colorKey != null) 'color_key': colorKey,
      if (isCredit != null) 'is_credit': isCredit,
      if (creditLimitCents != null) 'credit_limit_cents': creditLimitCents,
      if (statementDay != null) 'statement_day': statementDay,
      if (last4 != null) 'last4': last4,
      if (goalCents != null) 'goal_cents': goalCents,
      if (archived != null) 'archived': archived,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<AccountType>? type,
    Value<int>? openingBalanceCents,
    Value<ColorKey>? colorKey,
    Value<bool>? isCredit,
    Value<int?>? creditLimitCents,
    Value<int?>? statementDay,
    Value<String?>? last4,
    Value<int?>? goalCents,
    Value<bool>? archived,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      openingBalanceCents: openingBalanceCents ?? this.openingBalanceCents,
      colorKey: colorKey ?? this.colorKey,
      isCredit: isCredit ?? this.isCredit,
      creditLimitCents: creditLimitCents ?? this.creditLimitCents,
      statementDay: statementDay ?? this.statementDay,
      last4: last4 ?? this.last4,
      goalCents: goalCents ?? this.goalCents,
      archived: archived ?? this.archived,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>($AccountsTable.$convertertype.toSql(type.value));
    }
    if (openingBalanceCents.present) {
      map['opening_balance_cents'] = Variable<int>(openingBalanceCents.value);
    }
    if (colorKey.present) {
      map['color_key'] = Variable<String>($AccountsTable.$convertercolorKey.toSql(colorKey.value));
    }
    if (isCredit.present) {
      map['is_credit'] = Variable<bool>(isCredit.value);
    }
    if (creditLimitCents.present) {
      map['credit_limit_cents'] = Variable<int>(creditLimitCents.value);
    }
    if (statementDay.present) {
      map['statement_day'] = Variable<int>(statementDay.value);
    }
    if (last4.present) {
      map['last4'] = Variable<String>(last4.value);
    }
    if (goalCents.present) {
      map['goal_cents'] = Variable<int>(goalCents.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('openingBalanceCents: $openingBalanceCents, ')
          ..write('colorKey: $colorKey, ')
          ..write('isCredit: $isCredit, ')
          ..write('creditLimitCents: $creditLimitCents, ')
          ..write('statementDay: $statementDay, ')
          ..write('last4: $last4, ')
          ..write('goalCents: $goalCents, ')
          ..write('archived: $archived, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 40),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CategoryKind, String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<CategoryKind>($CategoriesTable.$converterkind);
  @override
  late final GeneratedColumnWithTypeConverter<ColorKey, String> colorKey = GeneratedColumn<String>(
    'color_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ColorKey>($CategoriesTable.$convertercolorKey);
  @override
  late final GeneratedColumnWithTypeConverter<IconKey, String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<IconKey>($CategoriesTable.$convertericonKey);
  static const VerificationMeta _monthlyLimitCentsMeta = const VerificationMeta('monthlyLimitCents');
  @override
  late final GeneratedColumn<int> monthlyLimitCents = GeneratedColumn<int>(
    'monthly_limit_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, kind, colorKey, iconKey, monthlyLimitCents, sortOrder, archived];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('monthly_limit_cents')) {
      context.handle(
        _monthlyLimitCentsMeta,
        monthlyLimitCents.isAcceptableOrUnknown(data['monthly_limit_cents']!, _monthlyLimitCentsMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta, sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('archived')) {
      context.handle(_archivedMeta, archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      kind: $CategoriesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      ),
      colorKey: $CategoriesTable.$convertercolorKey.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}color_key'])!,
      ),
      iconKey: $CategoriesTable.$convertericonKey.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}icon_key'])!,
      ),
      monthlyLimitCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_limit_cents'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      archived: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}archived'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategoryKind, String, String> $converterkind = const EnumNameConverter<CategoryKind>(
    CategoryKind.values,
  );
  static JsonTypeConverter2<ColorKey, String, String> $convertercolorKey = const EnumNameConverter<ColorKey>(
    ColorKey.values,
  );
  static JsonTypeConverter2<IconKey, String, String> $convertericonKey = const EnumNameConverter<IconKey>(
    IconKey.values,
  );
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String name;
  final CategoryKind kind;
  final ColorKey colorKey;
  final IconKey iconKey;
  final int? monthlyLimitCents;
  final int sortOrder;
  final bool archived;
  const CategoryRow({
    required this.id,
    required this.name,
    required this.kind,
    required this.colorKey,
    required this.iconKey,
    this.monthlyLimitCents,
    required this.sortOrder,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>($CategoriesTable.$converterkind.toSql(kind));
    }
    {
      map['color_key'] = Variable<String>($CategoriesTable.$convertercolorKey.toSql(colorKey));
    }
    {
      map['icon_key'] = Variable<String>($CategoriesTable.$convertericonKey.toSql(iconKey));
    }
    if (!nullToAbsent || monthlyLimitCents != null) {
      map['monthly_limit_cents'] = Variable<int>(monthlyLimitCents);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      colorKey: Value(colorKey),
      iconKey: Value(iconKey),
      monthlyLimitCents: monthlyLimitCents == null && nullToAbsent ? const Value.absent() : Value(monthlyLimitCents),
      sortOrder: Value(sortOrder),
      archived: Value(archived),
    );
  }

  factory CategoryRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $CategoriesTable.$converterkind.fromJson(serializer.fromJson<String>(json['kind'])),
      colorKey: $CategoriesTable.$convertercolorKey.fromJson(serializer.fromJson<String>(json['colorKey'])),
      iconKey: $CategoriesTable.$convertericonKey.fromJson(serializer.fromJson<String>(json['iconKey'])),
      monthlyLimitCents: serializer.fromJson<int?>(json['monthlyLimitCents']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>($CategoriesTable.$converterkind.toJson(kind)),
      'colorKey': serializer.toJson<String>($CategoriesTable.$convertercolorKey.toJson(colorKey)),
      'iconKey': serializer.toJson<String>($CategoriesTable.$convertericonKey.toJson(iconKey)),
      'monthlyLimitCents': serializer.toJson<int?>(monthlyLimitCents),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  CategoryRow copyWith({
    String? id,
    String? name,
    CategoryKind? kind,
    ColorKey? colorKey,
    IconKey? iconKey,
    Value<int?> monthlyLimitCents = const Value.absent(),
    int? sortOrder,
    bool? archived,
  }) => CategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    colorKey: colorKey ?? this.colorKey,
    iconKey: iconKey ?? this.iconKey,
    monthlyLimitCents: monthlyLimitCents.present ? monthlyLimitCents.value : this.monthlyLimitCents,
    sortOrder: sortOrder ?? this.sortOrder,
    archived: archived ?? this.archived,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      colorKey: data.colorKey.present ? data.colorKey.value : this.colorKey,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      monthlyLimitCents: data.monthlyLimitCents.present ? data.monthlyLimitCents.value : this.monthlyLimitCents,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('colorKey: $colorKey, ')
          ..write('iconKey: $iconKey, ')
          ..write('monthlyLimitCents: $monthlyLimitCents, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, kind, colorKey, iconKey, monthlyLimitCents, sortOrder, archived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.colorKey == this.colorKey &&
          other.iconKey == this.iconKey &&
          other.monthlyLimitCents == this.monthlyLimitCents &&
          other.sortOrder == this.sortOrder &&
          other.archived == this.archived);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<CategoryKind> kind;
  final Value<ColorKey> colorKey;
  final Value<IconKey> iconKey;
  final Value<int?> monthlyLimitCents;
  final Value<int> sortOrder;
  final Value<bool> archived;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.colorKey = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.monthlyLimitCents = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    required CategoryKind kind,
    required ColorKey colorKey,
    required IconKey iconKey,
    this.monthlyLimitCents = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       kind = Value(kind),
       colorKey = Value(colorKey),
       iconKey = Value(iconKey);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<String>? colorKey,
    Expression<String>? iconKey,
    Expression<int>? monthlyLimitCents,
    Expression<int>? sortOrder,
    Expression<bool>? archived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (colorKey != null) 'color_key': colorKey,
      if (iconKey != null) 'icon_key': iconKey,
      if (monthlyLimitCents != null) 'monthly_limit_cents': monthlyLimitCents,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (archived != null) 'archived': archived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<CategoryKind>? kind,
    Value<ColorKey>? colorKey,
    Value<IconKey>? iconKey,
    Value<int?>? monthlyLimitCents,
    Value<int>? sortOrder,
    Value<bool>? archived,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      colorKey: colorKey ?? this.colorKey,
      iconKey: iconKey ?? this.iconKey,
      monthlyLimitCents: monthlyLimitCents ?? this.monthlyLimitCents,
      sortOrder: sortOrder ?? this.sortOrder,
      archived: archived ?? this.archived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>($CategoriesTable.$converterkind.toSql(kind.value));
    }
    if (colorKey.present) {
      map['color_key'] = Variable<String>($CategoriesTable.$convertercolorKey.toSql(colorKey.value));
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>($CategoriesTable.$convertericonKey.toSql(iconKey.value));
    }
    if (monthlyLimitCents.present) {
      map['monthly_limit_cents'] = Variable<int>(monthlyLimitCents.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('colorKey: $colorKey, ')
          ..write('iconKey: $iconKey, ')
          ..write('monthlyLimitCents: $monthlyLimitCents, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archived: $archived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringRulesTable extends RecurringRules with TableInfo<$RecurringRulesTable, RecurringRuleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 60),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TxnKind, String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TxnKind>($RecurringRulesTable.$converterkind);
  static const VerificationMeta _amountCentsMeta = const VerificationMeta('amountCents');
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    check: () => ComparableExpr(amountCents).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Frequency, String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Frequency>($RecurringRulesTable.$converterfrequency);
  static const VerificationMeta _intervalMeta = const VerificationMeta('interval');
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
    'interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _dayOfMonthMeta = const VerificationMeta('dayOfMonth');
  @override
  late final GeneratedColumn<int> dayOfMonth = GeneratedColumn<int>(
    'day_of_month',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta('weekday');
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextDueDateMeta = const VerificationMeta('nextDueDate');
  @override
  late final GeneratedColumn<DateTime> nextDueDate = GeneratedColumn<DateTime>(
    'next_due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    kind,
    amountCents,
    accountId,
    categoryId,
    note,
    frequency,
    interval,
    dayOfMonth,
    weekday,
    startDate,
    nextDueDate,
    active,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_rules';
  @override
  VerificationContext validateIntegrity(Insertable<RecurringRuleRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(_amountCentsMeta, amountCents.isAcceptableOrUnknown(data['amount_cents']!, _amountCentsMeta));
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta, accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(_categoryIdMeta, categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('note')) {
      context.handle(_noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('interval')) {
      context.handle(_intervalMeta, interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta));
    }
    if (data.containsKey('day_of_month')) {
      context.handle(_dayOfMonthMeta, dayOfMonth.isAcceptableOrUnknown(data['day_of_month']!, _dayOfMonthMeta));
    }
    if (data.containsKey('weekday')) {
      context.handle(_weekdayMeta, weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta, startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('next_due_date')) {
      context.handle(_nextDueDateMeta, nextDueDate.isAcceptableOrUnknown(data['next_due_date']!, _nextDueDateMeta));
    } else if (isInserting) {
      context.missing(_nextDueDateMeta);
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta, active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringRuleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringRuleRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      kind: $RecurringRulesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      ),
      amountCents: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}amount_cents'])!,
      accountId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      categoryId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}note']),
      frequency: $RecurringRulesTable.$converterfrequency.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}frequency'])!,
      ),
      interval: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}interval'])!,
      dayOfMonth: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}day_of_month']),
      weekday: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}weekday']),
      startDate: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      nextDueDate: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}next_due_date'])!,
      active: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RecurringRulesTable createAlias(String alias) {
    return $RecurringRulesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TxnKind, String, String> $converterkind = const EnumNameConverter<TxnKind>(TxnKind.values);
  static JsonTypeConverter2<Frequency, String, String> $converterfrequency = const EnumNameConverter<Frequency>(
    Frequency.values,
  );
}

class RecurringRuleRow extends DataClass implements Insertable<RecurringRuleRow> {
  final String id;
  final String title;
  final TxnKind kind;
  final int amountCents;
  final String accountId;
  final String? categoryId;
  final String? note;
  final Frequency frequency;
  final int interval;
  final int? dayOfMonth;
  final int? weekday;
  final DateTime startDate;
  final DateTime nextDueDate;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RecurringRuleRow({
    required this.id,
    required this.title,
    required this.kind,
    required this.amountCents,
    required this.accountId,
    this.categoryId,
    this.note,
    required this.frequency,
    required this.interval,
    this.dayOfMonth,
    this.weekday,
    required this.startDate,
    required this.nextDueDate,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    {
      map['kind'] = Variable<String>($RecurringRulesTable.$converterkind.toSql(kind));
    }
    map['amount_cents'] = Variable<int>(amountCents);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    {
      map['frequency'] = Variable<String>($RecurringRulesTable.$converterfrequency.toSql(frequency));
    }
    map['interval'] = Variable<int>(interval);
    if (!nullToAbsent || dayOfMonth != null) {
      map['day_of_month'] = Variable<int>(dayOfMonth);
    }
    if (!nullToAbsent || weekday != null) {
      map['weekday'] = Variable<int>(weekday);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    map['next_due_date'] = Variable<DateTime>(nextDueDate);
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecurringRulesCompanion toCompanion(bool nullToAbsent) {
    return RecurringRulesCompanion(
      id: Value(id),
      title: Value(title),
      kind: Value(kind),
      amountCents: Value(amountCents),
      accountId: Value(accountId),
      categoryId: categoryId == null && nullToAbsent ? const Value.absent() : Value(categoryId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      frequency: Value(frequency),
      interval: Value(interval),
      dayOfMonth: dayOfMonth == null && nullToAbsent ? const Value.absent() : Value(dayOfMonth),
      weekday: weekday == null && nullToAbsent ? const Value.absent() : Value(weekday),
      startDate: Value(startDate),
      nextDueDate: Value(nextDueDate),
      active: Value(active),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecurringRuleRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringRuleRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      kind: $RecurringRulesTable.$converterkind.fromJson(serializer.fromJson<String>(json['kind'])),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      accountId: serializer.fromJson<String>(json['accountId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      note: serializer.fromJson<String?>(json['note']),
      frequency: $RecurringRulesTable.$converterfrequency.fromJson(serializer.fromJson<String>(json['frequency'])),
      interval: serializer.fromJson<int>(json['interval']),
      dayOfMonth: serializer.fromJson<int?>(json['dayOfMonth']),
      weekday: serializer.fromJson<int?>(json['weekday']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      nextDueDate: serializer.fromJson<DateTime>(json['nextDueDate']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'kind': serializer.toJson<String>($RecurringRulesTable.$converterkind.toJson(kind)),
      'amountCents': serializer.toJson<int>(amountCents),
      'accountId': serializer.toJson<String>(accountId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'note': serializer.toJson<String?>(note),
      'frequency': serializer.toJson<String>($RecurringRulesTable.$converterfrequency.toJson(frequency)),
      'interval': serializer.toJson<int>(interval),
      'dayOfMonth': serializer.toJson<int?>(dayOfMonth),
      'weekday': serializer.toJson<int?>(weekday),
      'startDate': serializer.toJson<DateTime>(startDate),
      'nextDueDate': serializer.toJson<DateTime>(nextDueDate),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RecurringRuleRow copyWith({
    String? id,
    String? title,
    TxnKind? kind,
    int? amountCents,
    String? accountId,
    Value<String?> categoryId = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Frequency? frequency,
    int? interval,
    Value<int?> dayOfMonth = const Value.absent(),
    Value<int?> weekday = const Value.absent(),
    DateTime? startDate,
    DateTime? nextDueDate,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RecurringRuleRow(
    id: id ?? this.id,
    title: title ?? this.title,
    kind: kind ?? this.kind,
    amountCents: amountCents ?? this.amountCents,
    accountId: accountId ?? this.accountId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    note: note.present ? note.value : this.note,
    frequency: frequency ?? this.frequency,
    interval: interval ?? this.interval,
    dayOfMonth: dayOfMonth.present ? dayOfMonth.value : this.dayOfMonth,
    weekday: weekday.present ? weekday.value : this.weekday,
    startDate: startDate ?? this.startDate,
    nextDueDate: nextDueDate ?? this.nextDueDate,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RecurringRuleRow copyWithCompanion(RecurringRulesCompanion data) {
    return RecurringRuleRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      kind: data.kind.present ? data.kind.value : this.kind,
      amountCents: data.amountCents.present ? data.amountCents.value : this.amountCents,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId: data.categoryId.present ? data.categoryId.value : this.categoryId,
      note: data.note.present ? data.note.value : this.note,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      interval: data.interval.present ? data.interval.value : this.interval,
      dayOfMonth: data.dayOfMonth.present ? data.dayOfMonth.value : this.dayOfMonth,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      nextDueDate: data.nextDueDate.present ? data.nextDueDate.value : this.nextDueDate,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRuleRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('amountCents: $amountCents, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('frequency: $frequency, ')
          ..write('interval: $interval, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('weekday: $weekday, ')
          ..write('startDate: $startDate, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    kind,
    amountCents,
    accountId,
    categoryId,
    note,
    frequency,
    interval,
    dayOfMonth,
    weekday,
    startDate,
    nextDueDate,
    active,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringRuleRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.kind == this.kind &&
          other.amountCents == this.amountCents &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.note == this.note &&
          other.frequency == this.frequency &&
          other.interval == this.interval &&
          other.dayOfMonth == this.dayOfMonth &&
          other.weekday == this.weekday &&
          other.startDate == this.startDate &&
          other.nextDueDate == this.nextDueDate &&
          other.active == this.active &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecurringRulesCompanion extends UpdateCompanion<RecurringRuleRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<TxnKind> kind;
  final Value<int> amountCents;
  final Value<String> accountId;
  final Value<String?> categoryId;
  final Value<String?> note;
  final Value<Frequency> frequency;
  final Value<int> interval;
  final Value<int?> dayOfMonth;
  final Value<int?> weekday;
  final Value<DateTime> startDate;
  final Value<DateTime> nextDueDate;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RecurringRulesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.kind = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.frequency = const Value.absent(),
    this.interval = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.weekday = const Value.absent(),
    this.startDate = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringRulesCompanion.insert({
    required String id,
    required String title,
    required TxnKind kind,
    required int amountCents,
    required String accountId,
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    required Frequency frequency,
    this.interval = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.weekday = const Value.absent(),
    required DateTime startDate,
    required DateTime nextDueDate,
    this.active = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       kind = Value(kind),
       amountCents = Value(amountCents),
       accountId = Value(accountId),
       frequency = Value(frequency),
       startDate = Value(startDate),
       nextDueDate = Value(nextDueDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RecurringRuleRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? kind,
    Expression<int>? amountCents,
    Expression<String>? accountId,
    Expression<String>? categoryId,
    Expression<String>? note,
    Expression<String>? frequency,
    Expression<int>? interval,
    Expression<int>? dayOfMonth,
    Expression<int>? weekday,
    Expression<DateTime>? startDate,
    Expression<DateTime>? nextDueDate,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (kind != null) 'kind': kind,
      if (amountCents != null) 'amount_cents': amountCents,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (note != null) 'note': note,
      if (frequency != null) 'frequency': frequency,
      if (interval != null) 'interval': interval,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (weekday != null) 'weekday': weekday,
      if (startDate != null) 'start_date': startDate,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringRulesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<TxnKind>? kind,
    Value<int>? amountCents,
    Value<String>? accountId,
    Value<String?>? categoryId,
    Value<String?>? note,
    Value<Frequency>? frequency,
    Value<int>? interval,
    Value<int?>? dayOfMonth,
    Value<int?>? weekday,
    Value<DateTime>? startDate,
    Value<DateTime>? nextDueDate,
    Value<bool>? active,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecurringRulesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      kind: kind ?? this.kind,
      amountCents: amountCents ?? this.amountCents,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      weekday: weekday ?? this.weekday,
      startDate: startDate ?? this.startDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>($RecurringRulesTable.$converterkind.toSql(kind.value));
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>($RecurringRulesTable.$converterfrequency.toSql(frequency.value));
    }
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
    }
    if (dayOfMonth.present) {
      map['day_of_month'] = Variable<int>(dayOfMonth.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRulesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('amountCents: $amountCents, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('frequency: $frequency, ')
          ..write('interval: $interval, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('weekday: $weekday, ')
          ..write('startDate: $startDate, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TxnsTable extends Txns with TableInfo<$TxnsTable, TxnRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TxnsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TxnKind, String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TxnKind>($TxnsTable.$converterkind);
  static const VerificationMeta _amountCentsMeta = const VerificationMeta('amountCents');
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    check: () => ComparableExpr(amountCents).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'),
  );
  static const VerificationMeta _toAccountIdMeta = const VerificationMeta('toAccountId');
  @override
  late final GeneratedColumn<String> toAccountId = GeneratedColumn<String>(
    'to_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurringRuleIdMeta = const VerificationMeta('recurringRuleId');
  @override
  late final GeneratedColumn<String> recurringRuleId = GeneratedColumn<String>(
    'recurring_rule_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES recurring_rules (id) ON DELETE SET NULL'),
  );
  static const VerificationMeta _occurrenceKeyMeta = const VerificationMeta('occurrenceKey');
  @override
  late final GeneratedColumn<String> occurrenceKey = GeneratedColumn<String>(
    'occurrence_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptPathMeta = const VerificationMeta('receiptPath');
  @override
  late final GeneratedColumn<String> receiptPath = GeneratedColumn<String>(
    'receipt_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    amountCents,
    accountId,
    toAccountId,
    categoryId,
    title,
    date,
    note,
    recurringRuleId,
    occurrenceKey,
    receiptPath,
    deletedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'txns';
  @override
  VerificationContext validateIntegrity(Insertable<TxnRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(_amountCentsMeta, amountCents.isAcceptableOrUnknown(data['amount_cents']!, _amountCentsMeta));
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta, accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('to_account_id')) {
      context.handle(_toAccountIdMeta, toAccountId.isAcceptableOrUnknown(data['to_account_id']!, _toAccountIdMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(_categoryIdMeta, categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('date')) {
      context.handle(_dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(_noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('recurring_rule_id')) {
      context.handle(
        _recurringRuleIdMeta,
        recurringRuleId.isAcceptableOrUnknown(data['recurring_rule_id']!, _recurringRuleIdMeta),
      );
    }
    if (data.containsKey('occurrence_key')) {
      context.handle(
        _occurrenceKeyMeta,
        occurrenceKey.isAcceptableOrUnknown(data['occurrence_key']!, _occurrenceKeyMeta),
      );
    }
    if (data.containsKey('receipt_path')) {
      context.handle(_receiptPathMeta, receiptPath.isAcceptableOrUnknown(data['receipt_path']!, _receiptPathMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta, deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {recurringRuleId, occurrenceKey},
  ];
  @override
  TxnRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TxnRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      kind: $TxnsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      ),
      amountCents: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}amount_cents'])!,
      accountId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      toAccountId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}to_account_id']),
      categoryId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title']),
      date: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}note']),
      recurringRuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurring_rule_id'],
      ),
      occurrenceKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}occurrence_key']),
      receiptPath: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}receipt_path']),
      deletedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TxnsTable createAlias(String alias) {
    return $TxnsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TxnKind, String, String> $converterkind = const EnumNameConverter<TxnKind>(TxnKind.values);
}

class TxnRow extends DataClass implements Insertable<TxnRow> {
  final String id;
  final TxnKind kind;
  final int amountCents;
  final String accountId;
  final String? toAccountId;
  final String? categoryId;
  final String? title;
  final DateTime date;
  final String? note;
  final String? recurringRuleId;
  final String? occurrenceKey;
  final String? receiptPath;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TxnRow({
    required this.id,
    required this.kind,
    required this.amountCents,
    required this.accountId,
    this.toAccountId,
    this.categoryId,
    this.title,
    required this.date,
    this.note,
    this.recurringRuleId,
    this.occurrenceKey,
    this.receiptPath,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['kind'] = Variable<String>($TxnsTable.$converterkind.toSql(kind));
    }
    map['amount_cents'] = Variable<int>(amountCents);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || toAccountId != null) {
      map['to_account_id'] = Variable<String>(toAccountId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || recurringRuleId != null) {
      map['recurring_rule_id'] = Variable<String>(recurringRuleId);
    }
    if (!nullToAbsent || occurrenceKey != null) {
      map['occurrence_key'] = Variable<String>(occurrenceKey);
    }
    if (!nullToAbsent || receiptPath != null) {
      map['receipt_path'] = Variable<String>(receiptPath);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TxnsCompanion toCompanion(bool nullToAbsent) {
    return TxnsCompanion(
      id: Value(id),
      kind: Value(kind),
      amountCents: Value(amountCents),
      accountId: Value(accountId),
      toAccountId: toAccountId == null && nullToAbsent ? const Value.absent() : Value(toAccountId),
      categoryId: categoryId == null && nullToAbsent ? const Value.absent() : Value(categoryId),
      title: title == null && nullToAbsent ? const Value.absent() : Value(title),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      recurringRuleId: recurringRuleId == null && nullToAbsent ? const Value.absent() : Value(recurringRuleId),
      occurrenceKey: occurrenceKey == null && nullToAbsent ? const Value.absent() : Value(occurrenceKey),
      receiptPath: receiptPath == null && nullToAbsent ? const Value.absent() : Value(receiptPath),
      deletedAt: deletedAt == null && nullToAbsent ? const Value.absent() : Value(deletedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TxnRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TxnRow(
      id: serializer.fromJson<String>(json['id']),
      kind: $TxnsTable.$converterkind.fromJson(serializer.fromJson<String>(json['kind'])),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      accountId: serializer.fromJson<String>(json['accountId']),
      toAccountId: serializer.fromJson<String?>(json['toAccountId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      title: serializer.fromJson<String?>(json['title']),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      recurringRuleId: serializer.fromJson<String?>(json['recurringRuleId']),
      occurrenceKey: serializer.fromJson<String?>(json['occurrenceKey']),
      receiptPath: serializer.fromJson<String?>(json['receiptPath']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>($TxnsTable.$converterkind.toJson(kind)),
      'amountCents': serializer.toJson<int>(amountCents),
      'accountId': serializer.toJson<String>(accountId),
      'toAccountId': serializer.toJson<String?>(toAccountId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'title': serializer.toJson<String?>(title),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String?>(note),
      'recurringRuleId': serializer.toJson<String?>(recurringRuleId),
      'occurrenceKey': serializer.toJson<String?>(occurrenceKey),
      'receiptPath': serializer.toJson<String?>(receiptPath),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TxnRow copyWith({
    String? id,
    TxnKind? kind,
    int? amountCents,
    String? accountId,
    Value<String?> toAccountId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> title = const Value.absent(),
    DateTime? date,
    Value<String?> note = const Value.absent(),
    Value<String?> recurringRuleId = const Value.absent(),
    Value<String?> occurrenceKey = const Value.absent(),
    Value<String?> receiptPath = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TxnRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    amountCents: amountCents ?? this.amountCents,
    accountId: accountId ?? this.accountId,
    toAccountId: toAccountId.present ? toAccountId.value : this.toAccountId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    title: title.present ? title.value : this.title,
    date: date ?? this.date,
    note: note.present ? note.value : this.note,
    recurringRuleId: recurringRuleId.present ? recurringRuleId.value : this.recurringRuleId,
    occurrenceKey: occurrenceKey.present ? occurrenceKey.value : this.occurrenceKey,
    receiptPath: receiptPath.present ? receiptPath.value : this.receiptPath,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TxnRow copyWithCompanion(TxnsCompanion data) {
    return TxnRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      amountCents: data.amountCents.present ? data.amountCents.value : this.amountCents,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      toAccountId: data.toAccountId.present ? data.toAccountId.value : this.toAccountId,
      categoryId: data.categoryId.present ? data.categoryId.value : this.categoryId,
      title: data.title.present ? data.title.value : this.title,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      recurringRuleId: data.recurringRuleId.present ? data.recurringRuleId.value : this.recurringRuleId,
      occurrenceKey: data.occurrenceKey.present ? data.occurrenceKey.value : this.occurrenceKey,
      receiptPath: data.receiptPath.present ? data.receiptPath.value : this.receiptPath,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TxnRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('amountCents: $amountCents, ')
          ..write('accountId: $accountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('recurringRuleId: $recurringRuleId, ')
          ..write('occurrenceKey: $occurrenceKey, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    amountCents,
    accountId,
    toAccountId,
    categoryId,
    title,
    date,
    note,
    recurringRuleId,
    occurrenceKey,
    receiptPath,
    deletedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TxnRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.amountCents == this.amountCents &&
          other.accountId == this.accountId &&
          other.toAccountId == this.toAccountId &&
          other.categoryId == this.categoryId &&
          other.title == this.title &&
          other.date == this.date &&
          other.note == this.note &&
          other.recurringRuleId == this.recurringRuleId &&
          other.occurrenceKey == this.occurrenceKey &&
          other.receiptPath == this.receiptPath &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TxnsCompanion extends UpdateCompanion<TxnRow> {
  final Value<String> id;
  final Value<TxnKind> kind;
  final Value<int> amountCents;
  final Value<String> accountId;
  final Value<String?> toAccountId;
  final Value<String?> categoryId;
  final Value<String?> title;
  final Value<DateTime> date;
  final Value<String?> note;
  final Value<String?> recurringRuleId;
  final Value<String?> occurrenceKey;
  final Value<String?> receiptPath;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TxnsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.accountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.title = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.recurringRuleId = const Value.absent(),
    this.occurrenceKey = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TxnsCompanion.insert({
    required String id,
    required TxnKind kind,
    required int amountCents,
    required String accountId,
    this.toAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.title = const Value.absent(),
    required DateTime date,
    this.note = const Value.absent(),
    this.recurringRuleId = const Value.absent(),
    this.occurrenceKey = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       amountCents = Value(amountCents),
       accountId = Value(accountId),
       date = Value(date),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TxnRow> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<int>? amountCents,
    Expression<String>? accountId,
    Expression<String>? toAccountId,
    Expression<String>? categoryId,
    Expression<String>? title,
    Expression<DateTime>? date,
    Expression<String>? note,
    Expression<String>? recurringRuleId,
    Expression<String>? occurrenceKey,
    Expression<String>? receiptPath,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (amountCents != null) 'amount_cents': amountCents,
      if (accountId != null) 'account_id': accountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (categoryId != null) 'category_id': categoryId,
      if (title != null) 'title': title,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (recurringRuleId != null) 'recurring_rule_id': recurringRuleId,
      if (occurrenceKey != null) 'occurrence_key': occurrenceKey,
      if (receiptPath != null) 'receipt_path': receiptPath,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TxnsCompanion copyWith({
    Value<String>? id,
    Value<TxnKind>? kind,
    Value<int>? amountCents,
    Value<String>? accountId,
    Value<String?>? toAccountId,
    Value<String?>? categoryId,
    Value<String?>? title,
    Value<DateTime>? date,
    Value<String?>? note,
    Value<String?>? recurringRuleId,
    Value<String?>? occurrenceKey,
    Value<String?>? receiptPath,
    Value<DateTime?>? deletedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TxnsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      amountCents: amountCents ?? this.amountCents,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      date: date ?? this.date,
      note: note ?? this.note,
      recurringRuleId: recurringRuleId ?? this.recurringRuleId,
      occurrenceKey: occurrenceKey ?? this.occurrenceKey,
      receiptPath: receiptPath ?? this.receiptPath,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>($TxnsTable.$converterkind.toSql(kind.value));
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<String>(toAccountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (recurringRuleId.present) {
      map['recurring_rule_id'] = Variable<String>(recurringRuleId.value);
    }
    if (occurrenceKey.present) {
      map['occurrence_key'] = Variable<String>(occurrenceKey.value);
    }
    if (receiptPath.present) {
      map['receipt_path'] = Variable<String>(receiptPath.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TxnsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('amountCents: $amountCents, ')
          ..write('accountId: $accountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('recurringRuleId: $recurringRuleId, ')
          ..write('occurrenceKey: $occurrenceKey, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsEntriesTable extends SettingsEntries with TableInfo<$SettingsEntriesTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _monthlyIncomeCentsMeta = const VerificationMeta('monthlyIncomeCents');
  @override
  late final GeneratedColumn<int> monthlyIncomeCents = GeneratedColumn<int>(
    'monthly_income_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaydayKind, String> paydayKind = GeneratedColumn<String>(
    'payday_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(PaydayKind.first.name),
  ).withConverter<PaydayKind>($SettingsEntriesTable.$converterpaydayKind);
  static const VerificationMeta _paydayDayMeta = const VerificationMeta('paydayDay');
  @override
  late final GeneratedColumn<int> paydayDay = GeneratedColumn<int>(
    'payday_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EUR'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, monthlyIncomeCents, paydayKind, paydayDay, currency, displayName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<SettingsRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('monthly_income_cents')) {
      context.handle(
        _monthlyIncomeCentsMeta,
        monthlyIncomeCents.isAcceptableOrUnknown(data['monthly_income_cents']!, _monthlyIncomeCentsMeta),
      );
    }
    if (data.containsKey('payday_day')) {
      context.handle(_paydayDayMeta, paydayDay.isAcceptableOrUnknown(data['payday_day']!, _paydayDayMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta, currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(_displayNameMeta, displayName.isAcceptableOrUnknown(data['display_name']!, _displayNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      monthlyIncomeCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_income_cents'],
      )!,
      paydayKind: $SettingsEntriesTable.$converterpaydayKind.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}payday_kind'])!,
      ),
      paydayDay: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}payday_day'])!,
      currency: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      displayName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}display_name']),
    );
  }

  @override
  $SettingsEntriesTable createAlias(String alias) {
    return $SettingsEntriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PaydayKind, String, String> $converterpaydayKind = const EnumNameConverter<PaydayKind>(
    PaydayKind.values,
  );
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final int id;
  final int monthlyIncomeCents;
  final PaydayKind paydayKind;
  final int paydayDay;
  final String currency;
  final String? displayName;
  const SettingsRow({
    required this.id,
    required this.monthlyIncomeCents,
    required this.paydayKind,
    required this.paydayDay,
    required this.currency,
    this.displayName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['monthly_income_cents'] = Variable<int>(monthlyIncomeCents);
    {
      map['payday_kind'] = Variable<String>($SettingsEntriesTable.$converterpaydayKind.toSql(paydayKind));
    }
    map['payday_day'] = Variable<int>(paydayDay);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    return map;
  }

  SettingsEntriesCompanion toCompanion(bool nullToAbsent) {
    return SettingsEntriesCompanion(
      id: Value(id),
      monthlyIncomeCents: Value(monthlyIncomeCents),
      paydayKind: Value(paydayKind),
      paydayDay: Value(paydayDay),
      currency: Value(currency),
      displayName: displayName == null && nullToAbsent ? const Value.absent() : Value(displayName),
    );
  }

  factory SettingsRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<int>(json['id']),
      monthlyIncomeCents: serializer.fromJson<int>(json['monthlyIncomeCents']),
      paydayKind: $SettingsEntriesTable.$converterpaydayKind.fromJson(serializer.fromJson<String>(json['paydayKind'])),
      paydayDay: serializer.fromJson<int>(json['paydayDay']),
      currency: serializer.fromJson<String>(json['currency']),
      displayName: serializer.fromJson<String?>(json['displayName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'monthlyIncomeCents': serializer.toJson<int>(monthlyIncomeCents),
      'paydayKind': serializer.toJson<String>($SettingsEntriesTable.$converterpaydayKind.toJson(paydayKind)),
      'paydayDay': serializer.toJson<int>(paydayDay),
      'currency': serializer.toJson<String>(currency),
      'displayName': serializer.toJson<String?>(displayName),
    };
  }

  SettingsRow copyWith({
    int? id,
    int? monthlyIncomeCents,
    PaydayKind? paydayKind,
    int? paydayDay,
    String? currency,
    Value<String?> displayName = const Value.absent(),
  }) => SettingsRow(
    id: id ?? this.id,
    monthlyIncomeCents: monthlyIncomeCents ?? this.monthlyIncomeCents,
    paydayKind: paydayKind ?? this.paydayKind,
    paydayDay: paydayDay ?? this.paydayDay,
    currency: currency ?? this.currency,
    displayName: displayName.present ? displayName.value : this.displayName,
  );
  SettingsRow copyWithCompanion(SettingsEntriesCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      monthlyIncomeCents: data.monthlyIncomeCents.present ? data.monthlyIncomeCents.value : this.monthlyIncomeCents,
      paydayKind: data.paydayKind.present ? data.paydayKind.value : this.paydayKind,
      paydayDay: data.paydayDay.present ? data.paydayDay.value : this.paydayDay,
      currency: data.currency.present ? data.currency.value : this.currency,
      displayName: data.displayName.present ? data.displayName.value : this.displayName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('monthlyIncomeCents: $monthlyIncomeCents, ')
          ..write('paydayKind: $paydayKind, ')
          ..write('paydayDay: $paydayDay, ')
          ..write('currency: $currency, ')
          ..write('displayName: $displayName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, monthlyIncomeCents, paydayKind, paydayDay, currency, displayName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.monthlyIncomeCents == this.monthlyIncomeCents &&
          other.paydayKind == this.paydayKind &&
          other.paydayDay == this.paydayDay &&
          other.currency == this.currency &&
          other.displayName == this.displayName);
}

class SettingsEntriesCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<int> monthlyIncomeCents;
  final Value<PaydayKind> paydayKind;
  final Value<int> paydayDay;
  final Value<String> currency;
  final Value<String?> displayName;
  const SettingsEntriesCompanion({
    this.id = const Value.absent(),
    this.monthlyIncomeCents = const Value.absent(),
    this.paydayKind = const Value.absent(),
    this.paydayDay = const Value.absent(),
    this.currency = const Value.absent(),
    this.displayName = const Value.absent(),
  });
  SettingsEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.monthlyIncomeCents = const Value.absent(),
    this.paydayKind = const Value.absent(),
    this.paydayDay = const Value.absent(),
    this.currency = const Value.absent(),
    this.displayName = const Value.absent(),
  });
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<int>? monthlyIncomeCents,
    Expression<String>? paydayKind,
    Expression<int>? paydayDay,
    Expression<String>? currency,
    Expression<String>? displayName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (monthlyIncomeCents != null) 'monthly_income_cents': monthlyIncomeCents,
      if (paydayKind != null) 'payday_kind': paydayKind,
      if (paydayDay != null) 'payday_day': paydayDay,
      if (currency != null) 'currency': currency,
      if (displayName != null) 'display_name': displayName,
    });
  }

  SettingsEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? monthlyIncomeCents,
    Value<PaydayKind>? paydayKind,
    Value<int>? paydayDay,
    Value<String>? currency,
    Value<String?>? displayName,
  }) {
    return SettingsEntriesCompanion(
      id: id ?? this.id,
      monthlyIncomeCents: monthlyIncomeCents ?? this.monthlyIncomeCents,
      paydayKind: paydayKind ?? this.paydayKind,
      paydayDay: paydayDay ?? this.paydayDay,
      currency: currency ?? this.currency,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (monthlyIncomeCents.present) {
      map['monthly_income_cents'] = Variable<int>(monthlyIncomeCents.value);
    }
    if (paydayKind.present) {
      map['payday_kind'] = Variable<String>($SettingsEntriesTable.$converterpaydayKind.toSql(paydayKind.value));
    }
    if (paydayDay.present) {
      map['payday_day'] = Variable<int>(paydayDay.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsEntriesCompanion(')
          ..write('id: $id, ')
          ..write('monthlyIncomeCents: $monthlyIncomeCents, ')
          ..write('paydayKind: $paydayKind, ')
          ..write('paydayDay: $paydayDay, ')
          ..write('currency: $currency, ')
          ..write('displayName: $displayName')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $RecurringRulesTable recurringRules = $RecurringRulesTable(this);
  late final $TxnsTable txns = $TxnsTable(this);
  late final $SettingsEntriesTable settingsEntries = $SettingsEntriesTable(this);
  late final Index txnsByDate = Index('txns_by_date', 'CREATE INDEX txns_by_date ON txns (date)');
  late final Index txnsByCategory = Index('txns_by_category', 'CREATE INDEX txns_by_category ON txns (category_id)');
  late final AccountsDao accountsDao = AccountsDao(this as AppDatabase);
  late final CategoriesDao categoriesDao = CategoriesDao(this as AppDatabase);
  late final TxnsDao txnsDao = TxnsDao(this as AppDatabase);
  late final RecurringDao recurringDao = RecurringDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    categories,
    recurringRules,
    txns,
    settingsEntries,
    txnsByDate,
    txnsByCategory,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName('recurring_rules', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('txns', kind: UpdateKind.update)],
    ),
  ]);
}

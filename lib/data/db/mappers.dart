import 'package:drift/drift.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/models/models.dart';

extension AccountRowX on AccountRow {
  Account toModel() => Account(
    id: id,
    name: name,
    type: type,
    openingBalanceCents: openingBalanceCents,
    colorKey: colorKey,
    isCredit: isCredit,
    creditLimitCents: creditLimitCents,
    statementDay: statementDay,
    last4: last4,
    goalCents: goalCents,
    archived: archived,
    sortOrder: sortOrder,
  );
}

extension AccountX on Account {
  AccountsCompanion toCompanion() => AccountsCompanion(
    id: Value(id),
    name: Value(name),
    type: Value(type),
    openingBalanceCents: Value(openingBalanceCents),
    colorKey: Value(colorKey),
    isCredit: Value(isCredit),
    creditLimitCents: Value(creditLimitCents),
    statementDay: Value(statementDay),
    last4: Value(last4),
    goalCents: Value(goalCents),
    archived: Value(archived),
    sortOrder: Value(sortOrder),
  );
}

extension CategoryRowX on CategoryRow {
  TxnCategory toModel() => TxnCategory(
    id: id,
    name: name,
    kind: kind,
    colorKey: colorKey,
    iconKey: iconKey,
    monthlyLimitCents: monthlyLimitCents,
    sortOrder: sortOrder,
    archived: archived,
  );
}

extension TxnCategoryX on TxnCategory {
  CategoriesCompanion toCompanion() => CategoriesCompanion(
    id: Value(id),
    name: Value(name),
    kind: Value(kind),
    colorKey: Value(colorKey),
    iconKey: Value(iconKey),
    monthlyLimitCents: Value(monthlyLimitCents),
    sortOrder: Value(sortOrder),
    archived: Value(archived),
  );
}

extension TxnRowX on TxnRow {
  Txn toModel() => Txn(
    id: id,
    kind: kind,
    amountCents: amountCents,
    accountId: accountId,
    toAccountId: toAccountId,
    categoryId: categoryId,
    title: title,
    date: date,
    note: note,
    recurringRuleId: recurringRuleId,
    occurrenceKey: occurrenceKey,
    receiptPath: receiptPath,
    deletedAt: deletedAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension TxnX on Txn {
  TxnsCompanion toCompanion() => TxnsCompanion(
    id: Value(id),
    kind: Value(kind),
    amountCents: Value(amountCents),
    accountId: Value(accountId),
    toAccountId: Value(toAccountId),
    categoryId: Value(categoryId),
    title: Value(title),
    date: Value(date),
    note: Value(note),
    recurringRuleId: Value(recurringRuleId),
    occurrenceKey: Value(occurrenceKey),
    receiptPath: Value(receiptPath),
    deletedAt: Value(deletedAt),
    createdAt: Value(createdAt),
    updatedAt: Value(updatedAt),
  );
}

extension RecurringRuleRowX on RecurringRuleRow {
  RecurringRule toModel() => RecurringRule(
    id: id,
    title: title,
    kind: kind,
    amountCents: amountCents,
    accountId: accountId,
    categoryId: categoryId,
    note: note,
    frequency: frequency,
    interval: interval,
    dayOfMonth: dayOfMonth,
    weekday: weekday,
    startDate: startDate,
    nextDueDate: nextDueDate,
    active: active,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension RecurringRuleX on RecurringRule {
  RecurringRulesCompanion toCompanion() => RecurringRulesCompanion(
    id: Value(id),
    title: Value(title),
    kind: Value(kind),
    amountCents: Value(amountCents),
    accountId: Value(accountId),
    categoryId: Value(categoryId),
    note: Value(note),
    frequency: Value(frequency),
    interval: Value(interval),
    dayOfMonth: Value(dayOfMonth),
    weekday: Value(weekday),
    startDate: Value(startDate),
    nextDueDate: Value(nextDueDate),
    active: Value(active),
    createdAt: Value(createdAt),
    updatedAt: Value(updatedAt),
  );
}

extension SettingsRowX on SettingsRow? {
  AppSettings toModel() {
    final r = this;
    if (r == null) return const AppSettings();
    return AppSettings(
      monthlyIncomeCents: r.monthlyIncomeCents,
      paydayKind: r.paydayKind,
      paydayDay: r.paydayDay,
      currency: r.currency,
    );
  }
}

extension AppSettingsX on AppSettings {
  SettingsEntriesCompanion toCompanion() => SettingsEntriesCompanion(
    id: const Value(1),
    monthlyIncomeCents: Value(monthlyIncomeCents),
    paydayKind: Value(paydayKind),
    paydayDay: Value(paydayDay),
    currency: Value(currency),
  );
}

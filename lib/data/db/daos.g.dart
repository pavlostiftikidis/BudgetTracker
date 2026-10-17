// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daos.dart';

// ignore_for_file: type=lint
mixin _$AccountsDaoMixin on DatabaseAccessor<AppDatabase> {
  $AccountsTable get accounts => attachedDatabase.accounts;
  $CategoriesTable get categories => attachedDatabase.categories;
  $RecurringRulesTable get recurringRules => attachedDatabase.recurringRules;
  $TxnsTable get txns => attachedDatabase.txns;
}

mixin _$CategoriesDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $RecurringRulesTable get recurringRules => attachedDatabase.recurringRules;
  $TxnsTable get txns => attachedDatabase.txns;
}

mixin _$TxnsDaoMixin on DatabaseAccessor<AppDatabase> {
  $AccountsTable get accounts => attachedDatabase.accounts;
  $CategoriesTable get categories => attachedDatabase.categories;
  $RecurringRulesTable get recurringRules => attachedDatabase.recurringRules;
  $TxnsTable get txns => attachedDatabase.txns;
}

mixin _$RecurringDaoMixin on DatabaseAccessor<AppDatabase> {
  $AccountsTable get accounts => attachedDatabase.accounts;
  $CategoriesTable get categories => attachedDatabase.categories;
  $RecurringRulesTable get recurringRules => attachedDatabase.recurringRules;
}

mixin _$SettingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SettingsEntriesTable get settingsEntries => attachedDatabase.settingsEntries;
}

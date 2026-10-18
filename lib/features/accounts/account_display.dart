import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/core/utils/greek.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/domain/recurring_schedule.dart';
import 'package:pulse/l10n/app_localizations.dart';

IconData accountIcon(AccountType type) => switch (type) {
  AccountType.bank => LucideIcons.landmark,
  AccountType.card => LucideIcons.creditCard,
  AccountType.cash => LucideIcons.banknote,
  AccountType.savings => LucideIcons.piggyBank,
};

String accountTypeLabel(AccountType type, AppLocalizations l10n) => switch (type) {
  AccountType.bank => l10n.accountTypeBank,
  AccountType.card => l10n.accountTypeCard,
  AccountType.cash => l10n.accountTypeCash,
  AccountType.savings => l10n.accountTypeSavings,
};

String accountTypeHint(AccountType type, AppLocalizations l10n) => switch (type) {
  AccountType.bank => l10n.accountTypeBankHint,
  AccountType.card => l10n.accountTypeCardHint,
  AccountType.cash => l10n.accountTypeCashHint,
  AccountType.savings => l10n.accountTypeSavingsHint,
};

/// "Τράπεζα · ••4417", "Όριο €2.000 · λήξη 5 Νοε", "Πορτοφόλι",
/// "Στόχος €5.000 · 65%".
String accountSubtitle(Account a, Money balance, DateTime today, AppLocalizations l10n) {
  switch (a.type) {
    case AccountType.bank:
      return a.last4 == null ? l10n.accountSubBank : l10n.accountSubBankLast4(a.last4!);
    case AccountType.card:
      if (a.isCredit && a.creditLimitCents != null) {
        final limit = Money(a.creditLimitCents!).format(showCents: false);
        if (a.statementDay == null) return l10n.accountSubCreditNoDate(limit);
        final due = RecurringSchedule.firstOnOrAfter(
          frequency: Frequency.monthly,
          date: dateOnly(today),
          dayOfMonth: a.statementDay,
        );
        return l10n.accountSubCredit(limit, dayMonthShort(due));
      }
      return l10n.accountSubCard;
    case AccountType.cash:
      return l10n.accountSubCash;
    case AccountType.savings:
      final goal = a.goalCents;
      if (goal == null || goal <= 0) return l10n.accountSubSavings;
      final pct = (balance.cents.clamp(0, goal) * 100) ~/ goal;
      return l10n.accountSubSavingsGoal(Money(goal).format(showCents: false), pct);
  }
}

/// Default account for a new transaction: a card for expenses, a bank
/// account for income, otherwise the first one.
Account? defaultAccountFor(TxnKind kind, List<Account> accounts) {
  if (accounts.isEmpty) return null;
  final preferred = switch (kind) {
    TxnKind.expense => AccountType.card,
    TxnKind.income || TxnKind.transfer => AccountType.bank,
  };
  return accounts.firstWhere((a) => a.type == preferred, orElse: () => accounts.first);
}

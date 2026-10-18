import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/core/theme/keys.dart';
import 'package:pulse/data/ids.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/repositories/account_repository.dart';
import 'package:pulse/data/repositories/category_repository.dart';
import 'package:pulse/data/repositories/settings_repository.dart';
import 'package:pulse/l10n/app_localizations.dart';

/// Expense categories suggested in step 2, with their default limits.
enum SuggestedCategory {
  groceries(ColorKey.lime, IconKey.cart, 40000),
  dining(ColorKey.coral, IconKey.food, 15000),
  bills(ColorKey.sky, IconKey.bolt, 25000),
  transport(ColorKey.violet, IconKey.car, 12000),
  entertainment(ColorKey.amber, IconKey.film, 6000);

  new(this.color, this.icon, this.defaultLimitCents);

  final ColorKey color;
  final IconKey icon;
  final int defaultLimitCents;

  String label(AppLocalizations l10n) => switch (this) {
    groceries => l10n.catGroceries,
    dining => l10n.catDining,
    bills => l10n.catBills,
    transport => l10n.catTransport,
    entertainment => l10n.catEntertainment,
  };
}

/// Limit stepper granularity (€10).
const Money kLimitStep = Money(1000);

ColorKey defaultAccountColor(AccountType t) => switch (t) {
  AccountType.bank => ColorKey.sky,
  AccountType.card => ColorKey.violet,
  AccountType.cash => ColorKey.lime,
  AccountType.savings => ColorKey.amber,
};

final class OnboardingDraft {
  const new({
    this.income = const Money(215000),
    this.payday = Payday.first,
    this.limits = const {},
    this.accounts = const {AccountType.bank, AccountType.card},
  });

  final Money income;
  final Payday payday;

  /// Missing entries use the suggestion's default.
  final Map<SuggestedCategory, Money> limits;
  final Set<AccountType> accounts;

  Money limitOf(SuggestedCategory c) => limits[c] ?? Money(c.defaultLimitCents);

  Money get totalLimits => SuggestedCategory.values.map(limitOf).sum();

  /// "Μένουν για αποταμίευση".
  Money get leftover => income - totalLimits;

  OnboardingDraft copyWith({
    Money? income,
    Payday? payday,
    Map<SuggestedCategory, Money>? limits,
    Set<AccountType>? accounts,
  }) => OnboardingDraft(
    income: income ?? this.income,
    payday: payday ?? this.payday,
    limits: limits ?? this.limits,
    accounts: accounts ?? this.accounts,
  );

  OnboardingDraft step(SuggestedCategory c, int direction) {
    final next = limitOf(c) + kLimitStep * direction;
    return copyWith(limits: {...limits, c: next.isNegative ? Money.zero : next});
  }
}

/// Saves settings, the suggested categories (plus income categories) and
/// the chosen accounts. Safe to call on a database that already has data:
/// nothing existing is touched or duplicated by name.
Future<void> completeOnboarding({
  required OnboardingDraft draft,
  required SettingsRepository settings,
  required CategoryRepository categories,
  required AccountRepository accounts,
  required AppLocalizations l10n,
}) async {
  final current = await settings.get();
  await settings.save(
    current.copyWith(
      monthlyIncomeCents: draft.income.cents,
      paydayKind: draft.payday.kind,
      paydayDay: draft.payday.customDay,
    ),
  );

  final existing = await categories.watchCategories(includeArchived: true).first;
  final names = {for (final c in existing) c.name};
  var order = existing.length;
  final toSave = <TxnCategory>[
    for (final s in SuggestedCategory.values)
      if (!names.contains(s.label(l10n)))
        TxnCategory(
          id: newId(),
          name: s.label(l10n),
          kind: CategoryKind.expense,
          colorKey: s.color,
          iconKey: s.icon,
          monthlyLimitCents: draft.limitOf(s).isPositive ? draft.limitOf(s).cents : null,
          sortOrder: order++,
        ),
    for (final (name, color, icon) in [
      (l10n.catSalary, ColorKey.lime, IconKey.salary),
      (l10n.catFreelance, ColorKey.sky, IconKey.laptop),
      (l10n.catGift, ColorKey.violet, IconKey.gift),
      (l10n.catOther, ColorKey.amber, IconKey.tag),
    ])
      if (!names.contains(name))
        TxnCategory(
          id: newId(),
          name: name,
          kind: CategoryKind.income,
          colorKey: color,
          iconKey: icon,
          sortOrder: order++,
        ),
  ];
  await categories.saveAll(toSave);

  final existingAccounts = await accounts.watchAccounts(includeArchived: true).first;
  final types = {for (final a in existingAccounts) a.type};
  var accOrder = existingAccounts.length;
  for (final type in AccountType.values.where(draft.accounts.contains)) {
    if (types.contains(type)) continue;
    await accounts.save(
      Account(
        id: newId(),
        name: switch (type) {
          AccountType.bank => l10n.accountTypeBank,
          AccountType.card => l10n.accountTypeCard,
          AccountType.cash => l10n.accountTypeCash,
          AccountType.savings => l10n.accountTypeSavings,
        },
        type: type,
        colorKey: defaultAccountColor(type),
        sortOrder: accOrder++,
      ),
    );
  }
}

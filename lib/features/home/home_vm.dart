import 'package:collection/collection.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/core/theme/keys.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/domain/budget_math.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_vm.g.dart';

/// One category's share of the period's spending; [category] is null for
/// "Άλλα" (smaller categories and uncategorised expenses).
final class SpendShare {
  const new({required this.category, required this.amount, required this.percent});

  final TxnCategory? category;
  final Money amount;
  final int percent;
}

final class WeekDayStat {
  const new({required this.day, required this.spent, required this.isToday, required this.isFuture});

  final DateTime day;
  final Money spent;
  final bool isToday;
  final bool isFuture;
}

final class FirstSteps {
  const new({required this.income, required this.firstTxn, required this.recurring, required this.balances});

  final bool income;
  final bool firstTxn;
  final bool recurring;
  final bool balances;

  int get done => [income, firstTxn, recurring, balances].where((d) => d).length;
  static const total = 4;
}

final class HomeVm {
  const new({
    required this.period,
    required this.previous,
    required this.isCurrent,
    required this.summary,
    required this.hasBudgets,
    required this.available,
    required this.spent,
    required this.income,
    required this.daysLeft,
    required this.dailyAllowance,
    required this.changePercent,
    required this.split,
    required this.savings,
    required this.savingsSeries,
    required this.week,
    required this.weekTotal,
    required this.isEmpty,
    required this.firstSteps,
    required this.monthlyIncome,
    required this.limitedCategories,
    required this.displayName,
  });

  final BudgetPeriod period;
  final BudgetPeriod previous;
  final bool isCurrent;
  final BudgetSummary summary;
  final bool hasBudgets;

  /// Σ limits − budgeted spending, or income − all spending when no
  /// category has a limit; drives the daily allowance.
  final Money available;

  /// "ΞΟΔΕΥΤΗΚΑΝ": all of the period's spending.
  final Money spent;

  /// "από €X": income recorded in the period, or the monthly income from
  /// settings while none is recorded yet.
  final Money income;
  final int daysLeft;
  final Money dailyAllowance;

  /// Spending so far vs the same number of days of the previous period.
  final int? changePercent;
  final List<SpendShare> split;
  final Money savings;
  final List<int> savingsSeries;
  final List<WeekDayStat> week;
  final Money weekTotal;

  /// No live transaction exists at all.
  final bool isEmpty;
  final FirstSteps firstSteps;
  final Money monthlyIncome;
  final int limitedCategories;
  final String? displayName;
}

/// How many periods back the savings sparkline reaches.
const int kHistoryPeriods = 6;

/// Range of transactions [buildHomeVm] needs for [period] seen at [now].
DateRange homeRange(BudgetPeriod period, Payday payday, DateTime now) {
  var oldest = period;
  for (var i = 1; i < kHistoryPeriods; i++) {
    oldest = oldest.previous(payday);
  }
  final weekStart = startOfWeek(_weekAnchor(period, now));
  final start = [oldest.start, weekStart].min;
  final end = [period.end, addDays(weekStart, 7), addDays(dateOnly(now), 1)].max;
  return DateRange(start, end);
}

DateTime _weekAnchor(BudgetPeriod period, DateTime now) => period.contains(now) ? now : period.lastDay;

HomeVm buildHomeVm({
  required AppSettings settings,
  required BudgetPeriod period,
  required List<TxnCategory> categories,
  required List<Account> accounts,
  required Map<String, Money> balances,
  required List<Txn> txns,
  required bool hasAnyTxn,
  required bool hasRules,
  required DateTime now,
}) {
  final payday = settings.payday;
  final today = dateOnly(now);
  final isCurrent = period.contains(now);
  final previous = period.previous(payday);
  final live = txns.where((t) => t.deletedAt == null).toList();
  final summary = BudgetSummary.compute(period: period, categories: categories, txns: live, today: now);

  Money expensesBetween(DateTime from, DateTime to) =>
      totalOf(live, TxnKind.expense, within: (d) => !d.isBefore(from) && d.isBefore(to));

  // Like-for-like comparison: the same number of days into each period.
  final elapsed = isCurrent ? period.daysElapsed(now) : period.lengthInDays;
  final spentSoFar = expensesBetween(period.start, isCurrent ? addDays(today, 1) : period.end);
  final previousSoFar = expensesBetween(
    previous.start,
    addDays(previous.start, elapsed).isBefore(previous.end) ? addDays(previous.start, elapsed) : previous.end,
  );

  final periodExpenses = expensesBetween(period.start, period.end);
  final hasBudgets = summary.hasBudgets;
  final available = hasBudgets ? summary.available : settings.monthlyIncome - periodExpenses;
  final recordedIncome = totalOf(live, TxnKind.income, within: period.contains);
  final income = recordedIncome.isPositive ? recordedIncome : settings.monthlyIncome;
  final daysLeft = isCurrent ? period.daysLeft(now) : 0;

  // Spending split: top five categories + "Άλλα".
  final byCategory = spendingByCategory(live, period: period);
  final uncategorised = live
      .where((t) => t.kind == TxnKind.expense && t.categoryId == null && period.contains(t.date))
      .map((t) => t.amount)
      .sum();
  final catMap = {for (final c in categories) c.id: c};
  final ranked = byCategory.entries.where((e) => e.value.isPositive).sorted((a, b) => b.value.compareTo(a.value));
  final top = ranked.take(5).toList();
  final other = ranked.skip(5).map((e) => e.value).sum() + uncategorised;
  final splitTotal = periodExpenses;
  int pct(Money m) => splitTotal.cents <= 0 ? 0 : divRound(m.cents * 100, splitTotal.cents);
  final split = [
    for (final e in top) SpendShare(category: catMap[e.key], amount: e.value, percent: pct(e.value)),
    if (other.isPositive) SpendShare(category: null, amount: other, percent: pct(other)),
  ];

  // Savings: balance of savings accounts, or the period's net if none.
  final savingsAccounts = accounts.where((a) => a.type == AccountType.savings && !a.archived).map((a) => a.id).toSet();
  final periods = <BudgetPeriod>[period];
  for (var i = 1; i < kHistoryPeriods; i++) {
    periods.insert(0, periods.first.previous(payday));
  }
  final Money savings;
  final List<int> series;
  if (savingsAccounts.isNotEmpty) {
    final current = savingsAccounts.map((id) => balances[id] ?? Money.zero).sum();
    Money flowAfter(DateTime instant) => live.where((t) => !t.date.isBefore(instant)).map((t) {
      var delta = Money.zero;
      if (savingsAccounts.contains(t.accountId)) {
        delta += switch (t.kind) {
          TxnKind.income => t.amount,
          TxnKind.expense || TxnKind.transfer => -t.amount,
        };
      }
      if (t.kind == TxnKind.transfer && savingsAccounts.contains(t.toAccountId)) delta += t.amount;
      return delta;
    }).sum();
    final atEnd = [for (final p in periods) current - flowAfter(p.end.isAfter(now) ? now : p.end)];
    savings = atEnd.last;
    series = [for (final m in atEnd) m.cents];
  } else {
    Money net(BudgetPeriod p) =>
        totalOf(live, TxnKind.income, within: p.contains) - totalOf(live, TxnKind.expense, within: p.contains);
    savings = net(period);
    series = [for (final p in periods) net(p).cents];
  }

  // This week (Monday–Sunday) around today, or the period's last week.
  final weekStart = startOfWeek(_weekAnchor(period, now));
  final week = [
    for (var i = 0; i < 7; i++)
      () {
        final day = addDays(weekStart, i);
        return WeekDayStat(
          day: day,
          spent: expensesBetween(day, addDays(day, 1)),
          isToday: day == today,
          isFuture: day.isAfter(today),
        );
      }(),
  ];

  return HomeVm(
    period: period,
    previous: previous,
    isCurrent: isCurrent,
    summary: summary,
    hasBudgets: hasBudgets,
    available: available,
    spent: periodExpenses,
    income: income,
    daysLeft: daysLeft,
    dailyAllowance: isCurrent ? computeDailyAllowance(available, daysLeft) : Money.zero,
    changePercent: percentChange(spentSoFar, previousSoFar),
    split: split,
    savings: savings,
    savingsSeries: series,
    week: week,
    weekTotal: week.map((d) => d.spent).sum(),
    isEmpty: !hasAnyTxn,
    firstSteps: FirstSteps(
      income: settings.monthlyIncomeCents > 0 && categories.any((c) => c.hasLimit),
      firstTxn: hasAnyTxn,
      recurring: hasRules,
      balances: accounts.any((a) => a.openingBalanceCents != 0),
    ),
    monthlyIncome: settings.monthlyIncome,
    limitedCategories: categories.where((c) => c.hasLimit && c.kind == CategoryKind.expense).length,
    displayName: settings.displayName,
  );
}

/// Most periods the Home picker offers.
const int kPickerPeriods = 12;

/// Periods the Home picker offers, newest first: the current one and the
/// earlier ones back to the period of the oldest transaction ([first]), so a
/// new user is not offered months from before they started.
List<BudgetPeriod> pickerPeriods(DateTime now, Payday payday, DateTime? first) {
  final periods = [BudgetPeriod.containing(now, payday)];
  while (periods.length < kPickerPeriods && first != null && first.isBefore(periods.last.start)) {
    periods.add(periods.last.previous(payday));
  }
  return periods;
}

/// Which period Home shows: 0 = current, 1 = previous, …
@riverpod
class HomePeriodOffset extends _$HomePeriodOffset {
  @override
  int build() => 0;

  int get offset => state;

  set offset(int value) => state = value;
}

@riverpod
Future<HomeVm> homeVm(Ref ref) async {
  final settings = await ref.watch(settingsProvider.future);
  final categories = await ref.watch(categoriesProvider.future);
  final accounts = await ref.watch(accountsProvider.future);
  final balances = await ref.watch(balancesProvider.future);
  final rules = await ref.watch(recurringRulesProvider.future);
  final hasAny = await ref.watch(hasTxnsProvider.future);
  final now = ref.watch(clockProvider).now();
  final offset = ref.watch(homePeriodOffsetProvider);

  var period = BudgetPeriod.containing(now, settings.payday);
  for (var i = 0; i < offset; i++) {
    period = period.previous(settings.payday);
  }
  final txns = await ref.watch(txnsInRangeProvider(homeRange(period, settings.payday, now)).future);
  return buildHomeVm(
    settings: settings,
    period: period,
    categories: categories,
    accounts: accounts,
    balances: balances,
    txns: txns,
    hasAnyTxn: hasAny,
    hasRules: rules.isNotEmpty,
    now: now,
  );
}

/// Colour of a split slice ("Άλλα" uses the neutral `rest` token).
ColorKey? shareColor(SpendShare s) => s.category?.colorKey;

import 'package:collection/collection.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/data/models/models.dart';

/// Budget health of one category.
enum CategoryState { normal, warning, over }

/// Under 85 % → normal; 85–100 % → warning; above 100 % → over.
/// Categories without a limit are always normal.
CategoryState categoryState(Money spent, Money? limit) {
  if (limit == null || limit.cents <= 0) return CategoryState.normal;
  if (spent > limit) return CategoryState.over;
  if (spent.cents * 100 >= limit.cents * 85) return CategoryState.warning;
  return CategoryState.normal;
}

/// Whole percentage of [limit] used, uncapped (186/150 → 124).
int percentOf(Money spent, Money limit) => limit.cents <= 0 ? 0 : (spent.cents * 100 / limit.cents).round();

/// Remaining available ÷ days left (today included), rounded down;
/// never negative.
Money computeDailyAllowance(Money available, int daysLeft) {
  if (!available.isPositive || daysLeft <= 0) return Money.zero;
  return available.divideFloor(daysLeft);
}

/// Expense totals per category id for [txns] inside [period] (or all of
/// them when null). Transfers and income never count.
Map<String, Money> spendingByCategory(Iterable<Txn> txns, {BudgetPeriod? period}) {
  final out = <String, Money>{};
  for (final t in txns) {
    if (t.kind != TxnKind.expense || t.deletedAt != null || t.categoryId == null) continue;
    if (period != null && !period.contains(t.date)) continue;
    out.update(t.categoryId!, (m) => m + t.amount, ifAbsent: () => t.amount);
  }
  return out;
}

Money totalOf(Iterable<Txn> txns, TxnKind kind, {bool Function(DateTime)? within}) => txns
    .where((t) => t.kind == kind && t.deletedAt == null && (within == null || within(t.date)))
    .map((t) => t.amount)
    .sum();

/// One budgeted category in a period.
final class CategoryBudget {
  const new({required this.category, required this.spent, required this.limit});

  final TxnCategory category;
  final Money spent;
  final Money limit;

  CategoryState get state => categoryState(spent, limit);
  int get percent => percentOf(spent, limit);
  Money get remaining => limit - spent;
  Money get overBy => spent > limit ? spent - limit : Money.zero;
}

/// Everything the Budgets screen and the Home hero need for one period.
final class BudgetSummary {
  const new({
    required this.period,
    required this.categories,
    required this.totalLimit,
    required this.spentBudgeted,
    required this.daysLeft,
  });

  /// "Available this month" = Σ limits − expenses in budgeted categories.
  factory compute({
    required BudgetPeriod period,
    required Iterable<TxnCategory> categories,
    required Iterable<Txn> txns,
    required DateTime today,
  }) {
    final spent = spendingByCategory(txns, period: period);
    final budgeted = categories
        .where((c) => !c.archived && c.kind == CategoryKind.expense && c.hasLimit)
        .map((c) => CategoryBudget(category: c, spent: spent[c.id] ?? Money.zero, limit: c.monthlyLimit!))
        .toList();
    return BudgetSummary(
      period: period,
      categories: budgeted,
      totalLimit: budgeted.map((b) => b.limit).sum(),
      spentBudgeted: budgeted.map((b) => b.spent).sum(),
      daysLeft: period.daysLeft(today),
    );
  }

  final BudgetPeriod period;
  final List<CategoryBudget> categories;
  final Money totalLimit;
  final Money spentBudgeted;
  final int daysLeft;

  Money get available => totalLimit - spentBudgeted;
  Money get dailyAllowance => computeDailyAllowance(available, daysLeft);
  int get withinLimitCount => categories.where((c) => c.state != CategoryState.over).length;
  bool get hasBudgets => categories.isNotEmpty;

  /// Share of the total limit used, 0–1 (capped).
  double get usedFraction =>
      totalLimit.cents <= 0 ? 0 : (spentBudgeted.cents / totalLimit.cents).clamp(0, 1).toDouble();

  CategoryBudget? forCategory(String id) => categories.firstWhereOrNull((c) => c.category.id == id);
}

/// Percentage change from [previous] to [current], rounded; null when there
/// is nothing to compare against.
int? percentChange(Money current, Money previous) {
  if (previous.cents <= 0) return null;
  return ((current.cents - previous.cents) * 100 / previous.cents).round();
}

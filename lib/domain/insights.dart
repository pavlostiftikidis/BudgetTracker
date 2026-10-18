import 'package:collection/collection.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/domain/budget_math.dart';

enum InsightScale { week, month, year }

/// One bar of the Insights chart: a calendar week, a budget period or a
/// calendar year.
final class Bucket {
  const new(this.range, {required this.labelDate});

  final DateRange range;

  /// Date used to name the bucket (the period's label month, the week's
  /// Monday, 1 Jan of the year).
  final DateTime labelDate;
}

/// The [count] buckets up to and including the one containing [now],
/// oldest first.
List<Bucket> bucketsFor(InsightScale scale, DateTime now, Payday payday, {int count = 6}) {
  final out = <Bucket>[];
  switch (scale) {
    case InsightScale.week:
      var start = startOfWeek(now);
      for (var i = 0; i < count; i++) {
        out.insert(0, Bucket(DateRange(start, addDays(start, 7)), labelDate: start));
        start = addDays(start, -7);
      }
    case InsightScale.month:
      var p = BudgetPeriod.containing(now, payday);
      for (var i = 0; i < count; i++) {
        out.insert(0, Bucket(p.range, labelDate: p.labelMonth));
        p = p.previous(payday);
      }
    case InsightScale.year:
      for (var i = 0; i < count; i++) {
        final y = now.year - i;
        out.insert(0, Bucket(DateRange(DateTime(y), DateTime(y + 1)), labelDate: DateTime(y)));
      }
  }
  return out;
}

/// Category whose spending grew the most (like-for-like), with its change.
final class CategoryIncrease {
  const new({required this.categoryId, required this.percent, required this.delta});

  final String categoryId;
  final int percent;
  final Money delta;
}

/// Ignore tiny categories so "+300%" on €2 never becomes the headline.
const Money kInsightMinimum = Money(1000);

final class InsightsData {
  const new({
    required this.buckets,
    required this.totals,
    required this.current,
    required this.changePercent,
    required this.topCategories,
    required this.increase,
    required this.topWeekday,
  });

  final List<Bucket> buckets;

  /// Expenses per bucket, aligned with [buckets].
  final List<Money> totals;
  final Money current;
  final int? changePercent;

  /// Category id → spending in the current bucket, largest first.
  final List<MapEntry<String, Money>> topCategories;
  final CategoryIncrease? increase;

  /// ISO weekday (1 = Monday) with the most spending across all buckets.
  final int? topWeekday;
}

InsightsData computeInsights({
  required InsightScale scale,
  required List<Txn> txns,
  required DateTime now,
  required Payday payday,
}) {
  final buckets = bucketsFor(scale, now, payday);
  final expenses = txns.where((t) => t.kind == TxnKind.expense && t.deletedAt == null).toList();
  Money spentIn(DateRange r) => expenses.where((t) => r.contains(t.date)).map((t) => t.amount).sum();

  final totals = [for (final b in buckets) spentIn(b.range)];
  final current = buckets.last.range;
  final previous = buckets[buckets.length - 2].range;

  // Like-for-like: how far into the current bucket we are, applied to the
  // previous one.
  final elapsedDays = daysBetween(current.start, now) + 1;
  final soFar = DateRange(current.start, addDays(dateOnly(now), 1));
  final prevEnd = addDays(previous.start, elapsedDays);
  final prevSoFar = DateRange(previous.start, prevEnd.isBefore(previous.end) ? prevEnd : previous.end);

  final nowByCat = spendingByCategory(expenses.where((t) => soFar.contains(t.date)));
  final prevByCat = spendingByCategory(expenses.where((t) => prevSoFar.contains(t.date)));

  CategoryIncrease? best;
  for (final e in nowByCat.entries) {
    final before = prevByCat[e.key];
    if (before == null || !before.isPositive || e.value < kInsightMinimum) continue;
    final pct = percentChange(e.value, before)!;
    if (pct > 0 && (best == null || pct > best.percent)) {
      best = CategoryIncrease(categoryId: e.key, percent: pct, delta: e.value - before);
    }
  }

  final byWeekday = <int, int>{};
  for (final t in expenses.where((t) => !t.date.isBefore(buckets.first.range.start))) {
    byWeekday.update(t.date.weekday, (v) => v + t.amountCents, ifAbsent: () => t.amountCents);
  }
  int? topWeekday;
  for (final e in byWeekday.entries) {
    if (topWeekday == null || e.value > byWeekday[topWeekday]!) topWeekday = e.key;
  }

  final currentByCat = spendingByCategory(expenses.where((t) => current.contains(t.date)));
  return InsightsData(
    buckets: buckets,
    totals: totals,
    current: totals.last,
    changePercent: percentChange(spentIn(soFar), spentIn(prevSoFar)),
    topCategories: currentByCat.entries.where((e) => e.value.isPositive).sorted((a, b) => b.value.compareTo(a.value)),
    increase: best,
    topWeekday: topWeekday,
  );
}

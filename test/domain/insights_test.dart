import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/domain/insights.dart';

import '../helpers/fixtures.dart';

DateTime d(int y, int m, int day, [int h = 12]) => DateTime(y, m, day, h);

void main() {
  group('buckets', () {
    test('months follow the budget period and end with the current one', () {
      final b = bucketsFor(InsightScale.month, t0, const Payday(PaydayKind.fifteenth));
      expect(b, hasLength(6));
      expect(b.last.range.start, DateTime(2026, 10, 15));
      expect(b.first.range.start, DateTime(2026, 5, 15));
      for (var i = 1; i < b.length; i++) {
        expect(b[i].range.start, b[i - 1].range.end, reason: 'contiguous');
      }
    });

    test('weeks start on Monday', () {
      final b = bucketsFor(InsightScale.week, t0, Payday.first);
      expect(b.last.range.start, DateTime(2026, 10, 12));
      expect(b.first.range.start, DateTime(2026, 9, 7));
    });

    test('years', () {
      final b = bucketsFor(InsightScale.year, t0, Payday.first);
      expect(b.map((x) => x.labelDate.year), [2021, 2022, 2023, 2024, 2025, 2026]);
    });
  });

  group('computeInsights (months, payday 1st, today 18 Oct)', () {
    final txns = [
      // Previous period, first 18 days: dining 150, groceries 300.
      txn(account: 'a', category: 'dining', cents: 15000, date: d(2026, 9, 10)),
      txn(account: 'a', category: 'groceries', cents: 30000, date: d(2026, 9, 12)),
      // Previous period after day 18 — not part of the like-for-like base.
      txn(account: 'a', category: 'dining', cents: 90000, date: d(2026, 9, 25)),
      // Current period: dining 186 (+24%), groceries 312 (+4%), tiny 2 → 9.
      txn(account: 'a', category: 'dining', cents: 18600, date: d(2026, 10, 5)),
      txn(account: 'a', category: 'groceries', cents: 31200, date: d(2026, 10, 6)),
      txn(account: 'a', category: 'tiny', cents: 200, date: d(2026, 9, 3)),
      txn(account: 'a', category: 'tiny', cents: 900, date: d(2026, 10, 3)),
      // Never counted.
      txn(account: 'a', to: 'b', cents: 99900, kind: TxnKind.transfer, date: d(2026, 10, 7)),
      txn(account: 'a', category: 'salary', cents: 215000, kind: TxnKind.income, date: d(2026, 10, 1)),
    ];
    final data = computeInsights(scale: InsightScale.month, txns: txns, now: t0, payday: Payday.first);

    test('totals per bucket count expenses only', () {
      expect(data.current, const Money(18600 + 31200 + 900));
      expect(data.totals[4], const Money(15000 + 30000 + 90000 + 200));
    });

    test('change is like-for-like', () {
      // 507 now vs 452 in the first 18 days of September.
      expect(data.changePercent, percentFor(50700, 45200));
    });

    test('biggest increase ignores tiny categories', () {
      expect(data.increase!.categoryId, 'dining');
      expect(data.increase!.percent, 24);
      expect(data.increase!.delta, const Money(3600));
    });

    test('top categories of the current bucket, largest first', () {
      expect(data.topCategories.map((e) => e.key), ['groceries', 'dining', 'tiny']);
    });

    test('top weekday by spending', () {
      expect(data.topWeekday, DateTime(2026, 9, 25).weekday);
    });
  });

  test('no increase when everything went down', () {
    final data = computeInsights(
      scale: InsightScale.month,
      txns: [
        txn(account: 'a', category: 'x', cents: 20000, date: d(2026, 9, 5)),
        txn(account: 'a', category: 'x', cents: 10000, date: d(2026, 10, 5)),
      ],
      now: t0,
      payday: Payday.first,
    );
    expect(data.increase, isNull);
    expect(data.changePercent, -50);
  });
}

int percentFor(int now, int before) => ((now - before) * 100 / before).round();

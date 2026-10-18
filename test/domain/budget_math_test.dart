import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/domain/budget_math.dart';

import '../helpers/fixtures.dart';

void main() {
  group('categoryState thresholds', () {
    const limit = Money(10000);

    test('under 85 % is normal', () {
      expect(categoryState(Money.zero, limit), CategoryState.normal);
      expect(categoryState(const Money(8499), limit), CategoryState.normal);
    });

    test('85–100 % is a warning, both ends included', () {
      expect(categoryState(const Money(8500), limit), CategoryState.warning);
      expect(categoryState(const Money(9999), limit), CategoryState.warning);
      expect(categoryState(const Money(10000), limit), CategoryState.warning);
    });

    test('above 100 % is over', () {
      expect(categoryState(const Money(10001), limit), CategoryState.over);
      expect(categoryState(const Money(18600), const Money(15000)), CategoryState.over);
    });

    test('no limit is always normal', () {
      expect(categoryState(const Money(999999), null), CategoryState.normal);
      expect(categoryState(const Money(1), Money.zero), CategoryState.normal);
    });
  });

  group('daily allowance', () {
    test('remaining ÷ days left including today, rounded down', () {
      expect(computeDailyAllowance(const Money(74230), 14), const Money(5302));
      expect(computeDailyAllowance(const Money(100), 3), const Money(33));
    });

    test('never negative; €0 when over budget or out of days', () {
      expect(computeDailyAllowance(const Money(-5000), 10), Money.zero);
      expect(computeDailyAllowance(Money.zero, 10), Money.zero);
      expect(computeDailyAllowance(const Money(5000), 0), Money.zero);
    });
  });

  group('BudgetSummary', () {
    final groceries = category(id: 'g', limit: 40000);
    final dining = category(id: 'd', name: 'Εστίαση', limit: 15000);
    final housing = category(id: 'h', name: 'Στέγαση');
    final salary = category(id: 's', name: 'Μισθός', kind: CategoryKind.income);
    final period = BudgetPeriod.containing(t0, Payday.first);

    final txns = [
      txn(account: 'a', category: 'g', cents: 31200),
      txn(account: 'a', category: 'd', cents: 18600),
      txn(account: 'a', category: 'h', cents: 65000),
      txn(account: 'a', category: 's', cents: 215000, kind: TxnKind.income),
      txn(account: 'a', to: 'b', cents: 30000, kind: TxnKind.transfer),
      txn(account: 'a', category: 'g', cents: 9999, date: DateTime(2026, 9, 30)),
      txn(account: 'a', category: 'g', cents: 5000, deletedAt: t0),
    ];

    final summary = BudgetSummary.compute(
      period: period,
      categories: [groceries, dining, housing, salary],
      txns: txns,
      today: t0,
    );

    test('available = Σ limits − spending in budgeted categories', () {
      expect(summary.totalLimit, const Money(55000));
      expect(summary.spentBudgeted, const Money(49800));
      expect(summary.available, const Money(5200));
    });

    test('unbudgeted spending, income, transfers, other periods and deleted rows do not count', () {
      expect(summary.categories.map((c) => c.category.id), ['g', 'd']);
      expect(summary.forCategory('g')!.spent, const Money(31200));
    });

    test('per-category state and counts', () {
      expect(summary.forCategory('g')!.state, CategoryState.normal);
      expect(summary.forCategory('d')!.state, CategoryState.over);
      expect(summary.forCategory('d')!.overBy, const Money(3600));
      expect(summary.forCategory('d')!.percent, 124);
      expect(summary.withinLimitCount, 1);
    });

    test('daily allowance uses the days left in the period', () {
      expect(summary.daysLeft, 14);
      expect(summary.dailyAllowance, const Money(371));
    });

    test('archived categories are not budgeted', () {
      final s = BudgetSummary.compute(
        period: period,
        categories: [
          groceries,
          category(id: 'x', limit: 10000, archived: true),
        ],
        txns: const [],
        today: t0,
      );
      expect(s.totalLimit, const Money(40000));
    });
  });

  test('percentChange', () {
    expect(percentChange(const Money(18600), const Money(15000)), 24);
    expect(percentChange(const Money(8200), const Money(10000)), -18);
    expect(percentChange(const Money(100), Money.zero), isNull);
  });
}

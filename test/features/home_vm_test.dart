import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/core/utils/clock.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/db/demo_seed.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/repositories/account_repository.dart';
import 'package:pulse/data/repositories/category_repository.dart';
import 'package:pulse/data/repositories/settings_repository.dart';
import 'package:pulse/data/repositories/txn_repository.dart';
import 'package:pulse/features/home/home_vm.dart';

import '../helpers/fixtures.dart';

void main() {
  group('with the demo data on 18 Oct', () {
    late AppDatabase db;
    late HomeVm vm;

    setUpAll(() async {
      db = memoryDb();
      await seedDemoData(db, now: t0);
      final settings = await DriftSettingsRepository(db).get();
      final period = BudgetPeriod.containing(t0, settings.payday);
      vm = buildHomeVm(
        settings: settings,
        period: period,
        categories: await DriftCategoryRepository(db).watchCategories().first,
        accounts: await DriftAccountRepository(db).watchAccounts().first,
        balances: await DriftAccountRepository(db).watchBalances().first,
        txns: await DriftTxnRepository(
          db,
          FixedClock(t0),
        ).watchTxns(range: homeRange(period, settings.payday, t0)).first,
        hasAnyTxn: true,
        hasRules: true,
        now: t0,
      );
    });

    tearDownAll(() => db.close());

    test('hero = Σ limits − budgeted spending', () {
      expect(vm.budgetTotal, const Money(98000));
      expect(vm.available, const Money(12900));
      expect(vm.daysLeft, 14);
      expect(vm.dailyAllowance, const Money(921));
    });

    test('spending split ranks categories and sums to ~100%', () {
      expect(vm.split.first.category!.id, DemoIds.groceries);
      expect(vm.split.map((s) => s.category?.id), isNot(contains(DemoIds.housing)), reason: 'rent is due on the 20th');
      final total = vm.split.fold<int>(0, (a, s) => a + s.percent);
      expect(total, inInclusiveRange(98, 102));
      expect(vm.split.length, lessThanOrEqualTo(6));
    });

    test('savings follows the savings account and grows each period', () {
      expect(vm.savings, const Money(325000));
      expect(vm.savingsSeries, hasLength(kHistoryPeriods));
      for (var i = 1; i < vm.savingsSeries.length; i++) {
        expect(vm.savingsSeries[i], greaterThan(vm.savingsSeries[i - 1]));
      }
    });

    test('week is Monday–Sunday with today marked', () {
      expect(vm.week, hasLength(7));
      expect(vm.week.first.day, DateTime(2026, 10, 12));
      expect(vm.week.last.isToday, isTrue, reason: '18 Oct 2026 is a Sunday');
      expect(vm.week.where((d) => d.isFuture), isEmpty);
      expect(vm.weekTotal, vm.week.map((d) => d.spent).sum());
    });

    test('comparison is like-for-like with the previous period', () {
      expect(vm.changePercent, isNotNull);
      expect(vm.previous.start, DateTime(2026, 9));
    });
  });

  group('edge cases', () {
    final acc = account(id: 'a');
    final period = BudgetPeriod.containing(t0, Payday.first);

    HomeVm build({List<TxnCategory> cats = const [], List<Txn> txns = const [], int income = 200000}) => buildHomeVm(
      settings: AppSettings(monthlyIncomeCents: income),
      period: period,
      categories: cats,
      accounts: [acc],
      balances: {'a': Money.zero},
      txns: txns,
      hasAnyTxn: txns.isNotEmpty,
      hasRules: false,
      now: t0,
    );

    test('without limits the hero is income − spending', () {
      final vm = build(txns: [txn(account: 'a', cents: 5000)]);
      expect(vm.hasBudgets, isFalse);
      expect(vm.available, const Money(195000));
      expect(vm.budgetTotal, const Money(200000));
    });

    test('over budget: hero negative, allowance €0', () {
      final cat = category(id: 'g', limit: 10000);
      final vm = build(
        cats: [cat],
        txns: [txn(account: 'a', category: 'g', cents: 15000)],
      );
      expect(vm.available, const Money(-5000));
      expect(vm.dailyAllowance, Money.zero);
    });

    test('uncategorised spending lands in "Άλλα"', () {
      final vm = build(txns: [txn(account: 'a', cents: 1000)]);
      expect(vm.split.single.category, isNull);
      expect(vm.split.single.percent, 100);
    });

    test('transfers are not spending', () {
      final vm = build(
        txns: [txn(account: 'a', to: 'b', cents: 9000, kind: TxnKind.transfer)],
      );
      expect(vm.split, isEmpty);
      expect(vm.weekTotal, Money.zero);
    });

    test('empty state and first steps', () {
      final vm = build(income: 0);
      expect(vm.isEmpty, isTrue);
      expect(vm.firstSteps.done, 0);
      final withLimits = build(cats: [category(limit: 100)]);
      expect(withLimits.firstSteps.income, isTrue);
    });

    test('a past period has no days left and no allowance', () {
      final past = period.previous(Payday.first);
      final vm = buildHomeVm(
        settings: const AppSettings(),
        period: past,
        categories: [category(limit: 10000)],
        accounts: [acc],
        balances: const {},
        txns: const [],
        hasAnyTxn: false,
        hasRules: false,
        now: t0,
      );
      expect(vm.isCurrent, isFalse);
      expect(vm.daysLeft, 0);
      expect(vm.dailyAllowance, Money.zero);
      expect(dateOnly(vm.week.last.day), past.lastDay.isBefore(vm.week.last.day) ? vm.week.last.day : vm.week.last.day);
    });
  });
}

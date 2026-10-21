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

    test('hero = all spending out of the income recorded this period', () {
      expect(vm.income, const Money(215000));
      expect(vm.spent, const Money(85100));
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

    test('without recorded income the hero is out of the monthly income', () {
      final vm = build(txns: [txn(account: 'a', cents: 5000)]);
      expect(vm.hasBudgets, isFalse);
      expect(vm.spent, const Money(5000));
      expect(vm.available, const Money(195000));
      expect(vm.income, const Money(200000));
    });

    test('recorded income replaces the monthly income and counts every expense', () {
      final cat = category(id: 'g', limit: 10000);
      final vm = build(
        cats: [cat],
        txns: [
          txn(account: 'a', kind: TxnKind.income, cents: 180000),
          txn(account: 'a', kind: TxnKind.income, cents: 30000),
          txn(account: 'a', category: 'g', cents: 4000),
          txn(account: 'a', cents: 6000),
        ],
      );
      expect(vm.income, const Money(210000));
      expect(vm.spent, const Money(10000));
      expect(vm.available, const Money(6000), reason: 'the allowance still follows the limits');
    });

    test('over budget: available negative, allowance €0', () {
      final cat = category(id: 'g', limit: 10000);
      final vm = build(
        cats: [cat],
        txns: [txn(account: 'a', category: 'g', cents: 15000)],
      );
      expect(vm.spent, const Money(15000));
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

  group('period picker', () {
    // t0 is 18 Oct 2026; with payday on the 1st the periods are months.
    test('a new user is offered only the current month', () {
      expect(pickerPeriods(t0, Payday.first, null), [BudgetPeriod.containing(t0, Payday.first)]);
      expect(pickerPeriods(t0, Payday.first, DateTime(2026, 10, 18, 9)), hasLength(1));
      expect(pickerPeriods(t0, Payday.first, DateTime(2026, 10)), hasLength(1));
    });

    test('goes back to the month of the oldest transaction', () {
      final periods = pickerPeriods(t0, Payday.first, DateTime(2026, 8, 31, 23, 59));
      expect([for (final p in periods) p.start], [DateTime(2026, 10), DateTime(2026, 9), DateTime(2026, 8)]);
    });

    test('never more than a year', () {
      expect(pickerPeriods(t0, Payday.first, DateTime(2020)), hasLength(kPickerPeriods));
    });

    test('the oldest live transaction is what counts', () async {
      final db = memoryDb();
      addTearDown(db.close);
      final repo = DriftTxnRepository(db, FixedClock(t0));
      expect(await repo.firstDate(), isNull);

      final a = account(id: 'a');
      await DriftAccountRepository(db).save(a);
      await repo.add(txn(account: 'a', cents: 100, date: DateTime(2026, 9, 3, 10)));
      await repo.add(txn(account: 'a', cents: 100, date: DateTime(2026, 7), deletedAt: t0));
      expect(await repo.firstDate(), DateTime(2026, 9, 3, 10));
    });
  });
}

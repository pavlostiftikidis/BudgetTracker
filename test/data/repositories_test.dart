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
import 'package:pulse/data/repositories/recurring_repository.dart';
import 'package:pulse/data/repositories/settings_repository.dart';
import 'package:pulse/data/repositories/txn_repository.dart';
import 'package:pulse/domain/budget_math.dart';

import '../helpers/fixtures.dart';

void main() {
  late AppDatabase db;
  late FixedClock clock;
  late AccountRepository accounts;
  late CategoryRepository categories;
  late TxnRepository txns;
  late RecurringRepository recurring;
  late SettingsRepository settings;

  setUp(() {
    db = memoryDb();
    clock = FixedClock(t0);
    accounts = DriftAccountRepository(db);
    categories = DriftCategoryRepository(db);
    txns = DriftTxnRepository(db, clock);
    recurring = DriftRecurringRepository(db, clock);
    settings = DriftSettingsRepository(db);
  });

  tearDown(() => db.close());

  Future<void> seedAccounts() async {
    await accounts.save(account(id: 'checking', opening: 120000));
    await accounts.save(account(id: 'card', type: AccountType.card, isCredit: true));
    await categories.save(category(id: 'g', limit: 40000));
  }

  group('balances via SQL aggregate', () {
    test('income, expenses, transfers and credit cards', () async {
      await seedAccounts();
      await txns.add(txn(account: 'checking', cents: 215000, kind: TxnKind.income));
      await txns.add(txn(account: 'card', category: 'g', cents: 4280));
      await txns.add(txn(account: 'checking', to: 'card', cents: 2000, kind: TxnKind.transfer));

      final b = await accounts.watchBalances().first;
      expect(b['checking'], const Money(120000 + 215000 - 2000));
      expect(b['card'], const Money(-4280 + 2000));
    });

    test('reacts to new transactions', () async {
      await seedAccounts();
      final emitted = <Money?>[];
      final sub = accounts.watchBalances().listen((b) => emitted.add(b['checking']));
      await pumpEventQueue();
      await txns.add(txn(account: 'checking', cents: 1000));
      await pumpEventQueue();
      await sub.cancel();
      expect(emitted.first, const Money(120000));
      expect(emitted.last, const Money(119000));
    });
  });

  group('soft delete', () {
    test('delete hides, restore brings back, balances follow', () async {
      await seedAccounts();
      final t = txn(account: 'checking', cents: 5000, id: 'x');
      await txns.add(t);

      await txns.softDelete('x');
      expect(await txns.watchTxns().first, isEmpty);
      expect((await accounts.watchBalances().first)['checking'], const Money(120000));
      expect((await txns.byId('x'))!.deletedAt, t0);

      await txns.restore('x');
      expect((await txns.watchTxns().first).single.id, 'x');
      expect((await accounts.watchBalances().first)['checking'], const Money(115000));
    });

    test('purge removes only rows deleted before the cutoff', () async {
      await seedAccounts();
      await txns.add(txn(account: 'checking', cents: 100, id: 'old'));
      await txns.add(txn(account: 'checking', cents: 100, id: 'recent'));
      clock.fixed = t0.subtract(const Duration(days: 8));
      await txns.softDelete('old');
      clock.fixed = t0.subtract(const Duration(days: 2));
      await txns.softDelete('recent');

      final purged = await txns.purgeDeletedBefore(t0.subtract(const Duration(days: 7)));
      expect(purged, 1);
      expect(await txns.byId('old'), isNull);
      expect(await txns.byId('recent'), isNotNull);
    });
  });

  test('amount must be positive (CHECK constraint)', () async {
    await seedAccounts();
    expect(() => txns.add(txn(account: 'checking', cents: 0)), throwsA(anything));
  });

  group('recurring materialisation', () {
    test('creates every due occurrence and advances the next date', () async {
      await seedAccounts();
      await recurring.save(rule(id: 'rent', account: 'checking', nextDue: DateTime(2026, 8, 20), category: 'g'));

      final created = await recurring.materializeDue();
      expect(created, 2);
      final list = await txns.watchTxns().first;
      expect(list.map((t) => dayKey(t.date)), ['2026-09-20', '2026-08-20']);
      expect(list.every((t) => t.recurringRuleId == 'rent' && t.amountCents == 65000), isTrue);
      expect((await recurring.byId('rent'))!.nextDueDate, DateTime(2026, 10, 20));
    });

    test('is idempotent', () async {
      await seedAccounts();
      await recurring.save(rule(id: 'rent', account: 'checking', nextDue: DateTime(2026, 10, 18)));
      expect(await recurring.materializeDue(), 1);
      expect(await recurring.materializeDue(), 0);

      // Even if the next date were rolled back, the (rule, day) key blocks duplicates.
      final r = (await recurring.byId('rent'))!;
      await recurring.save(r.copyWith(nextDueDate: DateTime(2026, 10, 18)));
      expect(await recurring.materializeDue(), 0);
      expect((await txns.watchTxns().first).length, 1);
    });

    test('a deleted occurrence is not re-created', () async {
      await seedAccounts();
      await recurring.save(rule(id: 'rent', account: 'checking', nextDue: DateTime(2026, 10, 18)));
      await recurring.materializeDue();
      final created = (await txns.watchTxns().first).single;
      await txns.softDelete(created.id);
      final r = (await recurring.byId('rent'))!;
      await recurring.save(r.copyWith(nextDueDate: DateTime(2026, 10, 18)));
      expect(await recurring.materializeDue(), 0);
    });

    test('paused rules are skipped', () async {
      await seedAccounts();
      await recurring.save(rule(id: 'gym', account: 'checking', nextDue: DateTime(2026, 9, 5), active: false));
      expect(await recurring.materializeDue(), 0);
      expect((await recurring.byId('gym'))!.nextDueDate, DateTime(2026, 9, 5));
    });

    test('resuming a paused rule skips what fell due while paused', () async {
      await seedAccounts();
      await recurring.save(rule(id: 'gym', account: 'checking', nextDue: DateTime(2026, 7, 5), active: false));
      await recurring.setActive('gym', active: true);
      expect((await recurring.byId('gym'))!.nextDueDate, DateTime(2026, 11, 5));
      expect(await recurring.materializeDue(), 0);
    });

    test('every N months', () async {
      await seedAccounts();
      await recurring.save(
        rule(
          id: 'ins',
          account: 'checking',
          nextDue: DateTime(2026, 1, 2),
          frequency: Frequency.everyNMonths,
          interval: 6,
          cents: 18600,
        ),
      );
      expect(await recurring.materializeDue(), 2);
      expect((await recurring.byId('ins'))!.nextDueDate, DateTime(2027, 1, 2));
    });
  });

  group('categories', () {
    test('archive instead of delete when used', () async {
      await seedAccounts();
      await categories.save(category(id: 'unused'));
      await txns.add(txn(account: 'checking', category: 'g', cents: 100));

      expect(await categories.archiveOrDelete('g'), isTrue);
      expect(await categories.archiveOrDelete('unused'), isFalse);
      final active = await categories.watchCategories().first;
      expect(active.map((c) => c.id), isNot(contains('g')));
      final all = await categories.watchCategories(includeArchived: true).first;
      expect(all.firstWhere((c) => c.id == 'g').archived, isTrue);
      expect(all.map((c) => c.id), isNot(contains('unused')));
    });

    test('reorder and counts', () async {
      await seedAccounts();
      await categories.save(category(id: 'd', name: 'Εστίαση'));
      await categories.reorder(['d', 'g']);
      expect((await categories.watchCategories().first).map((c) => c.id), ['d', 'g']);
      await txns.add(txn(account: 'checking', category: 'g', cents: 100));
      await txns.add(txn(account: 'checking', category: 'g', cents: 100));
      expect(await categories.watchTxnCounts().first, {'g': 2});
    });
  });

  test('settings default, save, wipe', () async {
    expect(await settings.get(), const AppSettings());
    await settings.save(const AppSettings(monthlyIncomeCents: 215000, paydayKind: PaydayKind.fifteenth));
    expect((await settings.watch().first).payday, const Payday(PaydayKind.fifteenth));
    await seedAccounts();
    await settings.wipeAll();
    expect(await accounts.watchAccounts().first, isEmpty);
    expect(await settings.get(), const AppSettings());
  });

  group('demo seed', () {
    test('produces a consistent dataset relative to today', () async {
      final now = DateTime(2026, 10, 18, 21);
      await seedDemoData(db, now: now);

      final all = await txns.watchTxns().first;
      expect(all, isNotEmpty);
      expect(all.every((t) => !t.date.isAfter(now)), isTrue, reason: 'no future transactions');

      final summary = BudgetSummary.compute(
        period: BudgetPeriod.containing(now, Payday.first),
        categories: await categories.watchCategories().first,
        txns: all,
        today: now,
      );
      expect(summary.totalLimit, const Money(98000));
      expect(summary.spentBudgeted, const Money(85100));
      expect(summary.forCategory(DemoIds.groceries)!.spent, const Money(31200));
      expect(summary.forCategory(DemoIds.dining)!.state, CategoryState.over);
      expect(summary.withinLimitCount, 4);

      final b = await accounts.watchBalances().first;
      expect(b[DemoIds.card]!.isNegative, isTrue);
      expect(b[DemoIds.checking]!.isPositive, isTrue);
      expect(b[DemoIds.cash]!.isPositive, isTrue);
      expect(b[DemoIds.savings], const Money(145000 + 6 * 30000));

      // Seeded occurrences are linked to their rules, so materialising
      // right after seeding creates nothing.
      clock.fixed = now;
      expect(await recurring.materializeDue(), 0);
    });

    test('a seed on the 1st of the month is valid too', () async {
      await seedDemoData(db, now: DateTime(2026, 11, 1, 7));
      clock.fixed = DateTime(2026, 11, 1, 7);
      expect(await recurring.materializeDue(), 0);
      expect(await txns.watchTxns().first, isNotEmpty);
    });
  });
}

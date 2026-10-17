import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/core/theme/palette.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/db/mappers.dart';
import 'package:pulse/data/ids.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/domain/recurring_schedule.dart';

/// `--dart-define=SEED_DEMO=true`; only honoured in debug builds.
const bool kSeedDemoFlag = bool.fromEnvironment('SEED_DEMO');

/// Ids are fixed so the demo is easy to reason about in tests.
abstract final class DemoIds {
  static const checking = 'demo-acc-checking';
  static const card = 'demo-acc-card';
  static const cash = 'demo-acc-cash';
  static const savings = 'demo-acc-savings';

  static const groceries = 'demo-cat-groceries';
  static const dining = 'demo-cat-dining';
  static const bills = 'demo-cat-bills';
  static const transport = 'demo-cat-transport';
  static const fun = 'demo-cat-fun';
  static const housing = 'demo-cat-housing';
  static const salary = 'demo-cat-salary';
  static const freelance = 'demo-cat-freelance';
  static const gift = 'demo-cat-gift';
  static const otherIncome = 'demo-cat-other';

  static const ruleRent = 'demo-rule-rent';
  static const ruleSalary = 'demo-rule-salary';
  static const ruleNetflix = 'demo-rule-netflix';
  static const rulePower = 'demo-rule-power';
  static const ruleSpotify = 'demo-rule-spotify';
  static const ruleInsurance = 'demo-rule-insurance';
  static const ruleGym = 'demo-rule-gym';
}

typedef _Item = ({
  int offset,
  int hour,
  int minute,
  TxnKind kind,
  String? category,
  String title,
  int cents,
  String account,
  String? toAccount,
  String? rule,
});

_Item _e(int offset, String category, String title, int cents, String account, {int hour = 12, int minute = 0, String? rule}) => (
  offset: offset,
  hour: hour,
  minute: minute,
  kind: TxnKind.expense,
  category: category,
  title: title,
  cents: cents,
  account: account,
  toAccount: null,
  rule: rule,
);

/// One budget period's worth of activity; offsets are days from the start
/// of a period that begins on the 1st. Totals up to day 18 match the
/// mockups (Σούπερ μάρκετ €312, Εστίαση €186, Λογαριασμοί €218, …).
final List<_Item> _template = [
  (
    offset: 0,
    hour: 8,
    minute: 30,
    kind: TxnKind.income,
    category: DemoIds.salary,
    title: 'Μισθός',
    cents: 215000,
    account: DemoIds.checking,
    toAccount: null,
    rule: DemoIds.ruleSalary,
  ),
  (
    offset: 1,
    hour: 9,
    minute: 0,
    kind: TxnKind.transfer,
    category: null,
    title: 'Μηνιαία αποταμίευση',
    cents: 30000,
    account: DemoIds.checking,
    toAccount: DemoIds.savings,
    rule: null,
  ),
  (
    offset: 3,
    hour: 13,
    minute: 10,
    kind: TxnKind.transfer,
    category: null,
    title: 'Ανάληψη ATM',
    cents: 10000,
    account: DemoIds.checking,
    toAccount: DemoIds.cash,
    rule: null,
  ),
  // Σούπερ μάρκετ — €312 by day 18.
  _e(1, DemoIds.groceries, 'Σκλαβενίτης', 6440, DemoIds.card, hour: 19, minute: 5),
  _e(4, DemoIds.groceries, 'Lidl', 3870, DemoIds.card, hour: 18, minute: 20),
  _e(6, DemoIds.groceries, 'ΑΒ Βασιλόπουλος', 6210, DemoIds.card, hour: 11, minute: 40),
  _e(9, DemoIds.groceries, 'Σκλαβενίτης', 4425, DemoIds.card, hour: 20),
  _e(12, DemoIds.groceries, 'Μασούτης', 3185, DemoIds.card, hour: 17, minute: 15),
  _e(14, DemoIds.groceries, 'Lidl', 2790, DemoIds.card, hour: 10, minute: 30),
  _e(17, DemoIds.groceries, 'Σκλαβενίτης', 4280, DemoIds.card, hour: 18, minute: 40),
  _e(20, DemoIds.groceries, 'Lidl', 3560, DemoIds.card, hour: 19),
  _e(23, DemoIds.groceries, 'Σκλαβενίτης', 5120, DemoIds.card, minute: 25),
  _e(26, DemoIds.groceries, 'ΑΒ Βασιλόπουλος', 4780, DemoIds.card, hour: 18),
  _e(28, DemoIds.groceries, 'Μασούτης', 2930, DemoIds.card, hour: 11),
  // Εστίαση — €186 by day 18.
  _e(2, DemoIds.dining, 'Pizza Fan', 2450, DemoIds.card, hour: 21),
  _e(4, DemoIds.dining, 'Coffee Island', 360, DemoIds.card, hour: 9, minute: 5),
  _e(5, DemoIds.dining, 'Ουζερί Τσιτσάνης', 4800, DemoIds.card, hour: 22),
  _e(8, DemoIds.dining, 'Coffee Island', 360, DemoIds.card, hour: 9, minute: 10),
  _e(10, DemoIds.dining, 'Σουβλάκι Γιώργος', 1650, DemoIds.cash, hour: 14),
  _e(11, DemoIds.dining, 'Wolt', 2440, DemoIds.card, hour: 20, minute: 45),
  _e(12, DemoIds.dining, 'Starbucks', 540, DemoIds.card, hour: 10),
  _e(15, DemoIds.dining, 'Sushi Bar', 5280, DemoIds.card, hour: 21, minute: 30),
  _e(16, DemoIds.dining, 'Coffee Island', 360, DemoIds.card, hour: 9),
  _e(17, DemoIds.dining, 'Coffee Island', 360, DemoIds.card, hour: 9, minute: 12),
  _e(19, DemoIds.dining, 'Coffee Island', 360, DemoIds.card, hour: 9),
  _e(21, DemoIds.dining, 'Ταβέρνα Ο Μήτσος', 3900, DemoIds.card, hour: 21),
  _e(24, DemoIds.dining, 'Wolt', 2150, DemoIds.card, hour: 20),
  _e(27, DemoIds.dining, 'Coffee Island', 360, DemoIds.card, hour: 9),
  // Λογαριασμοί — €218 by day 18.
  _e(2, DemoIds.bills, 'ΕΥΔΑΠ', 2370, DemoIds.checking, hour: 10),
  _e(7, DemoIds.bills, 'Cosmote', 4290, DemoIds.checking, hour: 10),
  _e(9, DemoIds.bills, 'Κοινόχρηστα', 8300, DemoIds.checking, hour: 11),
  _e(13, DemoIds.bills, 'ΔΕΗ', 6840, DemoIds.checking, hour: 10, rule: DemoIds.rulePower),
  // Μετακίνηση — €94 by day 18.
  _e(5, DemoIds.transport, 'ΟΑΣΑ', 3000, DemoIds.cash, hour: 8),
  _e(11, DemoIds.transport, 'Uber', 1900, DemoIds.card, hour: 23),
  _e(16, DemoIds.transport, 'Shell', 4500, DemoIds.card, hour: 19, minute: 5),
  _e(22, DemoIds.transport, 'Shell', 4200, DemoIds.card, hour: 18),
  _e(26, DemoIds.transport, 'Uber', 1600, DemoIds.card, hour: 22),
  // Ψυχαγωγία — €41 by day 18.
  _e(6, DemoIds.fun, 'Village Cinemas', 1800, DemoIds.card, hour: 20),
  _e(10, DemoIds.fun, 'Spotify', 1099, DemoIds.card, hour: 7, rule: DemoIds.ruleSpotify),
  _e(15, DemoIds.fun, 'Steam', 1201, DemoIds.card, hour: 22),
  _e(21, DemoIds.fun, 'Netflix', 1399, DemoIds.card, hour: 7, rule: DemoIds.ruleNetflix),
  _e(24, DemoIds.fun, 'Πρωτοπορία', 2200, DemoIds.card, hour: 13),
  // Στέγαση (no limit).
  _e(19, DemoIds.housing, 'Ενοίκιο', 65000, DemoIds.checking, hour: 9, rule: DemoIds.ruleRent),
];

const List<String> _variable = [DemoIds.groceries, DemoIds.dining, DemoIds.transport, DemoIds.fun, DemoIds.bills];

/// Per-mille scale for [category] in the period [back] periods ago. The
/// last period is tuned so Εστίαση shows "+24%"; older ones wobble ±12 %.
int _factor(int back, String? category) {
  final i = _variable.indexOf(category ?? '');
  if (back == 0 || i < 0) return 1000;
  if (back == 1) return const [1040, 806, 1120, 950, 1000][i];
  return 880 + (back * 53 + i * 29) % 241;
}

int _scaled(int cents, int factor) => factor == 1000 ? cents : ((cents * factor ~/ 1000 + 5) ~/ 10) * 10;

/// Writes the demo dataset. Assumes an empty database.
Future<void> seedDemoData(AppDatabase db, {required DateTime now}) async {
  final today = dateOnly(now);
  const payday = Payday.first;

  await db.transaction(() async {
    await db.settingsDao.save(const AppSettings(monthlyIncomeCents: 215000).toCompanion());

    for (final a in const [
      Account(id: DemoIds.checking, name: 'Τρεχούμενος', type: AccountType.bank, openingBalanceCents: 120000, last4: '4417'),
      Account(
        id: DemoIds.card,
        name: 'Πιστωτική κάρτα',
        type: AccountType.card,
        colorKey: ColorKey.coral,
        isCredit: true,
        creditLimitCents: 200000,
        statementDay: 5,
        sortOrder: 1,
      ),
      Account(id: DemoIds.cash, name: 'Μετρητά', type: AccountType.cash, colorKey: ColorKey.amber, openingBalanceCents: 8000, sortOrder: 2),
      Account(
        id: DemoIds.savings,
        name: 'Αποταμίευση',
        type: AccountType.savings,
        colorKey: ColorKey.lime,
        openingBalanceCents: 145000,
        goalCents: 500000,
        sortOrder: 3,
      ),
    ]) {
      await db.accountsDao.upsert(a.toCompanion());
    }

    var order = 0;
    for (final c in [
      (DemoIds.groceries, 'Σούπερ μάρκετ', ColorKey.lime, IconKey.cart, 40000),
      (DemoIds.dining, 'Εστίαση', ColorKey.coral, IconKey.food, 15000),
      (DemoIds.bills, 'Λογαριασμοί', ColorKey.sky, IconKey.bolt, 25000),
      (DemoIds.transport, 'Μετακίνηση', ColorKey.violet, IconKey.car, 12000),
      (DemoIds.fun, 'Ψυχαγωγία', ColorKey.amber, IconKey.film, 6000),
      (DemoIds.housing, 'Στέγαση', ColorKey.teal, IconKey.home, null),
    ]) {
      await db.categoriesDao.upsert(
        TxnCategory(
          id: c.$1,
          name: c.$2,
          kind: CategoryKind.expense,
          colorKey: c.$3,
          iconKey: c.$4,
          monthlyLimitCents: c.$5,
          sortOrder: order++,
        ).toCompanion(),
      );
    }
    for (final c in [
      (DemoIds.salary, 'Μισθός', ColorKey.lime, IconKey.salary),
      (DemoIds.freelance, 'Freelance', ColorKey.sky, IconKey.laptop),
      (DemoIds.gift, 'Δώρο', ColorKey.violet, IconKey.gift),
      (DemoIds.otherIncome, 'Άλλο', ColorKey.amber, IconKey.tag),
    ]) {
      await db.categoriesDao.upsert(
        TxnCategory(id: c.$1, name: c.$2, kind: CategoryKind.income, colorKey: c.$3, iconKey: c.$4, sortOrder: order++)
            .toCompanion(),
      );
    }

    final tomorrow = addDays(today, 1);
    DateTime nextMonthly(int day) =>
        RecurringSchedule.firstOnOrAfter(frequency: Frequency.monthly, date: tomorrow, dayOfMonth: day);
    var insuranceDue = nextMonthly(2);
    while (insuranceDue.month != 1 && insuranceDue.month != 7) {
      insuranceDue = addMonthsAnchored(insuranceDue, 1, 2);
    }
    final start = DateTime(today.year - 1, today.month);
    for (final r in [
      (DemoIds.ruleRent, 'Ενοίκιο', TxnKind.expense, 65000, DemoIds.housing, Frequency.monthly, 1, 20, nextMonthly(20), true),
      (DemoIds.ruleSalary, 'Μισθός', TxnKind.income, 215000, DemoIds.salary, Frequency.monthly, 1, 1, nextMonthly(1), true),
      (DemoIds.ruleNetflix, 'Netflix', TxnKind.expense, 1399, DemoIds.fun, Frequency.monthly, 1, 22, nextMonthly(22), true),
      (DemoIds.rulePower, 'ΔΕΗ', TxnKind.expense, 6840, DemoIds.bills, Frequency.monthly, 1, 14, nextMonthly(14), true),
      (DemoIds.ruleSpotify, 'Spotify', TxnKind.expense, 1099, DemoIds.fun, Frequency.monthly, 1, 11, nextMonthly(11), true),
      (
        DemoIds.ruleInsurance,
        'Ασφάλεια αυτοκινήτου',
        TxnKind.expense,
        18600,
        DemoIds.transport,
        Frequency.everyNMonths,
        6,
        2,
        insuranceDue,
        true,
      ),
      (DemoIds.ruleGym, 'Γυμναστήριο', TxnKind.expense, 3500, DemoIds.fun, Frequency.monthly, 1, 5, nextMonthly(5), false),
    ]) {
      await db.recurringDao.upsert(
        RecurringRule(
          id: r.$1,
          title: r.$2,
          kind: r.$3,
          amountCents: r.$4,
          accountId: r.$3 == TxnKind.income ? DemoIds.checking : (r.$1 == DemoIds.ruleNetflix || r.$1 == DemoIds.ruleSpotify ? DemoIds.card : DemoIds.checking),
          categoryId: r.$5,
          frequency: r.$6,
          interval: r.$7,
          dayOfMonth: r.$8,
          startDate: start,
          nextDueDate: r.$9,
          active: r.$10,
          createdAt: now,
          updatedAt: now,
        ).toCompanion(),
      );
    }

    // Oldest period first so each card payoff knows last period's spend.
    final current = BudgetPeriod.containing(today, payday);
    final periods = <BudgetPeriod>[current];
    for (var i = 1; i < 6; i++) {
      periods.add(periods.last.previous(payday));
    }
    var cardSpendLastPeriod = 0;
    var bump = 0;
    for (var back = periods.length - 1; back >= 0; back--) {
      final period = periods[back];
      var cardSpend = 0;
      final items = [
        ..._template,
        if (cardSpendLastPeriod > 0)
          (
            offset: 4,
            hour: 10,
            minute: 0,
            kind: TxnKind.transfer,
            category: null,
            title: 'Εξόφληση κάρτας',
            cents: cardSpendLastPeriod,
            account: DemoIds.checking,
            toAccount: DemoIds.card,
            rule: null,
          ),
      ];
      for (final item in items) {
        if (item.offset >= period.lengthInDays) continue;
        final day = addDays(period.start, item.offset);
        if (day.isAfter(today)) continue;
        var date = DateTime(day.year, day.month, day.day, item.hour, item.minute);
        if (date.isAfter(now)) date = now.subtract(Duration(minutes: 3 + bump++));
        final cents = _scaled(item.cents, _factor(back, item.category));
        if (item.kind == TxnKind.expense && item.account == DemoIds.card) cardSpend += cents;
        await db.txnsDao.insertRow(
          Txn(
            id: newId(),
            kind: item.kind,
            amountCents: cents,
            accountId: item.account,
            toAccountId: item.toAccount,
            categoryId: item.category,
            title: item.title,
            date: date,
            recurringRuleId: item.rule,
            occurrenceKey: item.rule == null ? null : dayKey(day),
            createdAt: date,
            updatedAt: date,
          ).toCompanion(),
        );
      }
      cardSpendLastPeriod = cardSpend;
    }
  });
}

/// Whether the database has any account yet (the seed only runs on an
/// empty one).
Future<bool> databaseIsEmpty(AppDatabase db) async =>
    (await (db.select(db.accounts)..limit(1)).get()).isEmpty;

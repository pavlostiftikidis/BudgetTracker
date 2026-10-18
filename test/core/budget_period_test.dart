import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/core/period/dates.dart';

DateTime d(int y, int m, int day) => DateTime(y, m, day);

void expectPeriod(BudgetPeriod p, DateTime start, DateTime end) {
  expect(p.start, start, reason: 'start');
  expect(p.end, end, reason: 'end (exclusive)');
}

void main() {
  group('payday on the 1st', () {
    const payday = Payday.first;

    test('period is the calendar month', () {
      final p = BudgetPeriod.containing(DateTime(2026, 10, 18, 21, 30), payday);
      expectPeriod(p, d(2026, 10, 1), d(2026, 11, 1));
      expect(p.lastDay, d(2026, 10, 31));
      expect(p.lengthInDays, 31);
    });

    test('first and last instants belong to the period', () {
      final p = BudgetPeriod.containing(d(2026, 10, 1), payday);
      expect(p.contains(d(2026, 10, 1)), isTrue);
      expect(p.contains(DateTime(2026, 10, 31, 23, 59, 59)), isTrue);
      expect(p.contains(d(2026, 11, 1)), isFalse);
    });

    test('days left include today', () {
      final p = BudgetPeriod.containing(d(2026, 10, 18), payday);
      expect(p.daysLeft(d(2026, 10, 18)), 14);
      expect(p.daysLeft(d(2026, 10, 31)), 1);
      expect(p.daysElapsed(d(2026, 10, 18)), 18);
    });
  });

  group('payday on the 15th', () {
    const payday = Payday(PaydayKind.fifteenth);

    test('15 Oct → 14 Nov', () {
      final p = BudgetPeriod.containing(d(2026, 10, 18), payday);
      expectPeriod(p, d(2026, 10, 15), d(2026, 11, 15));
      expect(p.lastDay, d(2026, 11, 14));
    });

    test('before payday belongs to the previous period', () {
      expectPeriod(BudgetPeriod.containing(d(2026, 10, 3), payday), d(2026, 9, 15), d(2026, 10, 15));
      expectPeriod(BudgetPeriod.containing(d(2026, 10, 14), payday), d(2026, 9, 15), d(2026, 10, 15));
      expectPeriod(BudgetPeriod.containing(d(2026, 10, 15), payday), d(2026, 10, 15), d(2026, 11, 15));
    });

    test('crosses the year boundary', () {
      expectPeriod(BudgetPeriod.containing(d(2027, 1, 3), payday), d(2026, 12, 15), d(2027, 1, 15));
      expectPeriod(BudgetPeriod.containing(d(2026, 12, 20), payday), d(2026, 12, 15), d(2027, 1, 15));
    });

    test('previous / next chain without gaps', () {
      final p = BudgetPeriod.containing(d(2026, 10, 18), payday);
      expect(p.previous(payday).end, p.start);
      expect(p.next(payday).start, p.end);
      expectPeriod(p.previous(payday), d(2026, 9, 15), d(2026, 10, 15));
    });
  });

  group('payday at month end', () {
    const payday = Payday(PaydayKind.last);

    test('runs from the last day of one month to the day before the next', () {
      expectPeriod(BudgetPeriod.containing(d(2026, 10, 18), payday), d(2026, 9, 30), d(2026, 10, 31));
      expectPeriod(BudgetPeriod.containing(d(2026, 10, 31), payday), d(2026, 10, 31), d(2026, 11, 30));
    });

    test('February in a leap year ends on the 29th', () {
      expectPeriod(BudgetPeriod.containing(d(2024, 2, 28), payday), d(2024, 1, 31), d(2024, 2, 29));
      expectPeriod(BudgetPeriod.containing(d(2024, 2, 29), payday), d(2024, 2, 29), d(2024, 3, 31));
    });

    test('February in a common year ends on the 28th', () {
      expectPeriod(BudgetPeriod.containing(d(2025, 2, 27), payday), d(2025, 1, 31), d(2025, 2, 28));
      expectPeriod(BudgetPeriod.containing(d(2025, 2, 28), payday), d(2025, 2, 28), d(2025, 3, 31));
    });
  });

  group('custom payday', () {
    test('day 31 clamps to short months', () {
      const payday = Payday(PaydayKind.custom, 31);
      expectPeriod(BudgetPeriod.containing(d(2025, 2, 15), payday), d(2025, 1, 31), d(2025, 2, 28));
      expectPeriod(BudgetPeriod.containing(d(2025, 4, 30), payday), d(2025, 4, 30), d(2025, 5, 31));
      expectPeriod(BudgetPeriod.containing(d(2025, 4, 29), payday), d(2025, 3, 31), d(2025, 4, 30));
    });

    test('day 30 in a leap February lands on the 29th', () {
      const payday = Payday(PaydayKind.custom, 30);
      expectPeriod(BudgetPeriod.containing(d(2024, 2, 29), payday), d(2024, 2, 29), d(2024, 3, 30));
      expectPeriod(BudgetPeriod.containing(d(2024, 2, 28), payday), d(2024, 1, 30), d(2024, 2, 29));
    });

    test('day 25', () {
      const payday = Payday(PaydayKind.custom, 25);
      final p = BudgetPeriod.containing(d(2026, 10, 18), payday);
      expectPeriod(p, d(2026, 9, 25), d(2026, 10, 25));
      expect(p.lengthInDays, 30);
    });
  });

  group('labelMonth names the month holding most days', () {
    test('calendar month', () {
      expect(BudgetPeriod.containing(d(2026, 10, 18), Payday.first).labelMonth, d(2026, 10, 1));
    });

    test('15 Oct – 14 Nov is October', () {
      expect(BudgetPeriod.containing(d(2026, 10, 18), const Payday(PaydayKind.fifteenth)).labelMonth, d(2026, 10, 1));
    });

    test('31 Oct – 29 Nov is November', () {
      expect(BudgetPeriod.containing(d(2026, 11, 5), const Payday(PaydayKind.last)).labelMonth, d(2026, 11, 1));
    });
  });

  group('date helpers', () {
    test('daysBetween ignores DST and time of day', () {
      expect(daysBetween(DateTime(2026, 3, 28, 23), DateTime(2026, 3, 30, 1)), 2);
      expect(daysBetween(d(2026, 10, 24), d(2026, 10, 26)), 2);
    });

    test('addMonthsAnchored keeps the anchor day', () {
      expect(addMonthsAnchored(d(2026, 1, 31), 1, 31), d(2026, 2, 28));
      expect(addMonthsAnchored(d(2026, 2, 28), 1, 31), d(2026, 3, 31));
      expect(addMonthsAnchored(d(2024, 1, 31), 1, 31), d(2024, 2, 29));
      expect(addMonthsAnchored(d(2026, 11, 2), 6, 2), d(2027, 5, 2));
    });

    test('startOfWeek is Monday', () {
      expect(startOfWeek(d(2026, 10, 18)), d(2026, 10, 12));
      expect(startOfWeek(d(2026, 10, 12)), d(2026, 10, 12));
    });
  });
}

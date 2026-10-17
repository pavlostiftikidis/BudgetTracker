import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/domain/recurring_schedule.dart';

import '../helpers/fixtures.dart';

DateTime d(int y, int m, int day) => DateTime(y, m, day);

void main() {
  group('advance', () {
    test('monthly keeps the anchor day through short months', () {
      final r = rule(account: 'a', nextDue: d(2026, 1, 31), dayOfMonth: 31);
      expect(RecurringSchedule.advance(r, d(2026, 1, 31)), d(2026, 2, 28));
      expect(RecurringSchedule.advance(r, d(2026, 2, 28)), d(2026, 3, 31));
    });

    test('every N months', () {
      final r = rule(account: 'a', nextDue: d(2026, 7, 2), frequency: Frequency.everyNMonths, interval: 6);
      expect(RecurringSchedule.advance(r, d(2026, 7, 2)), d(2027, 1, 2));
    });

    test('weekly and yearly', () {
      final w = rule(account: 'a', nextDue: d(2026, 10, 12), frequency: Frequency.weekly);
      expect(RecurringSchedule.advance(w, d(2026, 10, 12)), d(2026, 10, 19));
      final y = rule(account: 'a', nextDue: d(2024, 2, 29), frequency: Frequency.yearly, dayOfMonth: 29);
      expect(RecurringSchedule.advance(y, d(2024, 2, 29)), d(2025, 2, 28));
    });
  });

  group('dueOccurrences', () {
    test('every occurrence up to and including today', () {
      final r = rule(account: 'a', nextDue: d(2026, 8, 20));
      expect(RecurringSchedule.dueOccurrences(r, d(2026, 10, 20)), [d(2026, 8, 20), d(2026, 9, 20), d(2026, 10, 20)]);
      expect(RecurringSchedule.dueOccurrences(r, d(2026, 10, 19)), [d(2026, 8, 20), d(2026, 9, 20)]);
    });

    test('nothing when the next date is in the future', () {
      expect(RecurringSchedule.dueOccurrences(rule(account: 'a', nextDue: d(2026, 10, 20)), d(2026, 10, 18)), isEmpty);
    });

    test('paused rules are skipped', () {
      final r = rule(account: 'a', nextDue: d(2026, 1, 5), active: false);
      expect(RecurringSchedule.dueOccurrences(r, d(2026, 10, 18)), isEmpty);
    });

    test('every 6 months', () {
      final r = rule(account: 'a', nextDue: d(2025, 7, 2), frequency: Frequency.everyNMonths, interval: 6);
      expect(RecurringSchedule.dueOccurrences(r, d(2026, 10, 18)), [d(2025, 7, 2), d(2026, 1, 2), d(2026, 7, 2)]);
    });
  });

  test('firstOnOrAfter', () {
    expect(
      RecurringSchedule.firstOnOrAfter(frequency: Frequency.monthly, date: d(2026, 10, 18), dayOfMonth: 20),
      d(2026, 10, 20),
    );
    expect(
      RecurringSchedule.firstOnOrAfter(frequency: Frequency.monthly, date: d(2026, 10, 21), dayOfMonth: 20),
      d(2026, 11, 20),
    );
    expect(
      RecurringSchedule.firstOnOrAfter(frequency: Frequency.monthly, date: d(2026, 2, 1), dayOfMonth: 31),
      d(2026, 2, 28),
    );
    expect(
      RecurringSchedule.firstOnOrAfter(frequency: Frequency.weekly, date: d(2026, 10, 18), weekday: DateTime.monday),
      d(2026, 10, 19),
    );
  });

  test('monthly-equivalent cost = amount ÷ interval in months', () {
    expect(RecurringSchedule.monthlyEquivalentCents(rule(account: 'a', nextDue: t0)), 65000);
    expect(
      RecurringSchedule.monthlyEquivalentCents(
        rule(account: 'a', nextDue: t0, cents: 18600, frequency: Frequency.everyNMonths, interval: 6),
      ),
      3100,
    );
    expect(
      RecurringSchedule.monthlyEquivalentCents(rule(account: 'a', nextDue: t0, cents: 12000, frequency: Frequency.yearly)),
      1000,
    );
    expect(
      RecurringSchedule.monthlyEquivalentCents(rule(account: 'a', nextDue: t0, cents: 1000, frequency: Frequency.weekly)),
      4333,
    );
  });

  test('occursOn', () {
    final r = rule(account: 'a', nextDue: d(2026, 10, 20));
    expect(RecurringSchedule.occursOn(r, d(2026, 10, 20)), isTrue);
    expect(RecurringSchedule.occursOn(r, d(2026, 11, 20)), isTrue);
    expect(RecurringSchedule.occursOn(r, d(2026, 10, 21)), isFalse);
    expect(RecurringSchedule.occursOn(r.copyWith(active: false), d(2026, 10, 20)), isFalse);
  });
}

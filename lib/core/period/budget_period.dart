import 'dart:math' as math;

import 'package:meta/meta.dart';
import 'package:pulse/core/period/dates.dart';

/// When the user gets paid; the budget "month" starts on that day.
enum PaydayKind { first, fifteenth, last, custom }

@immutable
final class Payday {
  const new(this.kind, [this.customDay = 1]) : assert(customDay >= 1 && customDay <= 31, 'day of month');

  static const first = Payday(PaydayKind.first);

  final PaydayKind kind;

  /// Day of month for [PaydayKind.custom]; ignored otherwise.
  final int customDay;

  /// The payday's date within [year]/[month]. A custom day past the month's
  /// end falls on its last day (31 → 30 Apr, 28/29 Feb).
  int dayIn(int year, int month) => switch (kind) {
    PaydayKind.first => 1,
    PaydayKind.fifteenth => 15,
    PaydayKind.last => daysInMonth(year, month),
    PaydayKind.custom => math.min(customDay, daysInMonth(year, month)),
  };

  DateTime dateIn(int year, int month) {
    final m = DateTime(year, month);
    return DateTime(m.year, m.month, dayIn(m.year, m.month));
  }

  @override
  bool operator ==(Object other) =>
      other is Payday && other.kind == kind && (kind != PaydayKind.custom || other.customDay == customDay);

  @override
  int get hashCode => Object.hash(kind, kind == PaydayKind.custom ? customDay : 0);
}

/// One budget period, `[start, end)` in whole days, from one payday to the
/// next (payday 15 → 15 Oct … 14 Nov).
@immutable
final class BudgetPeriod {
  const new(this.start, this.end);

  factory containing(DateTime date, Payday payday) {
    final d = dateOnly(date);
    final thisAnchor = payday.dateIn(d.year, d.month);
    if (!d.isBefore(thisAnchor)) {
      return BudgetPeriod(thisAnchor, payday.dateIn(d.year, d.month + 1));
    }
    return BudgetPeriod(payday.dateIn(d.year, d.month - 1), thisAnchor);
  }

  /// First day (inclusive), at local midnight.
  final DateTime start;

  /// Day after the last day (exclusive), at local midnight.
  final DateTime end;

  DateTime get lastDay => addDays(end, -1);

  int get lengthInDays => daysBetween(start, end);

  DateRange get range => DateRange(start, end);

  bool contains(DateTime t) => !t.isBefore(start) && t.isBefore(end);

  BudgetPeriod previous(Payday payday) => BudgetPeriod.containing(addDays(start, -1), payday);

  BudgetPeriod next(Payday payday) => BudgetPeriod.containing(end, payday);

  /// Days remaining including [today]; 0 once the period is over and the
  /// full length before it starts.
  int daysLeft(DateTime today) => daysBetween(today, end).clamp(0, lengthInDays);

  /// Days elapsed including [today].
  int daysElapsed(DateTime today) => (daysBetween(start, today) + 1).clamp(0, lengthInDays);

  /// The calendar month holding most of the period, used to name it
  /// ("Οκτώβριος" for 1–31 Oct and for 15 Oct–14 Nov, "Νοέμβριος" for
  /// 31 Oct–29 Nov).
  DateTime get labelMonth {
    final mid = addDays(start, (lengthInDays - 1) ~/ 2);
    return DateTime(mid.year, mid.month);
  }

  @override
  bool operator ==(Object other) => other is BudgetPeriod && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'BudgetPeriod(${dayKey(start)} → ${dayKey(end)})';
}

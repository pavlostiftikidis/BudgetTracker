import 'package:meta/meta.dart';

/// Calendar-day helpers that ignore time of day and are immune to DST.
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

/// Whole calendar days from [from] to [to] (negative if [to] is earlier).
int daysBetween(DateTime from, DateTime to) =>
    DateTime.utc(to.year, to.month, to.day).difference(DateTime.utc(from.year, from.month, from.day)).inDays;

DateTime addDays(DateTime d, int days) => DateTime(d.year, d.month, d.day + days);

/// [months] after [d], landing on [anchorDay] (or the month's last day when
/// the month is shorter): Jan 31 + 1 → Feb 28/29, + 2 → Mar 31.
DateTime addMonthsAnchored(DateTime d, int months, int anchorDay) {
  final first = DateTime(d.year, d.month + months);
  final day = anchorDay.clamp(1, daysInMonth(first.year, first.month));
  return DateTime(first.year, first.month, day);
}

bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

/// Monday of the week containing [d].
DateTime startOfWeek(DateTime d) => addDays(dateOnly(d), -(d.weekday - DateTime.monday));

/// "2026-10-18", used as a stable key for recurring occurrences.
String dayKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Half-open interval of instants, `[start, end)`.
@immutable
final class DateRange {
  const new(this.start, this.end);

  final DateTime start;
  final DateTime end;

  bool contains(DateTime t) => !t.isBefore(start) && t.isBefore(end);

  DateRange union(DateRange other) => DateRange(
    start.isBefore(other.start) ? start : other.start,
    end.isAfter(other.end) ? end : other.end,
  );

  @override
  bool operator ==(Object other) => other is DateRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'DateRange($start, $end)';
}

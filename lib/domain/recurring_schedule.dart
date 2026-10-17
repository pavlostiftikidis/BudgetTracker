import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/data/models/models.dart';

/// Pure scheduling rules for [RecurringRule]s.
abstract final class RecurringSchedule {
  /// Safety net against runaway loops (e.g. a weekly rule left paused
  /// for years and re-enabled with an old due date).
  static const maxOccurrencesPerRun = 520;

  /// The occurrence after [from].
  static DateTime advance(RecurringRule rule, DateTime from) {
    final anchor = rule.dayOfMonth ?? rule.startDate.day;
    final n = rule.interval < 1 ? 1 : rule.interval;
    return switch (rule.frequency) {
      Frequency.monthly => addMonthsAnchored(from, 1, anchor),
      Frequency.everyNMonths => addMonthsAnchored(from, n, anchor),
      Frequency.weekly => addDays(dateOnly(from), 7 * n),
      Frequency.yearly => addMonthsAnchored(from, 12 * n, anchor),
    };
  }

  /// Every occurrence from `rule.nextDueDate` up to and including [today].
  /// Empty for paused rules.
  static List<DateTime> dueOccurrences(RecurringRule rule, DateTime today) {
    if (!rule.active) return const [];
    final out = <DateTime>[];
    final limit = dateOnly(today);
    var due = dateOnly(rule.nextDueDate);
    while (!due.isAfter(limit) && out.length < maxOccurrencesPerRun) {
      out.add(due);
      due = advance(rule, due);
    }
    return out;
  }

  /// First occurrence on or after [date] for a rule anchored on
  /// `dayOfMonth` / `weekday`.
  static DateTime firstOnOrAfter({
    required Frequency frequency,
    required DateTime date,
    int? dayOfMonth,
    int? weekday,
  }) {
    final d = dateOnly(date);
    switch (frequency) {
      case Frequency.weekly:
        final wd = weekday ?? d.weekday;
        return addDays(d, (wd - d.weekday) % 7);
      case Frequency.monthly:
      case Frequency.everyNMonths:
      case Frequency.yearly:
        final anchor = dayOfMonth ?? d.day;
        final thisMonth = addMonthsAnchored(DateTime(d.year, d.month), 0, anchor);
        return thisMonth.isBefore(d) ? addMonthsAnchored(DateTime(d.year, d.month), 1, anchor) : thisMonth;
    }
  }

  /// Cost per month: amount ÷ interval in months (weekly → ×52/12).
  static int monthlyEquivalentCents(RecurringRule rule) {
    final n = rule.interval < 1 ? 1 : rule.interval;
    return switch (rule.frequency) {
      Frequency.monthly => rule.amountCents,
      Frequency.everyNMonths => divRound(rule.amountCents, n),
      Frequency.weekly => divRound(rule.amountCents * 52, 12 * n),
      Frequency.yearly => divRound(rule.amountCents, 12 * n),
    };
  }

  /// Whether the rule has an occurrence on [day] (used by the 7-day strip),
  /// looking forward from its next due date.
  static bool occursOn(RecurringRule rule, DateTime day) {
    if (!rule.active) return false;
    final target = dateOnly(day);
    var due = dateOnly(rule.nextDueDate);
    var guard = 0;
    while (due.isBefore(target) && guard++ < maxOccurrencesPerRun) {
      due = advance(rule, due);
    }
    return isSameDay(due, target);
  }
}

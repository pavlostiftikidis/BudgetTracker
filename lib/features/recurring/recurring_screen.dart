import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/core/theme/palette.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/utils/greek.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/empty_state.dart';
import 'package:pulse/core/widgets/icon_tile.dart';
import 'package:pulse/core/widgets/mono_label.dart';
import 'package:pulse/core/widgets/page_header.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';
import 'package:pulse/core/widgets/pulse_switch.dart';
import 'package:pulse/core/widgets/surface_card.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/domain/recurring_schedule.dart';
import 'package:pulse/features/recurring/rule_form_sheet.dart';
import 'package:pulse/l10n/app_localizations.dart';

/// "Μηνιαία, 20ή", "Κάθε 6 μήνες", "Κάθε Δευτέρα", "Ετήσια, 5 Νοε".
String frequencyLabel(RecurringRule r, AppLocalizations l10n) => switch (r.frequency) {
  Frequency.monthly => l10n.freqMonthly(dayOrdinal(r.dayOfMonth ?? r.startDate.day)),
  Frequency.everyNMonths => l10n.freqEveryNMonths(r.interval),
  Frequency.weekly => l10n.freqWeekly(weekdayNameOf(r.weekday ?? r.startDate.weekday)),
  Frequency.yearly => l10n.freqYearly(dayMonthShort(r.nextDueDate)),
};

/// Sum of the monthly-equivalent cost of active expense rules.
Money monthlyFixedCost(Iterable<RecurringRule> rules) => rules
    .where((r) => r.active && r.kind == TxnKind.expense)
    .map((r) => Money(RecurringSchedule.monthlyEquivalentCents(r)))
    .sum();

class RecurringScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = context.l10n;
    final rules = ref.watch(recurringRulesProvider).value;
    final categories = {for (final x in ref.watch(allCategoriesProvider).value ?? const <TxnCategory>[]) x.id: x};
    final income = ref.watch(settingsProvider).value?.monthlyIncome ?? Money.zero;
    final today = dateOnly(ref.watch(clockProvider).now());
    if (rules == null) return const PulseScaffold(body: SizedBox.shrink());

    final sorted = [...rules.where((r) => r.active), ...rules.where((r) => !r.active)];
    final monthly = monthlyFixedCost(rules);
    final share = income.isPositive ? divRound(monthly.cents * 100, income.cents) : null;
    final activeCount = rules.where((r) => r.active).length;
    final bottom = PulseScaffold.navClearance + MediaQuery.paddingOf(context).bottom;

    return PulseScaffold(
      floatingAction: PrimaryButton(label: l10n.recurringNew, onPressed: () => showRuleForm(context)),
      body: Column(
        children: [
          PageHeader(title: l10n.recurringTitle, trailing: const [ThemeToggleButton()]),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20, 8, 20, bottom),
              children: [
                SurfaceCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MonoLabel(l10n.recurringMonthlyLabel),
                                const SizedBox(height: 4),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    monthly.format(showCents: monthly.cents % 100 != 0),
                                    style: PulseText.hero.copyWith(fontSize: 36, letterSpacing: -1.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (share != null)
                            Text(
                              l10n.recurringShareOfIncome(share),
                              textAlign: TextAlign.right,
                              style: PulseText.caption.copyWith(color: c.muted),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _NextDays(today: today, rules: rules, categories: categories),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(l10n.recurringListTitle, style: PulseText.sectionTitle.copyWith(fontSize: 17)),
                      ),
                    ),
                    Text(l10n.recurringActiveCount(activeCount), style: PulseText.caption.copyWith(color: c.muted)),
                  ],
                ),
                const SizedBox(height: 8),
                if (sorted.isEmpty)
                  EmptyState(icon: LucideIcons.repeat, title: l10n.recurringEmpty)
                else
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: c.line),
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < sorted.length; i++)
                          _RuleRow(
                            rule: sorted[i],
                            category: categories[sorted[i].categoryId],
                            today: today,
                            last: i == sorted.length - 1,
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NextDays extends StatelessWidget {
  const new({required this.today, required this.rules, required this.categories});

  final DateTime today;
  final List<RecurringRule> rules;
  final Map<String, TxnCategory> categories;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    return Semantics(
      container: true,
      label: l10n.recurringNext7Days,
      child: Row(
        children: [
          for (var i = 0; i < 7; i++) ...[
            if (i > 0) const SizedBox(width: 6),
            Expanded(
              child: () {
                final day = addDays(today, i);
                final due = rules.where((r) => RecurringSchedule.occursOn(r, day)).toList();
                final isToday = i == 0;
                return Semantics(
                  container: true,
                  label: l10n.recurringDueDaySemantics(
                    '${weekdayName(day)} ${day.day} ${monthGenitive(day)}',
                    due.map((r) => r.title).join(', '),
                  ),
                  excludeSemantics: true,
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: isToday ? c.text : c.surface2,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          greekUpper(weekdayShort(day)),
                          textScaler: TextScaler.noScaling,
                          style: PulseText.mono.copyWith(
                            fontSize: 10,
                            letterSpacing: 0,
                            color: (isToday ? c.bg : c.text).withValues(alpha: 0.75),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${day.day}',
                          textScaler: TextScaler.noScaling,
                          style: PulseText.title.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isToday ? c.bg : c.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final r in due.take(3))
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: c.tint(categories[r.categoryId]?.colorKey ?? ColorKey.grey).ink,
                                ),
                              ),
                            if (due.isEmpty) const SizedBox(height: 6),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }(),
            ),
          ],
        ],
      ),
    );
  }
}

class _RuleRow extends ConsumerWidget {
  const new({required this.rule, required this.category, required this.today, required this.last});

  final RecurringRule rule;
  final TxnCategory? category;
  final DateTime today;
  final bool last;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = context.l10n;
    final days = daysBetween(today, rule.nextDueDate);
    final soon = rule.active && days <= 7;
    final next = !rule.active
        ? l10n.recurringPaused
        : (soon ? l10n.dueIn(days < 0 ? 0 : days) : dayMonthShort(rule.nextDueDate));
    final income = rule.kind == TxnKind.income;
    final amount = rule.amount.format(showCents: rule.amountCents % 100 != 0);
    final freq = frequencyLabel(rule, l10n);
    return Opacity(
      opacity: rule.active ? 1 : 0.55,
      child: InkWell(
        onTap: () => showRuleForm(context, rule: rule),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
          decoration: BoxDecoration(
            border: last ? null : Border(bottom: BorderSide(color: c.line)),
          ),
          child: Row(
            children: [
              IconTile(initial: initialOf(rule.title), color: category?.colorKey ?? ColorKey.grey),
              const SizedBox(width: 12),
              Expanded(
                child: Semantics(
                  container: true,
                  button: true,
                  label: '${rule.title}, $freq, $next, ${income ? '+' : ''}$amount',
                  excludeSemantics: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rule.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: PulseText.title),
                      const SizedBox(height: 2),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: '$freq · '),
                            TextSpan(
                              text: next,
                              style: TextStyle(color: soon ? c.accentInk : c.muted, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        style: PulseText.small.copyWith(fontWeight: FontWeight.w500, color: c.muted),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${income ? '+' : ''}$amount',
                style: PulseText.amount.copyWith(fontWeight: FontWeight.w800, color: income ? c.accentInk : c.text),
              ),
              PulseSwitch(
                value: rule.active,
                semanticLabel: l10n.recurringToggle(rule.title),
                onChanged: (v) => ref.read(recurringRepositoryProvider).setActive(rule.id, active: v),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

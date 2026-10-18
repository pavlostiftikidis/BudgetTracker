import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/app/router.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/utils/greek.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/empty_state.dart';
import 'package:pulse/core/widgets/error_view.dart';
import 'package:pulse/core/widgets/hero_amount.dart';
import 'package:pulse/core/widgets/icon_tile.dart';
import 'package:pulse/core/widgets/mono_label.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';
import 'package:pulse/core/widgets/segmented_spend_bar.dart';
import 'package:pulse/core/widgets/sheets.dart';
import 'package:pulse/core/widgets/sparkline.dart';
import 'package:pulse/core/widgets/surface_card.dart';
import 'package:pulse/core/widgets/week_bars.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/features/home/home_vm.dart';
import 'package:pulse/features/transactions/txn_display.dart';

class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(homeVmProvider);
    final vm = async.value;
    if (vm == null) {
      return async.hasError
          ? ErrorView(error: async.error!, onRetry: () => ref.invalidate(homeVmProvider))
          : const SizedBox.shrink();
    }
    final bottom = PulseScaffold.bottomClearance(context);
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, bottom),
          children: vm.isEmpty ? _emptyChildren(context, vm) : _children(context, vm),
        ),
        if (vm.isEmpty)
          Positioned(
            right: 18,
            bottom: bottom - 8,
            child: const ExcludeSemantics(child: _StartHereBubble()),
          ),
      ],
    );
  }

  List<Widget> _children(BuildContext context, HomeVm vm) {
    final c = context.colors;
    final l10n = context.l10n;
    final change = vm.changePercent;
    final good = change != null && change <= 0;
    return [
      _Header(vm: vm),
      const SizedBox(height: 22),
      MonoLabel(l10n.homeBalanceLabel),
      const SizedBox(height: 6),
      HeroAmount(amount: vm.available, color: vm.available.isNegative ? c.coralInk : null),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (change != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: ShapeDecoration(color: good ? c.accentSoft : c.coralSoft, shape: const StadiumBorder()),
              child: Text(
                l10n.vsPrevious(
                  '${change > 0 ? '+' : (change < 0 ? kMinus : '')}${change.abs()}%',
                  monthShort(vm.previous.labelMonth),
                ),
                style: PulseText.caption.copyWith(fontWeight: FontWeight.w700, color: good ? c.accentInk : c.coralInk),
              ),
            ),
          Text(
            [
              l10n.ofAmount(vm.budgetTotal.format(showCents: false)),
              if (vm.isCurrent) l10n.daysLeft(vm.daysLeft),
            ].join(' · '),
            style: PulseText.label.copyWith(fontWeight: FontWeight.w500, color: c.muted),
          ),
        ],
      ),
      const SizedBox(height: 22),
      SegmentedSpendBar(
        slices: [
          for (final s in vm.split)
            BarSlice(
              label: s.category?.name ?? l10n.otherCategories,
              value: s.amount.cents,
              percent: s.percent,
              color: s.category == null ? c.rest : c.tint(s.category!.colorKey).ink,
            ),
        ],
        semanticLabel: l10n.homeSpendSplitSemantics(
          vm.split.map((s) => '${s.category?.name ?? l10n.otherCategories} ${s.percent}%').join(', '),
        ),
      ),
      if (vm.split.isEmpty) ...[
        const SizedBox(height: 10),
        Text(l10n.noSpendingYet, style: PulseText.caption.copyWith(color: c.muted)),
      ],
      const SizedBox(height: 22),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _AllowanceCard(amount: vm.dailyAllowance)),
            const SizedBox(width: 10),
            Expanded(
              child: _SavingsCard(amount: vm.savings, series: vm.savingsSeries),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      _WeekCard(vm: vm),
      const SizedBox(height: 22),
      const _RecentSection(),
    ];
  }

  List<Widget> _emptyChildren(BuildContext context, HomeVm vm) {
    final c = context.colors;
    final l10n = context.l10n;
    final steps = vm.firstSteps;
    final hero = vm.hasBudgets ? vm.summary.totalLimit : vm.monthlyIncome;
    return [
      _Header(vm: vm, welcome: true),
      const SizedBox(height: 22),
      MonoLabel(l10n.homeAvailableToSpend),
      const SizedBox(height: 6),
      HeroAmount(amount: hero, showCents: false),
      const SizedBox(height: 6),
      Text(
        l10n.homeWholeMonthAhead(monthName(vm.period.labelMonth)),
        style: PulseText.label.copyWith(fontWeight: FontWeight.w500, color: c.muted),
      ),
      const SizedBox(height: 22),
      const SegmentedSpendBar(slices: [], semanticLabel: ''),
      const SizedBox(height: 10),
      Text(l10n.homeEmptyHint, style: PulseText.caption.copyWith(color: c.muted)),
      const SizedBox(height: 22),
      SurfaceCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(l10n.firstStepsTitle, style: PulseText.sectionTitle.copyWith(fontSize: 17)),
                  ),
                ),
                Text(
                  l10n.progressOf(steps.done, FirstSteps.total),
                  style: PulseText.caption.copyWith(fontWeight: FontWeight.w700, color: c.accentInk),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: steps.done / FirstSteps.total,
                minHeight: 6,
                color: c.accent,
                backgroundColor: c.surface2,
                semanticsLabel: l10n.firstStepsTitle,
              ),
            ),
            const SizedBox(height: 6),
            _StepRow(
              title: l10n.firstStepIncome,
              subtitle: l10n.firstStepIncomeSub(vm.monthlyIncome.format(showCents: false), vm.limitedCategories),
              done: steps.income,
              route: Routes.categories,
            ),
            _StepRow(title: l10n.firstStepTxn, subtitle: l10n.firstStepTxnSub, done: steps.firstTxn, route: Routes.add),
            _StepRow(
              title: l10n.firstStepRecurring,
              subtitle: l10n.firstStepRecurringSub,
              done: steps.recurring,
              route: Routes.recurring,
            ),
            _StepRow(
              title: l10n.firstStepAccounts,
              subtitle: l10n.firstStepAccountsSub,
              done: steps.balances,
              route: Routes.accounts,
              last: true,
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      CustomPaint(
        painter: DashedRRectPainter(color: c.line, radius: Radii.cardSm),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(14)),
                child: Icon(LucideIcons.receipt, color: c.muted, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.emptyNoTxnsTitle, style: PulseText.title),
                    const SizedBox(height: 2),
                    Text(l10n.emptyNoTxnsBody, style: PulseText.caption.copyWith(color: c.muted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}

class _Header extends ConsumerWidget {
  const new({required this.vm, this.welcome = false});

  final HomeVm vm;
  final bool welcome;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = context.l10n;
    final name = vm.displayName?.trim() ?? '';
    final initials = name.isEmpty
        ? null
        : name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).take(2).map(initialOf).join();
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: c.accent, shape: BoxShape.circle),
          child: initials == null
              ? Icon(LucideIcons.user, size: 20, color: c.onAccent)
              : Text(
                  initials,
                  textScaler: TextScaler.noScaling,
                  style: PulseText.title.copyWith(fontWeight: FontWeight.w800, color: c.onAccent),
                ),
        ),
        const SizedBox(width: 10),
        if (welcome)
          Expanded(child: Text(l10n.homeWelcome, style: PulseText.title))
        else
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Semantics(
                button: true,
                label: '${l10n.homePeriodPicker}: ${monthName(vm.period.labelMonth)}',
                container: true,
                excludeSemantics: true,
                child: Material(
                  color: c.surface,
                  shape: StadiumBorder(side: BorderSide(color: c.line)),
                  child: InkWell(
                    customBorder: const StadiumBorder(),
                    onTap: () => _pickPeriod(context, ref),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 44),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                monthName(vm.period.labelMonth),
                                overflow: TextOverflow.ellipsis,
                                style: PulseText.label.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(LucideIcons.chevronDown, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(width: 8),
        CircleIconButton(
          icon: LucideIcons.settings,
          semanticLabel: l10n.navMore,
          onPressed: () => context.push(Routes.settings),
        ),
        const SizedBox(width: 8),
        const ThemeToggleButton(),
      ],
    );
  }

  Future<void> _pickPeriod(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsProvider).value ?? const AppSettings();
    final now = ref.read(clockProvider).now();
    final periods = <BudgetPeriod>[BudgetPeriod.containing(now, settings.payday)];
    for (var i = 1; i < 12; i++) {
      periods.add(periods.last.previous(settings.payday));
    }
    final selected = ref.read(homePeriodOffsetProvider);
    final picked = await showPulseSheet<int>(
      context,
      builder: (context) => SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetHeader(title: context.l10n.homePeriodPicker),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (var i = 0; i < periods.length; i++)
                    PickerRow(
                      title: '${monthName(periods[i].labelMonth)} ${periods[i].labelMonth.year}',
                      trailingText: '${dayMonthShort(periods[i].start)} – ${dayMonthShort(periods[i].lastDay)}',
                      selected: i == selected,
                      onTap: () => Navigator.pop(context, i),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (picked != null) ref.read(homePeriodOffsetProvider.notifier).offset = picked;
  }
}

class _AllowanceCard extends StatelessWidget {
  const new({required this.amount});

  final Money amount;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    // Whole euros rounded down, so the card never promises more than is left.
    final shown = Money(amount.cents ~/ 100 * 100).format(showCents: false);
    return Semantics(
      label: '${l10n.homeTodayCanSpend} $shown',
      container: true,
      excludeSemantics: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 128),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: c.accent, borderRadius: BorderRadius.circular(Radii.card)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(LucideIcons.clock, size: 22, color: c.onAccent),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeTodayCanSpend,
                  style: PulseText.caption.copyWith(fontWeight: FontWeight.w600, color: c.onAccent),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(shown, style: PulseText.amountXL.copyWith(color: c.onAccent)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SavingsCard extends StatelessWidget {
  const new({required this.amount, required this.series});

  final Money amount;
  final List<int> series;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    return Semantics(
      label: l10n.homeSavingsSemantics(amount.format(showCents: false)),
      container: true,
      excludeSemantics: true,
      child: SurfaceCard(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Sparkline(values: series, color: c.sky),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeSavings,
                    style: PulseText.caption.copyWith(fontWeight: FontWeight.w600, color: c.muted),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      amount.format(showCents: false),
                      style: PulseText.amountXL.copyWith(color: amount.isNegative ? c.coralInk : null),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekCard extends StatelessWidget {
  const new({required this.vm});

  final HomeVm vm;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(l10n.homeThisWeek, style: PulseText.title)),
              Text(vm.weekTotal.format(showCents: false), style: PulseText.amount),
            ],
          ),
          const SizedBox(height: 12),
          WeekBars(
            bars: [
              for (final d in vm.week)
                WeekBar(label: weekdayNarrow(d.day), value: d.spent.cents, today: d.isToday, future: d.isFuture),
            ],
            semanticLabel: l10n.homeWeekBarsSemantics(
              vm.week.where((d) => !d.isFuture).map((d) => '${weekdayName(d.day)} ${d.spent.format()}').join(', '),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentSection extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = context.l10n;
    final recent = ref.watch(recentTxnsProvider(3)).value ?? const <Txn>[];
    final lookups = ref.watch(lookupsProvider).value;
    final now = ref.watch(clockProvider).now();
    if (lookups == null || recent.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(header: true, child: Text(l10n.homeRecent, style: PulseText.sectionTitle)),
            ),
            TextButton(
              onPressed: () => context.push(Routes.transactions),
              child: Text(l10n.homeSeeAll, style: PulseText.label.copyWith(color: c.accentInk)),
            ),
          ],
        ),
        for (final t in recent) _RecentRow(view: describeTxn(t, lookups, l10n), now: now),
      ],
    );
  }
}

class _RecentRow extends StatelessWidget {
  const new({required this.view, required this.now});

  final TxnView view;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final day = dayLabel(view.txn.date, now, l10n);
    final when = day == l10n.dayToday ? timeOfDay(view.txn.date) : day;
    return Semantics(
      button: true,
      label: txnSemantics(view, l10n),
      container: true,
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push(Routes.editTransaction(view.txn.id)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TxnRowContent(view: view, subtitleOverride: '${view.categoryName} · $when'),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const new({required this.title, required this.subtitle, required this.done, required this.route, this.last = false});

  final String title;
  final String subtitle;
  final bool done;
  final String route;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    return Semantics(
      button: true,
      label: '$title, $subtitle${done ? ', ${l10n.stepDone}' : ''}',
      container: true,
      excludeSemantics: true,
      child: InkWell(
        onTap: () => context.push(route),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: last ? null : Border(bottom: BorderSide(color: c.line)),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? c.accent : null,
                  border: Border.all(color: done ? c.accent : c.line, width: 1.5),
                ),
                child: done ? Icon(LucideIcons.check, size: 16, color: c.onAccent) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: PulseText.title.copyWith(
                        color: done ? c.muted : c.text,
                        decoration: done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: PulseText.small.copyWith(fontWeight: FontWeight.w500, color: c.muted),
                    ),
                  ],
                ),
              ),
              if (!done) Icon(LucideIcons.chevronRight, size: 18, color: c.muted),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Ξεκίνα από εδώ" bubble pointing down at the + button.
class _StartHereBubble extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: c.text, borderRadius: BorderRadius.circular(14)),
          child: Text(
            context.l10n.emptyStartHere,
            style: PulseText.caption.copyWith(fontWeight: FontWeight.w800, color: c.bg),
          ),
        ),
        Positioned(
          right: 22,
          bottom: -6,
          child: Transform.rotate(angle: 0.785398, child: Container(width: 12, height: 12, color: c.text)),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/app/router.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/utils/greek.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/empty_state.dart';
import 'package:pulse/core/widgets/error_view.dart';
import 'package:pulse/core/widgets/mono_label.dart';
import 'package:pulse/core/widgets/progress_ring.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';
import 'package:pulse/core/widgets/surface_card.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/domain/budget_math.dart';
import 'package:pulse/features/categories/category_form_sheet.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budgets_screen.g.dart';

@riverpod
Future<BudgetSummary> currentBudget(Ref ref) async {
  final settings = await ref.watch(settingsProvider.future);
  final categories = await ref.watch(categoriesProvider.future);
  final now = ref.watch(clockProvider).now();
  final period = BudgetPeriod.containing(now, settings.payday);
  final txns = await ref.watch(txnsInRangeProvider(period.range).future);
  return BudgetSummary.compute(period: period, categories: categories, txns: txns, today: now);
}

/// Number of ticks in the summary bar; the last three (85 %+) turn amber.
const int kTicks = 20;

class BudgetsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = context.l10n;
    final async = ref.watch(currentBudgetProvider);
    final summary = async.value;
    if (summary == null) {
      return async.hasError
          ? ErrorView(error: async.error!, onRetry: () => ref.invalidate(currentBudgetProvider))
          : const SizedBox.shrink();
    }
    return ListView(
      padding: EdgeInsets.fromLTRB(20, 20, 20, PulseScaffold.bottomClearance(context)),
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(l10n.budgetsTitle, style: PulseText.screenTitle.copyWith(fontSize: 30)),
              ),
            ),
            CircleIconButton(
              icon: LucideIcons.layoutGrid,
              semanticLabel: l10n.categoriesTitle,
              onPressed: () => context.push(Routes.categories),
            ),
            const SizedBox(width: 8),
            const ThemeToggleButton(),
          ],
        ),
        const SizedBox(height: 20),
        if (!summary.hasBudgets)
          EmptyState(
            icon: LucideIcons.chartPie,
            title: l10n.budgetsEmpty,
            action: OutlineButtonPill(
              icon: LucideIcons.plus,
              label: l10n.budgetsNewCategory,
              onPressed: () => showCategoryForm(context),
            ),
          )
        else ...[
          _SummaryCard(summary: summary),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - 10) / 2;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final b in summary.categories)
                    SizedBox(
                      width: width,
                      child: _CategoryCard(budget: b),
                    ),
                  SizedBox(
                    width: width,
                    child: CustomPaint(
                      painter: DashedRRectPainter(color: c.line, radius: Radii.cardSm),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(Radii.cardSm),
                          onTap: () => showCategoryForm(context),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 146),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.plus, color: c.muted),
                                const SizedBox(height: 8),
                                Text(l10n.budgetsNewCategory, style: PulseText.label.copyWith(color: c.muted)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const new({required this.summary});

  final BudgetSummary summary;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final over = summary.spentBudgeted > summary.totalLimit;
    final filled = summary.totalLimit.cents <= 0
        ? 0
        : ((summary.spentBudgeted.cents * kTicks + summary.totalLimit.cents ~/ 2) ~/ summary.totalLimit.cents).clamp(
            0,
            kTicks,
          );
    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: MonoLabel(greekUpper(monthName(summary.period.labelMonth)))),
              Text(
                l10n.budgetsWithinLimit(summary.withinLimitCount, summary.categories.length),
                style: PulseText.caption.copyWith(fontWeight: FontWeight.w700, color: c.accentInk),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Semantics(
            label: l10n.budgetsSummarySemantics(summary.spentBudgeted.format(), summary.totalLimit.format()),
            container: true,
            excludeSemantics: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        summary.spentBudgeted.format(showCents: false),
                        style: PulseText.hero.copyWith(
                          fontSize: 40,
                          letterSpacing: -2,
                          color: over ? c.coralInk : null,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '/ ${summary.totalLimit.format(showCents: false)}',
                        style: PulseText.title.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: c.muted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    for (var i = 0; i < kTicks; i++) ...[
                      if (i > 0) const SizedBox(width: 3),
                      Expanded(
                        child: Container(
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: i >= filled
                                ? c.surface2
                                : i >= kTicks - 3
                                ? (over ? c.coral : c.amber)
                                : c.accent,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const new({required this.budget});

  final CategoryBudget budget;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final state = budget.state;
    final over = state == CategoryState.over;
    final warning = state == CategoryState.warning;
    final ringColor = switch (state) {
      CategoryState.over => c.coral,
      CategoryState.warning => c.amber,
      CategoryState.normal => c.tint(budget.category.colorKey).ink,
    };
    final stateText = switch (state) {
      CategoryState.over => l10n.budgetOverBy(budget.overBy.format()),
      CategoryState.warning => l10n.budgetNearLimit,
      CategoryState.normal => l10n.budgetRemaining(budget.remaining.format()),
    };
    return Semantics(
      button: true,
      label: [
        l10n.budgetRingSemantics(budget.category.name, budget.percent),
        l10n.budgetSpentOfLimit(budget.spent.format(), budget.limit.format()),
        stateText,
      ].join(', '),
      container: true,
      excludeSemantics: true,
      child: SurfaceCard(
        radius: Radii.cardSm,
        padding: const EdgeInsets.all(14),
        color: over ? c.coralSoft : null,
        borderColor: over ? c.coral : null,
        onTap: () => showCategoryForm(context, category: budget.category),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProgressRing(
                  value: budget.percent / 100,
                  color: ringColor,
                  child: Text(
                    '${budget.percent}%',
                    textScaler: TextScaler.noScaling,
                    style: PulseText.label.copyWith(fontWeight: FontWeight.w800, fontFeatures: PulseText.tabular),
                  ),
                ),
                const Spacer(),
                if (over)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: ShapeDecoration(color: c.coral, shape: const StadiumBorder()),
                    child: Text(
                      '+${budget.overBy.format(showCents: false)}',
                      style: PulseText.small.copyWith(fontSize: 11, fontWeight: FontWeight.w800, color: c.onAccent),
                    ),
                  )
                else if (warning)
                  Icon(LucideIcons.triangleAlert, size: 18, color: c.amberInk),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              budget.category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PulseText.title.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(
              l10n.budgetSpentOfLimit(budget.spent.format(showCents: false), budget.limit.format(showCents: false)),
              style: PulseText.caption.copyWith(color: c.muted, fontFeatures: PulseText.tabular),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/core/theme/palette.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/utils/greek.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/empty_state.dart';
import 'package:pulse/core/widgets/error_view.dart';
import 'package:pulse/core/widgets/mono_label.dart';
import 'package:pulse/core/widgets/pill_segmented_control.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';
import 'package:pulse/core/widgets/surface_card.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/domain/insights.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'insights_screen.g.dart';

@riverpod
class InsightsScaleSetting extends _$InsightsScaleSetting {
  @override
  InsightScale build() => InsightScale.month;

  InsightScale get scale => state;

  set scale(InsightScale value) => state = value;
}

@riverpod
Future<InsightsData> insights(Ref ref) async {
  final settings = await ref.watch(settingsProvider.future);
  final scale = ref.watch(insightsScaleSettingProvider);
  final now = ref.watch(clockProvider).now();
  final buckets = bucketsFor(scale, now, settings.payday);
  final range = DateRange(buckets.first.range.start, buckets.last.range.end);
  final txns = await ref.watch(txnsInRangeProvider(range).future);
  return computeInsights(scale: scale, txns: txns, now: now, payday: settings.payday);
}

/// "€1,4k" above a bar, "€851" below a thousand.
String compactEuros(Money m) {
  final euros = m.roundedEuros;
  if (euros < 1000) return '€$euros';
  final tenths = divRound(euros, 100);
  return '€${tenths ~/ 10},${tenths % 10}k';
}

String bucketLabel(InsightScale scale, Bucket b) => switch (scale) {
  InsightScale.week => '${b.labelDate.day}/${b.labelDate.month}',
  InsightScale.month => greekUpper(monthShort(b.labelDate)),
  InsightScale.year => '${b.labelDate.year}',
};

String spendingLabel(InsightScale scale, Bucket b, AppLocalizations l10n) => l10n.insightsSpendingLabel(switch (scale) {
  InsightScale.week => l10n.insightsThisWeek,
  InsightScale.month => greekUpper(monthGenitive(b.labelDate)),
  InsightScale.year => '${b.labelDate.year}',
});

class InsightsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = context.l10n;
    final scale = ref.watch(insightsScaleSettingProvider);
    final async = ref.watch(insightsProvider);
    final data = async.value;
    if (data == null && async.hasError) {
      return ErrorView(error: async.error!, onRetry: () => ref.invalidate(insightsProvider));
    }
    final categories = {for (final x in ref.watch(allCategoriesProvider).value ?? const <TxnCategory>[]) x.id: x};

    return ListView(
      padding: EdgeInsets.fromLTRB(20, 20, 20, PulseScaffold.bottomClearance(context)),
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(l10n.insightsTitle, style: PulseText.screenTitle.copyWith(fontSize: 30)),
              ),
            ),
            const ThemeToggleButton(),
          ],
        ),
        const SizedBox(height: 18),
        PillSegmentedControl<InsightScale>(
          semanticLabel: l10n.periodControl,
          selected: scale,
          onChanged: (s) => ref.read(insightsScaleSettingProvider.notifier).scale = s,
          segments: [
            Segment(value: InsightScale.week, label: l10n.periodWeek),
            Segment(value: InsightScale.month, label: l10n.periodMonth),
            Segment(value: InsightScale.year, label: l10n.periodYear),
          ],
        ),
        const SizedBox(height: 20),
        if (data != null) ...[
          _Hero(data: data, scale: scale),
          const SizedBox(height: 18),
          _Chart(data: data, scale: scale),
          const SizedBox(height: 14),
          _InsightCard(data: data, categories: categories),
          const SizedBox(height: 22),
          Semantics(
            header: true,
            child: Text(l10n.topCategories, style: PulseText.sectionTitle.copyWith(fontSize: 17)),
          ),
          const SizedBox(height: 12),
          if (data.topCategories.isEmpty)
            EmptyState(icon: LucideIcons.chartColumn, title: l10n.insightsEmpty)
          else
            for (final e in data.topCategories.take(5)) ...[
              _TopCategoryRow(
                name: categories[e.key]?.name ?? '—',
                amount: e.value,
                max: data.topCategories.first.value,
                color: c.tint(categories[e.key]?.colorKey ?? ColorKey.grey).ink,
              ),
              const SizedBox(height: 12),
            ],
        ],
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const new({required this.data, required this.scale});

  final InsightsData data;
  final InsightScale scale;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final change = data.changePercent;
    final good = change != null && change <= 0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MonoLabel(spendingLabel(scale, data.buckets.last, l10n)),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  data.current.format(showCents: false),
                  style: PulseText.hero.copyWith(fontSize: 48, letterSpacing: -2.4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: ShapeDecoration(
            color: change == null ? c.surface2 : (good ? c.accentSoft : c.coralSoft),
            shape: const StadiumBorder(),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (change != null) ...[
                Icon(
                  good ? LucideIcons.trendingDown : LucideIcons.trendingUp,
                  size: 14,
                  color: good ? c.accentInk : c.coralInk,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                change == null
                    ? l10n.noPreviousData
                    : '${change > 0 ? '+' : (change < 0 ? kMinus : '')}${change.abs()}%',
                style: PulseText.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: change == null ? c.muted : (good ? c.accentInk : c.coralInk),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const new({required this.data, required this.scale});

  final InsightsData data;
  final InsightScale scale;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final maxCents = data.totals.fold<int>(0, (m, t) => t.cents > m ? t.cents : m);
    final last = data.totals.length - 1;
    final summary = [
      for (var i = 0; i <= last; i++)
        '${bucketLabel(scale, data.buckets[i])} ${data.totals[i].format(showCents: false)}',
    ].join(', ');
    return Semantics(
      container: true,
      label: l10n.insightsChartSemantics(summary),
      excludeSemantics: true,
      child: SurfaceCard(
        padding: const EdgeInsets.fromLTRB(12, 18, 12, 10),
        child: SizedBox(
          height: 176,
          child: BarChart(
            BarChartData(
              maxY: maxCents <= 0 ? 1 : maxCents * 1.18,
              alignment: BarChartAlignment.spaceAround,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barTouchData: const BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 26,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          bucketLabel(scale, data.buckets[i]),
                          textScaler: TextScaler.noScaling,
                          style: PulseText.mono.copyWith(
                            fontSize: 11,
                            letterSpacing: 0,
                            color: i == last ? c.text : c.muted,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                for (var i = 0; i <= last; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data.totals[i].cents.toDouble(),
                        width: 34,
                        color: i == last ? c.accent : c.surface2,
                        borderRadius: BorderRadius.circular(10),
                        label: BarChartRodLabel(
                          text: compactEuros(data.totals[i]),
                          style: PulseText.small.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: i == last ? c.text : c.muted,
                          ),
                          offset: const Offset(0, 4),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            duration: context.motion(Motion.chart),
          ),
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const new({required this.data, required this.categories});

  final InsightsData data;
  final Map<String, TxnCategory> categories;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final inc = data.increase;
    final weekday = data.topWeekday == null ? null : l10n.insightTopWeekday(weekdayWithArticle(data.topWeekday!));
    final title = inc == null
        ? l10n.insightNoIncrease
        : l10n.insightIncreaseTitle(categories[inc.categoryId]?.name ?? '—', '+${inc.percent}%');
    final body = [if (inc != null) l10n.insightIncreaseBody(inc.delta.format(showCents: false)), ?weekday].join(' ');
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: inc == null ? c.accentSoft : c.coralSoft,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: inc == null ? c.accent : c.coral,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(inc == null ? LucideIcons.sparkles : LucideIcons.trendingUp, size: 18, color: c.onAccent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: PulseText.title.copyWith(fontWeight: FontWeight.w800)),
                  if (body.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(body, style: PulseText.caption.copyWith(color: c.muted, height: 1.4)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopCategoryRow extends StatelessWidget {
  const new({required this.name, required this.amount, required this.max, required this.color});

  final String name;
  final Money amount;
  final Money max;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fraction = max.cents <= 0 ? 0.0 : amount.cents / max.cents;
    return Semantics(
      container: true,
      label: '$name ${amount.format()}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(name, style: PulseText.label)),
              Text(amount.format(showCents: false), style: PulseText.label.copyWith(fontFeatures: PulseText.tabular)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 8,
              child: Stack(
                children: [
                  Positioned.fill(child: ColoredBox(color: c.surface2)),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: context.reduceMotion ? fraction : 0, end: fraction),
                    duration: context.motion(Motion.chart),
                    curve: Motion.curve,
                    builder: (context, f, _) => FractionallySizedBox(
                      alignment: AlignmentDirectional.centerStart,
                      widthFactor: f,
                      heightFactor: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(99)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

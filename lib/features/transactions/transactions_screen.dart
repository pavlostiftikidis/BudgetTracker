import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/app/router.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/utils/greek.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/empty_state.dart';
import 'package:pulse/core/widgets/mono_label.dart';
import 'package:pulse/core/widgets/page_header.dart';
import 'package:pulse/core/widgets/pill_segmented_control.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';
import 'package:pulse/core/widgets/swipeable_txn_tile.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/features/transactions/txn_actions.dart';
import 'package:pulse/features/transactions/txn_display.dart';
import 'package:pulse/features/transactions/txn_grouping.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final _group = SwipeGroup();
  final _search = TextEditingController();
  TxnFilter _filter = TxnFilter.all;

  @override
  void dispose() {
    _group.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final txns = ref.watch(allTxnsProvider).value;
    final lookups = ref.watch(lookupsProvider).value;
    final today = ref.watch(clockProvider).now();
    final actions = ref.watch(txnActionsProvider);

    final groups = (txns == null || lookups == null)
        ? const <DayGroup>[]
        : groupByDay(
            txns
                .where((t) => matchesFilter(t, _filter))
                .map((t) => describeTxn(t, lookups, l10n))
                .where((v) => matchesQuery(v, _search.text)),
          );

    final rows = <Widget>[
      for (final g in groups) ...[
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
          child: Row(
            children: [
              Expanded(child: Semantics(header: true, child: MonoLabel(greekUpper(dayLabel(g.day, today, l10n))))),
              Text(
                g.total.formatSigned(),
                style: PulseText.small.copyWith(color: g.total.isPositive ? c.accentInk : c.muted),
              ),
            ],
          ),
        ),
        for (final v in g.items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SwipeableTxnTile(
              key: ValueKey(v.txn.id),
              id: v.txn.id,
              group: _group,
              semanticLabel: txnSemantics(v, l10n),
              onTap: () => context.push(Routes.editTransaction(v.txn.id)),
              onEdit: () => context.push(Routes.editTransaction(v.txn.id)),
              onDelete: () => deleteWithUndo(context, actions, id: v.txn.id, name: v.title),
              child: TxnRowContent(view: v),
            ),
          ),
      ],
    ];

    return PulseScaffold(
      body: Column(
        children: [
          PageHeader(title: l10n.txnsTitle, trailing: const [ThemeToggleButton()]),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Column(
              children: [
                TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: l10n.txnsSearchHint,
                    prefixIcon: Icon(LucideIcons.search, size: 18, color: c.muted),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: l10n.actionClose,
                            icon: Icon(LucideIcons.x, size: 18, color: c.muted),
                            onPressed: () => setState(_search.clear),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                PillSegmentedControl<TxnFilter>(
                  semanticLabel: l10n.txnsTitle,
                  selected: _filter,
                  onChanged: (f) => setState(() => _filter = f),
                  segments: [
                    Segment(value: TxnFilter.all, label: l10n.filterAll),
                    Segment(value: TxnFilter.expenses, label: l10n.filterExpenses),
                    Segment(value: TxnFilter.income, label: l10n.filterIncome),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(LucideIcons.moveHorizontal, size: 16, color: c.muted),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(l10n.txnsSwipeHint, style: PulseText.caption.copyWith(color: c.muted)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: txns == null
                ? const SizedBox.shrink()
                : rows.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: EmptyState(icon: LucideIcons.searchX, title: l10n.txnsEmpty),
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + MediaQuery.paddingOf(context).bottom),
                    children: rows,
                  ),
          ),
        ],
      ),
    );
  }
}

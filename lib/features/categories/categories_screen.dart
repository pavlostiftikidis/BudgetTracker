import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/theme/palette.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/empty_state.dart';
import 'package:pulse/core/widgets/icon_tile.dart';
import 'package:pulse/core/widgets/page_header.dart';
import 'package:pulse/core/widgets/pill_segmented_control.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/features/categories/category_form_sheet.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  CategoryKind _kind = CategoryKind.expense;

  /// Optimistic order while the database write is in flight.
  List<String>? _pendingOrder;

  Future<void> _reorder(List<TxnCategory> all, List<TxnCategory> shown, int oldIndex, int newIndex) async {
    final ids = shown.map((c) => c.id).toList();
    final moved = ids.removeAt(oldIndex);
    ids.insert(newIndex, moved);
    // The other kind's categories keep their order after this kind's.
    final full = [...ids, ...all.where((c) => c.kind != _kind).map((c) => c.id)];
    setState(() => _pendingOrder = ids);
    await ref.read(categoryRepositoryProvider).reorder(full);
    if (mounted) setState(() => _pendingOrder = null);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final all = ref.watch(categoriesProvider).value ?? const <TxnCategory>[];
    final counts = ref.watch(categoryTxnCountsProvider).value ?? const <String, int>{};
    var shown = all.where((x) => x.kind == _kind).toList();
    final pending = _pendingOrder;
    if (pending != null) {
      final byId = {for (final x in shown) x.id: x};
      shown = [for (final id in pending) ?byId[id]];
    }

    return PulseScaffold(
      body: Column(
        children: [
          PageHeader(
            title: l10n.categoriesTitle,
            trailing: [
              Semantics(
                button: true,
                label: l10n.newCategoryTitle,
                container: true,
                excludeSemantics: true,
                child: Material(
                  color: c.accent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => showCategoryForm(context, kind: _kind),
                    child: SizedBox.square(dimension: 44, child: Icon(LucideIcons.plus, color: c.onAccent, size: 20)),
                  ),
                ),
              ),
              const ThemeToggleButton(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: PillSegmentedControl<CategoryKind>(
              semanticLabel: l10n.categoriesTitle,
              selected: _kind,
              onChanged: (k) => setState(() => _kind = k),
              segments: [
                Segment(value: CategoryKind.expense, label: l10n.categoryKindExpense),
                Segment(value: CategoryKind.income, label: l10n.categoryKindIncome),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.categoryReorderHint, style: PulseText.caption.copyWith(color: c.muted)),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: shown.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: EmptyState(icon: LucideIcons.layoutGrid, title: l10n.newCategoryTitle),
                    ),
                  )
                : ReorderableListView.builder(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + MediaQuery.paddingOf(context).bottom),
                    itemCount: shown.length,
                    buildDefaultDragHandles: false,
                    onReorderItem: (o, n) => _reorder(all, shown, o, n),
                    proxyDecorator: (child, _, _) => Material(color: Colors.transparent, elevation: 6, child: child),
                    itemBuilder: (context, i) => _CategoryRow(
                      key: ValueKey(shown[i].id),
                      category: shown[i],
                      count: counts[shown[i].id] ?? 0,
                      index: i,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const new({required this.category, required this.count, required this.index, super.key});

  final TxnCategory category;
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final meta = [
      if (category.hasLimit)
        l10n.categoryLimit(category.monthlyLimit!.format(showCents: false))
      else
        l10n.categoryNoLimit,
      l10n.txnCount(count),
    ].join(' · ');
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: c.line),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => showCategoryForm(context, category: category),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
            child: Row(
              children: [
                IconTile(icon: category.iconKey.icon, color: category.colorKey, filled: true),
                const SizedBox(width: 12),
                Expanded(
                  child: Semantics(
                    button: true,
                    label: '${category.name}, $meta',
                    container: true,
                    excludeSemantics: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category.name, style: PulseText.title),
                        const SizedBox(height: 2),
                        Text(
                          meta,
                          style: PulseText.small.copyWith(fontWeight: FontWeight.w500, color: c.muted),
                        ),
                      ],
                    ),
                  ),
                ),
                ReorderableDragStartListener(
                  index: index,
                  child: Semantics(
                    label: l10n.categoryReorderHint,
                    child: SizedBox.square(
                      dimension: 44,
                      child: Icon(LucideIcons.gripVertical, color: c.muted, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

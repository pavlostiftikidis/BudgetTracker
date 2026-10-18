import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/theme/palette.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/icon_tile.dart';
import 'package:pulse/core/widgets/mono_label.dart';
import 'package:pulse/core/widgets/pill_segmented_control.dart';
import 'package:pulse/core/widgets/sheets.dart';
import 'package:pulse/data/ids.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/features/categories/color_swatches.dart';
import 'package:pulse/l10n/app_localizations.dart';

String iconName(IconKey k, AppLocalizations l10n) => switch (k) {
  IconKey.cart => l10n.iconCart,
  IconKey.food => l10n.iconFood,
  IconKey.car => l10n.iconCar,
  IconKey.home => l10n.iconHome,
  IconKey.film => l10n.iconFilm,
  IconKey.heart => l10n.iconHeart,
  IconKey.gift => l10n.iconGift,
  IconKey.plane => l10n.iconPlane,
  IconKey.book => l10n.iconBook,
  IconKey.shirt => l10n.iconShirt,
  IconKey.bolt => l10n.iconBolt,
  IconKey.salary => l10n.iconSalary,
  IconKey.laptop => l10n.iconLaptop,
  IconKey.tag => l10n.iconTag,
};

/// "Νέα κατηγορία" (or edit [category]) bottom sheet with a live preview.
Future<void> showCategoryForm(BuildContext context, {TxnCategory? category, CategoryKind? kind}) =>
    showPulseSheet<void>(
      context,
      builder: (_) => _CategoryForm(category: category, kind: kind),
    );

class _CategoryForm extends ConsumerStatefulWidget {
  const new({this.category, this.kind});

  final TxnCategory? category;
  final CategoryKind? kind;

  @override
  ConsumerState<_CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends ConsumerState<_CategoryForm> {
  late final TxnCategory? _c = widget.category;
  late final _name = TextEditingController(text: _c?.name ?? '');
  late final _limit = TextEditingController(
    text: _c?.monthlyLimit == null ? '' : _c!.monthlyLimit!.formatPlain(showCents: _c.monthlyLimit!.cents % 100 != 0),
  );
  late CategoryKind _kind = _c?.kind ?? widget.kind ?? CategoryKind.expense;
  late ColorKey _color = _c?.colorKey ?? ColorKey.coral;
  late IconKey _icon = _c?.iconKey ?? IconKey.heart;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _limit.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final name = _name.text.trim();
    if (name.isEmpty) return setState(() => _error = l10n.validationNameRequired);
    int? limit;
    if (_limit.text.trim().isNotEmpty) {
      final m = Money.tryParse(_limit.text);
      if (m == null || validateAmount(m) != null) return setState(() => _error = l10n.validationAmountRequired);
      limit = m.cents;
    }
    final existing = ref.read(categoriesProvider).value ?? const <TxnCategory>[];
    final category =
        (_c ??
                TxnCategory(
                  id: newId(),
                  name: name,
                  kind: _kind,
                  colorKey: _color,
                  iconKey: _icon,
                  sortOrder: existing.length,
                ))
            .copyWith(name: name, kind: _kind, colorKey: _color, iconKey: _icon, monthlyLimitCents: limit);
    await ref.read(categoryRepositoryProvider).save(category);
    await HapticFeedback.lightImpact();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final messenger = ScaffoldMessenger.of(context);
    final notice = context.l10n.categoryArchivedNotice;
    final archived = await ref.read(categoryRepositoryProvider).archiveOrDelete(_c!.id);
    await HapticFeedback.mediumImpact();
    if (!mounted) return;
    Navigator.pop(context);
    if (archived) messenger.showSnackBar(SnackBar(content: Text(notice)));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final limitText = _limit.text.trim().isEmpty ? l10n.categoryNoLimit : l10n.categoryLimit('€${_limit.text.trim()}');
    final icons = {...IconKey.pickable, _icon}.toList();
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              header: true,
              child: Text(
                _c == null ? l10n.newCategoryTitle : l10n.editCategoryTitle,
                style: PulseText.screenTitle.copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Semantics(
                  label: '${_name.text}, ${colorName(_color, l10n)}, ${iconName(_icon, l10n)}, $limitText',
                  container: true,
                  excludeSemantics: true,
                  child: IconTile(icon: _icon.icon, color: _color, size: 56, radius: 18, filled: true),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MonoLabel(l10n.categoryNameLabel),
                      TextField(
                        controller: _name,
                        maxLength: 40,
                        autofocus: _c == null,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (_) => setState(() {}),
                        style: PulseText.sectionTitle.copyWith(fontSize: 22),
                        decoration: InputDecoration(
                          hintText: l10n.categoryNameHint,
                          counterText: '',
                          filled: false,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 6),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: c.line, width: 2)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: c.accentInk, width: 2)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        limitText,
                        style: PulseText.small.copyWith(fontWeight: FontWeight.w500, color: c.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_c == null) ...[
              const SizedBox(height: 16),
              PillSegmentedControl<CategoryKind>(
                semanticLabel: l10n.fieldAccountType,
                selected: _kind,
                onChanged: (k) => setState(() => _kind = k),
                segments: [
                  Segment(value: CategoryKind.expense, label: l10n.categoryKindExpense),
                  Segment(value: CategoryKind.income, label: l10n.categoryKindIncome),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Text(
              l10n.categoryColor,
              style: PulseText.caption.copyWith(fontWeight: FontWeight.w700, color: c.muted),
            ),
            const SizedBox(height: 6),
            ColorSwatches(selected: _color, onChanged: (k) => setState(() => _color = k)),
            const SizedBox(height: 12),
            Text(
              l10n.categoryIcon,
              style: PulseText.caption.copyWith(fontWeight: FontWeight.w700, color: c.muted),
            ),
            const SizedBox(height: 8),
            Semantics(
              container: true,
              label: l10n.categoryIcon,
              child: GridView.count(
                crossAxisCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.15,
                children: [
                  for (final k in icons)
                    Semantics(
                      inMutuallyExclusiveGroup: true,
                      checked: k == _icon,
                      button: true,
                      label: iconName(k, l10n),
                      container: true,
                      excludeSemantics: true,
                      child: Material(
                        color: k == _icon ? c.tint(_color).fill : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: k == _icon ? c.tint(_color).fill : c.line, width: 1.5),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => setState(() => _icon = k),
                          child: Icon(k.icon, size: 22, color: k == _icon ? c.onAccent : c.muted),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_kind == CategoryKind.expense) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${l10n.categoryMonthlyLimit} ${l10n.fieldOptional}',
                        style: PulseText.label.copyWith(fontWeight: FontWeight.w500, color: c.muted),
                      ),
                    ),
                    SizedBox(
                      width: 110,
                      child: TextField(
                        controller: _limit,
                        onChanged: (_) => setState(() {}),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.right,
                        style: PulseText.amount.copyWith(fontSize: 16, fontWeight: FontWeight.w800),
                        decoration: InputDecoration(
                          hintText: '€0',
                          prefixText: _limit.text.isEmpty ? null : '€',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: PulseText.caption.copyWith(color: c.coralInk)),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                if (_c != null) ...[
                  Semantics(
                    button: true,
                    label: l10n.categoryDeleteOrArchive,
                    container: true,
                    excludeSemantics: true,
                    child: Material(
                      color: Colors.transparent,
                      shape: CircleBorder(side: BorderSide(color: c.coral, width: 1.5)),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _delete,
                        child: SizedBox.square(dimension: 58, child: Icon(LucideIcons.trash2, color: c.coralInk)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: PrimaryButton(
                    label: _c == null ? l10n.categoryCreate : l10n.actionSave,
                    height: 58,
                    onPressed: _save,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

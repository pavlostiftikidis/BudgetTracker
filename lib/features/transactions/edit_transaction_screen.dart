import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/theme/palette.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/utils/greek.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/empty_state.dart';
import 'package:pulse/core/widgets/icon_tile.dart';
import 'package:pulse/core/widgets/page_header.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';
import 'package:pulse/core/widgets/pulse_switch.dart';
import 'package:pulse/core/widgets/sheets.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/features/transactions/pickers.dart';
import 'package:pulse/features/transactions/receipt_store.dart';
import 'package:pulse/features/transactions/txn_actions.dart';
import 'package:pulse/features/transactions/txn_display.dart';

class EditTransactionScreen extends ConsumerStatefulWidget {
  const new({required this.id, super.key});

  final String id;

  @override
  ConsumerState<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends ConsumerState<EditTransactionScreen> {
  Txn? _original;
  late Txn _draft;
  late bool _repeat;
  final _title = TextEditingController();
  final _note = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  void _init(Txn t) {
    _original = t;
    _draft = t;
    _repeat = t.recurringRuleId != null;
    _title.text = t.title ?? '';
    _note.text = t.note ?? '';
  }

  Future<void> _save(Lookups lookups) async {
    if (_saving) return;
    setState(() => _saving = true);
    final view = describeTxn(_draft, lookups, context.l10n);
    await ref
        .read(txnActionsProvider)
        .saveEdit(
          original: _original!,
          edited: _draft.copyWith(title: _title.text, note: _note.text),
          repeatMonthly: _repeat,
          fallbackTitle: view.categoryName,
        );
    await HapticFeedback.lightImpact();
    if (mounted) context.pop();
  }

  Future<void> _confirmDelete(TxnView view, Lookups lookups) async {
    final c = context.colors;
    final l10n = context.l10n;
    final t = _original!;
    final account = lookups.account(t.accountId)?.name ?? '—';
    final body = switch (t.kind) {
      TxnKind.expense => l10n.deleteDialogBodyExpense(view.title, view.amountText, monthAccusative(t.date), account),
      TxnKind.income => l10n.deleteDialogBodyIncome(view.title, view.amountText, monthAccusative(t.date), account),
      TxnKind.transfer => l10n.deleteDialogBodyTransfer(
        t.amount.format(),
        account,
        lookups.account(t.toAccountId)?.name ?? '—',
      ),
    };
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: c.coralSoft, borderRadius: BorderRadius.circular(16)),
          child: Icon(LucideIcons.trash2, color: c.coralInk),
        ),
        iconPadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        title: Text(l10n.deleteDialogTitle),
        content: Text(body),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlineButtonPill(label: l10n.actionCancel, onPressed: () => Navigator.pop(context, false)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Material(
                  color: c.coral,
                  shape: const StadiumBorder(),
                  child: InkWell(
                    key: const ValueKey('confirm-delete'),
                    customBorder: const StadiumBorder(),
                    onTap: () => Navigator.pop(context, true),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 52),
                      child: Center(
                        child: Text(
                          l10n.actionDelete,
                          style: PulseText.label.copyWith(color: c.onAccent, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final deleting = deleteWithUndo(context, ref.read(txnActionsProvider), id: t.id, name: view.title);
    context.pop();
    await deleting;
  }

  Future<void> _attachReceipt() async {
    final l10n = context.l10n;
    final camera = await showPulseSheet<bool>(
      context,
      builder: (context) => SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetHeader(title: l10n.editAttachReceipt),
            PickerRow(
              title: l10n.receiptFromCamera,
              selected: false,
              leading: const Icon(LucideIcons.camera, size: 20),
              onTap: () => Navigator.pop(context, true),
            ),
            PickerRow(
              title: l10n.receiptFromGallery,
              selected: false,
              leading: const Icon(LucideIcons.image, size: 20),
              onTap: () => Navigator.pop(context, false),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (camera == null) return;
    final path = await pickAndStoreReceipt(_draft.id, camera: camera);
    if (path != null && mounted) setState(() => _draft = _draft.copyWith(receiptPath: path));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final async = ref.watch(txnByIdProvider(widget.id));
    final lookups = ref.watch(lookupsProvider).value;
    final txn = async.value;

    if (txn != null && _original == null) _init(txn);

    if (async.hasValue && (txn == null || txn.deletedAt != null) && _original == null) {
      return PulseScaffold(
        body: Column(
          children: [
            PageHeader(title: l10n.editTitle),
            Padding(
              padding: const EdgeInsets.all(20),
              child: EmptyState(icon: LucideIcons.searchX, title: l10n.editNotFound),
            ),
          ],
        ),
      );
    }
    if (_original == null || lookups == null) return const PulseScaffold(body: SizedBox.shrink());

    final view = describeTxn(_draft, lookups, l10n);
    final category = lookups.category(_draft.categoryId);
    final isTransfer = _draft.isTransfer;

    Widget row(String label, String value, VoidCallback onTap, {Color? dot}) => Semantics(
      button: true,
      label: '$label: $value',
      container: true,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 54),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: PulseText.label.copyWith(fontWeight: FontWeight.w500, color: c.muted),
                ),
              ),
              if (dot != null) ...[ColorDot(color: dot), const SizedBox(width: 8)],
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: PulseText.title,
                ),
              ),
              const SizedBox(width: 6),
              Icon(LucideIcons.chevronRight, size: 18, color: c.muted),
            ],
          ),
        ),
      ),
    );

    final divider = Divider(color: c.line, height: 1);

    return PulseScaffold(
      body: Column(
        children: [
          PageHeader(title: l10n.editTitle, trailing: const [ThemeToggleButton()]),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
                Center(
                  child: IconTile(icon: view.icon, color: view.color, size: 64, radius: 22, filled: !isTransfer),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _title,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.sentences,
                  style: PulseText.sectionTitle,
                  decoration: InputDecoration(
                    hintText: view.categoryName,
                    filled: false,
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
                Center(
                  child: Semantics(
                    button: true,
                    label: '${l10n.editAmountTap}: ${view.amountText}',
                    container: true,
                    excludeSemantics: true,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final m = await editAmount(context, _draft.amount);
                        if (m != null) setState(() => _draft = _draft.copyWith(amountCents: m.cents));
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: c.line, width: 2)),
                        ),
                        child: FittedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(switch (_draft.kind) {
                                TxnKind.expense => '−€',
                                TxnKind.income => '+€',
                                TxnKind.transfer => '€',
                              }, style: PulseText.heroDecimals.copyWith(fontSize: 26, color: c.muted)),
                              const SizedBox(width: 4),
                              Text(
                                _draft.amount.formatPlain(),
                                style: PulseText.hero.copyWith(
                                  fontSize: 56,
                                  letterSpacing: -2.8,
                                  color: _draft.kind == TxnKind.income ? c.accentInk : c.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: c.line),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        if (isTransfer) ...[
                          row(l10n.transferFrom, lookups.account(_draft.accountId)?.name ?? '—', () async {
                            final id = await pickAccount(
                              context,
                              selected: _draft.accountId,
                              exclude: _draft.toAccountId,
                            );
                            if (id != null) setState(() => _draft = _draft.copyWith(accountId: id));
                          }),
                          divider,
                          row(l10n.transferTo, lookups.account(_draft.toAccountId)?.name ?? '—', () async {
                            final id = await pickAccount(
                              context,
                              selected: _draft.toAccountId,
                              exclude: _draft.accountId,
                            );
                            if (id != null) setState(() => _draft = _draft.copyWith(toAccountId: id));
                          }),
                        ] else ...[
                          row(l10n.pickCategory, category?.name ?? '—', () async {
                            final id = await pickCategory(
                              context,
                              kind: _draft.kind == TxnKind.income ? CategoryKind.income : CategoryKind.expense,
                              selected: _draft.categoryId,
                            );
                            if (id != null) setState(() => _draft = _draft.copyWith(categoryId: id));
                          }, dot: c.tint(category?.colorKey ?? ColorKey.grey).ink),
                          divider,
                          row(l10n.pickAccount, lookups.account(_draft.accountId)?.name ?? '—', () async {
                            final id = await pickAccount(context, selected: _draft.accountId);
                            if (id != null) setState(() => _draft = _draft.copyWith(accountId: id));
                          }),
                        ],
                        divider,
                        row(l10n.pickDate, dateTimeShort(_draft.date), () async {
                          final d = await pickDateTime(context, _draft.date);
                          if (d != null) setState(() => _draft = _draft.copyWith(date: d));
                        }),
                        divider,
                        ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 54),
                          child: Row(
                            children: [
                              Text(
                                l10n.addNote,
                                style: PulseText.label.copyWith(fontWeight: FontWeight.w500, color: c.muted),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _note,
                                  textAlign: TextAlign.right,
                                  style: PulseText.title,
                                  decoration: InputDecoration(
                                    hintText: l10n.addNoteHint,
                                    filled: false,
                                    isDense: true,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isTransfer) ...[
                          divider,
                          ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 54),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.editRepeatMonthly,
                                    style: PulseText.label.copyWith(fontWeight: FontWeight.w500, color: c.muted),
                                  ),
                                ),
                                PulseSwitch(
                                  value: _repeat,
                                  semanticLabel: l10n.editRepeatMonthly,
                                  onChanged: (v) => setState(() => _repeat = v),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                if (_draft.receiptPath != null && File(_draft.receiptPath!).existsSync())
                  _ReceiptPreview(
                    path: _draft.receiptPath!,
                    onRemove: () => setState(() => _draft = _draft.copyWith(receiptPath: null)),
                  )
                else
                  CustomPaint(
                    painter: DashedRRectPainter(color: c.line, radius: 18),
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: _attachReceipt,
                        child: SizedBox(
                          height: 56,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.paperclip, size: 18, color: c.muted),
                              const SizedBox(width: 8),
                              Text(l10n.editAttachReceipt, style: PulseText.label.copyWith(color: c.muted)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: [
                Semantics(
                  button: true,
                  label: l10n.editDeleteTxn,
                  container: true,
                  excludeSemantics: true,
                  child: Material(
                    color: Colors.transparent,
                    shape: CircleBorder(side: BorderSide(color: c.coral, width: 1.5)),
                    child: InkWell(
                      key: const ValueKey('edit-delete'),
                      customBorder: const CircleBorder(),
                      onTap: () => _confirmDelete(view, lookups),
                      child: SizedBox.square(dimension: 60, child: Icon(LucideIcons.trash2, color: c.coralInk)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(label: l10n.editSaveChanges, onPressed: () => _save(lookups)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptPreview extends StatelessWidget {
  const new({required this.path, required this.onRemove});

  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(path),
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                semanticLabel: context.l10n.editReceiptAttached,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(context.l10n.editReceiptAttached, style: PulseText.title)),
            IconButton(
              tooltip: context.l10n.editRemoveReceipt,
              icon: Icon(LucideIcons.x, color: c.muted),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

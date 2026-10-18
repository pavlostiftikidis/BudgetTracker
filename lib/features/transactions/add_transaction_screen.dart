import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/app/router.dart';
import 'package:pulse/core/money/amount_input.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/category_chip.dart';
import 'package:pulse/core/widgets/empty_state.dart';
import 'package:pulse/core/widgets/money_keypad.dart';
import 'package:pulse/core/widgets/mono_label.dart';
import 'package:pulse/core/widgets/pill_segmented_control.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/features/accounts/account_display.dart';
import 'package:pulse/features/transactions/pickers.dart';
import 'package:pulse/features/transactions/transfer_widgets.dart';
import 'package:pulse/features/transactions/txn_actions.dart';
import 'package:pulse/features/transactions/txn_display.dart';

/// "Νέα κίνηση": full-screen modal with keypad. Expense / income, plus
/// transfer when opened with `?mode=transfer`.
class AddTransactionScreen extends ConsumerStatefulWidget {
  const new({this.transfer = false, super.key});

  final bool transfer;

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  late TxnKind _kind = widget.transfer ? TxnKind.transfer : TxnKind.expense;
  AmountInput _amount = const AmountInput();
  String? _categoryId;
  String? _accountId;
  String? _toAccountId;
  late DateTime _day = ref.read(clockProvider).now();
  String _note = '';
  TxnError? _error;
  bool _saving = false;

  CategoryKind get _categoryKind => _kind == TxnKind.income ? CategoryKind.income : CategoryKind.expense;

  Future<void> _save({
    required List<TxnCategory> categories,
    required String? accountId,
    required String? categoryId,
    required String? toId,
  }) async {
    final error = validateTxn(
      kind: _kind,
      amount: _amount.value,
      accountId: accountId,
      toAccountId: toId,
      categoryId: categoryId,
      categoryRequired: categories.isNotEmpty,
    );
    setState(() => _error = error);
    if (error != null || _saving) return;
    setState(() => _saving = true);
    await ref
        .read(txnActionsProvider)
        .add(
          kind: _kind,
          amount: _amount.value,
          accountId: accountId!,
          toAccountId: toId,
          categoryId: categoryId,
          day: _day,
          note: _note,
          title: _kind == TxnKind.transfer ? context.l10n.transferTitle : null,
        );
    await HapticFeedback.lightImpact();
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
    final categories = (ref.watch(categoriesProvider).value ?? const <TxnCategory>[])
        .where((cat) => cat.kind == _categoryKind)
        .toList();
    final today = ref.watch(clockProvider).now();

    final categoryId = categories.any((x) => x.id == _categoryId) ? _categoryId : categories.firstOrNull?.id;
    final accountId = _accountId ?? defaultAccountFor(_kind, accounts)?.id;
    final pair = defaultTransferPair(accounts);
    final fromId = _accountId ?? pair.from;
    final toId = _toAccountId ?? pair.to;
    final account = accounts.where((a) => a.id == accountId).firstOrNull;
    final isTransfer = _kind == TxnKind.transfer;
    final small = MediaQuery.sizeOf(context).height < 720;

    final header = Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          CircleIconButton(icon: LucideIcons.x, semanticLabel: l10n.actionClose, onPressed: () => context.pop()),
          const SizedBox(width: 10),
          Expanded(
            child: PillSegmentedControl<TxnKind>(
              semanticLabel: l10n.addTypeGroup,
              selected: _kind,
              onChanged: (k) => setState(() {
                _kind = k;
                _error = null;
                if (!widget.transfer) _accountId = null;
              }),
              segments: [
                Segment(value: TxnKind.expense, label: l10n.addExpense),
                Segment(value: TxnKind.income, label: l10n.addIncome),
                if (widget.transfer) Segment(value: TxnKind.transfer, label: l10n.addTransfer),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const ThemeToggleButton(),
        ],
      ),
    );

    if (accounts.isEmpty) {
      return PulseScaffold(
        body: Column(
          children: [
            header,
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: EmptyState(
                    icon: LucideIcons.wallet,
                    title: l10n.validationAccountRequired,
                    action: OutlineButtonPill(
                      label: l10n.accountsTitle,
                      icon: LucideIcons.plus,
                      onPressed: () => context.pushReplacement(Routes.accounts),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final label = switch (_kind) {
      TxnKind.expense => l10n.addNewExpenseLabel,
      TxnKind.income => l10n.addNewIncomeLabel,
      TxnKind.transfer => l10n.addNewTransferLabel,
    };

    return PulseScaffold(
      body: Column(
        children: [
          header,
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Column(
                children: [
                  MonoLabel(label),
                  const SizedBox(height: 6),
                  _AmountDisplay(amount: _amount, kind: _kind),
                  SizedBox(height: small ? 12 : 18),
                  if (isTransfer)
                    TransferRows(
                      fromId: fromId,
                      toId: toId,
                      onFrom: (id) => setState(() => _accountId = id),
                      onTo: (id) => setState(() => _toAccountId = id),
                    )
                  else
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final cat in categories)
                          CategoryChip(
                            label: cat.name,
                            color: cat.colorKey,
                            selected: cat.id == categoryId,
                            onTap: () => setState(() => _categoryId = cat.id),
                          ),
                      ],
                    ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickButton(
                          icon: LucideIcons.calendar,
                          label: dayLabel(_day, today, l10n),
                          onTap: () async {
                            final d = await pickDateTime(context, _day, withTime: false);
                            if (d != null) setState(() => _day = d);
                          },
                        ),
                      ),
                      if (!isTransfer) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: _QuickButton(
                            icon: account == null ? LucideIcons.wallet : accountIcon(account.type),
                            label: account?.name ?? l10n.pickAccount,
                            onTap: () async {
                              final id = await pickAccount(context, selected: accountId);
                              if (id != null) setState(() => _accountId = id);
                            },
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      Expanded(
                        child: _QuickButton(
                          icon: LucideIcons.stickyNote,
                          label: _note.isEmpty ? l10n.addNote : _note,
                          onTap: () async {
                            final n = await editNote(context, _note);
                            if (n != null) setState(() => _note = n.trim());
                          },
                        ),
                      ),
                    ],
                  ),
                  if (isTransfer) ...[
                    const SizedBox(height: 10),
                    Text(l10n.transferNote, style: PulseText.caption.copyWith(color: c.muted)),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Semantics(
                      liveRegion: true,
                      child: Text(txnErrorText(_error!, l10n), style: PulseText.caption.copyWith(color: c.coralInk)),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Column(
              children: [
                MoneyKeypad(
                  value: _amount,
                  keyHeight: small ? 46 : 60,
                  onChanged: (v) => setState(() {
                    _amount = v;
                    _error = null;
                  }),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  key: const ValueKey('add-save'),
                  label: isTransfer
                      ? l10n.transferSubmit(_amount.value.format())
                      : l10n.addSaveAmount('${_kind == TxnKind.income ? '+' : ''}${_amount.value.format()}'),
                  trailingArrow: true,
                  height: small ? 54 : 60,
                  onPressed: () => _save(
                    categories: categories,
                    accountId: isTransfer ? fromId : accountId,
                    categoryId: isTransfer ? null : categoryId,
                    toId: isTransfer ? toId : null,
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

/// "€ 18,50 |" with a blinking lime caret.
class _AmountDisplay extends StatefulWidget {
  const new({required this.amount, required this.kind});

  final AmountInput amount;
  final TxnKind kind;

  @override
  State<_AmountDisplay> createState() => _AmountDisplayState();
}

class _AmountDisplayState extends State<_AmountDisplay> with SingleTickerProviderStateMixin {
  late final AnimationController _blink = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reduceMotion) {
      _blink
        ..stop()
        ..value = 1;
    } else if (!_blink.isAnimating) {
      _blink.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final income = widget.kind == TxnKind.income;
    final color = income ? c.accentInk : c.text;
    return Semantics(
      liveRegion: true,
      label: context.l10n.amountSemantics(widget.amount.value.format()),
      excludeSemantics: true,
      child: SizedBox(
        height: 96,
        child: FittedBox(
          child: Row(
            children: [
              Text('${income ? '+' : ''}€', style: PulseText.heroDecimals.copyWith(fontSize: 34, color: c.muted)),
              const SizedBox(width: 4),
              Text(
                widget.amount.display,
                style: PulseText.hero.copyWith(fontSize: 80, letterSpacing: -4.8, color: color),
              ),
              const SizedBox(width: 6),
              FadeTransition(
                opacity: CurvedAnimation(parent: _blink, curve: Curves.easeInOut),
                child: Container(
                  width: 3,
                  height: 64,
                  decoration: BoxDecoration(color: c.accent, borderRadius: BorderRadius.circular(2)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  const new({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: c.line),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 16, color: c.text),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: PulseText.caption.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

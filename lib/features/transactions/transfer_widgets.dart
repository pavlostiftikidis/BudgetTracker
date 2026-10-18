import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/money/amount_input.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/money_keypad.dart';
import 'package:pulse/core/widgets/mono_label.dart';
import 'package:pulse/core/widgets/sheets.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/features/accounts/account_display.dart';
import 'package:pulse/features/transactions/pickers.dart';
import 'package:pulse/features/transactions/txn_actions.dart';
import 'package:pulse/l10n/app_localizations.dart';

String txnErrorText(TxnError e, AppLocalizations l10n) => switch (e) {
  TxnError.amountRequired => l10n.validationAmountRequired,
  TxnError.amountTooLarge => l10n.validationAmountMax,
  TxnError.sameAccount => l10n.validationSameAccount,
  TxnError.accountRequired => l10n.validationAccountRequired,
  TxnError.categoryRequired => l10n.validationCategoryRequired,
};

/// Default source and destination: a bank account, then savings (or any
/// other account).
({String? from, String? to}) defaultTransferPair(List<Account> accounts) {
  final from = defaultAccountFor(TxnKind.transfer, accounts);
  if (from == null) return (from: null, to: null);
  final others = accounts.where((a) => a.id != from.id).toList();
  final to = others.where((a) => a.type == AccountType.savings).firstOrNull ?? others.firstOrNull;
  return (from: from.id, to: to?.id);
}

/// "ΑΠΟ" / "ΠΡΟΣ" rows with a swap button between them.
class TransferRows extends ConsumerWidget {
  const new({required this.fromId, required this.toId, required this.onFrom, required this.onTo, super.key});

  final String? fromId;
  final String? toId;
  final ValueChanged<String> onFrom;
  final ValueChanged<String> onTo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = context.l10n;
    final accounts = {for (final a in ref.watch(accountsProvider).value ?? const <Account>[]) a.id: a};
    final balances = ref.watch(balancesProvider).value ?? const <String, Money>{};

    Widget row(String label, String? id, Future<void> Function() onTap) {
      final a = accounts[id];
      final bal = a == null ? null : balances[a.id] ?? a.openingBalance;
      return Semantics(
        button: true,
        label: '$label ${a?.name ?? ''}',
        excludeSemantics: true,
        child: Material(
          color: c.surface2,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 52),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 72, 10),
                child: Row(
                  children: [
                    SizedBox(width: 42, child: MonoLabel(label)),
                    ColorDot(color: a == null ? c.line : c.tint(a.colorKey).ink),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(a?.name ?? '—', style: PulseText.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    if (bal != null)
                      Text(
                        bal.format(),
                        style: PulseText.caption.copyWith(
                          color: bal.isNegative ? c.coralInk : c.muted,
                          fontFeatures: PulseText.tabular,
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

    return Stack(
      children: [
        Column(
          children: [
            row(l10n.transferFrom, fromId, () async {
              final id = await pickAccount(context, selected: fromId);
              if (id != null) onFrom(id);
            }),
            const SizedBox(height: 8),
            row(l10n.transferTo, toId, () async {
              final id = await pickAccount(context, selected: toId);
              if (id != null) onTo(id);
            }),
          ],
        ),
        Positioned(
          right: 18,
          top: 0,
          bottom: 0,
          child: Center(
            child: Semantics(
              button: true,
              label: l10n.transferSwap,
              excludeSemantics: true,
              child: Material(
                color: c.text,
                shape: CircleBorder(side: BorderSide(color: c.surface, width: 3)),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    unawaited(HapticFeedback.selectionClick());
                    final f = fromId;
                    final t = toId;
                    if (t != null) onFrom(t);
                    if (f != null) onTo(f);
                  },
                  child: SizedBox.square(dimension: 44, child: Icon(LucideIcons.arrowUpDown, size: 18, color: c.bg)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bottom sheet from Accounts › Μεταφορά.
Future<void> showTransferSheet(BuildContext context) =>
    showPulseSheet<void>(context, builder: (_) => const _TransferSheet());

class _TransferSheet extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_TransferSheet> createState() => _TransferSheetState();
}

class _TransferSheetState extends ConsumerState<_TransferSheet> {
  AmountInput _amount = const AmountInput();
  String? _from;
  String? _to;
  TxnError? _error;
  bool _saving = false;

  Future<void> _submit() async {
    final error = validateTxn(kind: TxnKind.transfer, amount: _amount.value, accountId: _from, toAccountId: _to);
    setState(() => _error = error);
    if (error != null || _saving) return;
    setState(() => _saving = true);
    await ref
        .read(txnActionsProvider)
        .add(
          kind: TxnKind.transfer,
          amount: _amount.value,
          accountId: _from!,
          toAccountId: _to,
          day: ref.read(clockProvider).now(),
          title: context.l10n.transferTitle,
        );
    await HapticFeedback.lightImpact();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
    if (_from == null && _to == null && accounts.isNotEmpty) {
      final pair = defaultTransferPair(accounts);
      _from = pair.from;
      _to = pair.to;
    }
    final small = MediaQuery.sizeOf(context).height < 720;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(l10n.transferTitle, style: PulseText.screenTitle.copyWith(fontSize: 22)),
                  ),
                ),
                Semantics(
                  liveRegion: true,
                  child: Text('€${_amount.display}', style: PulseText.amountXL.copyWith(fontSize: 32)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (accounts.length < 2)
              Text(l10n.transferNeedsTwo, style: PulseText.body.copyWith(color: c.muted))
            else
              TransferRows(
                fromId: _from,
                toId: _to,
                onFrom: (id) => setState(() => _from = id),
                onTo: (id) => setState(() => _to = id),
              ),
            const SizedBox(height: 12),
            Text(l10n.transferNote, style: PulseText.caption.copyWith(color: c.muted)),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(txnErrorText(_error!, l10n), style: PulseText.caption.copyWith(color: c.coralInk)),
            ],
            const SizedBox(height: 14),
            MoneyKeypad(value: _amount, keyHeight: small ? 46 : 54, onChanged: (v) => setState(() => _amount = v)),
            const SizedBox(height: 12),
            PrimaryButton(
              label: l10n.transferSubmit(_amount.value.format()),
              height: 58,
              onPressed: accounts.length < 2 ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}

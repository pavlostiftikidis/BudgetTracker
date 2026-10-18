import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/theme/palette.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/category_chip.dart';
import 'package:pulse/core/widgets/pulse_switch.dart';
import 'package:pulse/core/widgets/sheets.dart';
import 'package:pulse/data/ids.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/features/accounts/account_display.dart';
import 'package:pulse/features/categories/color_swatches.dart';

/// New account, or edit / archive [account].
Future<void> showAccountForm(BuildContext context, {Account? account}) =>
    showPulseSheet<void>(context, builder: (_) => _AccountForm(account: account));

class _AccountForm extends ConsumerStatefulWidget {
  const new({this.account});

  final Account? account;

  @override
  ConsumerState<_AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends ConsumerState<_AccountForm> {
  late final Account? _a = widget.account;
  late final _name = TextEditingController(text: _a?.name ?? '');
  late final _opening = TextEditingController(text: _a == null ? '' : _a.openingBalance.formatPlain());
  late final _limit = TextEditingController(
    text: _a?.creditLimitCents == null ? '' : Money(_a!.creditLimitCents!).formatPlain(showCents: false),
  );
  late final _day = TextEditingController(text: _a?.statementDay?.toString() ?? '');
  late final _last4 = TextEditingController(text: _a?.last4 ?? '');
  late final _goal = TextEditingController(
    text: _a?.goalCents == null ? '' : Money(_a!.goalCents!).formatPlain(showCents: false),
  );
  late AccountType _type = _a?.type ?? AccountType.bank;
  late ColorKey _color = _a?.colorKey ?? ColorKey.sky;
  late bool _credit = _a?.isCredit ?? false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _opening, _limit, _day, _last4, _goal]) {
      c.dispose();
    }
    super.dispose();
  }

  int? _cents(TextEditingController c) => c.text.trim().isEmpty ? null : Money.tryParse(c.text)?.cents;

  Future<void> _save() async {
    final l10n = context.l10n;
    final name = _name.text.trim();
    if (name.isEmpty) return setState(() => _error = l10n.validationNameRequired);
    final opening = _opening.text.trim().isEmpty ? 0 : Money.tryParse(_opening.text)?.cents;
    if (opening == null) return setState(() => _error = l10n.validationAmountRequired);
    final day = int.tryParse(_day.text.trim());
    final last4 = _last4.text.trim();
    final accounts = ref.read(accountsProvider).value ?? const <Account>[];
    final account = (_a ?? Account(id: newId(), name: name, type: _type, sortOrder: accounts.length)).copyWith(
      name: name,
      type: _type,
      colorKey: _color,
      openingBalanceCents: opening,
      isCredit: _type == AccountType.card && _credit,
      creditLimitCents: _type == AccountType.card && _credit ? _cents(_limit) : null,
      statementDay: _type == AccountType.card && _credit && day != null && day >= 1 && day <= 31 ? day : null,
      last4: _type == AccountType.bank && RegExp(r'^\d{4}$').hasMatch(last4) ? last4 : null,
      goalCents: _type == AccountType.savings ? _cents(_goal) : null,
    );
    await ref.read(accountRepositoryProvider).save(account);
    await HapticFeedback.lightImpact();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _archive() async {
    final archived = await ref.read(accountRepositoryProvider).archiveOrDelete(_a!.id);
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final text = context.l10n.accountArchiveConfirm;
    Navigator.pop(context);
    if (archived) messenger.showSnackBar(SnackBar(content: Text(text)));
  }

  Widget _field(TextEditingController c, String label, {String? hint, TextInputType? keyboard, int? maxLength}) =>
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: TextField(
          controller: c,
          keyboardType: keyboard,
          maxLength: maxLength,
          decoration: InputDecoration(labelText: label, hintText: hint, counterText: ''),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    const money = TextInputType.numberWithOptions(decimal: true, signed: true);
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Semantics(
                header: true,
                child: Text(
                  _a == null ? l10n.newAccountTitle : l10n.editAccountTitle,
                  style: PulseText.screenTitle.copyWith(fontSize: 22),
                ),
              ),
            ),
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 60,
              decoration: InputDecoration(labelText: l10n.fieldName, counterText: ''),
            ),
            const SizedBox(height: 14),
            Text(l10n.fieldAccountType, style: PulseText.label.copyWith(color: c.muted)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in AccountType.values)
                  CategoryChip(
                    label: accountTypeLabel(t, l10n),
                    color: _color,
                    selected: t == _type,
                    onTap: () => setState(() => _type = t),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(l10n.categoryColor, style: PulseText.label.copyWith(color: c.muted)),
            const SizedBox(height: 8),
            ColorSwatches(selected: _color, onChanged: (k) => setState(() => _color = k)),
            _field(_opening, l10n.fieldOpeningBalance, hint: '0,00', keyboard: money),
            if (_type == AccountType.bank)
              _field(_last4, '${l10n.fieldLast4} ${l10n.fieldOptional}', keyboard: TextInputType.number, maxLength: 4),
            if (_type == AccountType.card) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: Text(l10n.fieldIsCredit, style: PulseText.title)),
                  PulseSwitch(
                    value: _credit,
                    semanticLabel: l10n.fieldIsCredit,
                    onChanged: (v) => setState(() => _credit = v),
                  ),
                ],
              ),
              if (_credit) ...[
                _field(_limit, l10n.fieldCreditLimit, keyboard: money),
                _field(_day, l10n.fieldStatementDay, keyboard: TextInputType.number, maxLength: 2),
              ],
            ],
            if (_type == AccountType.savings)
              _field(_goal, '${l10n.fieldSavingsGoal} ${l10n.fieldOptional}', keyboard: money),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: PulseText.caption.copyWith(color: c.coralInk)),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                if (_a != null) ...[
                  OutlineButtonPill(
                    label: l10n.actionArchive,
                    icon: LucideIcons.archive,
                    color: c.coralInk,
                    height: 56,
                    onPressed: _archive,
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: PrimaryButton(label: l10n.actionSave, height: 56, onPressed: _save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

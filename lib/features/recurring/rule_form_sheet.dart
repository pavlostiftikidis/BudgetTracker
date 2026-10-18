import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/core/theme/palette.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/utils/greek.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/category_chip.dart';
import 'package:pulse/core/widgets/pill_segmented_control.dart';
import 'package:pulse/core/widgets/sheets.dart';
import 'package:pulse/data/ids.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/features/accounts/account_display.dart';
import 'package:pulse/features/transactions/pickers.dart';

/// New recurring rule, or edit / delete [rule].
Future<void> showRuleForm(BuildContext context, {RecurringRule? rule}) =>
    showPulseSheet<void>(context, builder: (_) => _RuleForm(rule: rule));

class _RuleForm extends ConsumerStatefulWidget {
  const new({this.rule});

  final RecurringRule? rule;

  @override
  ConsumerState<_RuleForm> createState() => _RuleFormState();
}

class _RuleFormState extends ConsumerState<_RuleForm> {
  late final RecurringRule? _r = widget.rule;
  late final _title = TextEditingController(text: _r?.title ?? '');
  late TxnKind _kind = _r?.kind ?? TxnKind.expense;
  late Money _amount = _r?.amount ?? Money.zero;
  late String? _categoryId = _r?.categoryId;
  late String? _accountId = _r?.accountId;
  late Frequency _frequency = _r?.frequency ?? Frequency.monthly;
  late int _interval = (_r?.frequency == Frequency.everyNMonths ? _r!.interval : 3).clamp(2, 12);
  late DateTime _next = _r?.nextDueDate ?? addDays(dateOnly(ref.read(clockProvider).now()), 1);
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _save(List<Account> accounts, List<TxnCategory> categories) async {
    final l10n = context.l10n;
    final title = _title.text.trim();
    final accountId = _accountId ?? defaultAccountFor(_kind, accounts)?.id;
    final categoryId = categories.any((c) => c.id == _categoryId) ? _categoryId : categories.firstOrNull?.id;
    if (title.isEmpty) return setState(() => _error = l10n.validationNameRequired);
    if (validateAmount(_amount) != null) return setState(() => _error = l10n.validationAmountRequired);
    if (accountId == null) return setState(() => _error = l10n.validationAccountRequired);

    final now = ref.read(clockProvider).now();
    final next = dateOnly(_next);
    final rule =
        (_r ??
                RecurringRule(
                  id: newId(),
                  title: title,
                  kind: _kind,
                  amountCents: _amount.cents,
                  accountId: accountId,
                  frequency: _frequency,
                  startDate: next,
                  nextDueDate: next,
                  createdAt: now,
                  updatedAt: now,
                ))
            .copyWith(
              title: title,
              kind: _kind,
              amountCents: _amount.cents,
              accountId: accountId,
              categoryId: categoryId,
              frequency: _frequency,
              interval: _frequency == Frequency.everyNMonths ? _interval : 1,
              dayOfMonth: _frequency == Frequency.weekly ? null : next.day,
              weekday: _frequency == Frequency.weekly ? next.weekday : null,
              nextDueDate: next,
              updatedAt: now,
            );
    final repo = ref.read(recurringRepositoryProvider);
    await repo.save(rule);
    // A first date of today (or earlier) becomes a transaction right away.
    await repo.materializeDue();
    await HapticFeedback.lightImpact();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    await ref.read(recurringRepositoryProvider).delete(_r!.id);
    await HapticFeedback.mediumImpact();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
    final categories = (ref.watch(categoriesProvider).value ?? const <TxnCategory>[])
        .where((x) => x.kind == (_kind == TxnKind.income ? CategoryKind.income : CategoryKind.expense))
        .toList();
    final selectedCategory = categories.any((x) => x.id == _categoryId) ? _categoryId : categories.firstOrNull?.id;
    final account = accounts.where((a) => a.id == (_accountId ?? defaultAccountFor(_kind, accounts)?.id)).firstOrNull;

    Widget label(String text) => Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Text(
        text,
        style: PulseText.caption.copyWith(fontWeight: FontWeight.w700, color: c.muted),
      ),
    );

    Widget row(String title, String value, VoidCallback onTap) => Semantics(
      container: true,
      button: true,
      label: '$title: $value',
      excludeSemantics: true,
      child: Material(
        color: c.surface2,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: PulseText.label.copyWith(fontWeight: FontWeight.w500, color: c.muted),
                    ),
                  ),
                  Text(value, style: PulseText.title),
                  const SizedBox(width: 6),
                  Icon(LucideIcons.chevronRight, size: 18, color: c.muted),
                ],
              ),
            ),
          ),
        ),
      ),
    );

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
                _r == null ? l10n.recurringNew : l10n.recurringEdit,
                style: PulseText.screenTitle.copyWith(fontSize: 22),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _title,
              maxLength: 60,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l10n.fieldName, counterText: ''),
            ),
            const SizedBox(height: 12),
            PillSegmentedControl<TxnKind>(
              semanticLabel: l10n.addTypeGroup,
              selected: _kind,
              onChanged: (k) => setState(() {
                _kind = k;
                _categoryId = null;
              }),
              segments: [
                Segment(value: TxnKind.expense, label: l10n.addExpense),
                Segment(value: TxnKind.income, label: l10n.addIncome),
              ],
            ),
            const SizedBox(height: 12),
            row(l10n.fieldAmount, _amount.format(), () async {
              final m = await editAmount(context, _amount);
              if (m != null) setState(() => _amount = m);
            }),
            const SizedBox(height: 8),
            row(l10n.pickAccount, account?.name ?? '—', () async {
              final id = await pickAccount(context, selected: account?.id);
              if (id != null) setState(() => _accountId = id);
            }),
            if (categories.isNotEmpty) ...[
              label(l10n.pickCategory),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final cat in categories)
                    CategoryChip(
                      label: cat.name,
                      color: cat.colorKey,
                      selected: cat.id == selectedCategory,
                      onTap: () => setState(() => _categoryId = cat.id),
                    ),
                ],
              ),
            ],
            label(l10n.fieldFrequency),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (f, text) in [
                  (Frequency.monthly, l10n.freqOptionMonthly),
                  (Frequency.everyNMonths, l10n.freqOptionEveryN),
                  (Frequency.weekly, l10n.freqOptionWeekly),
                  (Frequency.yearly, l10n.freqOptionYearly),
                ])
                  CategoryChip(
                    label: text,
                    color: _frequency == f
                        ? (categories.where((x) => x.id == selectedCategory).firstOrNull?.colorKey ?? ColorKey.lime)
                        : ColorKey.grey,
                    selected: _frequency == f,
                    onTap: () => setState(() => _frequency = f),
                  ),
              ],
            ),
            if (_frequency == Frequency.everyNMonths) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.fieldIntervalMonths,
                      style: PulseText.label.copyWith(fontWeight: FontWeight.w500, color: c.muted),
                    ),
                  ),
                  CircleIconButton(
                    icon: LucideIcons.minus,
                    semanticLabel: '−',
                    onPressed: _interval > 2 ? () => setState(() => _interval--) : null,
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '$_interval',
                      textAlign: TextAlign.center,
                      style: PulseText.amountXL.copyWith(fontSize: 20),
                    ),
                  ),
                  CircleIconButton(
                    icon: LucideIcons.plus,
                    semanticLabel: '+',
                    onPressed: _interval < 12 ? () => setState(() => _interval++) : null,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            row(l10n.fieldFirstDue, '${weekdayShort(_next)} ${dayMonthShort(_next)} ${_next.year}', () async {
              final d = await pickDateTime(context, _next, withTime: false);
              if (d != null) setState(() => _next = dateOnly(d));
            }),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: PulseText.caption.copyWith(color: c.coralInk)),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                if (_r != null) ...[
                  Semantics(
                    button: true,
                    label: l10n.recurringDelete,
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
                    label: l10n.actionSave,
                    height: 58,
                    onPressed: () => _save(accounts, categories),
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

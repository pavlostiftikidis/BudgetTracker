import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/core/money/amount_input.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/category_chip.dart';
import 'package:pulse/core/widgets/money_keypad.dart';
import 'package:pulse/core/widgets/sheets.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';

/// Lists the active accounts with their balances; returns the chosen id.
Future<String?> pickAccount(BuildContext context, {String? selected, String? exclude}) {
  return showPulseSheet<String>(
    context,
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final c = context.colors;
        final accounts = ref.watch(accountsProvider).value ?? const <Account>[];
        final balances = ref.watch(balancesProvider).value ?? const <String, Money>{};
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SheetHeader(title: context.l10n.pickAccount),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final a in accounts.where((a) => a.id != exclude))
                      PickerRow(
                        title: a.name,
                        selected: a.id == selected,
                        leading: ColorDot(color: c.tint(a.colorKey).ink, size: 12),
                        trailingText: (balances[a.id] ?? a.openingBalance).format(),
                        trailingColor: (balances[a.id]?.isNegative ?? false) ? c.coralInk : null,
                        onTap: () => Navigator.pop(context, a.id),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    ),
  );
}

/// Category chips for [kind]; returns the chosen id.
Future<String?> pickCategory(BuildContext context, {required CategoryKind kind, String? selected}) {
  return showPulseSheet<String>(
    context,
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final cats = (ref.watch(categoriesProvider).value ?? const <TxnCategory>[]).where((c) => c.kind == kind);
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SheetHeader(title: context.l10n.pickCategory),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final cat in cats)
                        CategoryChip(
                          label: cat.name,
                          color: cat.colorKey,
                          selected: cat.id == selected,
                          onTap: () => Navigator.pop(context, cat.id),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

/// Date then time; keeps [initial]'s time when the time picker is dismissed.
Future<DateTime?> pickDateTime(BuildContext context, DateTime initial, {bool withTime = true}) async {
  final now = DateTime.now();
  final date = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2000),
    lastDate: DateTime(now.year + 1, 12, 31),
  );
  if (date == null || !context.mounted) return null;
  if (!withTime) return DateTime(date.year, date.month, date.day, initial.hour, initial.minute);
  final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(initial));
  final t = time ?? TimeOfDay.fromDateTime(initial);
  return DateTime(date.year, date.month, date.day, t.hour, t.minute);
}

/// Free-text note; returns null when dismissed, '' when cleared.
Future<String?> editNote(BuildContext context, String initial) {
  final controller = TextEditingController(text: initial);
  return showPulseSheet<String>(
    context,
    builder: (context) => SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetHeader(title: context.l10n.addNote),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: controller,
                autofocus: true,
                maxLength: 120,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(hintText: context.l10n.addNoteHint, counterText: ''),
                onSubmitted: (v) => Navigator.pop(context, v),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PrimaryButton(
                label: context.l10n.actionDone,
                height: 54,
                onPressed: () => Navigator.pop(context, controller.text),
              ),
            ),
          ],
        ),
      ),
    ),
  ).whenComplete(controller.dispose);
}

/// Keypad sheet for changing an existing amount.
Future<Money?> editAmount(BuildContext context, Money initial) {
  return showPulseSheet<Money>(context, builder: (context) => _AmountSheet(initial: initial));
}

class _AmountSheet extends StatefulWidget {
  const new({required this.initial});

  final Money initial;

  @override
  State<_AmountSheet> createState() => _AmountSheetState();
}

class _AmountSheetState extends State<_AmountSheet> {
  late AmountInput _input = AmountInput.fromMoney(widget.initial);

  @override
  Widget build(BuildContext context) {
    final valid = validateAmount(_input.value) == null;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              liveRegion: true,
              label: context.l10n.amountSemantics(_input.value.format()),
              excludeSemantics: true,
              child: FittedBox(child: Text('€${_input.display}', style: PulseText.amountXL.copyWith(fontSize: 48))),
            ),
            const SizedBox(height: 16),
            MoneyKeypad(value: _input, keyHeight: 52, onChanged: (v) => setState(() => _input = v)),
            const SizedBox(height: 12),
            PrimaryButton(
              label: context.l10n.actionDone,
              height: 56,
              onPressed: valid ? () => Navigator.pop(context, _input.value) : null,
            ),
          ],
        ),
      ),
    );
  }
}

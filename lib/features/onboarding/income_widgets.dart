import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/utils/greek.dart';
import 'package:pulse/core/widgets/sheets.dart';

/// Digits only, grouped as you type: "2150" → "2.150". Whole euros.
class GroupedEurosFormatter extends TextInputFormatter {
  static const maxDigits = 6;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > maxDigits) digits = digits.substring(0, maxDigits);
    digits = digits.replaceFirst(RegExp(r'^0+(?=\d)'), '');
    final text = digits.isEmpty ? '' : Money(int.parse(digits) * 100).formatPlain(showCents: false);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

Money parseGroupedEuros(String text) {
  final digits = text.replaceAll(RegExp(r'\D'), '');
  return digits.isEmpty ? Money.zero : Money(int.parse(digits) * 100);
}

/// Big "€ 2.150" income input with a lime caret colour.
class IncomeField extends StatelessWidget {
  const new({required this.controller, required this.onChanged, super.key});

  final TextEditingController controller;
  final ValueChanged<Money> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [GroupedEurosFormatter()],
      cursorColor: c.accent,
      cursorWidth: 3,
      onChanged: (v) => onChanged(parseGroupedEuros(v)),
      style: PulseText.hero.copyWith(fontSize: 56, letterSpacing: -2.8),
      decoration: InputDecoration(
        filled: false,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: '0',
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 6, top: 14),
          child: Text('€', style: PulseText.heroDecimals.copyWith(fontSize: 30, color: c.muted)),
        ),
        prefixIconConstraints: const BoxConstraints(),
      ),
    );
  }
}

/// "1η του μήνα / 15η / Τέλος μήνα / Άλλη" chips. "Άλλη" asks for a day.
class PaydayPicker extends StatelessWidget {
  const new({required this.value, required this.onChanged, super.key});

  final Payday value;
  final ValueChanged<Payday> onChanged;

  Future<void> _pickCustom(BuildContext context) async {
    final day = await showPulseSheet<int>(
      context,
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.l10n.paydayGroup, style: PulseText.screenTitle.copyWith(fontSize: 22)),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                children: [
                  for (var d = 1; d <= 31; d++)
                    Material(
                      color: value.kind == PaydayKind.custom && value.customDay == d
                          ? context.colors.accent
                          : context.colors.surface2,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.pop(context, d),
                        child: Center(
                          child: Text(
                            '$d',
                            style: PulseText.title.copyWith(
                              color: value.kind == PaydayKind.custom && value.customDay == d
                                  ? context.colors.onAccent
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (day != null) onChanged(Payday(PaydayKind.custom, day));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final options = [
      (PaydayKind.first, l10n.paydayFirst),
      (PaydayKind.fifteenth, l10n.paydayFifteenth),
      (PaydayKind.last, l10n.paydayLast),
      (
        PaydayKind.custom,
        value.kind == PaydayKind.custom ? l10n.paydayCustomValue(dayOrdinal(value.customDay)) : l10n.paydayOther,
      ),
    ];
    return Semantics(
      container: true,
      label: l10n.paydayGroup,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final (kind, text) in options)
            Semantics(
              button: true,
              selected: value.kind == kind,
              inMutuallyExclusiveGroup: true,
              child: Material(
                color: value.kind == kind ? c.text : Colors.transparent,
                shape: StadiumBorder(side: BorderSide(color: value.kind == kind ? c.text : c.line, width: 1.5)),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: () => kind == PaydayKind.custom ? _pickCustom(context) : onChanged(Payday(kind)),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 44),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Text(text, style: PulseText.label.copyWith(color: value.kind == kind ? c.bg : c.text)),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

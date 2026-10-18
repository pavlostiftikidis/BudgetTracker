import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/money/amount_input.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';

/// 3×4 keypad: 1–9, ",", 0, backspace. The rules (two decimals, five
/// integer digits, one comma) live in [AmountInput]; this widget only
/// forwards keys. Long-press on backspace clears.
class MoneyKeypad extends StatelessWidget {
  const new({required this.value, required this.onChanged, this.keyHeight = 60, this.gap = 6, super.key});

  final AmountInput value;
  final ValueChanged<AmountInput> onChanged;
  final double keyHeight;
  final double gap;

  static const _layout = <KeypadKey>[
    DigitKey(1),
    DigitKey(2),
    DigitKey(3),
    DigitKey(4),
    DigitKey(5),
    DigitKey(6),
    DigitKey(7),
    DigitKey(8),
    DigitKey(9),
    CommaKey(),
    DigitKey(0),
    BackspaceKey(),
  ];

  void _press(KeypadKey key) {
    final next = value.press(key);
    if (next != value) {
      unawaited(HapticFeedback.selectionClick());
      onChanged(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var row = 0; row < 4; row++) ...[
          if (row > 0) SizedBox(height: gap),
          Row(
            children: [
              for (var col = 0; col < 3; col++) ...[
                if (col > 0) SizedBox(width: gap),
                Expanded(
                  child: _Key(
                    keyValue: _layout[row * 3 + col],
                    height: keyHeight,
                    semanticLabel: switch (_layout[row * 3 + col]) {
                      DigitKey(:final digit) => '$digit',
                      CommaKey() => l10n.keypadComma,
                      BackspaceKey() => l10n.keypadDelete,
                    },
                    onTap: _press,
                    onLongPress: _layout[row * 3 + col] is BackspaceKey ? () => onChanged(const AmountInput()) : null,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _Key extends StatelessWidget {
  const new({
    required this.keyValue,
    required this.height,
    required this.semanticLabel,
    required this.onTap,
    this.onLongPress,
  });

  final KeypadKey keyValue;
  final double height;
  final String semanticLabel;
  final ValueChanged<KeypadKey> onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final label = switch (keyValue) {
      DigitKey(:final digit) => '$digit',
      CommaKey() => Money.decimalSeparator,
      BackspaceKey() => null,
    };
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          key: ValueKey('key-$semanticLabel'),
          borderRadius: BorderRadius.circular(18),
          onTap: () => onTap(keyValue),
          onLongPress: onLongPress,
          child: SizedBox(
            height: height,
            child: Center(
              child: label == null
                  ? Icon(LucideIcons.delete, size: 24, color: c.text)
                  : Text(
                      label,
                      style: PulseText.amountXL.copyWith(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: 0),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

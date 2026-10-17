import 'package:meta/meta.dart';
import 'package:pulse/core/money/money.dart';

/// A key on the money keypad.
sealed class KeypadKey {
  const new();
}

final class DigitKey extends KeypadKey {
  const new(this.digit) : assert(digit >= 0 && digit <= 9, 'single digit');
  final int digit;
}

final class CommaKey extends KeypadKey {
  const new();
}

final class BackspaceKey extends KeypadKey {
  const new();
}

/// Text typed on the keypad, e.g. "18,5". Enforces at most five integer
/// digits (≤ 99.999) and two decimals, one comma and no leading zeros.
@immutable
final class AmountInput {
  const new([this.text = '']);

  /// Pre-fills the keypad from an existing amount ("45,00" → "45").
  factory fromMoney(Money m) {
    if (m.cents <= 0) return const AmountInput();
    final euros = m.cents ~/ 100;
    final c = m.cents % 100;
    if (c == 0) return AmountInput('$euros');
    final dec = c % 10 == 0 ? '${c ~/ 10}' : c.toString().padLeft(2, '0');
    return AmountInput('$euros,$dec');
  }

  static const maxIntegerDigits = 5;
  static const maxDecimals = 2;

  final String text;

  bool get isEmpty => text.isEmpty;

  /// Shown on screen: "0" when nothing typed yet, grouped integer part
  /// ("1.250,5").
  String get display {
    if (text.isEmpty) return '0';
    final parts = text.split(',');
    final whole = Money(int.parse(parts[0].isEmpty ? '0' : parts[0]) * 100).formatPlain(showCents: false);
    return parts.length == 2 ? '$whole,${parts[1]}' : whole;
  }

  Money get value => Money.tryParse(text.isEmpty ? '0' : text) ?? Money.zero;

  AmountInput press(KeypadKey key) {
    final hasComma = text.contains(',');
    switch (key) {
      case BackspaceKey():
        return text.isEmpty ? this : AmountInput(text.substring(0, text.length - 1));
      case CommaKey():
        if (hasComma) return this;
        return AmountInput(text.isEmpty ? '0,' : '$text,');
      case DigitKey(:final digit):
        if (hasComma) {
          final decimals = text.length - text.indexOf(',') - 1;
          if (decimals >= maxDecimals) return this;
          return AmountInput('$text$digit');
        }
        if (text == '0') return digit == 0 ? this : AmountInput('$digit');
        if (text.isEmpty && digit == 0) return const AmountInput('0');
        if (text.length >= maxIntegerDigits) return this;
        return AmountInput('$text$digit');
    }
  }

  @override
  bool operator ==(Object other) => other is AmountInput && other.text == text;

  @override
  int get hashCode => text.hashCode;
}

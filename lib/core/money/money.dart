import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

/// True minus sign (U+2212), used for every negative amount on screen.
const String kMinus = '−';

/// An amount in euro cents. Amounts are integers end to end; a `double`
/// never touches money.
@immutable
final class Money implements Comparable<Money> {
  const new(this.cents);

  static const zero = Money(0);

  /// Largest amount a single transaction may carry: €99.999,99.
  static const max = Money(9999999);

  final int cents;

  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'el_GR',
    symbol: '€',
    customPattern: '¤#,##0',
    decimalDigits: 0,
  );
  static final NumberFormat _grouped = NumberFormat.decimalPattern('el_GR');

  /// "," in el_GR.
  static String get decimalSeparator => _currency.symbols.DECIMAL_SEP;

  bool get isZero => cents == 0;
  bool get isNegative => cents < 0;
  bool get isPositive => cents > 0;

  Money operator +(Money other) => Money(cents + other.cents);
  Money operator -(Money other) => Money(cents - other.cents);
  Money operator -() => Money(-cents);
  Money operator *(int factor) => Money(cents * factor);
  bool operator <(Money other) => cents < other.cents;
  bool operator <=(Money other) => cents <= other.cents;
  bool operator >(Money other) => cents > other.cents;
  bool operator >=(Money other) => cents >= other.cents;

  Money abs() => Money(cents.abs());

  /// Integer division rounded down (towards −∞), e.g. for a daily allowance.
  Money divideFloor(int divisor) {
    assert(divisor > 0, 'divisor must be positive');
    if (cents >= 0) return Money(cents ~/ divisor);
    return Money(-((-cents + divisor - 1) ~/ divisor));
  }

  /// Whole euros rounded half away from zero.
  int get roundedEuros {
    final r = (cents.abs() + 50) ~/ 100;
    return cents < 0 ? -r : r;
  }

  /// "€1.057,70"; negatives as "−€1.057,70". With [showCents] false the
  /// amount is rounded to whole euros: "€1.058".
  String format({bool showCents = true}) {
    final sign = cents < 0 ? kMinus : '';
    if (!showCents) {
      return '$sign${_currency.format(roundedEuros.abs())}';
    }
    final abs = cents.abs();
    return '$sign${_currency.format(abs ~/ 100)}$decimalSeparator${_two(abs % 100)}';
  }

  /// Always carries a sign: "+€2.150,00", "−€42,80"; zero has none.
  String formatSigned({bool showCents = true}) {
    if (cents > 0) return '+${format(showCents: showCents)}';
    return format(showCents: showCents);
  }

  /// Pieces for a hero number "742,30 €": whole part (with sign, grouped),
  /// decimals including the separator, and the currency symbol.
  ({String whole, String decimals, String symbol}) get heroParts {
    final abs = cents.abs();
    final sign = cents < 0 ? kMinus : '';
    return (
      whole: '$sign${_grouped.format(abs ~/ 100)}',
      decimals: '$decimalSeparator${_two(abs % 100)}',
      symbol: '€',
    );
  }

  /// Plain number without symbol: "1.057,70" (or "1.058" without cents).
  String formatPlain({bool showCents = true}) {
    final sign = cents < 0 ? kMinus : '';
    if (!showCents) return '$sign${_grouped.format(roundedEuros.abs())}';
    final abs = cents.abs();
    return '$sign${_grouped.format(abs ~/ 100)}$decimalSeparator${_two(abs % 100)}';
  }

  /// Parses user input in el_GR notation: "1.057,70", "18,5", "18,", "42",
  /// "€42,80", "−3,60". Returns null for anything with more than two decimals
  /// or that is not a number at all.
  static Money? tryParse(String input) {
    var s = input.trim().replaceAll('€', '').replaceAll(RegExp(r'[\s  ]'), '');
    if (s.isEmpty) return null;
    var negative = false;
    if (s.startsWith('-') || s.startsWith(kMinus)) {
      negative = true;
      s = s.substring(1);
    } else if (s.startsWith('+')) {
      s = s.substring(1);
    }
    final parts = s.split(decimalSeparator);
    if (parts.length > 2) return null;
    final whole = parts.first;
    if (!RegExp(r'^\d{1,3}(\.\d{3})*$|^\d*$').hasMatch(whole)) return null;
    final digits = whole.replaceAll('.', '');
    final frac = parts.length == 2 ? parts[1] : '';
    if (!RegExp(r'^\d{0,2}$').hasMatch(frac)) return null;
    if (digits.isEmpty && frac.isEmpty) return null;
    if (digits.length > 9) return null;
    final euros = digits.isEmpty ? 0 : int.parse(digits);
    final c = euros * 100 + (frac.isEmpty ? 0 : int.parse(frac.padRight(2, '0')));
    return Money(negative ? -c : c);
  }

  @override
  int compareTo(Money other) => cents.compareTo(other.cents);

  @override
  bool operator ==(Object other) => other is Money && other.cents == cents;

  @override
  int get hashCode => cents.hashCode;

  @override
  String toString() => 'Money($cents)';

  static String _two(int n) => n.toString().padLeft(2, '0');
}

/// Integer division rounded half away from zero, for cents.
int divRound(int numerator, int denominator) {
  assert(denominator > 0, 'denominator must be positive');
  final q = (numerator.abs() * 2 + denominator) ~/ (2 * denominator);
  return numerator < 0 ? -q : q;
}

extension MoneySum on Iterable<Money> {
  Money sum() => fold(Money.zero, (a, b) => a + b);
}

/// Validation result for a transaction amount.
enum AmountError { required, tooLarge }

/// Amount must be > 0 and ≤ €99.999,99 (two decimals is guaranteed by [Money]).
AmountError? validateAmount(Money? amount) {
  if (amount == null || amount.cents <= 0) return AmountError.required;
  if (amount > Money.max) return AmountError.tooLarge;
  return null;
}

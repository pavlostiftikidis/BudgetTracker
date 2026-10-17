import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/money/money.dart';

void main() {
  group('Money.format', () {
    test('el_GR grouping and decimals with the symbol first', () {
      expect(const Money(105770).format(), '€1.057,70');
      expect(const Money(4280).format(), '€42,80');
      expect(const Money(5).format(), '€0,05');
      expect(Money.zero.format(), '€0,00');
      expect(Money.max.format(), '€99.999,99');
      expect(const Money(123456789).format(), '€1.234.567,89');
    });

    test('negatives use the true minus sign U+2212', () {
      expect(const Money(-4280).format(), '−€42,80');
      expect(const Money(-4280).format(), isNot(contains('-')));
    });

    test('signed variants', () {
      expect(const Money(215000).formatSigned(), '+€2.150,00');
      expect(const Money(-360).formatSigned(), '−€3,60');
      expect(Money.zero.formatSigned(), '€0,00');
    });

    test('whole euros round half away from zero', () {
      expect(const Money(5302).format(showCents: false), '€53');
      expect(const Money(5350).format(showCents: false), '€54');
      expect(const Money(109249).format(showCents: false), '€1.092');
      expect(const Money(-5350).format(showCents: false), '−€54');
    });

    test('hero parts', () {
      final p = const Money(74230).heroParts;
      expect(p.whole, '742');
      expect(p.decimals, ',30');
      expect(p.symbol, '€');
      expect(const Money(105770).heroParts.whole, '1.057');
      expect(const Money(-5820).heroParts.whole, '−58');
    });
  });

  group('Money.tryParse', () {
    test('accepts el_GR input', () {
      expect(Money.tryParse('1.057,70'), const Money(105770));
      expect(Money.tryParse('18,5'), const Money(1850));
      expect(Money.tryParse('18,'), const Money(1800));
      expect(Money.tryParse('42'), const Money(4200));
      expect(Money.tryParse(',5'), const Money(50));
      expect(Money.tryParse('€42,80'), const Money(4280));
      expect(Money.tryParse(' 2.150,00 € '), const Money(215000));
      expect(Money.tryParse('−3,60'), const Money(-360));
      expect(Money.tryParse('-3,60'), const Money(-360));
    });

    test('rejects malformed input and more than two decimals', () {
      expect(Money.tryParse(''), isNull);
      expect(Money.tryParse('abc'), isNull);
      expect(Money.tryParse('1,234'), isNull);
      expect(Money.tryParse('1,2,3'), isNull);
      expect(Money.tryParse('12.34'), isNull, reason: '"." is the grouping separator');
      expect(Money.tryParse(','), isNull);
    });

    test('round-trips through format', () {
      for (final c in [0, 1, 99, 100, 4280, 105770, 9999999]) {
        expect(Money.tryParse(Money(c).format()), Money(c));
      }
    });
  });

  group('validateAmount', () {
    test('amount must be positive and at most €99.999,99', () {
      expect(validateAmount(null), AmountError.required);
      expect(validateAmount(Money.zero), AmountError.required);
      expect(validateAmount(const Money(-1)), AmountError.required);
      expect(validateAmount(const Money(1)), isNull);
      expect(validateAmount(Money.max), isNull);
      expect(validateAmount(const Money(10000000)), AmountError.tooLarge);
    });
  });

  group('integer arithmetic', () {
    test('divideFloor rounds towards −∞', () {
      expect(const Money(74230).divideFloor(14), const Money(5302));
      expect(const Money(-7).divideFloor(2), const Money(-4));
      expect(const Money(7).divideFloor(2), const Money(3));
    });

    test('divRound rounds half away from zero', () {
      expect(divRound(18600, 6), 3100);
      expect(divRound(1399 * 52, 12), 6062);
      expect(divRound(5, 2), 3);
      expect(divRound(-5, 2), -3);
    });

    test('operators and sum', () {
      expect(const Money(100) + const Money(50), const Money(150));
      expect(const Money(100) - const Money(150), const Money(-50));
      expect(-const Money(100), const Money(-100));
      expect([const Money(1), const Money(2), const Money(3)].sum(), const Money(6));
      expect(const Money(1) < const Money(2), isTrue);
    });
  });
}

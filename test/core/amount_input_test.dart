import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/money/amount_input.dart';
import 'package:pulse/core/money/money.dart';

AmountInput type(String keys, [AmountInput start = const AmountInput()]) {
  var input = start;
  for (final ch in keys.split('')) {
    input = input.press(switch (ch) {
      ',' => const CommaKey(),
      '<' => const BackspaceKey(),
      _ => DigitKey(int.parse(ch)),
    });
  }
  return input;
}

void main() {
  test('digits and comma build an amount', () {
    expect(type('18,5').text, '18,5');
    expect(type('18,5').value, const Money(1850));
    expect(type('42').value, const Money(4200));
  });

  test('at most two decimals', () {
    expect(type('3,605').text, '3,60');
    expect(type('3,605').value, const Money(360));
  });

  test('one comma only', () {
    expect(type('1,,2').text, '1,2');
  });

  test('leading comma becomes 0,', () {
    expect(type(',5').text, '0,5');
    expect(type(',5').value, const Money(50));
  });

  test('no leading zeros', () {
    expect(type('007').text, '7');
    expect(type('0').text, '0');
    expect(type('0,05').value, const Money(5));
  });

  test('at most five integer digits (€99.999)', () {
    expect(type('1234567').text, '12345');
    expect(type('99999,99').value, Money.max);
  });

  test('backspace removes the last character', () {
    expect(type('18,5<').text, '18,');
    expect(type('18,5<<').text, '18');
    expect(type('1<<<').text, '');
  });

  test('display groups thousands and shows 0 when empty', () {
    expect(const AmountInput().display, '0');
    expect(type('12500').display, '12.500');
    expect(type('1250,5').display, '1.250,5');
  });

  test('fromMoney pre-fills the keypad', () {
    expect(AmountInput.fromMoney(const Money(4500)).text, '45');
    expect(AmountInput.fromMoney(const Money(4550)).text, '45,5');
    expect(AmountInput.fromMoney(const Money(4505)).text, '45,05');
    expect(AmountInput.fromMoney(Money.zero).text, '');
  });
}

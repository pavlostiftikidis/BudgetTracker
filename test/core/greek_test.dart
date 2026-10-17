import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/app/bootstrap.dart';
import 'package:pulse/core/utils/greek.dart';

void main() {
  setUpAll(initLocale);

  test('greekUpper drops accents and keeps diaeresis', () {
    expect(greekUpper('Οκτωβρίου'), 'ΟΚΤΩΒΡΙΟΥ');
    expect(greekUpper('Μάι'), 'ΜΑΪ');
    expect(greekUpper('Ιούν'), 'ΙΟΥΝ');
    expect(greekUpper('Αύγ'), 'ΑΥΓ');
    expect(greekUpper('Σάβ'), 'ΣΑΒ');
    expect(greekUpper('νέο έξοδο'), 'ΝΕΟ ΕΞΟΔΟ');
    expect(greekUpper('κοροϊδεύω'), 'ΚΟΡΟΪΔΕΥΩ');
  });

  test('month forms', () {
    final oct = DateTime(2026, 10);
    expect(monthName(oct), 'Οκτώβριος');
    expect(monthGenitive(oct), 'Οκτωβρίου');
    expect(monthAccusative(oct), 'Οκτώβριο');
    expect(monthAccusative(DateTime(2026, 5)), 'Μάιο');
  });

  test('day ordinals', () {
    expect(dayOrdinal(1), '1η');
    expect(dayOrdinal(14), '14η');
    expect(dayOrdinal(20), '20ή');
    expect(dayOrdinal(22), '22η');
    expect(dayOrdinal(30), '30ή');
  });

  test('weekday forms', () {
    final fri = DateTime(2026, 10, 16);
    expect(weekdayName(fri), 'Παρασκευή');
    expect(greekUpper(weekdayShort(DateTime(2026, 10, 17))), 'ΣΑΒ');
    expect(weekdayNarrow(fri), 'Π');
  });

  test('short dates', () {
    expect(dayMonthShort(DateTime(2026, 11, 5)), '5 Νοε');
    expect(timeOfDay(DateTime(2026, 10, 18, 9, 12)), '09:12');
  });
}

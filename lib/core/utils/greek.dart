import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';

const String kLocale = 'el';

const Map<String, String> _stripTonos = {
  'ά': 'α',
  'έ': 'ε',
  'ή': 'η',
  'ί': 'ι',
  'ό': 'ο',
  'ύ': 'υ',
  'ώ': 'ω',
  'ΐ': 'ϊ',
  'ΰ': 'ϋ',
  'Ά': 'Α',
  'Έ': 'Ε',
  'Ή': 'Η',
  'Ί': 'Ι',
  'Ό': 'Ο',
  'Ύ': 'Υ',
  'Ώ': 'Ω',
};

/// Uppercases Greek text the way Greek typography expects: accents are
/// dropped ("Οκτωβρίου" → "ΟΚΤΩΒΡΙΟΥ"), and a vowel that loses its accent
/// before ι/υ turns that letter into Ϊ/Ϋ so the pronunciation is kept
/// ("Μάι" → "ΜΑΪ").
String greekUpper(String input) {
  final out = StringBuffer();
  final chars = input.split('');
  for (var i = 0; i < chars.length; i++) {
    final ch = chars[i];
    final stripped = _stripTonos[ch];
    if (stripped != null && i + 1 < chars.length && 'άέόύ'.contains(ch)) {
      final next = chars[i + 1];
      if (next == 'ι' || next == 'υ') {
        out
          ..write(stripped.toUpperCase())
          ..write(next == 'ι' ? 'Ϊ' : 'Ϋ');
        i++;
        continue;
      }
    }
    out.write((stripped ?? ch).toUpperCase());
  }
  return out.toString();
}

/// Locale symbols, read directly: some date patterns ("LLLL") are treated as
/// skeletons by intl and come back in the genitive.
DateSymbols get _symbols => DateFormat(null, kLocale).dateSymbols;

/// Index into intl's weekday arrays, which start on Sunday.
int _weekdayIndex(DateTime d) => d.weekday % 7;

/// "Οκτώβριος" (standalone, nominative).
String monthName(DateTime d) => _symbols.STANDALONEMONTHS[d.month - 1];

/// "Οκτωβρίου" (genitive, as used in "ΕΞΟΔΑ ΟΚΤΩΒΡΙΟΥ").
String monthGenitive(DateTime d) => _symbols.MONTHS[d.month - 1];

/// "Οκτώβριο" (accusative, as in "από τον Οκτώβριο"). Every Greek month name
/// is masculine in -ος, so the accusative drops the final ς.
String monthAccusative(DateTime d) {
  final n = monthName(d);
  return n.endsWith('ς') ? n.substring(0, n.length - 1) : n;
}

/// "Σεπ" (short standalone).
String monthShort(DateTime d) => _symbols.STANDALONESHORTMONTHS[d.month - 1];

/// Feminine ordinal for a day of the month: "1η", "15η", "20ή", "30ή".
/// The accent follows the stress of the spoken word (εικοστή, τριακοστή).
String dayOrdinal(int day) => day == 20 || day == 30 ? '$dayή' : '$dayη';

/// "Παρασκευή".
String weekdayName(DateTime d) => _symbols.STANDALONEWEEKDAYS[_weekdayIndex(d)];

/// Name of an ISO weekday (1 = Δευτέρα … 7 = Κυριακή).
String weekdayNameOf(int isoWeekday) => weekdayName(DateTime(2024, 1, isoWeekday));

/// "τη Δευτέρα", "την Παρασκευή", "το Σάββατο" — the accusative with its
/// article, as in "γίνονται την Παρασκευή". The final ν of "την" stays before
/// vowels and κ, π, τ (and their clusters), per standard spelling.
String weekdayWithArticle(int isoWeekday) => const [
  'τη Δευτέρα',
  'την Τρίτη',
  'την Τετάρτη',
  'την Πέμπτη',
  'την Παρασκευή',
  'το Σάββατο',
  'την Κυριακή',
][isoWeekday - 1];

/// "Παρ" → shown upper-cased in strips ("ΠΑΡ").
String weekdayShort(DateTime d) => _symbols.STANDALONESHORTWEEKDAYS[_weekdayIndex(d)];

/// "Π" — single-letter weekday for bar charts.
String weekdayNarrow(DateTime d) => _symbols.STANDALONENARROWWEEKDAYS[_weekdayIndex(d)];

/// "5 Νοε".
String dayMonthShort(DateTime d) => '${d.day} ${greekTitleCaseShortMonth(monthShortGenitive(d))}';

/// Genitive abbreviation ("Νοε").
String monthShortGenitive(DateTime d) => _symbols.SHORTMONTHS[d.month - 1];

String greekTitleCaseShortMonth(String s) => s.replaceAll('.', '');

/// "Παρ 16 Οκτ, 19:05".
String dateTimeShort(DateTime d) => '${weekdayShort(d)} ${dayMonthShort(d)}, ${DateFormat('HH:mm', kLocale).format(d)}';

/// "Τετ, 14 Οκτ".
String dayHeader(DateTime d) => '${weekdayShort(d)}, ${dayMonthShort(d)}';

/// "18:40".
String timeOfDay(DateTime d) => DateFormat('HH:mm', kLocale).format(d);

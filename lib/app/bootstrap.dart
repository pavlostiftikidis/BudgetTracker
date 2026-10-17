import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pulse/core/utils/greek.dart';

/// Locale data and licences shared by `main` and tests.
Future<void> initLocale() async {
  await initializeDateFormatting(kLocale);
  Intl.defaultLocale = 'el_GR';
}

void registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (family, file) in [
      ('Manrope', 'assets/fonts/OFL-Manrope.txt'),
      ('JetBrains Mono', 'assets/fonts/OFL-JetBrainsMono.txt'),
    ]) {
      yield LicenseEntryWithLineBreaks([family], await rootBundle.loadString(file));
    }
  });
}

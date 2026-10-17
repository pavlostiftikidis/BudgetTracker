import 'package:flutter/painting.dart';

abstract final class PulseFonts {
  static const sans = 'Manrope';
  static const mono = 'JetBrainsMono';
}

const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

/// Type scale. Styles carry no colour so they inherit from the theme;
/// add one with `copyWith(color: ...)` where needed. Letter spacing is in
/// logical pixels (em × font size).
abstract final class PulseText {
  static const hero = TextStyle(
    fontFamily: PulseFonts.sans,
    fontSize: 88,
    fontWeight: FontWeight.w800,
    letterSpacing: -5.3,
    height: 0.95,
    fontFeatures: _tabular,
  );

  static const heroDecimals = TextStyle(
    fontFamily: PulseFonts.sans,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.96,
    fontFeatures: _tabular,
  );

  static const screenTitle = TextStyle(
    fontFamily: PulseFonts.sans,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.6,
    height: 1.15,
  );

  static const amountXL = TextStyle(
    fontFamily: PulseFonts.sans,
    fontSize: 30,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.2,
    height: 1.1,
    fontFeatures: _tabular,
  );

  static const sectionTitle = TextStyle(
    fontFamily: PulseFonts.sans,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.2,
  );

  static const title = TextStyle(
    fontFamily: PulseFonts.sans,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static const amount = TextStyle(
    fontFamily: PulseFonts.sans,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    fontFeatures: _tabular,
  );

  static const body = TextStyle(
    fontFamily: PulseFonts.sans,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.35,
  );

  static const label = TextStyle(
    fontFamily: PulseFonts.sans,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static const caption = TextStyle(
    fontFamily: PulseFonts.sans,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const small = TextStyle(
    fontFamily: PulseFonts.sans,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFeatures: _tabular,
  );

  /// Small uppercase labels such as "ΥΠΟΛΟΙΠΟ ΜΗΝΑ".
  static const mono = TextStyle(
    fontFamily: PulseFonts.mono,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.44,
    fontFeatures: _tabular,
  );

  static const List<FontFeature> tabular = _tabular;
}

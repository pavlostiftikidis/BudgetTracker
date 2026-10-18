import 'package:flutter/material.dart';
import 'package:pulse/core/theme/palette.dart';

/// Every colour the app paints with. Widgets read it through
/// `context.colors` and never hard-code a hex value.
@immutable
class PulseColors extends ThemeExtension<PulseColors> {
  const new({
    required this.brightness,
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.line,
    required this.text,
    required this.muted,
    required this.accent,
    required this.onAccent,
    required this.accentInk,
    required this.accentSoft,
    required this.coral,
    required this.coralInk,
    required this.coralSoft,
    required this.sky,
    required this.violet,
    required this.amber,
    required this.amberInk,
    required this.amberSoft,
    required this.nav,
    required this.rest,
    required this.shadow,
  });

  static const dark = PulseColors(
    brightness: Brightness.dark,
    bg: Color(0xFF0B0C0E),
    surface: Color(0xFF15171B),
    surface2: Color(0xFF1D2026),
    line: Color(0xFF262A31),
    text: Color(0xFFF2F3F5),
    muted: Color(0xFF9AA0AA),
    accent: Color(0xFFC6F36B),
    onAccent: Color(0xFF0B0C0E),
    accentInk: Color(0xFFC6F36B),
    accentSoft: Color(0x26C6F36B),
    coral: Color(0xFFFF7A59),
    coralInk: Color(0xFFFF7A59),
    coralSoft: Color(0x1FFF7A59),
    sky: Color(0xFF6CB8FF),
    violet: Color(0xFFB49CFF),
    amber: Color(0xFFFFC857),
    amberInk: Color(0xFFFFC857),
    amberSoft: Color(0x1FFFC857),
    nav: Color(0xF216181C),
    rest: Color(0xFF3A3F48),
    shadow: Color(0x59000000),
  );

  static const light = PulseColors(
    brightness: Brightness.light,
    bg: Color(0xFFF4F4F1),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFEEEEEA),
    line: Color(0xFFE3E3DE),
    text: Color(0xFF0E0F11),
    muted: Color(0xFF5D626B),
    accent: Color(0xFFC6F36B),
    onAccent: Color(0xFF0B0C0E),
    accentInk: Color(0xFF355A00),
    accentSoft: Color(0xFFE4F8BE),
    coral: Color(0xFFE2552F),
    coralInk: Color(0xFFB23C17),
    coralSoft: Color(0xFFFBE3DA),
    sky: Color(0xFF2F7FD6),
    violet: Color(0xFF7A5CE0),
    amber: Color(0xFFC98A0B),
    amberInk: Color(0xFF8A5A00),
    amberSoft: Color(0xFFFBEFD2),
    nav: Color(0xF2FFFFFF),
    rest: Color(0xFFC9CBC5),
    shadow: Color(0x14000000),
  );

  final Brightness brightness;
  final Color bg;
  final Color surface;
  final Color surface2;
  final Color line;
  final Color text;
  final Color muted;

  /// Lime. Always paired with [onAccent] text.
  final Color accent;
  final Color onAccent;

  /// Accent used as text on [bg]/[surface].
  final Color accentInk;
  final Color accentSoft;

  /// Coral for fills, borders and strokes; [coralInk] for text.
  final Color coral;
  final Color coralInk;
  final Color coralSoft;
  final Color sky;
  final Color violet;

  /// Amber for fills and strokes; [amberInk] for text.
  final Color amber;
  final Color amberInk;
  final Color amberSoft;

  /// Translucent background of the floating navigation pill.
  final Color nav;

  /// Neutral segment colour ("Άλλα", empty tracks).
  final Color rest;
  final Color shadow;

  bool get isDark => brightness == Brightness.dark;

  Tint tint(ColorKey key) {
    final bright = Palette.bright[key]!;
    if (isDark) {
      return Tint(fill: bright, ink: bright, soft: bright.withValues(alpha: 0.15));
    }
    return Tint(fill: bright, ink: Palette.lightInk[key]!, soft: bright.withValues(alpha: 0.35));
  }

  @override
  PulseColors copyWith({
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? line,
    Color? text,
    Color? muted,
    Color? accent,
    Color? onAccent,
    Color? accentInk,
    Color? accentSoft,
    Color? coral,
    Color? coralInk,
    Color? coralSoft,
    Color? sky,
    Color? violet,
    Color? amber,
    Color? amberInk,
    Color? amberSoft,
    Color? nav,
    Color? rest,
    Color? shadow,
  }) {
    return PulseColors(
      brightness: brightness,
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      line: line ?? this.line,
      text: text ?? this.text,
      muted: muted ?? this.muted,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentInk: accentInk ?? this.accentInk,
      accentSoft: accentSoft ?? this.accentSoft,
      coral: coral ?? this.coral,
      coralInk: coralInk ?? this.coralInk,
      coralSoft: coralSoft ?? this.coralSoft,
      sky: sky ?? this.sky,
      violet: violet ?? this.violet,
      amber: amber ?? this.amber,
      amberInk: amberInk ?? this.amberInk,
      amberSoft: amberSoft ?? this.amberSoft,
      nav: nav ?? this.nav,
      rest: rest ?? this.rest,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  PulseColors lerp(covariant PulseColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return PulseColors(
      brightness: t < 0.5 ? brightness : other.brightness,
      bg: l(bg, other.bg),
      surface: l(surface, other.surface),
      surface2: l(surface2, other.surface2),
      line: l(line, other.line),
      text: l(text, other.text),
      muted: l(muted, other.muted),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      accentInk: l(accentInk, other.accentInk),
      accentSoft: l(accentSoft, other.accentSoft),
      coral: l(coral, other.coral),
      coralInk: l(coralInk, other.coralInk),
      coralSoft: l(coralSoft, other.coralSoft),
      sky: l(sky, other.sky),
      violet: l(violet, other.violet),
      amber: l(amber, other.amber),
      amberInk: l(amberInk, other.amberInk),
      amberSoft: l(amberSoft, other.amberSoft),
      nav: l(nav, other.nav),
      rest: l(rest, other.rest),
      shadow: l(shadow, other.shadow),
    );
  }
}

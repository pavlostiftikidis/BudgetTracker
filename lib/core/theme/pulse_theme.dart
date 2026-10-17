import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pulse/core/theme/pulse_colors.dart';
import 'package:pulse/core/theme/pulse_text.dart';

/// Shape and spacing scale.
abstract final class Insets {
  static const double screen = 20;
  static const double xs = 8;
  static const double sm = 10;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
}

abstract final class Radii {
  static const double card = 24;
  static const double cardSm = 22;
  static const double tile = 13;
  static const double sheet = 32;
  static const double pill = 999;
}

abstract final class Motion {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 240);
  static const Duration chart = Duration(milliseconds: 600);
  static const Curve curve = Curves.easeOutCubic;
}

abstract final class PulseTheme {
  static ThemeData dark() => _build(PulseColors.dark);
  static ThemeData light() => _build(PulseColors.light);

  static ThemeData _build(PulseColors c) {
    final scheme = ColorScheme(
      brightness: c.brightness,
      primary: c.accent,
      onPrimary: c.onAccent,
      secondary: c.sky,
      onSecondary: c.onAccent,
      error: c.coral,
      onError: c.onAccent,
      surface: c.surface,
      onSurface: c.text,
      onSurfaceVariant: c.muted,
      surfaceContainerHighest: c.surface2,
      outline: c.line,
      outlineVariant: c.line,
      shadow: c.shadow,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: c.brightness,
      colorScheme: scheme,
      fontFamily: PulseFonts.sans,
    );
    const roundedSheet = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.sheet)),
    );
    return base.copyWith(
      scaffoldBackgroundColor: c.bg,
      canvasColor: c.bg,
      splashFactory: InkRipple.splashFactory,
      textTheme: base.textTheme.apply(
        fontFamily: PulseFonts.sans,
        bodyColor: c.text,
        displayColor: c.text,
      ),
      iconTheme: IconThemeData(color: c.text, size: 22),
      dividerTheme: DividerThemeData(color: c.line, thickness: 1, space: 1),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.accentInk,
        selectionColor: c.accentSoft,
        selectionHandleColor: c.accentInk,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        modalBackgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: roundedSheet,
        showDragHandle: true,
        dragHandleColor: c.line,
        dragHandleSize: const Size(40, 5),
        clipBehavior: Clip.antiAlias,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Radii.card)),
        titleTextStyle: PulseText.sectionTitle.copyWith(color: c.text),
        contentTextStyle: PulseText.body.copyWith(color: c.muted),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.text,
        contentTextStyle: PulseText.label.copyWith(color: c.bg),
        shape: const StadiumBorder(),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface2,
        hintStyle: PulseText.body.copyWith(color: c.muted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: c.accentInk, width: 1.5),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: c.surface2,
        headerForegroundColor: c.text,
        todayBorder: BorderSide(color: c.accentInk),
        todayForegroundColor: WidgetStatePropertyAll(c.text),
        dayForegroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.onAccent : c.text,
        ),
        dayBackgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.accent : null,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.text,
          textStyle: PulseText.label,
          minimumSize: const Size(44, 44),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: c.accentInk),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      extensions: [c],
    );
  }
}

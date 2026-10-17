import 'package:flutter/material.dart';
import 'package:pulse/core/theme/pulse_colors.dart';
import 'package:pulse/l10n/app_localizations.dart';

extension PulseContext on BuildContext {
  PulseColors get colors => Theme.of(this).extension<PulseColors>()!;

  AppLocalizations get l10n => AppLocalizations.of(this);

  /// [d], or zero when the platform asks for reduced motion.
  Duration motion(Duration d) =>
      MediaQuery.maybeDisableAnimationsOf(this) ?? false ? Duration.zero : d;

  bool get reduceMotion => MediaQuery.maybeDisableAnimationsOf(this) ?? false;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/app/app_providers.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';

/// 44×44 round outlined icon button used in headers.
class CircleIconButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.size = 44,
    this.filled = false,
    super.key,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final double size;

  /// Filled with the text colour instead of the surface (e.g. back button
  /// in onboarding).
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: semanticLabel,
      excludeSemantics: true,
      child: Tooltip(
        message: semanticLabel,
        child: Material(
          color: filled ? c.text : c.surface,
          shape: CircleBorder(side: BorderSide(color: filled ? c.text : c.line)),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: SizedBox.square(
              dimension: size,
              child: Icon(icon, size: 20, color: filled ? c.bg : c.text),
            ),
          ),
        ),
      ),
    );
  }
}

/// Sun/moon button that flips between dark and light.
class ThemeToggleButton extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    return CircleIconButton(
      icon: isDark ? LucideIcons.sun : LucideIcons.moon,
      semanticLabel: isDark ? context.l10n.themeToLight : context.l10n.themeToDark,
      onPressed: () => ref.read(themeModeControllerProvider.notifier).toggle(brightness),
    );
  }
}

/// Full-width lime call to action ("Συνέχεια", "Αποθήκευση €18,50 →").
class PrimaryButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    this.trailingArrow = false,
    this.height = 60,
    this.expand = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool trailingArrow;
  final double height;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onPressed != null;
    final fg = enabled ? c.onAccent : c.muted;
    final child = Material(
      color: enabled ? c.accent : c.surface2,
      shape: const StadiumBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const StadiumBorder(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: PulseText.title.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: fg,
                      fontFeatures: PulseText.tabular,
                    ),
                  ),
                ),
                if (trailingArrow) ...[
                  const SizedBox(width: 10),
                  Icon(LucideIcons.arrowRight, size: 20, color: fg),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    return Semantics(button: true, enabled: enabled, child: child);
  }
}

/// Outlined secondary action ("Νέος", coral delete button).
class OutlineButtonPill extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.height = 52,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Border and text colour; defaults to the text colour.
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = color ?? c.text;
    return Semantics(
      button: true,
      child: Material(
        color: Colors.transparent,
        shape: StadiumBorder(side: BorderSide(color: color ?? c.line, width: 1.5)),
        child: InkWell(
          onTap: onPressed,
          customBorder: const StadiumBorder(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: fg),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(label, style: PulseText.label.copyWith(color: fg)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

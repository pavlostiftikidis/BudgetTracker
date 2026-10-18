import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/theme/palette.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/l10n/app_localizations.dart';

String colorName(ColorKey k, AppLocalizations l10n) => switch (k) {
  ColorKey.lime => l10n.colorLime,
  ColorKey.coral => l10n.colorCoral,
  ColorKey.sky => l10n.colorSky,
  ColorKey.violet => l10n.colorViolet,
  ColorKey.amber => l10n.colorAmber,
  ColorKey.teal => l10n.colorTeal,
  ColorKey.pink => l10n.colorPink,
  ColorKey.grey => l10n.colorGrey,
};

/// Eight round colour swatches acting as a radio group.
class ColorSwatches extends StatelessWidget {
  const new({required this.selected, required this.onChanged, super.key});

  final ColorKey selected;
  final ValueChanged<ColorKey> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    return Semantics(
      container: true,
      label: l10n.categoryColor,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final k in ColorKey.values)
            Semantics(
              inMutuallyExclusiveGroup: true,
              checked: k == selected,
              button: true,
              label: colorName(k, l10n),
              excludeSemantics: true,
              child: InkResponse(
                onTap: () => onChanged(k),
                radius: 24,
                child: SizedBox.square(
                  dimension: 44,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: c.tint(k).ink,
                        shape: BoxShape.circle,
                        border: Border.all(color: k == selected ? c.text : Colors.transparent, width: 2.5),
                      ),
                      child: k == selected
                          ? Icon(LucideIcons.check, size: 16, color: c.isDark ? c.onAccent : c.surface)
                          : null,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

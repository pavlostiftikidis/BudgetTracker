import 'package:flutter/material.dart';
import 'package:pulse/core/theme/palette.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';

/// Rounded square with an icon or an initial: 40×40, radius 13 by default.
class IconTile extends StatelessWidget {
  const new({
    this.icon,
    this.initial,
    this.color = ColorKey.grey,
    this.size = 40,
    this.radius = Radii.tile,
    this.filled = false,
    super.key,
  }) : assert(icon != null || initial != null, 'icon or initial');

  final IconData? icon;
  final String? initial;
  final ColorKey color;
  final double size;
  final double radius;

  /// Bright fill with a dark glyph (accounts, edit header) instead of a soft
  /// tint with a coloured glyph.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tint = c.tint(color);
    final Color bg;
    final Color fg;
    if (filled) {
      bg = tint.fill;
      fg = c.onAccent;
    } else if (initial != null) {
      bg = c.surface2;
      fg = tint.ink;
    } else {
      bg = tint.soft;
      fg = tint.ink;
    }
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(radius)),
        child: icon != null
            ? Icon(icon, size: size * 0.48, color: fg)
            : Text(
                initial!,
                textScaler: TextScaler.noScaling,
                style: TextStyle(fontSize: size * 0.4, fontWeight: FontWeight.w800, color: fg),
              ),
      ),
    );
  }
}

/// First letter of [text], upper-cased the Greek way, for initial tiles.
String initialOf(String text) {
  final t = text.trim();
  if (t.isEmpty) return '•';
  final first = String.fromCharCode(t.runes.first);
  const plain = {'Ά': 'Α', 'Έ': 'Ε', 'Ή': 'Η', 'Ί': 'Ι', 'Ό': 'Ο', 'Ύ': 'Υ', 'Ώ': 'Ω'};
  final up = first.toUpperCase();
  return plain[up] ?? up;
}

import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// User-selectable colour of a category or account. Persisted by [name].
enum ColorKey { lime, coral, sky, violet, amber, teal, pink, grey }

/// Icon of a category. Persisted by [name].
///
/// The first ten are offered in the "Νέα κατηγορία" picker; the rest are used
/// by built-in categories (bills, salary, freelance, other).
enum IconKey {
  cart,
  food,
  car,
  home,
  film,
  heart,
  gift,
  plane,
  book,
  shirt,
  bolt,
  salary,
  laptop,
  tag;

  static const List<IconKey> pickable = [
    cart,
    food,
    car,
    home,
    film,
    heart,
    gift,
    plane,
    book,
    shirt,
  ];

  IconData get icon => switch (this) {
    cart => LucideIcons.shoppingCart,
    food => LucideIcons.utensils,
    car => LucideIcons.car,
    home => LucideIcons.house,
    film => LucideIcons.film,
    heart => LucideIcons.heart,
    gift => LucideIcons.gift,
    plane => LucideIcons.plane,
    book => LucideIcons.book,
    shirt => LucideIcons.shirt,
    bolt => LucideIcons.zap,
    salary => LucideIcons.briefcase,
    laptop => LucideIcons.laptop,
    tag => LucideIcons.tag,
  };
}

/// Fill / ink / soft triple for one [ColorKey] in one brightness.
@immutable
class Tint {
  const new({required this.fill, required this.ink, required this.soft});

  /// Bright colour, only ever used behind dark text or as a decorative fill.
  final Color fill;

  /// Colour for text, icons, strokes and chart marks on the page background.
  final Color ink;

  /// Low-emphasis background for icon tiles and badges.
  final Color soft;
}

/// Raw category colours. Dark mode uses the bright value everywhere; light
/// mode keeps it for fills and uses the darker variant for ink (≥ 4.5:1 on
/// both `surface` and `surface2`).
abstract final class Palette {
  static const Map<ColorKey, Color> bright = {
    ColorKey.lime: Color(0xFFC6F36B),
    ColorKey.coral: Color(0xFFFF7A59),
    ColorKey.sky: Color(0xFF6CB8FF),
    ColorKey.violet: Color(0xFFB49CFF),
    ColorKey.amber: Color(0xFFFFC857),
    ColorKey.teal: Color(0xFF5EE0C4),
    ColorKey.pink: Color(0xFFFF8FC7),
    ColorKey.grey: Color(0xFFC9CDD4),
  };

  static const Map<ColorKey, Color> lightInk = {
    ColorKey.lime: Color(0xFF3F6A08),
    ColorKey.coral: Color(0xFFB23C17),
    ColorKey.sky: Color(0xFF1F66B8),
    ColorKey.violet: Color(0xFF6A48D6),
    ColorKey.amber: Color(0xFF8A5A00),
    ColorKey.teal: Color(0xFF08715E),
    ColorKey.pink: Color(0xFFB8306F),
    ColorKey.grey: Color(0xFF5D626B),
  };
}

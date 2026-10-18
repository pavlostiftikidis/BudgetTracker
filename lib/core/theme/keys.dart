// Pure Dart (no Flutter imports) so drift can load the schema in a plain VM.

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

  static const List<IconKey> pickable = [cart, food, car, home, film, heart, gift, plane, book, shirt];
}

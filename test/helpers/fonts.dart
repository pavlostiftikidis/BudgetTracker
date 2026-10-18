import 'package:flutter/services.dart';

bool _loaded = false;

/// Loads the app's real fonts (and the Lucide icon font) so goldens show
/// actual glyphs instead of the test font's boxes.
Future<void> loadAppFonts() async {
  if (_loaded) return;
  _loaded = true;
  final families = {
    'Manrope': [
      'assets/fonts/Manrope-Regular.ttf',
      'assets/fonts/Manrope-Medium.ttf',
      'assets/fonts/Manrope-SemiBold.ttf',
      'assets/fonts/Manrope-Bold.ttf',
      'assets/fonts/Manrope-ExtraBold.ttf',
    ],
    'JetBrainsMono': ['assets/fonts/JetBrainsMono-Medium.ttf', 'assets/fonts/JetBrainsMono-SemiBold.ttf'],
    'packages/lucide_icons_flutter/Lucide': ['packages/lucide_icons_flutter/assets/lucide.ttf'],
  };
  for (final entry in families.entries) {
    final loader = FontLoader(entry.key);
    for (final asset in entry.value) {
      loader.addFont(rootBundle.load(asset));
    }
    await loader.load();
  }
}

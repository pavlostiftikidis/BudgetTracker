# Decisions

Choices made where the spec was silent, or where following it literally would
have broken another requirement. Newest decisions are appended per phase.

## Toolchain

- **Flutter 3.47.7 / Dart 3.13.5** (stable on 2026-10-18). Package versions are
  whatever `pub` resolved as latest-compatible on that date (Riverpod 3.4,
  go_router 18, drift 2.35, freezed 4).
- **Lints: `very_good_analysis` 11** with two rules relaxed:
  `public_member_api_docs` (app code, not a package) and
  `lines_longer_than_80_chars` (the formatter owns line length). VGA 11 enforces
  Dart 3.13's `new(...)` constructor syntax (`unnecessary_type_name_in_constructor`),
  so constructors are written that way.
- **Generated code is committed** (`*.g.dart`, `*.freezed.dart`, l10n output) so a
  fresh clone analyses and runs without a build step. Regenerate with
  `dart run build_runner build`.

## Fonts

- Manrope (400–800) and JetBrains Mono (500–600) are **bundled through the
  pubspec `fonts:` section** instead of loading them with `google_fonts`. Both
  approaches are offline, but `google_fonts` registers each weight as its own
  family (`Manrope_700`), so the ubiquitous `style.copyWith(fontWeight: ...)`
  would silently keep the old weight. The `.ttf` files are the exact files
  `google_fonts` 9.0 would download (fetched from fonts.gstatic.com and checked
  against the SHA-256 hashes in that package), so rendering is identical. OFL
  licences are registered with `LicenseRegistry`.
- Both families cover Greek, `€` and the minus sign U+2212 (checked with
  fontTools).

## Colour and contrast

- The spec's light-mode `coral` (#E2552F, 3.8:1 on white) and `amber`
  (#C98A0B, 3.0:1) are kept for fills, borders and strokes, where 3:1 is
  enough, and **`coralInk` (#B23C17) / `amberInk` (#8A5A00) were added for
  text**, mirroring the spec's own `accent` / `accentInk` split. Both reach
  ≥ 4.5:1 on `bg`, `surface` and `surface2`.
- Light-mode category inks (used for icons, initials and chart marks) are
  darker variants of the bright palette, chosen to reach ≥ 4.5:1 on both
  `surface` and `surface2`: lime #3F6A08, coral #B23C17, sky #1F66B8,
  violet #6A48D6, amber #8A5A00, teal #08715E, pink #B8306F, grey #5D626B.
  In dark mode the bright value is used everywhere.
- Text on coral/sky action fills (swipe actions) uses the dark `onAccent`
  colour in both themes (≥ 4.7:1), never white.
- Extra tokens the mockups use but the table does not list: `nav` (translucent
  nav pill), `rest` (neutral "Άλλα" segment / tracks), `shadow`, `amberSoft`.

## Typography

- Greek uppercase labels drop the accents (`ΕΞΟΔΑ ΟΚΤΩΒΡΙΟΥ`, not
  `ΟΚΤΩΒΡΊΟΥ`) and keep diaeresis where needed (`ΜΑΪ`). See `greekUpper`.
- Day ordinals follow the spoken stress: `20ή`, `30ή`, otherwise `1η`, `22η`.
  (The mockup's `22α` is the older katharevousa form.)
- Text scale is clamped at 1.3 app-wide (`MediaQuery.withClampedTextScaling`),
  the level the spec requires layouts to survive.

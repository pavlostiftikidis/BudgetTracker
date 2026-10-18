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

## Data layer (phase 2)

- **Structure:** besides `core/`, `data/` and `features/`, pure business rules
  (balances, budget maths, recurring schedule) live in **`lib/domain/`**. They
  depend only on the models and `core/`, so they are unit-tested without
  Flutter or a database.
- **Ids are client-generated UUID v4 strings**, not autoincrement integers, so a
  future sync backend can merge rows from several devices without remapping.
- **Enums are stored as text** (`textEnum`) so reordering an enum can never
  corrupt data. Dates use drift's default (Unix seconds, local time).
- **Extra fields beyond the spec:**
  - `Txn.title`: merchant or short title ("Σκλαβενίτης"); the UI falls back to
    the category name. Needed for the Edit screen's "merchant/title".
  - `Txn.occurrenceKey`: `yyyy-MM-dd` of the recurring occurrence. A unique
    index on `(recurringRuleId, occurrenceKey)` makes materialisation
    idempotent at the database level, so it holds even if a rule's
    `nextDueDate` were rolled back. A soft-deleted occurrence is not
    re-created.
  - `RecurringRule.title`: the name shown in the list ("Ενοίκιο").
  - `Account.last4`, `creditLimitCents`, `statementDay`, `goalCents`: they
    drive the account subtitles in the mockups ("Τράπεζα · ••4417",
    "Όριο €2.000 · λήξη 5 Νοε", "Στόχος €5.000 · 65%").
- **Where settings live:** income, payday and currency are in the `settings`
  table. Theme and the onboarding flag are in `shared_preferences`, because
  they are needed synchronously before the database opens. The biometric lock
  flag will go in `flutter_secure_storage` (phase 6).
- **Balances** are computed with one SQL aggregate per account and kind
  (`UNION` with the incoming side of transfers), not by loading every
  transaction. The same maths exists as a pure function for unit tests.
- **Categories and accounts that are in use are archived, not deleted.** A
  category also counts as "in use" when a recurring rule references it.
- **Budget period label:** a period is named after the calendar month that
  holds most of its days ("15 Oct–14 Nov" → Οκτώβριος, "31 Oct–29 Nov" →
  Νοέμβριος).
- **No `rxdart`:** the one stream combinator needed (`combineLatest2`) is a
  30-line helper in `core/utils/streams.dart`.
- **drift managers are disabled** (`generate_manager: false`); the app uses
  DAOs only.
- **Migrations:** `schemaVersion` 1 with an exported snapshot in
  `drift_schemas/`. Adding a version means bumping `schemaVersion`, running
  `dart run drift_dev make-migrations` (it generates step helpers and
  migration tests under `test/drift/`), and adding the step in `onUpgrade`.
  Core value types (`Money`, `BudgetPeriod`, enums) are pure Dart (`meta`
  rather than Flutter), so drift can load the schema in a plain VM.

## Demo data

- `--dart-define=SEED_DEMO=true` is honoured **only in debug builds**, and only
  on an empty database. It marks onboarding as done.
- The data is generated **relative to today** over the current and five
  previous periods (payday on the 1st), so the app always looks alive and
  Insights has history. Up to the 18th of the month the category totals
  match the mockups (Σούπερ μάρκετ €312, Εστίαση €186, Λογαριασμοί €218,
  Μετακίνηση €94, Ψυχαγωγία €41 → €851 / €980, "4 από 5 εντός ορίου"). The
  previous period is tuned so Εστίαση shows "+24%".
- The credit card is paid off on the 5th of each month from the previous
  month's card spending, so it carries a realistic negative balance.
  Seeded rent, salary, ΔΕΗ, Netflix and Spotify transactions are linked to
  their recurring rules, so materialisation right after seeding creates
  nothing.

## Transactions, accounts, transfers (phase 3)

- **Transfers:** Accounts › "Μεταφορά" opens the transfer bottom sheet from
  the mockup (Από / Προς with swap, amount on a keypad, the note, "Μεταφορά
  €X"). The same rows also power a transfer mode of "Νέα κίνηση"
  (`/add?mode=transfer`, a third segment), so both spec bullets point at one
  implementation. Transfers have no category and never count as income or
  expense.
- **Form state** (amount being typed, selected chip, picked date) is local
  widget state. Riverpod holds application state (repositories, streams,
  derived view models). Writes that touch more than one repository go
  through `TxnActions`.
- **Default account:** a card for expenses, a bank account for income,
  otherwise the first account. Transfers default to bank → savings.
- **A new transaction dated today keeps the current time;** any other day is
  stored at 12:00, so time-zone shifts never move it to another day.
- **Validation messages** appear under the composer. Saving with €0 explains
  why rather than silently disabling the button.
- **"Επανάληψη κάθε μήνα"** creates a monthly rule anchored on the
  transaction's day of month, links the transaction as its first occurrence,
  and schedules the next one a month later. Switching it off deletes the
  rule. Past occurrences stay as ordinary transactions.
- **Receipts** are copied into the app's documents folder
  (`receipts/<txnId>-<ts>.jpg`), so they survive the picker's temp cleanup.
  The camera and photo-library usage strings are in `Info.plist`.
- **Undo** snackbar: the messenger, colours and strings are captured before
  any `await`, so the toast still appears after the Edit screen pops.
- **Swipe tile:** besides the drag gesture, "Επεξ." and "Διαγραφή" are
  exposed as semantics custom actions, so screen-reader users can reach them
  without swiping.
- **Search** ignores case and Greek accents (it compares `greekUpper` keys),
  and matches title, category, account and note.
- Widget tests run with "reduce motion" on (the blinking caret is static),
  which also covers that accessibility path.

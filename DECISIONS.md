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

## Home, Budgets, Categories (phase 4)

- **"ΥΠΟΛΟΙΠΟ ΜΗΝΑ"** is the spec's "available" (Σ limits − budgeted
  spending), so it matches Budgets exactly. When no category has a limit yet
  it falls back to income − all spending ("από €income"), so the hero is
  never meaningless.
- **"−18% vs Σεπ"** compares spending **like-for-like**: the first N days
  of this period against the first N days of the previous one (N = days
  elapsed). A plain month-vs-month comparison would always look like a drop
  early in the month. Lower spending gets the lime badge, higher the coral
  one, and the sign is always printed, so colour is not the only signal.
- **"Σήμερα μπορείς"** shows whole euros rounded *down*, so it never
  promises more than is left (€129 over 14 days → €9.21 → "€9").
- **Spending split:** the top five expense categories plus "Άλλα" (the rest
  and uncategorised spending), including categories without a limit (e.g.
  rent). Transfers never count.
- **Savings card:** the balance of savings-type accounts, with a sparkline of
  that balance at the end of each of the last six periods. Without a savings
  account it shows the period's net (income − expenses).
- **Week:** Monday–Sunday around today. When looking at a past period, it
  is the week of that period's last day.
- **The period pill** opens a picker of the last 12 periods; Home then shows
  that period (no days left or allowance for past periods).
- **Avatar initials** come from an optional `displayName` setting (schema
  v2, see phase 7). Without a name the avatar shows a person icon.
- **Budgets:** the 20-tick bar fills proportionally; ticks 18–20 (≥ 85 %)
  turn amber, or coral once the total is over. Category cards show the
  percentage in the ring, a coral "+€X" badge and coral border when over,
  and a warning icon when at 85–100 %, so state is never colour-only. A grid
  button in the header opens Κατηγορίες.
- **Categories:** drag handles only (the rows stay tappable for editing),
  with the order saved across both kinds. The sheet's preview tile updates
  live. Deleting a category that has transactions or a rule archives it and
  says so.
- **Bottom sheets open on the root navigator**, so they are drawn above the
  floating nav. A widget test caught the nav covering the sheet's main
  button. Tests now fail on any tap that would hit a different widget
  (`hitTestWarningShouldBeFatal`).
- `Semantics` wrappers that replace their children's semantics are
  `container: true`, so each card reads as its own node instead of merging
  with its neighbours.
- **Goldens** (Home dark/light/empty, Budgets dark/light, Transactions,
  Accounts, Add) use the real fonts and are generated on Windows; regenerate
  with `flutter test --update-goldens --tags golden`.

## Recurring and Insights (phase 5)

- **Resuming a paused rule skips** the occurrences that fell due while it
  was paused: its next due date moves to the first occurrence on or after
  today. Otherwise re-enabling a gym membership after three months would
  back-fill three charges, which contradicts "paused rules are skipped".
- **"ΠΑΓΙΑ / ΜΗΝΑ"** sums the monthly-equivalent cost of *active expense*
  rules. Income rules (salary) are listed with a "+" amount but not added.
  "% του εισοδήματος" uses the income from settings and is hidden when no
  income is set.
- **Next due:** within 7 days it reads "σήμερα / αύριο / σε N μέρες" in
  `accentInk`, otherwise as a date ("14 Νοε"). Paused rows are at 55 %
  opacity and read "Σε παύση". Active rules are listed first, by next due
  date.
- **7-day strip:** dots use the rule's category colour, up to three per
  day. Each day has a spoken label ("Τρίτη 20 Οκτωβρίου: Ενοίκιο").
- A rule saved with a first date of today or earlier becomes a transaction
  right away (materialisation runs after saving).
- **Insights buckets:** "Μήνας" = budget periods (so payday on the 15th
  shows 15→14 bars), "Εβδομάδα" = Monday–Sunday weeks, "Έτος" = calendar
  years. Six bars each, the current one in the accent.
- **Change and the insight card are like-for-like**, as on Home: the first N
  days of the current bucket against the first N days of the previous one.
  The card names the category with the biggest increase (ignoring
  categories under €10, so "+300%" on a €2 coffee never becomes the
  headline) and adds the weekday with the most spending over the six
  buckets ("γίνονται την Παρασκευή", with the correct article). When
  nothing increased, a lime "well done" card is shown instead.
- **Bar values** use a compact form above €1.000 ("€1,8k").

## Onboarding, Settings, lock, export (phase 6)

- **Onboarding income** is whole euros, grouped as you type ("2.150").
  "Άλλη" payday opens a 1–31 day grid; days past a month's end fall on its
  last day (see `Payday`).
- **"Παράλειψη" completes onboarding with the defaults** on screen (income
  €2.150, payday the 1st, the five suggested limits, Τρεχούμενος + Κάρτα),
  so a skipped setup still leaves a working app. Completing is idempotent:
  nothing that already exists is duplicated.
- Besides the five suggested expense categories, onboarding creates the
  income categories the Add screen offers (Μισθός, Freelance, Δώρο, Άλλο),
  without limits. Accounts are created with the mockup colours and €0
  opening balances. The "Υπόλοιπα λογαριασμών" first step prompts the user
  to set real balances.
- The limit steppers send an action ("+€10 on Εστίαση") that the parent
  applies to its *current* state, so quick repeated taps are never lost.
  A widget test caught the stale-closure version.
- **Biometric lock:** the flag lives in `flutter_secure_storage`. Turning it
  on requires a successful authentication first (so nobody locks themselves
  out); without biometrics the switch stays off and says why. The app
  re-locks only after **30 s in the background**, so the photo picker or the
  share sheet does not trigger a new prompt. The lock screen prompts
  automatically and keeps an "Ξεκλείδωμα" button for retries. While the flag
  is loading only the background is drawn, so content never flashes.
  Android uses `FlutterFragmentActivity` + `USE_BIOMETRIC`; iOS has
  `NSFaceIDUsageDescription`.
- **CSV export** is built for Greek spreadsheets: UTF-8 with BOM, `;`
  separator, CRLF, `yyyy-MM-dd HH:mm` dates, amounts with a plain `-` and a
  decimal comma ("-42,80") so they import as numbers. Deleted rows are left
  out; rows are oldest first. It is shared through the system share sheet.
- **Reset** wipes the database, the stored receipts and the lock flag, then
  flips the onboarding flag; the router takes the user back to step 1.
- Settings also offers "Όνομα" (the Home avatar initials) and the licence
  page (fonts are registered there).

## Polish (phase 7)

- **Schema v2 is a real migration.** Adding `settings.display_name` in
  phase 4, I rewrote the v1 snapshot instead of bumping the version. A build
  from an earlier phase was already installed on the emulator, so its v1
  database lacked the column and the app hung on a blank screen at start.
  It is now `schemaVersion` 2 with a `stepByStep` migration (`addColumn`),
  the original v1 snapshot restored, and generated tests for the schema
  shape and data integrity. It was verified by installing over that exact
  device database. Rule from now on: any schema change after a build has
  left the machine is a new version.
- **Failure states:** the startup and the three main screens show an error
  with "Δοκίμασε ξανά" instead of staying blank; debug builds also print the
  error. Demo seeding is a provider (`seedDemoEnabledProvider`), so this
  path is covered by tests.
- **Layout guarantees** are tested, not assumed: every screen and the main
  sheets at 360×640 and 390×844, text scale 1.0 and 1.3, with the real
  fonts, in dark and light.
- Verified on an Android 16 emulator (API 36): debug APK builds, the
  database opens, sqlite's native library loads, the demo data seeds, and
  the main screens render as in the goldens.
- Not done and worth knowing:
  - iOS was not built here (Windows host).
  - Receipt images of transactions that are purged after 7 days are not
    deleted yet; they are removed on "Επαναφορά δεδομένων".
  - Lucide ships every weight of its icon font; tree-shaking keeps only the
    used glyphs in release builds.

## Launch splash

- **The app icon builds itself** on a cold start (`lib/app/splash.dart`):
  the wallet settles in, the lime ring sweeps to 75%, the dot pops and one
  pulse ripples out (1.1 s), then it fades into the app. It mirrors the
  motion on the website. The geometry is the 1024 px icon's (the site's
  `app/icon.svg`), drawn by `AppMarkPainter` in
  `lib/core/widgets/app_mark.dart`; a new icon means updating it. The same
  painter draws `AppMark`, the icon next to "Pulse" on the welcome page.
- **It never cuts startup short and never waits on it twice:** the app is
  built underneath from the first frame, and the splash leaves once startup
  has finished *and* the intro has played. A slow startup holds the finished
  icon. With the lock on, the biometric prompt can appear over the splash.
- **Always dark,** like the icon. The native launch screens (Android
  `LaunchTheme`/`NormalTheme`, iOS `LaunchScreen.storyboard`) use the same
  `#0B0C0E`, so there is no white flash before it. Android 12+ shows its
  own system splash regardless; its icon is made transparent so the logo
  is not shown twice.
- **Reduced motion:** the finished icon shows until startup is done and
  goes at once. Widget tests run that way, so they never wait on it.

## Backup and import

- **"Αντίγραφο ασφαλείας" is the whole app in one zip** (`pulse-backup-
  yyyy-MM-dd.zip`), shared through the system share sheet like the CSV:
  `backup.json` holds settings, accounts and categories (archived ones too),
  recurring rules and the live transactions; `receipts/` holds the receipt
  images. Soft-deleted transactions are left out, as in the CSV. Theme, the
  lock flag and the onboarding flag are per device and are not included.
- **Receipt paths are stored relative** (`receipts/<name>`) because the
  documents folder differs between installs; on import they are pointed at
  this install's folder. A receipt whose file is gone is dropped.
- **"Εισαγωγή αντιγράφου" replaces everything, it does not merge.** The file
  is read and checked first; a dialog then shows its date and number of
  transactions before anything changes. The database swap is one
  transaction (`AppDatabase.replaceAll`), so a file the database rejects
  (e.g. a transaction on a missing account) leaves the data as it was.
  Receipts are unpacked beside the live folder and swapped in only after the
  database accepted the data. Recurring rules that fell due since the backup
  are materialised right after.
- **Versioned:** `backup.json` carries `"format": "pulse-backup"` and
  `"version": 1` (`kBackupVersion`). A newer version is refused with a
  message to update the app; when the layout changes, bump the version and
  keep older files restoring. Only flat files directly under `receipts/` are
  unpacked, so a crafted entry name cannot write elsewhere.
- **Packages:** `archive` for the zip, `file_picker` to choose the file
  (Android may return a content URI, which is copied to a temporary file).

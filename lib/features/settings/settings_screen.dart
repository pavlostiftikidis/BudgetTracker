import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/app/app_providers.dart';
import 'package:pulse/app/router.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/utils/greek.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/page_header.dart';
import 'package:pulse/core/widgets/pill_segmented_control.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';
import 'package:pulse/core/widgets/pulse_switch.dart';
import 'package:pulse/core/widgets/sheets.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/features/onboarding/income_widgets.dart';
import 'package:pulse/features/settings/app_lock.dart';
import 'package:pulse/features/settings/backup.dart';
import 'package:pulse/features/settings/csv_export.dart';
import 'package:pulse/features/transactions/receipt_store.dart';
import 'package:pulse/features/transactions/txn_display.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_screen.g.dart';

String paydayLabel(Payday p, AppLocalizations l10n) => switch (p.kind) {
  PaydayKind.first => l10n.paydayFirst,
  PaydayKind.fifteenth => l10n.paydayFifteenth,
  PaydayKind.last => l10n.paydayLast,
  PaydayKind.custom => l10n.paydayCustomValue(dayOrdinal(p.customDay)),
};

@Riverpod(keepAlive: true)
ReceiptStorage receiptStorage(Ref ref) => const DocumentsReceiptStorage();

@Riverpod(keepAlive: true)
BackupPicker backupPicker(Ref ref) => const SystemBackupPicker();

/// Deletes all data and returns to onboarding.
Future<void> resetAllData(WidgetRef ref) async {
  await ref.read(settingsRepositoryProvider).wipeAll();
  await ref.read(receiptStorageProvider).deleteAll();
  await ref.read(secureFlagsProvider).setBiometricLock(enabled: false);
  ref.invalidate(appLockProvider);
  await ref.read(onboardingDoneProvider.notifier).set(done: false);
}

/// Ρυθμίσεις › Εισαγωγή αντιγράφου, and "Έχω αντίγραφο ασφαλείας" on the
/// welcome page, where [fresh] says there is nothing to overwrite yet. Picks
/// a backup, shows its date and size, and replaces all data with it.
/// Returns whether it did.
Future<bool> importBackup(BuildContext context, WidgetRef ref, {bool fresh = false}) async {
  final messenger = ScaffoldMessenger.of(context);
  final l10n = context.l10n;
  void fail(BackupProblem problem) => messenger.showSnackBar(
    SnackBar(
      content: Text(switch (problem) {
        BackupProblem.notABackup => l10n.importNotBackup,
        BackupProblem.newerVersion => l10n.importNewerVersion,
        BackupProblem.failed => l10n.importFailed,
      }),
    ),
  );

  final file = await ref.read(backupPickerProvider).pick();
  if (file == null) return false;
  final Backup backup;
  try {
    backup = await readBackup(file);
  } on BackupException catch (e) {
    fail(e.problem);
    return false;
  }
  if (!context.mounted) return false;
  final made = '${dayMonthShort(backup.createdAt)} ${backup.createdAt.year}';
  final count = backup.data.txns.length;
  final ok = await _confirm(
    context,
    title: l10n.importDialogTitle,
    body: fresh ? l10n.importDialogBodyFresh(made, count) : l10n.importDialogBody(made, count),
    action: l10n.importConfirm,
    destructive: !fresh,
  );
  if (!ok) return false;
  try {
    await restoreBackup(
      file,
      backup,
      repository: ref.read(backupRepositoryProvider),
      receiptsDir: await ref.read(receiptStorageProvider).directory(),
    );
  } on BackupException catch (e) {
    fail(e.problem);
    return false;
  }
  // Rules that fell due since the backup was made.
  await ref.read(recurringRepositoryProvider).materializeDue();
  messenger.showSnackBar(SnackBar(content: Text(l10n.importDone)));
  return true;
}

/// Asks before [action]; true if confirmed. A [destructive] action, one that
/// overwrites data, gets a coral button.
Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String body,
  required String action,
  bool destructive = true,
}) async {
  final c = context.colors;
  final l10n = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlineButtonPill(label: l10n.actionCancel, onPressed: () => Navigator.pop(context, false)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Material(
                color: destructive ? c.coral : c.accent,
                shape: const StadiumBorder(),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: () => Navigator.pop(context, true),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 52),
                    child: Center(
                      child: Text(
                        action,
                        style: PulseText.label.copyWith(color: c.onAccent, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
  return ok ?? false;
}

class SettingsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = context.l10n;
    final mode = ref.watch(themeModeControllerProvider);
    final settings = ref.watch(settingsProvider).value ?? const AppSettings();
    final lock = ref.watch(appLockProvider).value;

    return PulseScaffold(
      body: Column(
        children: [
          PageHeader(title: l10n.settingsTitle),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + MediaQuery.paddingOf(context).bottom),
              children: [
                _SectionTitle(l10n.settingsSectionData),
                _Group(
                  children: [
                    _Row(
                      icon: LucideIcons.wallet,
                      title: l10n.accountsTitle,
                      onTap: () => context.push(Routes.accounts),
                    ),
                    _Row(
                      icon: LucideIcons.layoutGrid,
                      title: l10n.categoriesTitle,
                      onTap: () => context.push(Routes.categories),
                    ),
                    _Row(
                      icon: LucideIcons.repeat,
                      title: l10n.recurringTitle,
                      onTap: () => context.push(Routes.recurring),
                    ),
                    _Row(
                      icon: LucideIcons.banknote,
                      title: l10n.settingsIncome,
                      subtitle:
                          '${settings.monthlyIncome.format(showCents: false)} · ${paydayLabel(settings.payday, l10n)}',
                      onTap: () => showPulseSheet<void>(context, builder: (_) => _IncomeSheet(settings: settings)),
                    ),
                    _Row(
                      icon: LucideIcons.user,
                      title: l10n.settingsName,
                      value: settings.displayName ?? '—',
                      onTap: () => _editName(context, ref, settings),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _SectionTitle(l10n.settingsSectionApp),
                _Group(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(l10n.settingsTheme, style: PulseText.title),
                          const SizedBox(height: 10),
                          PillSegmentedControl<ThemeMode>(
                            semanticLabel: l10n.settingsTheme,
                            selected: mode,
                            onChanged: ref.read(themeModeControllerProvider.notifier).set,
                            segments: [
                              Segment(value: ThemeMode.system, label: l10n.themeSystem),
                              Segment(value: ThemeMode.dark, label: l10n.themeDark),
                              Segment(value: ThemeMode.light, label: l10n.themeLight),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _Row(
                      icon: LucideIcons.scanFace,
                      title: l10n.settingsBiometric,
                      subtitle: (lock?.enabled ?? false) ? l10n.settingsLockOn : null,
                      trailing: PulseSwitch(
                        value: lock?.enabled ?? false,
                        semanticLabel: l10n.settingsBiometric,
                        onChanged: lock == null ? null : (v) => _toggleLock(context, ref, v),
                      ),
                    ),
                    _Row(icon: LucideIcons.euro, title: l10n.settingsCurrency, value: l10n.currencyEur),
                    _Row(icon: LucideIcons.download, title: l10n.settingsExportCsv, onTap: () => _export(context, ref)),
                    _Row(
                      icon: LucideIcons.databaseBackup,
                      title: l10n.settingsBackup,
                      subtitle: l10n.settingsBackupSub,
                      onTap: () => _backup(context, ref),
                    ),
                    _Row(
                      icon: LucideIcons.archiveRestore,
                      title: l10n.settingsImportBackup,
                      onTap: () => importBackup(context, ref),
                    ),
                    _Row(
                      icon: LucideIcons.fileText,
                      title: l10n.settingsLicenses,
                      onTap: () => showLicensePage(context: context, applicationName: 'Pulse', useRootNavigator: true),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _Group(
                  children: [
                    _Row(
                      icon: LucideIcons.rotateCcw,
                      title: l10n.settingsReset,
                      color: c.coralInk,
                      onTap: () => _confirmReset(context, ref),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleLock(BuildContext context, WidgetRef ref, bool enabled) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final ok = await ref.read(appLockProvider.notifier).setEnabled(enabled: enabled, reason: l10n.biometricReason);
    if (!ok && enabled) messenger.showSnackBar(SnackBar(content: Text(l10n.biometricUnavailable)));
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final txns = await ref.read(allTxnsProvider.future);
    final lookups = await ref.read(lookupsProvider.future);
    if (txns.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.exportEmpty)));
      return;
    }
    await exportAndShareCsv(txns, lookups, l10n, ref.read(clockProvider).now());
  }

  Future<void> _backup(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final data = await ref.read(backupRepositoryProvider).snapshot();
    await shareBackup(data, l10n, ref.read(clockProvider).now());
  }

  Future<void> _editName(BuildContext context, WidgetRef ref, AppSettings settings) async {
    final controller = TextEditingController(text: settings.displayName ?? '');
    final name = await showPulseSheet<String>(
      context,
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.l10n.settingsName, style: PulseText.screenTitle.copyWith(fontSize: 22)),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                autofocus: true,
                maxLength: 40,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(hintText: context.l10n.settingsNameHint, counterText: ''),
                onSubmitted: (v) => Navigator.pop(context, v),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: context.l10n.actionSave,
                height: 56,
                onPressed: () => Navigator.pop(context, controller.text),
              ),
            ],
          ),
        ),
      ),
    );
    controller.dispose();
    if (name == null) return;
    final trimmed = name.trim();
    await ref.read(settingsRepositoryProvider).save(settings.copyWith(displayName: trimmed.isEmpty ? null : trimmed));
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await _confirm(
      context,
      title: l10n.resetDialogTitle,
      body: l10n.resetDialogBody,
      action: l10n.resetConfirm,
    );
    if (!ok) return;
    await HapticFeedback.heavyImpact();
    await resetAllData(ref);
  }
}

class _IncomeSheet extends ConsumerStatefulWidget {
  const new({required this.settings});

  final AppSettings settings;

  @override
  ConsumerState<_IncomeSheet> createState() => _IncomeSheetState();
}

class _IncomeSheetState extends ConsumerState<_IncomeSheet> {
  late final _income = TextEditingController(text: widget.settings.monthlyIncome.formatPlain(showCents: false));
  late Money _amount = widget.settings.monthlyIncome;
  late Payday _payday = widget.settings.payday;

  @override
  void dispose() {
    _income.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.incomeSheetTitle, style: PulseText.screenTitle.copyWith(fontSize: 22)),
            const SizedBox(height: 16),
            Text(l10n.onbIncomeLabel, style: PulseText.caption.copyWith(color: context.colors.muted)),
            Semantics(
              label: l10n.onbIncomeLabel,
              child: IncomeField(controller: _income, onChanged: (m) => _amount = m),
            ),
            const SizedBox(height: 16),
            Text(l10n.onbPaydayQuestion, style: PulseText.label),
            const SizedBox(height: 10),
            PaydayPicker(value: _payday, onChanged: (p) => setState(() => _payday = p)),
            const SizedBox(height: 8),
            Text(l10n.onbPaydayHelper, style: PulseText.caption.copyWith(color: context.colors.muted)),
            const SizedBox(height: 18),
            PrimaryButton(
              label: l10n.actionSave,
              height: 56,
              onPressed: () async {
                await ref
                    .read(settingsRepositoryProvider)
                    .save(
                      widget.settings.copyWith(
                        monthlyIncomeCents: _amount.cents,
                        paydayKind: _payday.kind,
                        paydayDay: _payday.customDay,
                      ),
                    );
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Semantics(
      header: true,
      child: Text(greekUpper(text), style: PulseText.mono.copyWith(color: context.colors.muted)),
    ),
  );
}

class _Group extends StatelessWidget {
  const new({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Radii.cardSm),
        side: BorderSide(color: c.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(height: 1, indent: 16, endIndent: 16, color: c.line),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    this.value,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.color,
  });

  final IconData icon;
  final String title;
  final String? value;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final content = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, trailing == null ? 12 : 8, 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color ?? c.muted),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: PulseText.title.copyWith(color: color)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: PulseText.small.copyWith(fontWeight: FontWeight.w500, color: c.muted),
                    ),
                  ],
                ],
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 170),
                child: Text(
                  value!,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: PulseText.caption.copyWith(color: c.muted),
                ),
              ),
            ],
            ?trailing,
            if (onTap != null && trailing == null) ...[
              const SizedBox(width: 6),
              Icon(LucideIcons.chevronRight, size: 18, color: c.muted),
            ],
          ],
        ),
      ),
    );
    if (onTap == null) return content;
    return InkWell(onTap: onTap, child: content);
  }
}

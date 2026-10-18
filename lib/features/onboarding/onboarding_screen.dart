import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/app/app_providers.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/icon_tile.dart';
import 'package:pulse/core/widgets/mono_label.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';
import 'package:pulse/core/widgets/sheets.dart';
import 'package:pulse/core/widgets/surface_card.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/features/accounts/account_display.dart';
import 'package:pulse/features/onboarding/income_widgets.dart';
import 'package:pulse/features/onboarding/onboarding_actions.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _steps = 3;
  int _step = 0;
  OnboardingDraft _draft = const OnboardingDraft();
  late final _income = TextEditingController(text: _draft.income.formatPlain(showCents: false));
  bool _saving = false;

  @override
  void dispose() {
    _income.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);
    await completeOnboarding(
      draft: _draft,
      settings: ref.read(settingsRepositoryProvider),
      categories: ref.read(categoryRepositoryProvider),
      accounts: ref.read(accountRepositoryProvider),
      l10n: context.l10n,
    );
    await HapticFeedback.lightImpact();
    // The router redirects to Home (empty state) once this flips.
    await ref.read(onboardingDoneProvider.notifier).set(done: true);
  }

  void _next() {
    FocusScope.of(context).unfocus();
    if (_step == _steps - 1) {
      unawaited(_finish());
    } else {
      setState(() => _step++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final (title, subtitle) = switch (_step) {
      0 => (l10n.onbIncomeTitle, l10n.onbIncomeSubtitle),
      1 => (l10n.onbLimitsTitle, l10n.onbLimitsSubtitle),
      _ => (l10n.onbAccountsTitle, l10n.onbAccountsSubtitle),
    };
    return PulseScaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    container: true,
                    label: l10n.onbProgress(_step + 1, _steps),
                    excludeSemantics: true,
                    child: Row(
                      children: [
                        for (var i = 0; i < _steps; i++) ...[
                          if (i > 0) const SizedBox(width: 6),
                          Expanded(
                            child: AnimatedContainer(
                              duration: context.motion(Motion.normal),
                              height: 6,
                              decoration: BoxDecoration(
                                color: i <= _step ? c.accent : c.surface2,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _saving ? null : _finish,
                  child: Text(l10n.actionSkip, style: PulseText.label.copyWith(color: c.muted)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              children: [
                MonoLabel(l10n.onbStep(_step + 1, _steps), color: c.accentInk),
                const SizedBox(height: 8),
                Semantics(header: true, child: Text(title, style: PulseText.screenTitle.copyWith(fontSize: 30))),
                const SizedBox(height: 8),
                Text(subtitle, style: PulseText.body.copyWith(color: c.muted, height: 1.5)),
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: context.motion(Motion.normal),
                  child: KeyedSubtree(
                    key: ValueKey(_step),
                    child: switch (_step) {
                      0 => _IncomeStep(
                        controller: _income,
                        draft: _draft,
                        onChanged: (d) => setState(() => _draft = d),
                      ),
                      1 => _LimitsStep(draft: _draft, onStep: (c, dir) => setState(() => _draft = _draft.step(c, dir))),
                      _ => _AccountsStep(draft: _draft, onChanged: (d) => setState(() => _draft = d)),
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                if (_step > 0) ...[
                  CircleIconButton(
                    icon: LucideIcons.arrowLeft,
                    semanticLabel: l10n.actionBack,
                    size: 60,
                    onPressed: () => setState(() => _step--),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: PrimaryButton(
                    key: const ValueKey('onboarding-next'),
                    label: _step == _steps - 1 ? l10n.actionStart : l10n.actionContinue,
                    trailingArrow: true,
                    onPressed: _saving ? null : _next,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IncomeStep extends StatelessWidget {
  const new({required this.controller, required this.draft, required this.onChanged});

  final TextEditingController controller;
  final OnboardingDraft draft;
  final ValueChanged<OnboardingDraft> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SurfaceCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.onbIncomeLabel,
                style: PulseText.caption.copyWith(fontWeight: FontWeight.w600, color: c.muted),
              ),
              const SizedBox(height: 10),
              Semantics(
                label: l10n.onbIncomeLabel,
                child: IncomeField(
                  controller: controller,
                  onChanged: (m) => onChanged(draft.copyWith(income: m)),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: ShapeDecoration(
                  color: c.surface2,
                  shape: StadiumBorder(side: BorderSide(color: c.line)),
                ),
                child: Text(l10n.currencyEur, style: PulseText.caption.copyWith(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(l10n.onbPaydayQuestion, style: PulseText.label),
        const SizedBox(height: 10),
        PaydayPicker(
          value: draft.payday,
          onChanged: (p) => onChanged(draft.copyWith(payday: p)),
        ),
        const SizedBox(height: 10),
        Text(l10n.onbPaydayHelper, style: PulseText.caption.copyWith(color: c.muted)),
      ],
    );
  }
}

class _LimitsStep extends StatelessWidget {
  const new({required this.draft, required this.onStep});

  final OnboardingDraft draft;

  /// Applied to the latest draft by the parent, so quick taps never use a
  /// stale copy.
  final void Function(SuggestedCategory category, int direction) onStep;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final leftover = draft.leftover;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(Radii.cardSm),
            border: Border.all(color: c.line),
          ),
          child: Column(
            children: [
              for (final (i, s) in SuggestedCategory.values.indexed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    border: i == SuggestedCategory.values.length - 1 ? null : Border(bottom: BorderSide(color: c.line)),
                  ),
                  child: Row(
                    children: [
                      ColorDot(color: c.tint(s.color).ink),
                      const SizedBox(width: 12),
                      Expanded(child: Text(s.label(l10n), style: PulseText.title)),
                      _StepButton(
                        icon: LucideIcons.minus,
                        label: l10n.stepperDecrease(s.label(l10n)),
                        onTap: draft.limitOf(s).isPositive ? () => onStep(s, -1) : null,
                      ),
                      SizedBox(
                        width: 64,
                        child: Semantics(
                          liveRegion: true,
                          child: Text(
                            draft.limitOf(s).format(showCents: false),
                            textAlign: TextAlign.center,
                            style: PulseText.amount.copyWith(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      _StepButton(
                        icon: LucideIcons.plus,
                        label: l10n.stepperIncrease(s.label(l10n)),
                        onTap: () => onStep(s, 1),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Semantics(
          container: true,
          liveRegion: true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: leftover.isNegative ? c.coralSoft : c.accentSoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.onbLeftForSavings,
                    style: PulseText.label.copyWith(color: leftover.isNegative ? c.coralInk : c.accentInk),
                  ),
                ),
                Text(
                  leftover.format(showCents: false),
                  style: PulseText.amount.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: leftover.isNegative ? c.coralInk : c.accentInk,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const new({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      container: true,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        child: SizedBox.square(
          dimension: 44,
          child: Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 18, color: onTap == null ? c.muted : c.text),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountsStep extends StatelessWidget {
  const new({required this.draft, required this.onChanged});

  final OnboardingDraft draft;
  final ValueChanged<OnboardingDraft> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final type in AccountType.values)
              SizedBox(
                width: width,
                child: () {
                  final on = draft.accounts.contains(type);
                  return Semantics(
                    container: true,
                    button: true,
                    checked: on,
                    label: '${accountTypeLabel(type, l10n)}, ${accountTypeHint(type, l10n)}',
                    excludeSemantics: true,
                    child: Material(
                      color: on ? c.surface : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Radii.cardSm),
                        side: BorderSide(color: on ? c.text : c.line, width: 1.5),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(Radii.cardSm),
                        onTap: () {
                          final next = {...draft.accounts};
                          on ? next.remove(type) : next.add(type);
                          onChanged(draft.copyWith(accounts: next));
                        },
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 128),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconTile(icon: accountIcon(type), color: defaultAccountColor(type)),
                                    const Spacer(),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: on ? c.accent : null,
                                        border: Border.all(color: on ? c.accent : c.line, width: 1.5),
                                      ),
                                      child: on ? Icon(LucideIcons.check, size: 14, color: c.onAccent) : null,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  accountTypeLabel(type, l10n),
                                  style: PulseText.title.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  accountTypeHint(type, l10n),
                                  style: PulseText.small.copyWith(fontWeight: FontWeight.w500, color: c.muted),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }(),
              ),
          ],
        );
      },
    );
  }
}

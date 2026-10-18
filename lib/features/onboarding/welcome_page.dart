import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/theme/palette.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/hero_amount.dart';
import 'package:pulse/core/widgets/icon_tile.dart';
import 'package:pulse/core/widgets/mono_label.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';
import 'package:pulse/core/widgets/surface_card.dart';
import 'package:pulse/features/onboarding/onboarding_actions.dart';

/// First screen of a fresh install, before the onboarding steps: what the
/// app does, with a preview of Home.
class WelcomePage extends StatelessWidget {
  const new({required this.onStart, super.key});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    return PulseScaffold(
      body: Column(
        children: [
          // Scrolls on small screens and large text; the button stays put.
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(color: c.accent, shape: BoxShape.circle),
                              child: Icon(LucideIcons.activity, size: 20, color: c.onAccent),
                            ),
                            const SizedBox(width: 10),
                            Text(l10n.appTitle, style: PulseText.sectionTitle),
                          ],
                        ),
                        const Spacer(),
                        const SizedBox(height: 24),
                        const ExcludeSemantics(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [_HomePreview(), SizedBox(height: 10), _TxnPreview()],
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: 24),
                        Semantics(
                          header: true,
                          child: Text(l10n.onbWelcomeTitle, style: PulseText.screenTitle.copyWith(fontSize: 32)),
                        ),
                        const SizedBox(height: 10),
                        Text(l10n.onbWelcomeBody, style: PulseText.body.copyWith(color: c.muted, height: 1.5)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(LucideIcons.lock, size: 16, color: c.accentInk),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                l10n.onbWelcomePrivacy,
                                style: PulseText.caption.copyWith(fontWeight: FontWeight.w600, color: c.muted),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: PrimaryButton(
              key: const ValueKey('onboarding-welcome-start'),
              label: l10n.actionStart,
              trailingArrow: true,
              onPressed: onStart,
            ),
          ),
        ],
      ),
    );
  }
}

/// Illustrative Home summary with sample figures.
class _HomePreview extends StatelessWidget {
  const new();

  static const _shares = [30, 21, 18, 9, 4];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonoLabel(l10n.homeSpentLabel),
          const SizedBox(height: 6),
          const HeroAmount(amount: Money(105770), size: 56),
          const SizedBox(height: 6),
          Text(
            '${l10n.ofAmount(const Money(215000).format(showCents: false))} · ${l10n.daysLeft(14)}',
            style: PulseText.caption.copyWith(color: c.muted),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (final (i, s) in SuggestedCategory.values.indexed) ...[
                Expanded(
                  flex: _shares[i],
                  child: _Segment(color: c.tint(s.color).ink),
                ),
                const SizedBox(width: 4),
              ],
              Expanded(flex: 18, child: _Segment(color: c.rest)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: c.accent, borderRadius: BorderRadius.circular(18)),
            child: Row(
              children: [
                Icon(LucideIcons.clock, size: 18, color: c.onAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.homeTodayCanSpend,
                    style: PulseText.label.copyWith(fontWeight: FontWeight.w600, color: c.onAccent),
                  ),
                ),
                Text(
                  const Money(5300).format(showCents: false),
                  style: PulseText.amount.copyWith(fontSize: 20, fontWeight: FontWeight.w800, color: c.onAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A sample logged expense under the summary.
class _TxnPreview extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    const category = SuggestedCategory.groceries;
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          IconTile(icon: category.icon.icon, color: category.color, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.label(l10n), style: PulseText.title),
                const SizedBox(height: 2),
                Text('${l10n.dayToday} · 18:40', style: PulseText.caption.copyWith(color: c.muted)),
              ],
            ),
          ),
          Text('$kMinus${const Money(4280).format()}', style: PulseText.amount.copyWith(fontSize: 15)),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const new({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) =>
      Container(height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)));
}

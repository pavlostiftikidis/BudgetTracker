import 'package:flutter/material.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';

/// Big number with muted decimals and currency: "742" + ",30 €".
/// Scales down to fit narrow screens and large text.
class HeroAmount extends StatelessWidget {
  const new({required this.amount, this.size = 88, this.color, this.showCents = true, super.key});

  final Money amount;
  final double size;
  final Color? color;
  final bool showCents;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final parts = showCents ? amount.heroParts : null;
    final whole = parts?.whole ?? amount.formatPlain(showCents: false);
    final tail = parts == null ? ' €' : '${parts.decimals} €';
    return Semantics(
      label: amount.format(showCents: showCents),
      container: true,
      excludeSemantics: true,
      child: SizedBox(
        width: double.infinity,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                whole,
                textScaler: TextScaler.noScaling,
                style: PulseText.hero.copyWith(fontSize: size, letterSpacing: -size * 0.06, color: color ?? c.text),
              ),
              const SizedBox(width: 4),
              Text(
                tail,
                textScaler: TextScaler.noScaling,
                style: PulseText.heroDecimals.copyWith(fontSize: size * 0.36, color: c.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

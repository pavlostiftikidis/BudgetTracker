import 'package:flutter/material.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/empty_state.dart';

@immutable
class WeekBar {
  const new({required this.label, required this.value, this.today = false, this.future = false});

  final String label;
  final int value;
  final bool today;
  final bool future;
}

/// Seven bars: today in the accent, past days neutral, future days as a
/// dashed outline.
class WeekBars extends StatelessWidget {
  const new({required this.bars, required this.semanticLabel, this.maxBarHeight = 60, super.key});

  final List<WeekBar> bars;
  final String semanticLabel;
  final double maxBarHeight;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final max = bars.fold<int>(0, (m, b) => b.value > m ? b.value : m);
    return Semantics(
      label: semanticLabel,
      image: true,
      container: true,
      excludeSemantics: true,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: context.reduceMotion ? 1 : 0, end: 1),
        duration: context.motion(Motion.chart),
        curve: Motion.curve,
        builder: (context, t, _) => Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < bars.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (bars[i].future)
                      CustomPaint(
                        painter: DashedRRectPainter(color: c.line, radius: 8, dash: 4, gap: 3),
                        child: SizedBox(height: maxBarHeight - 4, width: double.infinity),
                      )
                    else
                      Container(
                        height: 8 + (maxBarHeight - 8) * (max == 0 ? 0 : bars[i].value / max) * t,
                        decoration: BoxDecoration(
                          color: bars[i].today ? c.accent : c.surface2,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      bars[i].label,
                      textScaler: TextScaler.noScaling,
                      style: PulseText.mono.copyWith(
                        fontSize: 11,
                        letterSpacing: 0,
                        color: bars[i].today ? c.text : c.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

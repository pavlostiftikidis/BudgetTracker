import 'package:flutter/material.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/empty_state.dart';

@immutable
class BarSlice {
  const new({required this.label, required this.value, required this.color, required this.percent});

  final String label;

  /// Relative size (cents).
  final int value;
  final Color color;

  /// Rounded share shown in the legend.
  final int percent;
}

/// Horizontal stacked bar of category shares, 4 px gaps, with a legend.
/// With no slices it draws a dashed placeholder.
class SegmentedSpendBar extends StatelessWidget {
  const new({required this.slices, required this.semanticLabel, this.height = 14, super.key});

  final List<BarSlice> slices;
  final String semanticLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (slices.isEmpty) {
      return CustomPaint(
        painter: DashedRRectPainter(color: c.line, radius: 4),
        child: SizedBox(height: height, width: double.infinity),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: semanticLabel,
          image: true,
          container: true,
          excludeSemantics: true,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: context.reduceMotion ? 1 : 0, end: 1),
            duration: context.motion(Motion.chart),
            curve: Motion.curve,
            builder: (context, t, _) => CustomPaint(
              size: Size(double.infinity, height),
              painter: _BarPainter(slices: slices, progress: t, radius: 4, gap: 4),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ExcludeSemantics(
          child: Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              for (final s in slices)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      s.label,
                      style: PulseText.small.copyWith(fontWeight: FontWeight.w500, color: c.muted),
                    ),
                    const SizedBox(width: 4),
                    Text('${s.percent}%', style: PulseText.small.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BarPainter extends CustomPainter {
  new({required this.slices, required this.progress, required this.radius, required this.gap});

  final List<BarSlice> slices;
  final double progress;
  final double radius;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final total = slices.fold<int>(0, (a, s) => a + s.value);
    if (total <= 0) return;
    final available = (size.width - gap * (slices.length - 1)) * progress;
    var x = 0.0;
    for (final s in slices) {
      final w = available * s.value / total;
      if (w > 0.5) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(x, 0, w, size.height), Radius.circular(radius)),
          Paint()..color = s.color,
        );
      }
      x += w + gap * progress;
    }
  }

  @override
  bool shouldRepaint(_BarPainter old) => old.progress != progress || old.slices != slices;
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';

/// Circular progress with round caps. [value] is 0–1 (larger values draw a
/// full ring). Animates from empty on first build.
class ProgressRing extends StatelessWidget {
  const new({
    required this.value,
    required this.color,
    this.size = 64,
    this.stroke = 7,
    this.track,
    this.child,
    super.key,
  });

  final double value;
  final Color color;
  final double size;
  final double stroke;
  final Color? track;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final target = value.clamp(0.0, 1.0);
    return SizedBox.square(
      dimension: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: context.reduceMotion ? target : 0, end: target),
        duration: context.motion(Motion.chart),
        curve: Motion.curve,
        builder: (context, v, child) => CustomPaint(
          painter: _RingPainter(value: v, color: color, track: track ?? context.colors.surface2, stroke: stroke),
          child: child,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  new({required this.value, required this.color, required this.track, required this.stroke});

  final double value;
  final Color color;
  final Color track;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arc = rect.deflate(stroke / 2);
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arc, 0, math.pi * 2, false, base..color = track);
    if (value <= 0) return;
    canvas.drawArc(arc, -math.pi / 2, math.pi * 2 * value, false, base..color = color);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.color != color || old.track != track || old.stroke != stroke;
}

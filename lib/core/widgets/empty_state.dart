import 'package:flutter/material.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';

/// Icon, title and an optional body, centred in a dashed card.
class EmptyState extends StatelessWidget {
  const new({required this.icon, required this.title, this.body, this.action, this.dashed = true, super.key});

  final IconData icon;
  final String title;
  final String? body;
  final Widget? action;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: c.muted, size: 22),
          ),
          const SizedBox(height: 12),
          Text(title, textAlign: TextAlign.center, style: PulseText.title),
          if (body != null) ...[
            const SizedBox(height: 4),
            Text(
              body!,
              textAlign: TextAlign.center,
              style: PulseText.caption.copyWith(color: c.muted),
            ),
          ],
          if (action != null) ...[const SizedBox(height: 14), action!],
        ],
      ),
    );
    if (!dashed) return content;
    return CustomPaint(
      painter: DashedRRectPainter(color: c.line, radius: Radii.cardSm),
      child: SizedBox(width: double.infinity, child: content),
    );
  }
}

/// Dashed rounded-rectangle outline (empty states, "Νέα κατηγορία" card,
/// future-day bars).
class DashedRRectPainter extends CustomPainter {
  const new({required this.color, required this.radius, this.strokeWidth = 1.5, this.dash = 6, this.gap = 5});

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final path = Path()..addRRect(RRect.fromRectAndRadius(rect.deflate(strokeWidth / 2), Radius.circular(radius)));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + dash), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(DashedRRectPainter old) =>
      old.color != color || old.radius != radius || old.strokeWidth != strokeWidth;
}

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The app icon drawn in code: the dark rounded tile, the lime ring at 75%
/// and the wallet. Fixed colours, so it reads as the same icon in both themes.
class AppMark extends StatelessWidget {
  const new({this.size = 40, super.key});

  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size.square(size), painter: const AppMarkPainter(tile: true));
}

/// The app icon on its 1024 grid, as in the site's `app/icon.svg` and
/// `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png`;
/// keep them in step. [sweep], [dot] and [beat] let the splash build it up.
class AppMarkPainter extends CustomPainter {
  const new({this.tile = false, this.sweep = 1, this.dot = 1, this.beat = 0});

  static const bg = Color(0xFF0B0C0E);
  static const track = Color(0xFF22262D);
  static const accent = Color(0xFFC6F36B);
  static const ink = Color(0xFFF2F3F5);

  /// Paints the rounded tile behind the mark (radius 230).
  final bool tile;

  /// 0–1 of the ring's 75% arc.
  final double sweep;

  /// Scale of the lime dot (overshoots 1 slightly as it pops).
  final double dot;

  /// 0–1 through the ripple; neither end draws it.
  final double beat;

  @override
  void paint(Canvas canvas, Size size) {
    final u = size.width / 1024;
    final centre = size.center(Offset.zero);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (tile) {
      canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(230 * u)), Paint()..color = bg);
    }

    if (beat > 0 && beat < 1) {
      canvas.drawCircle(
        centre,
        (300 + 160 * beat) * u,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 96 * u * (1 - beat)
          ..color = accent.withValues(alpha: 0.45 * (1 - beat)),
      );
    }

    // Ring: radius 300, stroke 96; a full track and the arc from 12 o'clock.
    final ring = Rect.fromCircle(center: centre, radius: 300 * u);
    canvas.drawArc(
      ring,
      0,
      math.pi * 2,
      false,
      stroke
        ..strokeWidth = 96 * u
        ..color = track,
    );
    if (sweep > 0) canvas.drawArc(ring, -math.pi / 2, math.pi * 1.5 * sweep, false, stroke..color = accent);

    // Wallet: a 280×200 body and a clasp open on its right edge, stroked 32,
    // and the dot.
    stroke
      ..strokeWidth = 32 * u
      ..color = ink;
    final clasp = Path()
      ..moveTo(652 * u, 474 * u)
      ..lineTo(566 * u, 474 * u)
      ..arcToPoint(Offset(540 * u, 500 * u), radius: Radius.circular(26 * u), clockwise: false)
      ..lineTo(540 * u, 524 * u)
      ..arcToPoint(Offset(566 * u, 550 * u), radius: Radius.circular(26 * u), clockwise: false)
      ..lineTo(652 * u, 550 * u);
    canvas
      ..drawRRect(RRect.fromLTRBR(372 * u, 412 * u, 652 * u, 612 * u, Radius.circular(48 * u)), stroke)
      ..drawPath(clasp, stroke);
    if (dot > 0) canvas.drawCircle(Offset(582 * u, 512 * u), 14 * u * dot, Paint()..color = accent);
  }

  @override
  bool shouldRepaint(AppMarkPainter old) =>
      old.tile != tile || old.sweep != sweep || old.dot != dot || old.beat != beat;
}

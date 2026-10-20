import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pulse/core/theme/pulse_colors.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/app_mark.dart';

/// Cold-start splash: the app icon builds itself. The wallet settles in, the
/// lime ring sweeps to 75% like a progress ring, the dot pops, one pulse
/// ripples out, and the splash fades into the app once [ready] is true.
///
/// [child] is built underneath the whole time, so it keeps its state when the
/// splash goes. The splash is always dark, like the icon and the native launch
/// screen before it. With reduced motion the finished icon shows until [ready]
/// and then goes at once.
class StartupSplash extends StatefulWidget {
  const new({required this.ready, required this.child, super.key});

  final bool ready;
  final Widget child;

  @override
  State<StartupSplash> createState() => _StartupSplashState();
}

class _StartupSplashState extends State<StartupSplash> with TickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))
    ..addStatusListener((_) => _maybeExit());
  late final AnimationController _exit = AnimationController(vsync: this, duration: Motion.normal)
    ..addStatusListener((status) {
      if (status.isCompleted) setState(() => _gone = true);
    });
  bool _reduceMotion = false;
  bool _gone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = context.reduceMotion;
    if (!_intro.isDismissed) return;
    if (_reduceMotion) {
      _intro.value = 1;
    } else {
      _intro.forward();
    }
  }

  @override
  void didUpdateWidget(StartupSplash old) {
    super.didUpdateWidget(old);
    _maybeExit();
  }

  /// Leaves once startup is done and the intro has played to the end.
  void _maybeExit() {
    if (_gone || !widget.ready || !_intro.isCompleted || !_exit.isDismissed) return;
    if (_reduceMotion) {
      setState(() => _gone = true);
    } else {
      _exit.forward();
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    _exit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ExcludeSemantics(excluding: !_gone, child: widget.child),
        if (!_gone)
          FadeTransition(
            opacity: ReverseAnimation(_exit),
            child: ColoredBox(
              key: const ValueKey('startup-splash'),
              color: PulseColors.dark.bg,
              child: Center(
                child: Semantics(
                  label: context.l10n.appTitle,
                  image: true,
                  child: AnimatedBuilder(animation: _intro, builder: (context, _) => _icon(_intro.value)),
                ),
              ),
            ),
          ),
      ],
    );
  }

  static const _appear = Interval(0, 0.25, curve: Motion.curve);
  static const _sweep = Interval(0.12, 0.68, curve: Curves.easeInOutCubic);
  static const _dot = Interval(0.6, 0.82, curve: Curves.easeOutBack);
  static const _beat = Interval(0.7, 1, curve: Curves.easeOut);

  Widget _icon(double t) {
    final appear = _appear.transform(t);
    final beat = _beat.transform(t);
    return Opacity(
      opacity: appear,
      child: Transform.scale(
        scale: (0.86 + 0.14 * appear) * (1 + 0.04 * math.sin(math.pi * beat)),
        child: CustomPaint(
          size: const Size.square(240),
          painter: AppMarkPainter(sweep: _sweep.transform(t), dot: _dot.transform(t), beat: beat),
        ),
      ),
    );
  }
}

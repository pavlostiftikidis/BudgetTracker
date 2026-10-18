import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';

/// 48×30 pill switch: lime track with a dark knob when on.
/// The hit area is 48×44.
class PulseSwitch extends StatelessWidget {
  const new({required this.value, required this.onChanged, required this.semanticLabel, super.key});

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final duration = context.motion(Motion.fast);
    return Semantics(
      toggled: value,
      enabled: onChanged != null,
      label: semanticLabel,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged == null
            ? null
            : () {
                unawaited(HapticFeedback.selectionClick());
                onChanged!(!value);
              },
        child: SizedBox(
          width: 52,
          height: 44,
          child: Center(
            child: AnimatedContainer(
              duration: duration,
              curve: Motion.curve,
              width: 48,
              height: 30,
              padding: const EdgeInsets.all(3),
              decoration: ShapeDecoration(color: value ? c.accent : c.line, shape: const StadiumBorder()),
              child: AnimatedAlign(
                duration: duration,
                curve: Motion.curve,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: value ? c.onAccent : (c.isDark ? c.muted : c.surface),
                    boxShadow: c.isDark || value ? null : [BoxShadow(color: c.shadow, blurRadius: 4)],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

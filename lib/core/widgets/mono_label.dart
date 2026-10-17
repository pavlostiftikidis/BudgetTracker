import 'package:flutter/material.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';

/// Small uppercase JetBrains Mono label ("ΥΠΟΛΟΙΠΟ ΜΗΝΑ").
class MonoLabel extends StatelessWidget {
  const new(this.text, {this.color, super.key});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: PulseText.mono.copyWith(color: color ?? context.colors.muted));
  }
}

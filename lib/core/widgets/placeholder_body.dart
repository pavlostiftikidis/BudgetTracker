import 'package:flutter/material.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';

/// Temporary body for screens that are not built yet.
class PlaceholderBody extends StatelessWidget {
  const new({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.l10n.placeholderScreen(name), style: PulseText.body.copyWith(color: context.colors.muted)),
    );
  }
}

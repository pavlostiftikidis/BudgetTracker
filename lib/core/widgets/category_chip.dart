import 'package:flutter/material.dart';
import 'package:pulse/core/theme/palette.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';

/// Selectable pill with a colour square: "■ Εστίαση".
class CategoryChip extends StatelessWidget {
  const new({required this.label, required this.color, required this.selected, required this.onTap, super.key});

  final String label;
  final ColorKey color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      excludeSemantics: true,
      label: label,
      child: Material(
        color: selected ? c.surface2 : Colors.transparent,
        shape: StadiumBorder(side: BorderSide(color: selected ? c.text : c.line, width: 1.5)),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: AnimatedContainer(
            duration: context.motion(Motion.fast),
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: c.tint(color).ink, borderRadius: BorderRadius.circular(3)),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: PulseText.label.copyWith(color: selected ? c.text : c.muted),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

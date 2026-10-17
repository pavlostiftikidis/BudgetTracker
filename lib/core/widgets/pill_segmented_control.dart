import 'package:flutter/material.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';

@immutable
class Segment<T> {
  const new({required this.value, required this.label});

  final T value;
  final String label;
}

/// Rounded track with equal-width segments; the selected one is filled with
/// the text colour.
class PillSegmentedControl<T> extends StatelessWidget {
  const new({
    required this.segments,
    required this.selected,
    required this.onChanged,
    required this.semanticLabel,
    super.key,
  });

  final List<Segment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      container: true,
      label: semanticLabel,
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.all(4),
        decoration: ShapeDecoration(
          color: c.surface,
          shape: StadiumBorder(side: BorderSide(color: c.line)),
        ),
        child: Row(
          children: [
            for (final s in segments)
              Expanded(
                child: Semantics(
                  button: true,
                  selected: s.value == selected,
                  inMutuallyExclusiveGroup: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onChanged(s.value),
                    child: AnimatedContainer(
                      duration: context.motion(Motion.fast),
                      curve: Motion.curve,
                      constraints: const BoxConstraints(minHeight: 34),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: ShapeDecoration(
                        color: s.value == selected ? c.text : c.text.withValues(alpha: 0),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        s.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: PulseText.label.copyWith(
                          color: s.value == selected ? c.bg : c.muted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

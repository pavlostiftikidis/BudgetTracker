import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';

/// Modal bottom sheet with the Pulse shape (radius 32, 40×5 handle) that
/// grows with its content and lifts above the keyboard.
Future<T?> showPulseSheet<T>(BuildContext context, {required WidgetBuilder builder}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    sheetAnimationStyle: context.reduceMotion
        ? AnimationStyle.noAnimation
        : const AnimationStyle(duration: Duration(milliseconds: 240), reverseDuration: Duration(milliseconds: 200)),
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: builder(context),
    ),
  );
}

/// Title row for a sheet, with an optional trailing widget.
class SheetHeader extends StatelessWidget {
  const new({required this.title, this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Semantics(header: true, child: Text(title, style: PulseText.screenTitle.copyWith(fontSize: 22))),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Selectable row used by account / category pickers.
class PickerRow extends StatelessWidget {
  const new({
    required this.title,
    required this.selected,
    required this.onTap,
    this.leading,
    this.trailingText,
    this.trailingColor,
    super.key,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;
  final String? trailingText;
  final Color? trailingColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      selected: selected,
      button: true,
      inMutuallyExclusiveGroup: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 12)],
                Expanded(child: Text(title, style: PulseText.title)),
                if (trailingText != null)
                  Text(
                    trailingText!,
                    style: PulseText.caption.copyWith(color: trailingColor ?? c.muted, fontFeatures: PulseText.tabular),
                  ),
                const SizedBox(width: 10),
                SizedBox(width: 22, child: selected ? Icon(LucideIcons.check, size: 20, color: c.accentInk) : null),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small coloured square used next to category / account names.
class ColorDot extends StatelessWidget {
  const new({required this.color, this.size = 10, super.key});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(size * 0.3)),
    );
  }
}

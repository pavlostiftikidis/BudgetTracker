import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';

@immutable
class PillNavItem {
  const new({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Rounded pill floating above the content. The active tab is a filled pill
/// with icon and label; the others are icon-only. The trailing lime circle
/// opens "Νέα κίνηση".
class FloatingPillNav extends StatelessWidget {
  const new({required this.items, required this.currentIndex, required this.onSelect, required this.onAdd, super.key});

  final List<PillNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: context.l10n.mainNavigation,
      child: Container(
        height: 68,
        padding: const EdgeInsets.only(left: 10, right: 8),
        decoration: BoxDecoration(
          color: c.nav,
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: c.line),
          boxShadow: [BoxShadow(color: c.shadow, blurRadius: 32, offset: const Offset(0, 12))],
        ),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              Flexible(
                flex: i == currentIndex ? 3 : 1,
                child: Align(
                  alignment: i == currentIndex ? AlignmentDirectional.centerStart : Alignment.center,
                  child: _NavTab(item: items[i], active: i == currentIndex, onTap: () => onSelect(i)),
                ),
              ),
            ],
            _AddButton(onTap: onAdd, label: context.l10n.navAdd),
          ],
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const new({required this.item, required this.active, required this.onTap});

  final PillNavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = active ? c.bg : c.muted;
    final tab = Semantics(
      button: true,
      selected: active,
      label: item.label,
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: AnimatedContainer(
            duration: context.motion(Motion.normal),
            curve: Motion.curve,
            height: 48,
            constraints: const BoxConstraints(minWidth: 48),
            padding: EdgeInsets.symmetric(horizontal: active ? 16 : 0),
            decoration: ShapeDecoration(
              color: active ? c.text : c.text.withValues(alpha: 0),
              shape: const StadiumBorder(),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, size: active ? 20 : 22, color: fg),
                if (active) ...[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: PulseText.label.copyWith(color: fg),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    return active ? tab : Tooltip(message: item.label, child: tab);
  }
}

class _AddButton extends StatelessWidget {
  const new({required this.onTap, required this.label});

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        message: label,
        child: Material(
          color: c.accent,
          shape: const CircleBorder(),
          child: InkWell(
            key: const ValueKey('nav-add'),
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox.square(dimension: 52, child: Icon(LucideIcons.plus, size: 24, color: c.onAccent)),
          ),
        ),
      ),
    );
  }
}

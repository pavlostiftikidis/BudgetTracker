import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';

/// Shares "which tile is open" across a list so opening one closes the rest.
class SwipeGroup extends ValueNotifier<Object?> {
  new() : super(null);
}

/// Row that slides left to reveal "Επεξ." (sky) and "Διαγραφή" (coral),
/// 70 px each. Screen-reader users get both as custom actions.
class SwipeableTxnTile extends StatefulWidget {
  const new({
    required this.id,
    required this.child,
    required this.semanticLabel,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.group,
    super.key,
  });

  final Object id;
  final Widget child;
  final String semanticLabel;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final SwipeGroup? group;

  static const double actionWidth = 70;
  static const double height = 68;

  @override
  State<SwipeableTxnTile> createState() => _SwipeableTxnTileState();
}

class _SwipeableTxnTileState extends State<SwipeableTxnTile> {
  static const double _gap = 6;
  static const double _open = -(SwipeableTxnTile.actionWidth * 2 + _gap * 3);

  double _offset = 0;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    widget.group?.addListener(_onGroup);
  }

  @override
  void didUpdateWidget(covariant SwipeableTxnTile old) {
    super.didUpdateWidget(old);
    if (old.group != widget.group) {
      old.group?.removeListener(_onGroup);
      widget.group?.addListener(_onGroup);
    }
  }

  @override
  void dispose() {
    widget.group?.removeListener(_onGroup);
    super.dispose();
  }

  void _onGroup() {
    if (widget.group?.value != widget.id && _offset != 0) setState(() => _offset = 0);
  }

  void _settle({required bool open}) {
    setState(() {
      _dragging = false;
      _offset = open ? _open : 0;
    });
    if (open) {
      unawaited(HapticFeedback.selectionClick());
      widget.group?.value = widget.id;
    } else if (widget.group?.value == widget.id) {
      widget.group?.value = null;
    }
  }

  void _run(VoidCallback action) {
    _settle(open: false);
    action();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final radius = BorderRadius.circular(20);
    return Semantics(
      container: true,
      button: true,
      label: widget.semanticLabel,
      customSemanticsActions: {
        CustomSemanticsAction(label: l10n.actionEditShort): widget.onEdit,
        CustomSemanticsAction(label: l10n.actionDelete): widget.onDelete,
      },
      onTap: widget.onTap,
      excludeSemantics: true,
      child: SizedBox(
        height: SwipeableTxnTile.height,
        child: ClipRRect(
          borderRadius: radius,
          child: Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: c.surface2)),
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(_gap),
                  child: Row(
                    children: [
                      _Action(
                        label: l10n.actionEditShort,
                        icon: LucideIcons.pencil,
                        color: c.sky,
                        onTap: () => _run(widget.onEdit),
                      ),
                      const SizedBox(width: _gap),
                      _Action(
                        label: l10n.actionDelete,
                        icon: LucideIcons.trash2,
                        color: c.coral,
                        onTap: () => _run(widget.onDelete),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: _dragging ? Duration.zero : context.motion(Motion.normal),
                curve: Motion.curve,
                top: 0,
                bottom: 0,
                left: _offset,
                right: -_offset,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _offset != 0 ? _settle(open: false) : widget.onTap(),
                  onHorizontalDragStart: (_) => setState(() => _dragging = true),
                  onHorizontalDragUpdate: (d) => setState(() => _offset = (_offset + d.delta.dx).clamp(_open - 24, 0)),
                  onHorizontalDragEnd: (d) {
                    final fling = d.primaryVelocity ?? 0;
                    _settle(open: fling < -300 || (fling <= 300 && _offset < _open / 2));
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: radius,
                      border: Border.all(color: c.line),
                    ),
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14), child: widget.child),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const new({required this.label, required this.icon, required this.color, required this.onTap});

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = context.colors.onAccent;
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: SizedBox(
          width: SwipeableTxnTile.actionWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                textScaler: TextScaler.noScaling,
                style: PulseText.small.copyWith(fontSize: 11, fontWeight: FontWeight.w800, color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

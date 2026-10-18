import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/buttons.dart';

/// Back (or close) button, screen title and optional trailing actions.
class PageHeader extends StatelessWidget {
  const new({required this.title, this.trailing = const [], this.close = false, this.onBack, super.key});

  final String title;
  final List<Widget> trailing;

  /// Shows an × instead of a back chevron.
  final bool close;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          CircleIconButton(
            icon: close ? LucideIcons.x : LucideIcons.chevronLeft,
            semanticLabel: close ? l10n.actionClose : l10n.actionBack,
            onPressed: onBack ?? () => context.canPop() ? context.pop() : context.go('/home'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Semantics(header: true, child: Text(title, style: PulseText.screenTitle.copyWith(fontSize: 24))),
          ),
          for (final w in trailing) ...[const SizedBox(width: 8), w],
        ],
      ),
    );
  }
}

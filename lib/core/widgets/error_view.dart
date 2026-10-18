import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/empty_state.dart';

/// Friendly failure state with a retry. Debug builds also show the error.
class ErrorView extends StatelessWidget {
  const new({required this.error, required this.onRetry, super.key});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: EmptyState(
          icon: LucideIcons.triangleAlert,
          title: l10n.errorTitle,
          body: kDebugMode ? '${l10n.errorBody}\n\n$error' : l10n.errorBody,
          action: OutlineButtonPill(icon: LucideIcons.rotateCcw, label: l10n.actionRetry, onPressed: onRetry),
        ),
      ),
    );
  }
}

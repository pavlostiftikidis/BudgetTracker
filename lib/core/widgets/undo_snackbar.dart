import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';

/// How long the undo toast stays up.
const Duration kUndoDuration = Duration(seconds: 5);

/// Pill toast "Διαγράφηκε: {name}" with a lime "Αναίρεση" button.
void showUndoSnackbar(
  BuildContext context, {
  required String name,
  required VoidCallback onUndo,
  double bottomMargin = 24,
}) => undoSnackbarPresenter(context, name: name, onUndo: onUndo, bottomMargin: bottomMargin)();

/// Captures everything it needs from [context] now and returns a function
/// that shows the toast later, even after the calling route has popped.
VoidCallback undoSnackbarPresenter(
  BuildContext context, {
  required String name,
  required VoidCallback onUndo,
  double bottomMargin = 24,
}) {
  final c = context.colors;
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  return () => messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: kUndoDuration,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(20, 0, 20, bottomMargin),
        padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
        backgroundColor: c.text,
        shape: const StadiumBorder(),
        elevation: 6,
        content: Row(
          children: [
            Icon(LucideIcons.trash2, size: 18, color: c.bg),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.deletedToast(name),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: PulseText.label.copyWith(color: c.bg),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: c.accent,
              shape: const StadiumBorder(),
              child: InkWell(
                customBorder: const StadiumBorder(),
                onTap: () {
                  messenger.hideCurrentSnackBar(reason: SnackBarClosedReason.action);
                  onUndo();
                },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    child: Text(
                      l10n.actionUndo,
                      style: PulseText.label.copyWith(color: c.onAccent, fontWeight: FontWeight.w800),
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

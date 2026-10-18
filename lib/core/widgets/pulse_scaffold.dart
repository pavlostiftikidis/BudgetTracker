import 'package:flutter/material.dart';
import 'package:pulse/core/utils/context_ext.dart';

/// Themed page: background, safe area and, optionally, the floating nav
/// pinned 24 px above the bottom inset.
class PulseScaffold extends StatelessWidget {
  const new({
    required this.body,
    this.floatingNav,
    this.floatingAction,
    this.safeBottom = true,
    this.resizeToAvoidBottomInset = true,
    super.key,
  });

  /// Height of the nav pill plus its offset and some breathing room; screens
  /// inside the shell pad their scroll views by this much.
  static const double navClearance = 68 + 24 + 20;

  static double bottomClearance(BuildContext context) => navClearance + MediaQuery.paddingOf(context).bottom;

  final Widget body;
  final Widget? floatingNav;

  /// Pinned above the nav position (e.g. "Νέο επαναλαμβανόμενο").
  final Widget? floatingAction;
  final bool safeBottom;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: context.colors.bg,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(bottom: safeBottom && floatingNav == null, child: body),
          ),
          if (floatingAction != null) Positioned(left: 20, right: 20, bottom: 24 + bottomInset, child: floatingAction!),
          if (floatingNav != null) Positioned(left: 20, right: 20, bottom: 24 + bottomInset, child: floatingNav!),
        ],
      ),
    );
  }
}

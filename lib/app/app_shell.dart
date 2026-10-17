import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/app/router.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/floating_pill_nav.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';

/// Hosts the three bottom-nav branches under the floating pill.
class AppShell extends StatelessWidget {
  const new({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PulseScaffold(
      resizeToAvoidBottomInset: false,
      body: shell,
      floatingNav: FloatingPillNav(
        currentIndex: shell.currentIndex,
        items: [
          PillNavItem(icon: LucideIcons.house, label: l10n.navHome),
          PillNavItem(icon: LucideIcons.chartColumn, label: l10n.navInsights),
          PillNavItem(icon: LucideIcons.chartPie, label: l10n.navBudgets),
        ],
        onSelect: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        onAdd: () => context.push(Routes.add),
      ),
    );
  }
}

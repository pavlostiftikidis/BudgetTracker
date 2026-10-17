import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/app/router.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/mono_label.dart';

class HomeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      children: [
        Row(
          children: [
            const Spacer(),
            CircleIconButton(
              icon: LucideIcons.settings,
              semanticLabel: l10n.navMore,
              onPressed: () => context.push(Routes.settings),
            ),
            const SizedBox(width: 8),
            const ThemeToggleButton(),
          ],
        ),
        const SizedBox(height: 22),
        MonoLabel(l10n.homeBalanceLabel),
        const SizedBox(height: 6),
        Text(l10n.navHome, style: PulseText.screenTitle),
      ],
    );
  }
}

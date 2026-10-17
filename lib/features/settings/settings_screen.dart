import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/app/app_providers.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/page_header.dart';
import 'package:pulse/core/widgets/pill_segmented_control.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';

class SettingsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final mode = ref.watch(themeModeControllerProvider);
    return PulseScaffold(
      body: ListView(
        children: [
          PageHeader(title: l10n.settingsTitle),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.settingsTheme, style: PulseText.title),
                const SizedBox(height: 10),
                PillSegmentedControl<ThemeMode>(
                  semanticLabel: l10n.settingsTheme,
                  selected: mode,
                  onChanged: ref.read(themeModeControllerProvider.notifier).set,
                  segments: [
                    Segment(value: ThemeMode.system, label: l10n.themeSystem),
                    Segment(value: ThemeMode.dark, label: l10n.themeDark),
                    Segment(value: ThemeMode.light, label: l10n.themeLight),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

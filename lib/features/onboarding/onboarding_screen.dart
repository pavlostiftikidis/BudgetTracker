import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/app/app_providers.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';

class OnboardingScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return PulseScaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.onbIncomeTitle, style: PulseText.screenTitle),
            const Spacer(),
            PrimaryButton(
              label: l10n.actionStart,
              onPressed: () => ref.read(onboardingDoneProvider.notifier).set(done: true),
            ),
          ],
        ),
      ),
    );
  }
}

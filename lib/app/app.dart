import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/app/app_providers.dart';
import 'package:pulse/app/router.dart';
import 'package:pulse/app/startup.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/widgets/error_view.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/features/settings/app_lock.dart';
import 'package:pulse/l10n/app_localizations.dart';

class PulseApp extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<PulseApp> createState() => _PulseAppState();
}

class _PulseAppState extends ConsumerState<PulseApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Recurring occurrences that fell due while the app was in the
    // background become transactions on resume.
    _lifecycle = AppLifecycleListener(onResume: () => ref.read(recurringRepositoryProvider).materializeDue());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeControllerProvider);
    final router = ref.watch(routerProvider);
    final ready = ref.watch(appStartupProvider);
    return MaterialApp.router(
      title: 'Pulse',
      debugShowCheckedModeBanner: false,
      theme: PulseTheme.light(),
      darkTheme: PulseTheme.dark(),
      themeMode: themeMode,
      themeAnimationDuration: const Duration(milliseconds: 220),
      themeAnimationCurve: Curves.easeOut,
      locale: const Locale('el', 'GR'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,
        child: switch (ready) {
          AsyncData() => AppLockGate(child: child ?? const SizedBox.shrink()),
          AsyncError(:final error) => _StartupError(error: error),
          _ => ColoredBox(color: Theme.of(context).scaffoldBackgroundColor),
        },
      ),
    );
  }
}

class _StartupError extends ConsumerWidget {
  const new({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ErrorView(error: error, onRetry: () => ref.invalidate(appStartupProvider)),
    );
  }
}

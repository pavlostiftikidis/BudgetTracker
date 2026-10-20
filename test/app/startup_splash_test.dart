import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/app/splash.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/l10n/app_localizations.dart';

/// Stands in for the app under the splash; counts how often it is mounted.
class _Probe extends StatefulWidget {
  const new();

  static int mounts = 0;

  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> {
  @override
  void initState() {
    super.initState();
    _Probe.mounts++;
  }

  @override
  Widget build(BuildContext context) => const Center(child: Text('app'));
}

void main() {
  final splash = find.byKey(const ValueKey('startup-splash'));

  setUp(() => _Probe.mounts = 0);

  Widget host({required bool ready}) => MaterialApp(
    theme: PulseTheme.dark(),
    locale: const Locale('el'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: StartupSplash(ready: ready, child: const _Probe()),
  );

  testWidgets('plays, waits for startup, then fades into the same app', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(host(ready: false));
    expect(splash, findsOneWidget);
    expect(find.bySemanticsLabel('Pulse'), findsOneWidget);
    expect(find.bySemanticsLabel('app'), findsNothing);

    // The intro is over but startup is not: the icon stays.
    await tester.pump(const Duration(seconds: 3));
    expect(splash, findsOneWidget);
    expect(tester.hasRunningAnimations, isFalse);

    await tester.pumpWidget(host(ready: true));
    await tester.pumpAndSettle();
    expect(splash, findsNothing);
    expect(find.bySemanticsLabel('app'), findsOneWidget);
    expect(_Probe.mounts, 1);
    semantics.dispose();
  });

  testWidgets('a fast startup still sees the whole intro', (tester) async {
    await tester.pumpWidget(host(ready: true));
    await tester.pump(const Duration(milliseconds: 900));
    expect(splash, findsOneWidget);

    await tester.pumpAndSettle();
    expect(splash, findsNothing);
  });

  testWidgets('with reduced motion the icon is static and leaves as soon as startup is done', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await tester.pumpWidget(host(ready: false));
    expect(splash, findsOneWidget);
    expect(tester.hasRunningAnimations, isFalse);

    await tester.pumpWidget(host(ready: true));
    expect(splash, findsNothing);
    expect(_Probe.mounts, 1);
  });
}

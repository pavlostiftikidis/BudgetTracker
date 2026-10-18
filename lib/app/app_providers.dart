import 'package:flutter/material.dart';
import 'package:pulse/data/prefs/app_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_providers.g.dart';

/// Overridden in `main` (and in tests) with a ready instance.
@Riverpod(keepAlive: true)
AppPrefs appPrefs(Ref ref) => throw UnimplementedError('appPrefsProvider must be overridden');

@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  ThemeMode build() => ref.watch(appPrefsProvider).themeMode;

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref.read(appPrefsProvider).setThemeMode(mode);
  }

  /// Flips between dark and light based on what is on screen now.
  Future<void> toggle(Brightness current) => set(current == Brightness.dark ? ThemeMode.light : ThemeMode.dark);
}

@Riverpod(keepAlive: true)
class OnboardingDone extends _$OnboardingDone {
  @override
  bool build() => ref.watch(appPrefsProvider).onboardingDone;

  Future<void> set({required bool done}) async {
    await ref.read(appPrefsProvider).setOnboardingDone(done: done);
    state = done;
  }
}

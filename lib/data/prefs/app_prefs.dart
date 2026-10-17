import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Small synchronous preferences needed before the database opens.
abstract interface class AppPrefs {
  ThemeMode get themeMode;
  Future<void> setThemeMode(ThemeMode mode);

  bool get onboardingDone;
  Future<void> setOnboardingDone({required bool done});
}

class SharedAppPrefs implements AppPrefs {
  new(this._prefs);

  static const _themeKey = 'theme_mode';
  static const _onboardingKey = 'onboarding_done';

  final SharedPreferences _prefs;

  @override
  ThemeMode get themeMode => ThemeMode.values.asNameMap()[_prefs.getString(_themeKey)] ?? ThemeMode.dark;

  @override
  Future<void> setThemeMode(ThemeMode mode) => _prefs.setString(_themeKey, mode.name);

  @override
  bool get onboardingDone => _prefs.getBool(_onboardingKey) ?? false;

  @override
  Future<void> setOnboardingDone({required bool done}) => _prefs.setBool(_onboardingKey, done);
}

/// In-memory implementation for tests and previews.
class MemoryAppPrefs implements AppPrefs {
  new({this.themeMode = ThemeMode.dark, this.onboardingDone = false});

  @override
  ThemeMode themeMode;

  @override
  bool onboardingDone;

  @override
  Future<void> setThemeMode(ThemeMode mode) async => themeMode = mode;

  @override
  Future<void> setOnboardingDone({required bool done}) async => onboardingDone = done;
}

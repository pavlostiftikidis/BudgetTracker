import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/app/app.dart';
import 'package:pulse/app/app_providers.dart';
import 'package:pulse/app/bootstrap.dart';
import 'package:pulse/data/prefs/app_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocale();
  registerFontLicenses();
  final prefs = SharedAppPrefs(await SharedPreferences.getInstance());

  runApp(
    ProviderScope(
      overrides: [appPrefsProvider.overrideWithValue(prefs)],
      child: const PulseApp(),
    ),
  );
}

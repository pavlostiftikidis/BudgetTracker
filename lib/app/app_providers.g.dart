// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Overridden in `main` (and in tests) with a ready instance.

@ProviderFor(appPrefs)
final appPrefsProvider = AppPrefsProvider._();

/// Overridden in `main` (and in tests) with a ready instance.

final class AppPrefsProvider extends $FunctionalProvider<AppPrefs, AppPrefs, AppPrefs> with $Provider<AppPrefs> {
  /// Overridden in `main` (and in tests) with a ready instance.
  AppPrefsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPrefsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPrefsHash();

  @$internal
  @override
  $ProviderElement<AppPrefs> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AppPrefs create(Ref ref) {
    return appPrefs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppPrefs value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AppPrefs>(value));
  }
}

String _$appPrefsHash() => r'ad7feed77cf4cc3fff0e01cafd6147f409f80b19';

@ProviderFor(ThemeModeController)
final themeModeControllerProvider = ThemeModeControllerProvider._();

final class ThemeModeControllerProvider extends $NotifierProvider<ThemeModeController, ThemeMode> {
  ThemeModeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeControllerHash();

  @$internal
  @override
  ThemeModeController create() => ThemeModeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<ThemeMode>(value));
  }
}

String _$themeModeControllerHash() => r'8caac9afc18b096ec79254db3ee967698a642aa4';

abstract class _$ThemeModeController extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<ThemeMode, ThemeMode>, ThemeMode, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(OnboardingDone)
final onboardingDoneProvider = OnboardingDoneProvider._();

final class OnboardingDoneProvider extends $NotifierProvider<OnboardingDone, bool> {
  OnboardingDoneProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingDoneProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingDoneHash();

  @$internal
  @override
  OnboardingDone create() => OnboardingDone();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }
}

String _$onboardingDoneHash() => r'2a7dabd879b9ba73101faf3da5f5ee136db59138';

abstract class _$OnboardingDone extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<bool, bool>, bool, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

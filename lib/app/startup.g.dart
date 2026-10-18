// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'startup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether to seed demo data into an empty database. Overridable in tests.

@ProviderFor(seedDemoEnabled)
final seedDemoEnabledProvider = SeedDemoEnabledProvider._();

/// Whether to seed demo data into an empty database. Overridable in tests.

final class SeedDemoEnabledProvider extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  /// Whether to seed demo data into an empty database. Overridable in tests.
  SeedDemoEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seedDemoEnabledProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seedDemoEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return seedDemoEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }
}

String _$seedDemoEnabledHash() => r'b8a1b9ae2631f5af41e979b37a6c3e1f7cf5cdb6';

/// Runs once before the first frame of content: optional demo seed, purge
/// of old soft-deleted rows, and recurring materialisation.

@ProviderFor(appStartup)
final appStartupProvider = AppStartupProvider._();

/// Runs once before the first frame of content: optional demo seed, purge
/// of old soft-deleted rows, and recurring materialisation.

final class AppStartupProvider extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Runs once before the first frame of content: optional demo seed, purge
  /// of old soft-deleted rows, and recurring materialisation.
  AppStartupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appStartupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appStartupHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return appStartup(ref);
  }
}

String _$appStartupHash() => r'1ce77d5e493e9e57b1d9dce89e37d923c19b9e55';

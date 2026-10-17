// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'startup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Runs once before the first frame of content: optional demo seed, purge
/// of old soft-deleted rows, and recurring materialisation.

@ProviderFor(appStartup)
final appStartupProvider = AppStartupProvider._();

/// Runs once before the first frame of content: optional demo seed, purge
/// of old soft-deleted rows, and recurring materialisation.

final class AppStartupProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
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
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return appStartup(ref);
  }
}

String _$appStartupHash() => r'f62b6a619b846a39083a726bd6a3b32f4c33d66a';

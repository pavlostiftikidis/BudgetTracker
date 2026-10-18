// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_lock.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(secureFlags)
final secureFlagsProvider = SecureFlagsProvider._();

final class SecureFlagsProvider extends $FunctionalProvider<SecureFlags, SecureFlags, SecureFlags>
    with $Provider<SecureFlags> {
  SecureFlagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureFlagsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureFlagsHash();

  @$internal
  @override
  $ProviderElement<SecureFlags> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  SecureFlags create(Ref ref) {
    return secureFlags(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureFlags value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SecureFlags>(value));
  }
}

String _$secureFlagsHash() => r'8ef4fc9ad2662e3710fc3c9dcdc31475a51f9fed';

@ProviderFor(biometricAuth)
final biometricAuthProvider = BiometricAuthProvider._();

final class BiometricAuthProvider extends $FunctionalProvider<BiometricAuth, BiometricAuth, BiometricAuth>
    with $Provider<BiometricAuth> {
  BiometricAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricAuthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricAuthHash();

  @$internal
  @override
  $ProviderElement<BiometricAuth> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  BiometricAuth create(Ref ref) {
    return biometricAuth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BiometricAuth value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<BiometricAuth>(value));
  }
}

String _$biometricAuthHash() => r'99041038f07efa15d22ea11f2beb9f2ac4efdada';

@ProviderFor(AppLock)
final appLockProvider = AppLockProvider._();

final class AppLockProvider extends $AsyncNotifierProvider<AppLock, LockState> {
  AppLockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockHash();

  @$internal
  @override
  AppLock create() => AppLock();
}

String _$appLockHash() => r'74082cb5e1be9a42068bdc10378a9452e298729f';

abstract class _$AppLock extends $AsyncNotifier<LockState> {
  FutureOr<LockState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LockState>, LockState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LockState>, LockState>,
              AsyncValue<LockState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

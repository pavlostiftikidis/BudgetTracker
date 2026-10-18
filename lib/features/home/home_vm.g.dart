// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Which period Home shows: 0 = current, 1 = previous, …

@ProviderFor(HomePeriodOffset)
final homePeriodOffsetProvider = HomePeriodOffsetProvider._();

/// Which period Home shows: 0 = current, 1 = previous, …
final class HomePeriodOffsetProvider extends $NotifierProvider<HomePeriodOffset, int> {
  /// Which period Home shows: 0 = current, 1 = previous, …
  HomePeriodOffsetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homePeriodOffsetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homePeriodOffsetHash();

  @$internal
  @override
  HomePeriodOffset create() => HomePeriodOffset();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<int>(value));
  }
}

String _$homePeriodOffsetHash() => r'df9dc45886f46499362177a7b2c861ac076b7fc2';

/// Which period Home shows: 0 = current, 1 = previous, …

abstract class _$HomePeriodOffset extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(homeVm)
final homeVmProvider = HomeVmProvider._();

final class HomeVmProvider extends $FunctionalProvider<AsyncValue<HomeVm>, HomeVm, FutureOr<HomeVm>>
    with $FutureModifier<HomeVm>, $FutureProvider<HomeVm> {
  HomeVmProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeVmProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeVmHash();

  @$internal
  @override
  $FutureProviderElement<HomeVm> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<HomeVm> create(Ref ref) {
    return homeVm(ref);
  }
}

String _$homeVmHash() => r'ef895d28eb6fa2ddbf6c174d2f97c05b8a6c8308';

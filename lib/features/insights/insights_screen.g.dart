// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insights_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InsightsScaleSetting)
final insightsScaleSettingProvider = InsightsScaleSettingProvider._();

final class InsightsScaleSettingProvider extends $NotifierProvider<InsightsScaleSetting, InsightScale> {
  InsightsScaleSettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insightsScaleSettingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insightsScaleSettingHash();

  @$internal
  @override
  InsightsScaleSetting create() => InsightsScaleSetting();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InsightScale value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<InsightScale>(value));
  }
}

String _$insightsScaleSettingHash() => r'087e9df9f873c8e68a499eb67916e7c2f276c928';

abstract class _$InsightsScaleSetting extends $Notifier<InsightScale> {
  InsightScale build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<InsightScale, InsightScale>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<InsightScale, InsightScale>, InsightScale, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(insights)
final insightsProvider = InsightsProvider._();

final class InsightsProvider extends $FunctionalProvider<AsyncValue<InsightsData>, InsightsData, FutureOr<InsightsData>>
    with $FutureModifier<InsightsData>, $FutureProvider<InsightsData> {
  InsightsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insightsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insightsHash();

  @$internal
  @override
  $FutureProviderElement<InsightsData> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<InsightsData> create(Ref ref) {
    return insights(ref);
  }
}

String _$insightsHash() => r'7acb70bc7054c27bb7b20c21b9fd90bbfeb65416';

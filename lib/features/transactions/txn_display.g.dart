// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'txn_display.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(lookups)
final lookupsProvider = LookupsProvider._();

final class LookupsProvider extends $FunctionalProvider<AsyncValue<Lookups>, Lookups, FutureOr<Lookups>>
    with $FutureModifier<Lookups>, $FutureProvider<Lookups> {
  LookupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lookupsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lookupsHash();

  @$internal
  @override
  $FutureProviderElement<Lookups> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Lookups> create(Ref ref) {
    return lookups(ref);
  }
}

String _$lookupsHash() => r'55ab177127d43e2f3086b3efb356f614587d9952';

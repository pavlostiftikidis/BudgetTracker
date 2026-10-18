// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'txn_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(txnActions)
final txnActionsProvider = TxnActionsProvider._();

final class TxnActionsProvider extends $FunctionalProvider<TxnActions, TxnActions, TxnActions>
    with $Provider<TxnActions> {
  TxnActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'txnActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$txnActionsHash();

  @$internal
  @override
  $ProviderElement<TxnActions> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  TxnActions create(Ref ref) {
    return txnActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TxnActions value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<TxnActions>(value));
  }
}

String _$txnActionsHash() => r'059027b24ee3516943081521a37de29dabaa6970';

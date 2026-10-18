// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budgets_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentBudget)
final currentBudgetProvider = CurrentBudgetProvider._();

final class CurrentBudgetProvider
    extends $FunctionalProvider<AsyncValue<BudgetSummary>, BudgetSummary, FutureOr<BudgetSummary>>
    with $FutureModifier<BudgetSummary>, $FutureProvider<BudgetSummary> {
  CurrentBudgetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentBudgetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentBudgetHash();

  @$internal
  @override
  $FutureProviderElement<BudgetSummary> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<BudgetSummary> create(Ref ref) {
    return currentBudget(ref);
  }
}

String _$currentBudgetHash() => r'f451dc5659e99f2b6744e935265f1d8e92f5b9af';

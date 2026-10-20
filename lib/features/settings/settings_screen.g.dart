// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(receiptStorage)
final receiptStorageProvider = ReceiptStorageProvider._();

final class ReceiptStorageProvider extends $FunctionalProvider<ReceiptStorage, ReceiptStorage, ReceiptStorage>
    with $Provider<ReceiptStorage> {
  ReceiptStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'receiptStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$receiptStorageHash();

  @$internal
  @override
  $ProviderElement<ReceiptStorage> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  ReceiptStorage create(Ref ref) {
    return receiptStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReceiptStorage value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<ReceiptStorage>(value));
  }
}

String _$receiptStorageHash() => r'ce83a0715dfc315cb1f525a15e5e868d4d246020';

@ProviderFor(backupPicker)
final backupPickerProvider = BackupPickerProvider._();

final class BackupPickerProvider extends $FunctionalProvider<BackupPicker, BackupPicker, BackupPicker>
    with $Provider<BackupPicker> {
  BackupPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupPickerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupPickerHash();

  @$internal
  @override
  $ProviderElement<BackupPicker> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  BackupPicker create(Ref ref) {
    return backupPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackupPicker value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<BackupPicker>(value));
  }
}

String _$backupPickerHash() => r'8a96ef3b5cf9877608baf0497887a95a67747e41';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Security-relevant flags, kept in the Keychain / Keystore rather than
/// plain preferences so they cannot be flipped by editing app data.
abstract interface class SecureFlags {
  Future<bool> biometricLock();
  Future<void> setBiometricLock({required bool enabled});
}

class KeychainSecureFlags implements SecureFlags {
  new([this._storage = const FlutterSecureStorage()]);

  static const _lockKey = 'biometric_lock';

  final FlutterSecureStorage _storage;

  @override
  Future<bool> biometricLock() async => await _storage.read(key: _lockKey) == 'true';

  @override
  Future<void> setBiometricLock({required bool enabled}) => _storage.write(key: _lockKey, value: '$enabled');
}

class MemorySecureFlags implements SecureFlags {
  new({this.lock = false});

  bool lock;

  @override
  Future<bool> biometricLock() async => lock;

  @override
  Future<void> setBiometricLock({required bool enabled}) async => lock = enabled;
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/data/prefs/secure_flags.dart';
import 'package:pulse/data/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_lock.g.dart';

/// Face ID / fingerprint / device credential.
abstract interface class BiometricAuth {
  Future<bool> isAvailable();

  /// True when the user authenticated; false when cancelled or failed.
  Future<bool> authenticate(String reason);
}

class LocalBiometricAuth implements BiometricAuth {
  final _auth = LocalAuthentication();

  @override
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported();
    } on Object {
      return false;
    }
  }

  @override
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(localizedReason: reason, persistAcrossBackgrounding: true);
    } on LocalAuthException {
      return false;
    }
  }
}

@Riverpod(keepAlive: true)
SecureFlags secureFlags(Ref ref) => KeychainSecureFlags();

@Riverpod(keepAlive: true)
BiometricAuth biometricAuth(Ref ref) => LocalBiometricAuth();

/// Re-lock only after the app has been in the background this long, so a
/// trip to the photo picker or share sheet does not ask again.
const Duration kRelockAfter = Duration(seconds: 30);

final class LockState {
  const new({required this.enabled, required this.locked});

  final bool enabled;
  final bool locked;
}

@Riverpod(keepAlive: true)
class AppLock extends _$AppLock {
  DateTime? _backgroundedAt;
  bool _authenticating = false;

  @override
  Future<LockState> build() async {
    final enabled = await ref.watch(secureFlagsProvider).biometricLock();
    return LockState(enabled: enabled, locked: enabled);
  }

  Future<bool> unlock(String reason) async {
    if (_authenticating) return false;
    _authenticating = true;
    try {
      final ok = await ref.read(biometricAuthProvider).authenticate(reason);
      if (ok) state = const AsyncData(LockState(enabled: true, locked: false));
      return ok;
    } finally {
      _authenticating = false;
    }
  }

  /// Turning the lock on asks for authentication first, so nobody locks
  /// themselves out with a sensor they cannot use. Returns false when the
  /// device has no biometrics or the user cancelled.
  Future<bool> setEnabled({required bool enabled, required String reason}) async {
    final auth = ref.read(biometricAuthProvider);
    if (enabled) {
      if (!await auth.isAvailable()) return false;
      if (!await auth.authenticate(reason)) return false;
    }
    await ref.read(secureFlagsProvider).setBiometricLock(enabled: enabled);
    state = AsyncData(LockState(enabled: enabled, locked: false));
    return true;
  }

  void onBackground() => _backgroundedAt = ref.read(clockProvider).now();

  void onForeground() {
    final since = _backgroundedAt;
    _backgroundedAt = null;
    final current = state.value;
    if (current == null || !current.enabled || since == null || _authenticating) return;
    if (ref.read(clockProvider).now().difference(since) >= kRelockAfter) {
      state = const AsyncData(LockState(enabled: true, locked: true));
    }
  }
}

/// Covers the app with the lock screen while locked.
class AppLockGate extends ConsumerStatefulWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onHide: () => ref.read(appLockProvider.notifier).onBackground(),
      onShow: () => ref.read(appLockProvider.notifier).onForeground(),
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lock = ref.watch(appLockProvider);
    // While the flag loads, show only the background so content never
    // flashes before the lock screen.
    final loading = lock.isLoading && !lock.hasValue;
    final locked = lock.value?.locked ?? false;
    return Stack(
      children: [
        ExcludeSemantics(excluding: locked || loading, child: widget.child),
        if (loading) Positioned.fill(child: ColoredBox(color: context.colors.bg)),
        // A fresh lock screen each time it appears, so it prompts again.
        if (locked) const Positioned.fill(child: _LockScreen(key: ValueKey('lock'))),
      ],
    );
  }
}

class _LockScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<_LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<_LockScreen> {
  @override
  void initState() {
    super.initState();
    // Prompt straight away; the button is there if the user cancels.
    WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
  }

  Future<void> _unlock() async {
    if (!mounted) return;
    await ref.read(appLockProvider.notifier).unlock(context.l10n.biometricReason);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    return Material(
      color: c.bg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: c.accent, shape: BoxShape.circle),
                child: Icon(LucideIcons.lock, color: c.onAccent, size: 30),
              ),
              const SizedBox(height: 20),
              Semantics(
                header: true,
                child: Text(
                  l10n.lockTitle,
                  textAlign: TextAlign.center,
                  style: PulseText.screenTitle.copyWith(fontSize: 24),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.biometricReason,
                textAlign: TextAlign.center,
                style: PulseText.body.copyWith(color: c.muted),
              ),
              const Spacer(),
              PrimaryButton(label: l10n.lockUnlock, onPressed: () => unawaited(_unlock())),
            ],
          ),
        ),
      ),
    );
  }
}

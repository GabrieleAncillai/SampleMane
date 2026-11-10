import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/mane_notice.dart';
import '../../../state/providers.dart';
import '../../../state/settings_controller.dart';
import '../../../theme/app_colors.dart';
import '../app_lock_service.dart';
import 'pin_pad.dart';

/// Covers the planner while the optional PIN lock is active. It never tears
/// down the shell underneath, so notifications and background work keep going.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child, this.graceSeconds = 30});

  final Widget child;
  final int graceSeconds;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate> with WidgetsBindingObserver {
  bool _locked = false;
  bool _wasHidden = false;
  DateTime? _leftAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _locked = ref.read(settingsProvider).appLockEnabled;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!ref.read(settingsProvider).appLockEnabled) return;
    if (state == AppLifecycleState.paused) {
      _leftAt = DateTime.now();
      _wasHidden = true;
      if (!_locked) setState(() => _locked = true);
      return;
    }
    if (state != AppLifecycleState.resumed || !_locked || !_wasHidden) return;
    _wasHidden = false;
    final needsAuth = appLockNeedsAuth(
      leftAt: _leftAt,
      graceSeconds: widget.graceSeconds,
      now: DateTime.now(),
    );
    if (!needsAuth) setState(() => _locked = false);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return Stack(
      children: [
        widget.child,
        if (_locked && settings.appLockEnabled)
          Positioned.fill(
            child: _PinLockScreen(
              onOpen: () {
                _leftAt = null;
                setState(() => _locked = false);
              },
            ),
          ),
      ],
    );
  }
}

class _PinLockScreen extends ConsumerStatefulWidget {
  const _PinLockScreen({required this.onOpen});

  final VoidCallback onOpen;

  @override
  ConsumerState<_PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends ConsumerState<_PinLockScreen> {
  String? _error;
  int _waitSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _refreshWait();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refreshWait() async {
    final remaining = await ref.read(appLockServiceProvider).lockoutRemaining();
    if (!mounted) return;
    setState(() => _waitSeconds = remaining.inSeconds + (remaining.inSeconds > 0 ? 1 : 0));
    if (_waitSeconds > 0) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        if (_waitSeconds <= 1) {
          timer.cancel();
          setState(() => _waitSeconds = 0);
        } else {
          setState(() => _waitSeconds--);
        }
      });
    }
  }

  Future<bool> _submit(String pin) async {
    final l10n = context.l10n;
    if (_waitSeconds > 0) return false;
    final ok = await ref.read(appLockServiceProvider).verify(pin);
    if (!mounted) return false;
    if (ok) {
      widget.onOpen();
      return true;
    }
    final remaining = await ref.read(appLockServiceProvider).lockoutRemaining();
    if (!mounted) return false;
    setState(() {
      _error = remaining > Duration.zero ? l10n.appLockLockedOut(remaining.inSeconds) : l10n.appLockWrong;
    });
    await _refreshWait();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.mc;
    return Material(
      color: c.pageBg,
      child: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(color: c.accentSoft, borderRadius: BorderRadius.circular(18)),
                    child: Icon(Icons.lock_outline, size: 28, color: c.accent),
                  ),
                  const SizedBox(height: 16),
                  PinPad(
                    title: l10n.appLockUnlockTitle,
                    subtitle: l10n.appLockUnlockSubtitle,
                    enabled: _waitSeconds == 0,
                    onSubmit: _submit,
                  ),
                  if (_waitSeconds > 0) ManeNotice(text: l10n.appLockLockedOut(_waitSeconds)),
                  if (_error != null && _waitSeconds == 0) ManeNotice(text: _error!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

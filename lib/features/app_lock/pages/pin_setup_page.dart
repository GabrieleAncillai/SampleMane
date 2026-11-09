import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/mane_notice.dart';
import '../../../state/providers.dart';
import '../../../state/settings_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../app_lock_service.dart';
import '../widgets/pin_pad.dart';

/// First-run PIN setup: choose, then repeat. Returns true when a PIN is saved.
class PinSetupPage extends ConsumerStatefulWidget {
  const PinSetupPage({super.key});

  @override
  ConsumerState<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends ConsumerState<PinSetupPage> {
  String? _first;
  String? _error;
  int _attempt = 0;

  Future<bool> _submit(String pin) async {
    final l10n = context.l10n;
    final first = _first;
    if (first == null) {
      if (pin.length < PinPad.minLength) {
        setState(() => _error = l10n.appLockPinLength);
        return false;
      }
      setState(() {
        _first = pin;
        _error = null;
      });
      return true;
    }
    if (pin != first) {
      setState(() {
        _first = null;
        _error = l10n.appLockPinMismatch;
        _attempt++;
      });
      return false;
    }
    try {
      await ref.read(appLockServiceProvider).setPin(pin);
      await ref.read(settingsProvider.notifier).reload();
    } on AppLockException catch (error) {
      if (mounted) setState(() => _error = '$error');
      return false;
    }
    if (!mounted) return true;
    Navigator.of(context).pop(true);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.mc;
    final first = _first;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: 8,
                top: 4,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: l10n.cancel,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: c.accentSoft,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(Icons.lock_outline, size: 28, color: c.accent),
                      ),
                      const SizedBox(height: 14),
                      Text(l10n.appLock, style: ManeType.headline(22, color: c.text)),
                      const SizedBox(height: 22),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: PinPad(
                          key: ValueKey('${first != null}$_attempt'),
                          title: first == null ? l10n.appLockPinTitle : l10n.appLockPinRepeat,
                          subtitle: first == null ? l10n.appLockSubtitle : '',
                          length: first?.length,
                          onSubmit: _submit,
                        ),
                      ),
                      if (_error != null) ManeNotice(text: _error!),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

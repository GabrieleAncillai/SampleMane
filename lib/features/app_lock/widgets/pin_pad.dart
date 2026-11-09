import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

/// Numeric keypad adapted from Streak's `pin_pad.dart`.
class PinPad extends StatefulWidget {
  const PinPad({
    super.key,
    required this.title,
    required this.onSubmit,
    this.subtitle = '',
    this.length,
    this.enabled = true,
  });

  final String title;
  final String subtitle;
  final int? length;
  final bool enabled;
  final Future<bool> Function(String pin) onSubmit;

  static const minLength = 4;
  static const maxLength = 8;

  @override
  State<PinPad> createState() => _PinPadState();
}

class _PinPadState extends State<PinPad> with SingleTickerProviderStateMixin {
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  String _pin = '';
  bool _busy = false;

  int get _max => widget.length ?? PinPad.maxLength;

  bool get _canConfirm => widget.length == null && _pin.length >= PinPad.minLength;

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  void _type(String digit) {
    if (!widget.enabled || _busy || _pin.length >= _max) return;
    setState(() => _pin += digit);
    if (widget.length != null && _pin.length == widget.length) _submit();
  }

  void _erase() {
    if (_pin.isEmpty || _busy) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _submit() async {
    if (_busy || !widget.enabled) return;
    _busy = true;
    final ok = await widget.onSubmit(_pin);
    _busy = false;
    if (!mounted) return;
    if (!ok) _shake.forward(from: 0);
    setState(() => _pin = '');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    final dots = widget.length ?? math.max(_pin.length, PinPad.minLength);
    final dense = dots > PinPad.maxLength;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: ManeType.headline(21, color: c.text),
          ),
          if (widget.subtitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              widget.subtitle,
              textAlign: TextAlign.center,
              style: ManeType.body(13.5, color: c.textSecondary),
            ),
          ],
          const SizedBox(height: 22),
          AnimatedBuilder(
            animation: _shake,
            builder: (context, child) => Transform.translate(
              offset: Offset(math.sin(_shake.value * math.pi * 6) * (1 - _shake.value) * 12, 0),
              child: child,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < dots; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    margin: EdgeInsets.symmetric(horizontal: dense ? 4 : 7),
                    width: dense ? 10 : 13,
                    height: dense ? 10 : 13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < _pin.length ? c.accent : Colors.transparent,
                      border: Border.all(
                        color: i < _pin.length ? c.accent : c.textTertiary.withValues(alpha: 0.5),
                        width: 1.6,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: widget.enabled ? 1 : 0.35,
            child: Column(
              children: [
                for (final row in const [
                  ['1', '2', '3'],
                  ['4', '5', '6'],
                  ['7', '8', '9'],
                ])
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (final digit in row) _Key(onTap: () => _type(digit), child: _digit(digit)),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Key(
                      onTap: _canConfirm ? _submit : null,
                      child: Icon(Icons.check, size: 24, color: _canConfirm ? c.accent : Colors.transparent),
                    ),
                    _Key(onTap: () => _type('0'), child: _digit('0')),
                    _Key(
                      onTap: _pin.isEmpty ? null : _erase,
                      child: Icon(
                        Icons.backspace_outlined,
                        size: 21,
                        color: _pin.isEmpty ? Colors.transparent : c.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _digit(String digit) => Text(digit, style: ManeType.headline(26, color: context.mc.text));
}

class _Key extends StatelessWidget {
  const _Key({required this.onTap, required this.child});

  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Material(
        color: onTap == null ? Colors.transparent : c.surfaceAlt.withValues(alpha: 0.75),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(width: 70, height: 70, child: Center(child: child)),
        ),
      ),
    );
  }
}

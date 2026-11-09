import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// The reference switch: a small track with a sliding thumb, not a Material
/// switch. It is used where a row needs a dense on/off control.
class TinySwitch extends StatelessWidget {
  const TinySwitch({super.key, required this.value, this.onChanged, this.semanticLabel});

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    final enabled = onChanged != null;
    final control = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 44,
      height: 26,
      padding: const EdgeInsets.all(3),
      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
      decoration: BoxDecoration(
        color: value ? c.accent : c.surfaceHigh,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: value ? c.accent : c.border),
      ),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(color: value ? c.onAccent : c.textTertiary, shape: BoxShape.circle),
      ),
    );
    final target = Semantics(
      toggled: value,
      enabled: enabled,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onChanged!(!value) : null,
        child: Opacity(opacity: enabled ? 1 : 0.45, child: control),
      ),
    );
    return target;
  }
}

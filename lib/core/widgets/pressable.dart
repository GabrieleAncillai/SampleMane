import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// A tap target that responds like the reference rows: a small scale on press,
/// fast in and soft out.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scale = 0.965,
    this.semanticLabel,
    this.semanticButton = false,
    this.behavior = HitTestBehavior.opaque,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scale;
  final String? semanticLabel;
  final bool semanticButton;
  final HitTestBehavior behavior;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool value) {
    if (_down != value && mounted) setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    Widget child = AnimatedScale(
      scale: reduce ? 1 : (_down ? widget.scale : 1),
      duration: Duration(milliseconds: _down ? 90 : 260),
      curve: _down ? Curves.easeOut : Curves.easeOutBack,
      child: widget.child,
    );
    child = GestureDetector(
      behavior: widget.behavior,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: widget.onTap == null ? null : (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      child: child,
    );
    final label = widget.semanticLabel;
    if (label == null && !widget.semanticButton) return child;
    return Semantics(
      button: widget.semanticButton,
      label: label,
      onTap: widget.onTap,
      child: ExcludeSemantics(excluding: label != null, child: child),
    );
  }
}

class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.size = 40,
    this.badge,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final double size;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    final button = Pressable(
      onTap: onTap,
      semanticLabel: tooltip,
      semanticButton: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: c.surface,
          border: Border.all(color: c.border),
          boxShadow: [BoxShadow(color: c.shadow, blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: size * 0.46, color: onTap == null ? c.textTertiary : c.text),
            if (badge != null) Positioned(top: 2, right: 2, child: badge!),
          ],
        ),
      ),
    );
    final tip = tooltip;
    return tip == null ? button : Tooltip(message: tip, child: button);
  }
}

/// A compact pill button for filters and secondary actions.
class GlassPill extends StatelessWidget {
  const GlassPill({
    super.key,
    required this.child,
    required this.onTap,
    this.selected = false,
    this.height = 38,
    this.padding = const EdgeInsets.symmetric(horizontal: 14),
  });

  final Widget child;
  final VoidCallback onTap;
  final bool selected;
  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    return Pressable(
      onTap: onTap,
      semanticButton: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: height,
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? c.accentSoft : c.surface,
          borderRadius: BorderRadius.circular(height / 2),
          border: Border.all(color: selected ? c.accent.withValues(alpha: 0.5) : c.border),
        ),
        child: child,
      ),
    );
  }
}

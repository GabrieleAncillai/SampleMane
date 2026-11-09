import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// The reference card surface: raised, quiet, one-pixel edge, no Material
/// elevation.
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 22,
    this.color,
    this.borderColor,
    this.clip = false,
    this.margin,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final Color? color;
  final Color? borderColor;
  final bool clip;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    return Container(
      margin: margin,
      padding: padding,
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      decoration: BoxDecoration(
        color: color ?? c.surface,
        border: Border.all(color: borderColor ?? c.border),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}

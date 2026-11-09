import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// The calm paper backdrop from the reference shell: a soft vertical wash and
/// a barely visible dot grid. It never competes with the plan.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, this.child, this.showDots = true});

  final Widget? child;
  final bool showDots;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: c.pageBg),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: dark
                  ? [c.accent.withValues(alpha: 0.055), c.pageBg.withValues(alpha: 0)]
                  : [c.accent.withValues(alpha: 0.035), c.pageBg.withValues(alpha: 0)],
              stops: const [0, 0.45],
            ),
          ),
        ),
        if (showDots)
          IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _DotPainter(
                  dark ? Colors.white.withValues(alpha: 0.035) : Colors.black.withValues(alpha: 0.035),
                ),
              ),
            ),
          ),
        if (child != null) Positioned.fill(child: child!),
      ],
    );
  }
}

class _DotPainter extends CustomPainter {
  _DotPainter(this.color);

  final Color color;
  static const _gap = 28.0;
  static const _radius = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (double y = _gap; y < size.height; y += _gap) {
      for (double x = _gap; x < size.width; x += _gap) {
        canvas.drawCircle(Offset(x, y), _radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotPainter oldDelegate) => oldDelegate.color != color;
}

/// A frosted surface for the floating shell pieces.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = 22,
    this.blur = 18,
    this.tint,
    this.borderColor,
    this.shadows = true,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final double blur;
  final Color? tint;
  final Color? borderColor;
  final bool shadows;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final shape = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: shadows
            ? [
                BoxShadow(color: c.shadow, blurRadius: 24, offset: const Offset(0, 10)),
                BoxShadow(
                  color: (dark ? Colors.white : Colors.black).withValues(alpha: 0.04),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: shape,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: tint ?? c.glass,
              borderRadius: shape,
              border: Border.all(color: borderColor ?? c.glassEdge),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

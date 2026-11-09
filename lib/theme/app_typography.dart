import 'package:flutter/material.dart';

/// The bundled reference typeface and Mane's type scale.
///
/// Nunito is the face GymMane uses for its small-app shell. Mane keeps one
/// family across display, body and labels so the hierarchy comes from weight,
/// size and spacing rather than a second font.
class ManeType {
  ManeType._();

  static const family = 'Nunito';

  static TextStyle _style(
    double size, {
    FontWeight weight = FontWeight.w600,
    double height = 1.25,
    double? spacing,
    Color? color,
  }) => TextStyle(
    fontFamily: family,
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: spacing,
    color: color,
  );

  static TextStyle display(double size, {FontWeight weight = FontWeight.w800, Color? color}) =>
      _style(size, weight: weight, height: 1.08, spacing: -0.6, color: color);

  static TextStyle headline(double size, {FontWeight weight = FontWeight.w800, Color? color}) =>
      _style(size, weight: weight, height: 1.15, spacing: -0.3, color: color);

  static TextStyle title(double size, {FontWeight weight = FontWeight.w700, Color? color}) =>
      _style(size, weight: weight, height: 1.25, color: color);

  static TextStyle body(double size, {FontWeight weight = FontWeight.w500, Color? color}) =>
      _style(size, weight: weight, height: 1.4, color: color);

  static TextStyle label(double size, {FontWeight weight = FontWeight.w700, Color? color}) =>
      _style(size, weight: weight, height: 1.2, color: color);

  static TextStyle kicker({Color? color}) =>
      _style(10.5, weight: FontWeight.w800, height: 1.2, spacing: 1.4, color: color);

  static TextTheme textTheme(Color text, Color muted) {
    return TextTheme(
      displayLarge: display(34, color: text),
      displayMedium: display(30, color: text),
      displaySmall: display(26, color: text),
      headlineLarge: headline(26, color: text),
      headlineMedium: headline(22, color: text),
      headlineSmall: headline(19, color: text),
      titleLarge: title(18, color: text),
      titleMedium: title(16, color: text),
      titleSmall: title(14, color: text),
      bodyLarge: body(15, color: text),
      bodyMedium: body(14, color: text),
      bodySmall: body(12.5, color: muted),
      labelLarge: label(13.5, color: text),
      labelMedium: label(12, color: muted),
      labelSmall: _style(10.5, weight: FontWeight.w800, spacing: 1.2, color: muted),
    );
  }
}

import 'package:flutter/material.dart';

import 'app_colors.dart';

class ManeTheme {
  ManeTheme._();

  static const seed = Color(0xFF4F6D5A);

  static ThemeData get light => _build(Brightness.light, ManeColors.light);
  static ThemeData get dark => _build(Brightness.dark, ManeColors.dark);

  static ThemeData _build(Brightness brightness, ManeColors colors) {
    final base = ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: brightness),
    );

    return base.copyWith(
      scaffoldBackgroundColor: colors.pageBg,
      colorScheme: base.colorScheme.copyWith(
        surface: colors.surface,
        primary: colors.accent,
        onSurface: colors.text,
        error: colors.danger,
      ),
      textTheme: base.textTheme.apply(bodyColor: colors.text, displayColor: colors.text),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      dividerColor: colors.border,
      extensions: [colors],
    );
  }
}

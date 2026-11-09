import 'package:flutter/material.dart';

@immutable
class ManeColors extends ThemeExtension<ManeColors> {
  const ManeColors({
    required this.pageBg,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.text,
    required this.textSecondary,
    required this.accent,
    required this.accentSoft,
    required this.home,
    required this.work,
    required this.danger,
  });

  final Color pageBg;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color text;
  final Color textSecondary;
  final Color accent;
  final Color accentSoft;
  final Color home;
  final Color work;
  final Color danger;

  static const light = ManeColors(
    pageBg: Color(0xFFF7F5F0),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEFECE6),
    border: Color(0xFFDED9D1),
    text: Color(0xFF1C1B18),
    textSecondary: Color(0xFF5E5A53),
    accent: Color(0xFF4F6D5A),
    accentSoft: Color(0x1F4F6D5A),
    home: Color(0xFF5B7F6B),
    work: Color(0xFF4A6FA5),
    danger: Color(0xFFC0392B),
  );

  static const dark = ManeColors(
    pageBg: Color(0xFF0F1210),
    surface: Color(0xFF191D1A),
    surfaceAlt: Color(0xFF222823),
    border: Color(0xFF313832),
    text: Color(0xFFF2F0EB),
    textSecondary: Color(0xFFA7ADA5),
    accent: Color(0xFF8FB39D),
    accentSoft: Color(0x298FB39D),
    home: Color(0xFF7EA88F),
    work: Color(0xFF7FA3D1),
    danger: Color(0xFFE5674C),
  );

  @override
  ManeColors copyWith({
    Color? pageBg,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? text,
    Color? textSecondary,
    Color? accent,
    Color? accentSoft,
    Color? home,
    Color? work,
    Color? danger,
  }) {
    return ManeColors(
      pageBg: pageBg ?? this.pageBg,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      text: text ?? this.text,
      textSecondary: textSecondary ?? this.textSecondary,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      home: home ?? this.home,
      work: work ?? this.work,
      danger: danger ?? this.danger,
    );
  }

  @override
  ManeColors lerp(ManeColors? other, double t) {
    if (other == null) return this;
    return ManeColors(
      pageBg: Color.lerp(pageBg, other.pageBg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      border: Color.lerp(border, other.border, t)!,
      text: Color.lerp(text, other.text, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      home: Color.lerp(home, other.home, t)!,
      work: Color.lerp(work, other.work, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

extension ManeColorsContext on BuildContext {
  ManeColors get mc => Theme.of(this).extension<ManeColors>() ?? ManeColors.light;
}

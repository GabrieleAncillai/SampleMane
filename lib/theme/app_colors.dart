import 'package:flutter/material.dart';

/// Mane's hand-authored palette. Screens should read these tokens through
/// `context.mc` instead of deriving colours from generated Material roles.
@immutable
class ManeColors extends ThemeExtension<ManeColors> {
  const ManeColors({
    required this.pageBg,
    required this.surface,
    required this.surfaceAlt,
    required this.surfaceHigh,
    required this.navBg,
    required this.border,
    required this.borderStrong,
    required this.text,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.personal,
    required this.personalSoft,
    required this.work,
    required this.workSoft,
    required this.home,
    required this.homeSoft,
    required this.danger,
    required this.dangerSoft,
    required this.warning,
    required this.warningSoft,
    required this.success,
    required this.successSoft,
    required this.info,
    required this.glass,
    required this.glassEdge,
    required this.shadow,
  });

  final Color pageBg;
  final Color surface;
  final Color surfaceAlt;
  final Color surfaceHigh;
  final Color navBg;
  final Color border;
  final Color borderStrong;
  final Color text;
  final Color textSecondary;
  final Color textTertiary;
  final Color accent;
  final Color accentSoft;
  final Color onAccent;
  final Color personal;
  final Color personalSoft;
  final Color work;
  final Color workSoft;
  final Color home;
  final Color homeSoft;
  final Color danger;
  final Color dangerSoft;
  final Color warning;
  final Color warningSoft;
  final Color success;
  final Color successSoft;
  final Color info;
  final Color glass;
  final Color glassEdge;
  final Color shadow;

  static const light = ManeColors(
    pageBg: Color(0xFFF6F4EF),
    surface: Color(0xFFFFFEFA),
    surfaceAlt: Color(0xFFEFECE5),
    surfaceHigh: Color(0xFFE7E3DA),
    navBg: Color(0xF7FFFEFA),
    border: Color(0xFFDED9CF),
    borderStrong: Color(0xFFC7C0B3),
    text: Color(0xFF1D1B17),
    textSecondary: Color(0xFF5C574F),
    textTertiary: Color(0xFF8C857A),
    accent: Color(0xFF4F6D5A),
    accentSoft: Color(0x1F4F6D5A),
    onAccent: Color(0xFFFFFFFF),
    personal: Color(0xFFB07D5C),
    personalSoft: Color(0x1FB07D5C),
    work: Color(0xFF4A6FA5),
    workSoft: Color(0x1F4A6FA5),
    home: Color(0xFF5B7F6B),
    homeSoft: Color(0x1F5B7F6B),
    danger: Color(0xFFB3402F),
    dangerSoft: Color(0x1FB3402F),
    warning: Color(0xFF96621A),
    warningSoft: Color(0x1F96621A),
    success: Color(0xFF3D7A52),
    successSoft: Color(0x1F3D7A52),
    info: Color(0xFF3268A0),
    glass: Color(0xF2FFFFFF),
    glassEdge: Color(0x14000000),
    shadow: Color(0x1A000000),
  );

  static const dark = ManeColors(
    pageBg: Color(0xFF0F1210),
    surface: Color(0xFF191D1A),
    surfaceAlt: Color(0xFF222823),
    surfaceHigh: Color(0xFF2B322C),
    navBg: Color(0xE6191D1A),
    border: Color(0xFF313832),
    borderStrong: Color(0xFF465046),
    text: Color(0xFFF2F0EB),
    textSecondary: Color(0xFFA7ADA5),
    textTertiary: Color(0xFF7C837B),
    accent: Color(0xFF8FB39D),
    accentSoft: Color(0x298FB39D),
    onAccent: Color(0xFF0F1210),
    personal: Color(0xFFD29A72),
    personalSoft: Color(0x29D29A72),
    work: Color(0xFF7FA3D1),
    workSoft: Color(0x297FA3D1),
    home: Color(0xFF7EA88F),
    homeSoft: Color(0x297EA88F),
    danger: Color(0xFFE5674C),
    dangerSoft: Color(0x29E5674C),
    warning: Color(0xFFD8A657),
    warningSoft: Color(0x29D8A657),
    success: Color(0xFF8FBF9F),
    successSoft: Color(0x298FBF9F),
    info: Color(0xFF7FA8C9),
    glass: Color(0x14FFFFFF),
    glassEdge: Color(0x14FFFFFF),
    shadow: Color(0x66000000),
  );

  Color forSpace(String id) => switch (id) {
    'personal' => personal,
    'work' => work,
    'home' => home,
    _ => accent,
  };

  Color softForSpace(String id) => switch (id) {
    'personal' => personalSoft,
    'work' => workSoft,
    'home' => homeSoft,
    _ => accentSoft,
  };

  @override
  ManeColors copyWith({
    Color? pageBg,
    Color? surface,
    Color? surfaceAlt,
    Color? surfaceHigh,
    Color? navBg,
    Color? border,
    Color? borderStrong,
    Color? text,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? accentSoft,
    Color? onAccent,
    Color? personal,
    Color? personalSoft,
    Color? work,
    Color? workSoft,
    Color? home,
    Color? homeSoft,
    Color? danger,
    Color? dangerSoft,
    Color? warning,
    Color? warningSoft,
    Color? success,
    Color? successSoft,
    Color? info,
    Color? glass,
    Color? glassEdge,
    Color? shadow,
  }) {
    return ManeColors(
      pageBg: pageBg ?? this.pageBg,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      navBg: navBg ?? this.navBg,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      text: text ?? this.text,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      onAccent: onAccent ?? this.onAccent,
      personal: personal ?? this.personal,
      personalSoft: personalSoft ?? this.personalSoft,
      work: work ?? this.work,
      workSoft: workSoft ?? this.workSoft,
      home: home ?? this.home,
      homeSoft: homeSoft ?? this.homeSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      info: info ?? this.info,
      glass: glass ?? this.glass,
      glassEdge: glassEdge ?? this.glassEdge,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  ManeColors lerp(ManeColors? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return ManeColors(
      pageBg: c(pageBg, other.pageBg),
      surface: c(surface, other.surface),
      surfaceAlt: c(surfaceAlt, other.surfaceAlt),
      surfaceHigh: c(surfaceHigh, other.surfaceHigh),
      navBg: c(navBg, other.navBg),
      border: c(border, other.border),
      borderStrong: c(borderStrong, other.borderStrong),
      text: c(text, other.text),
      textSecondary: c(textSecondary, other.textSecondary),
      textTertiary: c(textTertiary, other.textTertiary),
      accent: c(accent, other.accent),
      accentSoft: c(accentSoft, other.accentSoft),
      onAccent: c(onAccent, other.onAccent),
      personal: c(personal, other.personal),
      personalSoft: c(personalSoft, other.personalSoft),
      work: c(work, other.work),
      workSoft: c(workSoft, other.workSoft),
      home: c(home, other.home),
      homeSoft: c(homeSoft, other.homeSoft),
      danger: c(danger, other.danger),
      dangerSoft: c(dangerSoft, other.dangerSoft),
      warning: c(warning, other.warning),
      warningSoft: c(warningSoft, other.warningSoft),
      success: c(success, other.success),
      successSoft: c(successSoft, other.successSoft),
      info: c(info, other.info),
      glass: c(glass, other.glass),
      glassEdge: c(glassEdge, other.glassEdge),
      shadow: c(shadow, other.shadow),
    );
  }
}

extension ManeColorsContext on BuildContext {
  ManeColors get mc => Theme.of(this).extension<ManeColors>() ?? ManeColors.light;
}

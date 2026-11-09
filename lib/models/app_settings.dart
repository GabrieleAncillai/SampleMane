import 'package:flutter/material.dart';

import '../core/i18n/l10n.dart';

abstract final class SettingsKeys {
  static const themeMode = 'themeMode';
  static const locale = 'locale';
  static const weekStart = 'weekStart';
  static const hideWorkSpace = 'hideWorkSpace';
  static const defaultReminderOffsets = 'defaultReminderOffsets';
  static const syncEnabled = 'syncEnabled';
  static const mcpEnabled = 'mcpEnabled';
}

/// App-wide preferences. Persisted in the `setting_records` table.
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.locale,
    this.weekStart = DateTime.monday,
    this.hideWorkSpace = false,
    this.defaultReminderOffsets = const <int>[10, 60],
    this.syncEnabled = false,
    this.mcpEnabled = false,
  });

  final ThemeMode themeMode;

  /// Null follows the system language.
  final Locale? locale;

  /// ISO weekday (1 = Monday) the week starts on.
  final int weekStart;

  final bool hideWorkSpace;

  /// Minutes before an occurrence pre-selected when a new entry is created.
  final List<int> defaultReminderOffsets;

  final bool syncEnabled;
  final bool mcpEnabled;

  factory AppSettings.fromMap(Map<String, String> values) {
    final localeValue = values[SettingsKeys.locale];
    final weekStartValue = int.tryParse(values[SettingsKeys.weekStart] ?? '');
    final offsets = <int>[];
    final rawOffsets = values[SettingsKeys.defaultReminderOffsets];
    if (rawOffsets != null) {
      for (final part in rawOffsets.split(',')) {
        final value = int.tryParse(part.trim());
        if (value != null && value >= 0 && !offsets.contains(value)) offsets.add(value);
      }
      offsets.sort();
    }

    return AppSettings(
      themeMode: switch (values[SettingsKeys.themeMode]) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      locale: localeValue == null || localeValue.isEmpty || localeValue == 'system'
          ? null
          : localeForCode(localeValue),
      weekStart: weekStartValue == 6 || weekStartValue == 7 ? weekStartValue! : DateTime.monday,
      hideWorkSpace: values[SettingsKeys.hideWorkSpace] == 'true',
      defaultReminderOffsets: rawOffsets == null ? const <int>[10, 60] : offsets,
      syncEnabled: values[SettingsKeys.syncEnabled] == 'true',
      mcpEnabled: values[SettingsKeys.mcpEnabled] == 'true',
    );
  }

  AppSettings copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool clearLocale = false,
    int? weekStart,
    bool? hideWorkSpace,
    List<int>? defaultReminderOffsets,
    bool? syncEnabled,
    bool? mcpEnabled,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    locale: clearLocale ? null : (locale ?? this.locale),
    weekStart: weekStart ?? this.weekStart,
    hideWorkSpace: hideWorkSpace ?? this.hideWorkSpace,
    defaultReminderOffsets: defaultReminderOffsets ?? this.defaultReminderOffsets,
    syncEnabled: syncEnabled ?? this.syncEnabled,
    mcpEnabled: mcpEnabled ?? this.mcpEnabled,
  );
}

import 'package:flutter/material.dart';
import 'package:mane_core/mane_core.dart';

import '../core/i18n/l10n.dart';

abstract final class SettingsKeys {
  static const themeMode = 'themeMode';
  static const locale = 'locale';
  static const weekStart = 'weekStart';
  static const hideWorkSpace = 'hideWorkSpace';
  static const defaultReminderOffsets = 'defaultReminderOffsets';
  static const syncEnabled = 'syncEnabled';
  static const mcpEnabled = 'mcpEnabled';
  static const mcpWritesEnabled = 'mcpWritesEnabled';
  static const sleepEnabled = 'sleepEnabled';
  static const sleepCommuteMinutes = 'sleepCommuteMinutes';
  static const sleepWindDownMinutes = 'sleepWindDownMinutes';
  static const sleepWakeBufferMinutes = 'sleepWakeBufferMinutes';
  static const autoBackupEnabled = 'autoBackupEnabled';
  static const autoBackupKeep = 'autoBackupKeep';
  static const workHoursEnabled = 'workHoursEnabled';
  static const workHoursStart = 'workHoursStart';
  static const workHoursEnd = 'workHoursEnd';
  static const quietHoursEnabled = 'quietHoursEnabled';
  static const quietHoursStart = 'quietHoursStart';
  static const quietHoursEnd = 'quietHoursEnd';
  static const appLockEnabled = 'appLockEnabled';
  static const appLockPinSalt = 'appLockPinSalt';
  static const appLockPinHash = 'appLockPinHash';
  static const appLockMisses = 'appLockMisses';
  static const appLockBlockedUntil = 'appLockBlockedUntil';
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
    this.mcpWritesEnabled = false,
    this.sleepEnabled = true,
    this.sleepCommuteMinutes = 30,
    this.sleepWindDownMinutes = 60,
    this.sleepWakeBufferMinutes = 30,
    this.autoBackupEnabled = false,
    this.autoBackupKeep = 5,
    this.appLockEnabled = false,
    this.hasAppLockPin = false,
    this.workHoursEnabled = false,
    this.workHoursStartMinute = 9 * 60,
    this.workHoursEndMinute = 17 * 60,
    this.quietHoursEnabled = false,
    this.quietHoursStartMinute = 22 * 60,
    this.quietHoursEndMinute = 7 * 60,
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
  final bool mcpWritesEnabled;

  final bool sleepEnabled;
  final int sleepCommuteMinutes;
  final int sleepWindDownMinutes;
  final int sleepWakeBufferMinutes;

  /// Writes a rotating JSON copy into the app's local backup folder.
  final bool autoBackupEnabled;
  final int autoBackupKeep;

  /// A PIN pad before the planner opens. The hash is device-local and never
  /// travels in a backup.
  final bool appLockEnabled;
  final bool hasAppLockPin;

  /// When enabled, Work entries leave the aggregate screens outside this
  /// window. Work deadlines stay visible, and search always finds them.
  final bool workHoursEnabled;
  final int workHoursStartMinute;
  final int workHoursEndMinute;

  /// Local notifications are not scheduled inside this window.
  final bool quietHoursEnabled;
  final int quietHoursStartMinute;
  final int quietHoursEndMinute;

  Duration get commute => Duration(minutes: sleepCommuteMinutes);
  Duration get windDown => Duration(minutes: sleepWindDownMinutes);
  Duration get wakeBuffer => Duration(minutes: sleepWakeBufferMinutes);

  bool isWorkTime(DateTime instant, String timeZone) {
    if (!workHoursEnabled) return true;
    return isMinuteInWindow(localMinuteAt(instant, timeZone), workHoursStartMinute, workHoursEndMinute);
  }

  bool isQuietTime(DateTime instant, String timeZone) {
    if (!quietHoursEnabled) return false;
    return isMinuteInWindow(localMinuteAt(instant, timeZone), quietHoursStartMinute, quietHoursEndMinute);
  }

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
      mcpWritesEnabled: values[SettingsKeys.mcpWritesEnabled] == 'true',
      sleepEnabled: values[SettingsKeys.sleepEnabled] != 'false',
      sleepCommuteMinutes: _minutes(values[SettingsKeys.sleepCommuteMinutes], 30),
      sleepWindDownMinutes: _minutes(values[SettingsKeys.sleepWindDownMinutes], 60),
      sleepWakeBufferMinutes: _minutes(values[SettingsKeys.sleepWakeBufferMinutes], 30),
      autoBackupEnabled: values[SettingsKeys.autoBackupEnabled] == 'true',
      autoBackupKeep: _keep(values[SettingsKeys.autoBackupKeep]),
      hasAppLockPin: (values[SettingsKeys.appLockPinHash] ?? '').isNotEmpty,
      appLockEnabled:
          values[SettingsKeys.appLockEnabled] == 'true' &&
          (values[SettingsKeys.appLockPinHash] ?? '').isNotEmpty,
      workHoursEnabled: values[SettingsKeys.workHoursEnabled] == 'true',
      workHoursStartMinute: _minutes(values[SettingsKeys.workHoursStart], 9 * 60),
      workHoursEndMinute: _minutes(values[SettingsKeys.workHoursEnd], 17 * 60),
      quietHoursEnabled: values[SettingsKeys.quietHoursEnabled] == 'true',
      quietHoursStartMinute: _minutes(values[SettingsKeys.quietHoursStart], 22 * 60),
      quietHoursEndMinute: _minutes(values[SettingsKeys.quietHoursEnd], 7 * 60),
    );
  }

  static int _keep(String? value) {
    final parsed = int.tryParse(value ?? '');
    if (parsed == null || parsed < 1) return 5;
    return parsed.clamp(1, 20);
  }

  static int _minutes(String? value, int fallback) {
    final parsed = int.tryParse(value ?? '');
    return parsed == null || parsed < 0 ? fallback : parsed;
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
    bool? mcpWritesEnabled,
    bool? sleepEnabled,
    int? sleepCommuteMinutes,
    int? sleepWindDownMinutes,
    int? sleepWakeBufferMinutes,
    bool? autoBackupEnabled,
    int? autoBackupKeep,
    bool? appLockEnabled,
    bool? hasAppLockPin,
    bool? workHoursEnabled,
    int? workHoursStartMinute,
    int? workHoursEndMinute,
    bool? quietHoursEnabled,
    int? quietHoursStartMinute,
    int? quietHoursEndMinute,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    locale: clearLocale ? null : (locale ?? this.locale),
    weekStart: weekStart ?? this.weekStart,
    hideWorkSpace: hideWorkSpace ?? this.hideWorkSpace,
    defaultReminderOffsets: defaultReminderOffsets ?? this.defaultReminderOffsets,
    syncEnabled: syncEnabled ?? this.syncEnabled,
    mcpEnabled: mcpEnabled ?? this.mcpEnabled,
    mcpWritesEnabled: mcpWritesEnabled ?? this.mcpWritesEnabled,
    sleepEnabled: sleepEnabled ?? this.sleepEnabled,
    sleepCommuteMinutes: sleepCommuteMinutes ?? this.sleepCommuteMinutes,
    sleepWindDownMinutes: sleepWindDownMinutes ?? this.sleepWindDownMinutes,
    sleepWakeBufferMinutes: sleepWakeBufferMinutes ?? this.sleepWakeBufferMinutes,
    autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
    autoBackupKeep: autoBackupKeep ?? this.autoBackupKeep,
    appLockEnabled: appLockEnabled ?? this.appLockEnabled,
    hasAppLockPin: hasAppLockPin ?? this.hasAppLockPin,
    workHoursEnabled: workHoursEnabled ?? this.workHoursEnabled,
    workHoursStartMinute: workHoursStartMinute ?? this.workHoursStartMinute,
    workHoursEndMinute: workHoursEndMinute ?? this.workHoursEndMinute,
    quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
    quietHoursStartMinute: quietHoursStartMinute ?? this.quietHoursStartMinute,
    quietHoursEndMinute: quietHoursEndMinute ?? this.quietHoursEndMinute,
  );
}

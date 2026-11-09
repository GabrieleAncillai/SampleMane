import 'dart:ffi' show DynamicLibrary;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/models/app_settings.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane/state/providers.dart';
import 'package:mane/state/settings_controller.dart';
import 'package:sqlite3/open.dart';

void main() {
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
  });

  test('parses stored settings with safe defaults', () {
    final settings = AppSettings.fromMap({
      SettingsKeys.themeMode: 'dark',
      SettingsKeys.locale: 'es',
      SettingsKeys.weekStart: '7',
      SettingsKeys.hideWorkSpace: 'true',
      SettingsKeys.defaultReminderOffsets: '60,10,10',
      SettingsKeys.syncEnabled: 'false',
    });

    expect(settings.themeMode, ThemeMode.dark);
    expect(settings.locale, const Locale('es'));
    expect(settings.weekStart, DateTime.sunday);
    expect(settings.hideWorkSpace, isTrue);
    expect(settings.defaultReminderOffsets, [10, 60]);
    expect(settings.syncEnabled, isFalse);
  });

  test('falls back on unknown values', () {
    final settings = AppSettings.fromMap({
      SettingsKeys.themeMode: 'neon',
      SettingsKeys.locale: 'tlh',
      SettingsKeys.weekStart: '4',
    });

    expect(settings.themeMode, ThemeMode.system);
    expect(settings.locale, const Locale('tlh'));
    expect(settings.weekStart, DateTime.monday);
  });

  test('settings persist through the repository and can be cleared', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.seedDefaults();

    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(database),
        initialSettingsProvider.overrideWithValue(const AppSettings()),
      ],
    );
    addTearDown(container.dispose);

    final controller = container.read(settingsProvider.notifier);
    await controller.setThemeMode(ThemeMode.light);
    await controller.setLocale(const Locale('es'));
    await controller.setWeekStart(DateTime.saturday);
    await controller.setHideWorkSpace(true);
    await controller.setDefaultReminderOffsets([30, 1440, 30]);

    final stored = await database.readSettings();
    expect(stored[SettingsKeys.themeMode], 'light');
    expect(stored[SettingsKeys.locale], 'es');
    expect(stored[SettingsKeys.weekStart], '6');
    expect(stored[SettingsKeys.hideWorkSpace], 'true');
    expect(stored[SettingsKeys.defaultReminderOffsets], '30,1440');

    await controller.setLocale(null);
    expect(container.read(settingsProvider).locale, isNull);
    expect((await database.readSettings())[SettingsKeys.locale], '');
  });

  test('tag filters toggle and clear', () {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final container = ProviderContainer(overrides: [databaseProvider.overrideWithValue(database)]);
    addTearDown(container.dispose);

    final filter = container.read(tagFilterProvider.notifier);
    filter.toggle('a');
    filter.toggle('b');
    expect(container.read(tagFilterProvider), {'a', 'b'});
    filter.toggle('a');
    expect(container.read(tagFilterProvider), {'b'});
    filter.clear();
    expect(container.read(tagFilterProvider), isEmpty);
  });
}

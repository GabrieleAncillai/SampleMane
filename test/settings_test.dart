import 'dart:async';
import 'dart:ffi' show DynamicLibrary;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/models/app_settings.dart';
import 'package:mane/models/date_range.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane/state/providers.dart';
import 'package:mane/state/settings_controller.dart';
import 'package:mane_core/mane_core.dart';
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

  test('reads automatic backup and app lock settings safely', () {
    final locked = AppSettings.fromMap({
      SettingsKeys.autoBackupEnabled: 'true',
      SettingsKeys.autoBackupKeep: '10',
      SettingsKeys.appLockEnabled: 'true',
      SettingsKeys.appLockPinHash: 'aGFzaA==',
    });
    expect(locked.autoBackupEnabled, isTrue);
    expect(locked.autoBackupKeep, 10);
    expect(locked.appLockEnabled, isTrue);
    expect(locked.hasAppLockPin, isTrue);

    final enabledWithoutPin = AppSettings.fromMap({
      SettingsKeys.appLockEnabled: 'true',
      SettingsKeys.autoBackupKeep: '999',
    });
    expect(enabledWithoutPin.appLockEnabled, isFalse);
    expect(enabledWithoutPin.autoBackupKeep, 20);
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

  test('the tag filter also filters shift patterns', () async {
    final database = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    addTearDown(database.close);
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');
    await database.saveTag(const Tag(id: 'pizzeria', name: 'Pizzeria', colorValue: 0xFF4A6FA5));
    await database.saveTag(const Tag(id: 'other', name: 'Other', colorValue: 0xFF5B7F6B));
    await database.saveShiftPattern(
      ShiftPattern(
        id: 'a',
        spaceId: 'work',
        name: 'A',
        timeZone: 'Europe/Madrid',
        cycleDays: 7,
        anchorDate: monday,
        tagIds: const {'pizzeria'},
        slots: const [ShiftSlot(dayIndex: 0, startMinute: 600, endMinute: 660)],
      ),
    );
    await database.saveShiftPattern(
      ShiftPattern(
        id: 'b',
        spaceId: 'work',
        name: 'B',
        timeZone: 'Europe/Madrid',
        cycleDays: 7,
        anchorDate: monday,
        tagIds: const {'other'},
        slots: const [ShiftSlot(dayIndex: 0, startMinute: 720, endMinute: 780)],
      ),
    );

    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(database),
        initialSettingsProvider.overrideWithValue(const AppSettings()),
      ],
    );
    addTearDown(container.dispose);

    var shifts = await _waitForShifts(container, (start: monday, end: monday));
    expect(shifts.map((shift) => shift.pattern.id).toSet(), {'a', 'b'});

    container.read(tagFilterProvider.notifier).toggle('pizzeria');
    shifts = await _waitForShifts(container, (
      start: monday,
      end: monday,
    ), matches: (items) => items.every((shift) => shift.pattern.id == 'a'));
    expect(shifts.map((shift) => shift.pattern.id).toSet(), {'a'});
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

Future<List<ShiftOccurrence>> _waitForShifts(
  ProviderContainer container,
  DateRange range, {
  bool Function(List<ShiftOccurrence>)? matches,
}) async {
  final completer = Completer<List<ShiftOccurrence>>();
  final subscription = container.listen(shiftsProvider(range), (previous, next) {
    if (next.hasValue && !completer.isCompleted) {
      final value = next.requireValue;
      if (matches == null || matches(value)) completer.complete(value);
    }
  }, fireImmediately: true);
  try {
    return await completer.future;
  } finally {
    subscription.close();
  }
}

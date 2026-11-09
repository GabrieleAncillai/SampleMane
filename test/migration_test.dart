import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane_core/mane_core.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
    initializeTimeZones();
  });

  test('migrates real v1 data to v2 without losing anything', () async {
    final directory = await Directory.systemTemp.createTemp('mane-migration');
    final path = '${directory.path}/mane.sqlite';
    final createdAt = DateTime.utc(2026, 11, 1).millisecondsSinceEpoch ~/ 1000;

    final raw = sqlite3.open(path);

    raw.execute(File('test/fixtures/schema_v1.sql').readAsStringSync());
    raw.execute(
      'INSERT INTO space_records (id, name, color, position, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?)',
      ['home', 'Home', 0xFF5B7F6B, 0, createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO space_records (id, name, color, position, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?)',
      ['work', 'Work', 0xFF4A6FA5, 1, createdAt, createdAt],
    );

    raw.execute(
      'INSERT INTO entry_records '
      '(id, space_id, title, kind, date_key, start_minute, end_minute, all_day, status, '
      'recurrence_json, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        'standup',
        'work',
        'Standup',
        'task',
        20261109,
        540,
        570,
        0,
        'open',
        '{"frequency":"weekly","interval":1,"weekdays":[1]}',
        createdAt,
        createdAt,
      ],
    );
    raw.execute(
      'INSERT INTO entry_records '
      '(id, space_id, title, kind, date_key, all_day, status, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      ['bins', 'home', 'Bins', 'task', 20261109, 1, 'open', createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO entry_records '
      '(id, space_id, title, kind, date_key, all_day, status, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      ['implicit', 'home', 'Old date-only row', 'task', 20261110, 0, 'open', createdAt, createdAt],
    );
    raw.execute('INSERT INTO completion_records (entry_id, date_key, created_at) VALUES (?, ?, ?)', [
      'standup',
      20261109,
      createdAt,
    ]);

    raw.execute(
      'INSERT INTO shift_pattern_records '
      '(id, space_id, name, cycle_days, anchor_date_key, slots_json, enabled, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        'bank',
        'work',
        'Bank',
        7,
        20261109,
        '[{"dayIndex":0,"label":"Open","startMinute":540,"endMinute":780},'
            '{"dayIndex":0,"label":"Close","startMinute":960,"endMinute":1200}]',
        1,
        createdAt,
        createdAt,
      ],
    );
    raw.dispose();

    final database = AppDatabase(NativeDatabase(File(path)), defaultTimeZone: 'Europe/Madrid');
    addTearDown(() async {
      await database.close();
      await directory.delete(recursive: true);
    });

    final spaces = await database.watchSpaces().first;
    expect(spaces.map((space) => space.id), ['personal', 'work', 'home']);
    expect(spaces.first.name, 'Personal');

    final entries = await database
        .watchEntriesBetween(LocalDate.parse('2026-11-09'), LocalDate.parse('2026-11-15'), 'Europe/Madrid')
        .first;

    final standup = entries.firstWhere((item) => item.entry.id == 'standup');
    expect(standup.entry.timeZone, 'Europe/Madrid');
    expect(standup.entry.startAt, DateTime.utc(2026, 11, 9, 8));
    expect(standup.entry.endAt, DateTime.utc(2026, 11, 9, 8, 30));
    expect(standup.entry.allDay, isFalse);
    expect(standup.completed, isTrue);

    final bins = entries.firstWhere((item) => item.entry.id == 'bins');
    expect(bins.entry.allDay, isTrue);
    expect(bins.entry.timeZone, isNull);
    expect(bins.entry.startAt, isNull);

    final implicit = entries.firstWhere((item) => item.entry.id == 'implicit');
    expect(implicit.entry.allDay, isTrue);

    final shifts = await database
        .watchShiftsBetween(LocalDate.parse('2026-11-09'), LocalDate.parse('2026-11-09'), 'Europe/Madrid')
        .first;
    expect(shifts, hasLength(2));
    expect(shifts.map((item) => item.slot.label), ['Open', 'Close']);
    expect(shifts.first.startAt, DateTime.utc(2026, 11, 9, 8));
    expect(shifts.first.pattern.timeZone, 'Europe/Madrid');

    final columns = await database.customSelect('PRAGMA table_info(shift_pattern_records)').get();
    expect(columns.map((row) => row.data['name']), isNot(contains('slots_json')));
    expect(columns.map((row) => row.data['name']), contains('time_zone'));

    final version = await database.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.single, 2);
  });
}

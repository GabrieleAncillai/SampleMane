import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane/models/home_item.dart';
import 'package:mane/models/local_identity.dart';
import 'package:mane/models/paired_device.dart';
import 'package:mane/models/shopping_item.dart';
import 'package:mane_core/mane_core.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
    initializeTimeZones();
  });

  test('migrates real v1 data to the current schema without losing anything', () async {
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
    expect(version.data.values.single, 7);
  });

  test('migrates real v2 data and keeps tags usable', () async {
    final directory = await Directory.systemTemp.createTemp('mane-migration-v2');
    final path = '${directory.path}/mane.sqlite';
    final createdAt = DateTime.utc(2026, 11, 1).millisecondsSinceEpoch ~/ 1000;

    final raw = sqlite3.open(path);
    raw.execute(File('test/fixtures/schema_v2.sql').readAsStringSync());
    raw.execute(
      'INSERT INTO space_records (id, name, color, position, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?)',
      ['personal', 'Personal', 0xFFB07D5C, 0, createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO entry_records '
      '(id, space_id, title, kind, date_key, all_day, status, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      ['taxes', 'personal', 'Taxes', 'deadline', 20261115, 1, 'open', createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO shift_pattern_records '
      '(id, space_id, name, time_zone, cycle_days, anchor_date_key, enabled, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      ['bank', 'personal', 'Bank', 'Europe/Madrid', 7, 20261109, 1, createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO shift_slot_records (pattern_id, day_index, label, start_minute, end_minute) '
      'VALUES (?, ?, ?, ?, ?)',
      ['bank', 0, 'Open', 540, 900],
    );
    raw.execute('INSERT INTO setting_records (key, value) VALUES (?, ?)', ['themeMode', 'dark']);
    raw.dispose();

    final database = AppDatabase(NativeDatabase(File(path)), defaultTimeZone: 'Europe/Madrid');
    addTearDown(() async {
      await database.close();
      await directory.delete(recursive: true);
    });

    final entries = await database
        .watchEntriesBetween(LocalDate.parse('2026-11-15'), LocalDate.parse('2026-11-15'), 'Europe/Madrid')
        .first;
    expect(entries.single.entry.title, 'Taxes');
    expect(entries.single.entry.tagIds, isEmpty);

    final shifts = await database
        .watchShiftsBetween(LocalDate.parse('2026-11-09'), LocalDate.parse('2026-11-09'), 'Europe/Madrid')
        .first;
    expect(shifts.single.slot.label, 'Open');

    await database.saveTag(const Tag(id: 'tax', name: 'Tax', colorValue: 0xFFB07D5C, position: 0));
    final entry = entries.single.entry.copyWith(tagIds: {'tax'});
    await database.saveEntry(entry);
    final tagged = await database
        .watchEntriesBetween(LocalDate.parse('2026-11-15'), LocalDate.parse('2026-11-15'), 'Europe/Madrid')
        .first;
    expect(tagged.single.entry.tagIds, {'tax'});
    expect((await database.watchTags().first).single.name, 'Tax');

    final version = await database.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.single, 7);
  });

  test('migrates real v3 data and exposes the v0.3 tables', () async {
    final directory = await Directory.systemTemp.createTemp('mane-migration-v3');
    final path = '${directory.path}/mane.sqlite';
    final createdAt = DateTime.utc(2026, 11, 1).millisecondsSinceEpoch ~/ 1000;

    final raw = sqlite3.open(path);
    raw.execute(File('test/fixtures/schema_v3.sql').readAsStringSync());
    raw.execute(
      'INSERT INTO space_records (id, name, color, position, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?)',
      ['home', 'Home', 0xFF5B7F6B, 0, createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO entry_records '
      '(id, space_id, title, kind, date_key, all_day, status, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      ['bins', 'home', 'Bins', 'task', 20261109, 1, 'open', createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO tag_records (id, name, color, position, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?)',
      ['house', 'House', 0xFF5B7F6B, 0, createdAt, createdAt],
    );
    raw.execute('INSERT INTO entry_tag_records (entry_id, tag_id) VALUES (?, ?)', ['bins', 'house']);
    raw.dispose();

    final database = AppDatabase(NativeDatabase(File(path)), defaultTimeZone: 'Europe/Madrid');
    addTearDown(() async {
      await database.close();
      await directory.delete(recursive: true);
    });

    final entries = await database
        .watchEntriesBetween(LocalDate.parse('2026-11-09'), LocalDate.parse('2026-11-09'), 'Europe/Madrid')
        .first;
    expect(entries.single.entry.tagIds, {'house'});
    expect(entries.single.entry.source, isNull);
    expect(entries.single.entry.readOnly, isFalse);
    expect(entries.single.entry.repeatAfterCompletionDays, isNull);

    await database.saveHomeItem(const HomeItem(id: 'rice', name: 'Rice', quantity: 1, reorderLevel: 2));
    await database.saveShoppingItem(
      const ShoppingItem(id: 'buy-rice', name: 'Rice', quantity: 3, homeItemId: 'rice'),
    );
    await database.setShoppingChecked('buy-rice', true);
    final home = await database.watchHomeItems().first;
    expect(home.single.quantity, 4);
    expect((await database.watchShoppingItems().first).single.checked, isTrue);

    await database.saveShiftChecklistItems('missing-pattern', const []);
    final version = await database.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.single, 7);
  });

  test('migrates real v4 data and creates the pairing tables', () async {
    final directory = await Directory.systemTemp.createTemp('mane-migration-v4');
    final path = '${directory.path}/mane.sqlite';
    final createdAt = DateTime.utc(2026, 11, 1).millisecondsSinceEpoch ~/ 1000;

    final raw = sqlite3.open(path);
    raw.execute(File('test/fixtures/schema_v4.sql').readAsStringSync());
    raw.execute(
      'INSERT INTO space_records (id, name, color, position, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?)',
      ['personal', 'Personal', 0xFFB07D5C, 0, createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO space_records (id, name, color, position, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?)',
      ['home', 'Home', 0xFF5B7F6B, 1, createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO entry_records '
      '(id, space_id, title, kind, date_key, all_day, status, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      ['passport', 'personal', 'Renew passport', 'task', 20261109, 1, 'open', createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO entry_records '
      '(id, space_id, title, kind, date_key, all_day, status, source, external_id, read_only, '
      'created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        'imported',
        'personal',
        'Imported',
        'event',
        20261110,
        1,
        'open',
        'ics',
        'uid:x',
        1,
        createdAt,
        createdAt,
      ],
    );
    raw.execute(
      'INSERT INTO tag_records (id, name, color, position, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?)',
      ['admin', 'Admin', 0xFFB07D5C, 0, createdAt, createdAt],
    );
    raw.execute('INSERT INTO entry_tag_records (entry_id, tag_id) VALUES (?, ?)', ['passport', 'admin']);
    raw.execute(
      'INSERT INTO home_item_records '
      '(id, name, quantity, reorder_level, unit, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?)',
      ['coffee', 'Coffee', 100.0, 150.0, 'g', createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO shopping_item_records '
      '(id, name, quantity, unit, home_item_id, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?)',
      ['buy-coffee', 'Coffee', 250.0, 'g', 'coffee', createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO shift_pattern_records '
      '(id, space_id, name, time_zone, cycle_days, anchor_date_key, enabled, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      ['bar', 'home', 'Bar', 'Europe/Madrid', 7, 20261109, 1, createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO shift_slot_records (pattern_id, day_index, label, start_minute, end_minute) '
      'VALUES (?, ?, ?, ?, ?)',
      ['bar', 0, 'Open', 960, 1320],
    );
    raw.execute(
      'INSERT INTO shift_checklist_item_records (id, pattern_id, label, position) VALUES (?, ?, ?, ?)',
      ['count', 'bar', 'Count the drawer', 0],
    );
    raw.execute(
      'INSERT INTO shift_checklist_completion_records (item_id, date_key, created_at) VALUES (?, ?, ?)',
      ['count', 20261109, createdAt],
    );
    raw.execute('INSERT INTO setting_records (key, value) VALUES (?, ?)', ['themeMode', 'dark']);
    raw.dispose();

    final database = AppDatabase(NativeDatabase(File(path)), defaultTimeZone: 'Europe/Madrid');
    addTearDown(() async {
      await database.close();
      await directory.delete(recursive: true);
    });

    final entries = await database
        .watchEntriesBetween(LocalDate.parse('2026-11-09'), LocalDate.parse('2026-11-10'), 'Europe/Madrid')
        .first;
    final passport = entries.firstWhere((item) => item.entry.id == 'passport');
    expect(passport.entry.tagIds, {'admin'});
    final imported = entries.firstWhere((item) => item.entry.id == 'imported');
    expect(imported.entry.readOnly, isTrue);
    expect(imported.entry.source, 'ics');

    expect((await database.watchHomeItems().first).single.isLowStock, isTrue);
    expect((await database.watchShoppingItems().first).single.homeItemId, 'coffee');
    expect((await database.readShiftChecklistItems('bar')).single.label, 'Count the drawer');
    expect(
      await database.readShiftChecklistCompletions(
        'bar',
        LocalDate.parse('2026-11-09'),
        slotKey: '0:960:1320:Open',
      ),
      {'count'},
    );
    expect(await database.readIdentity(), isNull);
    expect(await database.readPairedDevices(), isEmpty);

    final now = DateTime.utc(2026, 11, 9, 8);
    await database.saveIdentity(
      LocalIdentity(
        deviceId: 'self',
        deviceName: 'Linux',
        username: 'muffin',
        pinSalt: 'c2FsdA==',
        pinHash: 'aGFzaA==',
        certificatePem: 'cert',
        privateKeyPem: 'key',
        mcpToken: 'token',
        createdAt: now,
        updatedAt: now,
      ),
    );
    final identity = await database.readIdentity();
    expect(identity!.deviceId, 'self');
    expect(identity.mcpToken, 'token');

    await database.savePairedDevice(
      PairedDevice(
        id: 'phone',
        name: 'Phone',
        username: 'muffin',
        certificateFingerprint: 'f' * 64,
        sharedKey: 'c2hhcmVk',
        host: '192.168.1.20',
        port: 8766,
        lastSeenAt: now,
        createdAt: now,
        updatedAt: now,
      ),
    );
    final paired = (await database.readPairedDevices()).single;
    expect(paired.name, 'Phone');
    expect(paired.host, '192.168.1.20');
    expect(paired.port, 8766);

    final version = await database.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.single, 7);
  });

  test('migrates real v5 checklist rows to per-slot keys', () async {
    final directory = await Directory.systemTemp.createTemp('mane-migration-v5');
    final path = '${directory.path}/mane.sqlite';
    final createdAt = DateTime.utc(2026, 11, 1).millisecondsSinceEpoch ~/ 1000;

    final raw = sqlite3.open(path);
    raw.execute(File('test/fixtures/schema_v5.sql').readAsStringSync());
    raw.execute(
      'INSERT INTO space_records (id, name, color, position, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?)',
      ['work', 'Work', 0xFF4A6FA5, 0, createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO tag_records (id, name, color, position, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?)',
      ['pizzeria', 'Pizzeria', 0xFF4A6FA5, 0, createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO shift_pattern_records '
      '(id, space_id, name, time_zone, cycle_days, anchor_date_key, enabled, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      ['bar', 'work', 'Bar', 'Europe/Madrid', 7, 20261109, 1, createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO shift_slot_records (pattern_id, day_index, label, start_minute, end_minute) '
      'VALUES (?, ?, ?, ?, ?)',
      ['bar', 0, 'Lunch', 720, 960],
    );
    raw.execute(
      'INSERT INTO shift_slot_records (pattern_id, day_index, label, start_minute, end_minute) '
      'VALUES (?, ?, ?, ?, ?)',
      ['bar', 0, 'Dinner', 1140, 1380],
    );
    raw.execute(
      'INSERT INTO shift_checklist_item_records (id, pattern_id, label, position) VALUES (?, ?, ?, ?)',
      ['count', 'bar', 'Count the drawer', 0],
    );
    raw.execute(
      'INSERT INTO shift_checklist_completion_records (item_id, date_key, created_at) VALUES (?, ?, ?)',
      ['count', 20261109, createdAt],
    );
    raw.dispose();

    final database = AppDatabase(NativeDatabase(File(path)), defaultTimeZone: 'Europe/Madrid');
    addTearDown(() async {
      await database.close();
      await directory.delete(recursive: true);
    });

    final pattern = (await database.watchShiftPatterns().first).single;
    final monday = LocalDate.parse('2026-11-09');
    final slots = pattern.slotsFor(monday);
    expect(slots.map((slot) => slot.label), ['Lunch', 'Dinner']);

    // The legacy tick belongs to the first slot of that date, not both.
    expect(await database.readShiftChecklistCompletions('bar', monday, slotKey: slots.first.key), {'count'});
    expect(await database.readShiftChecklistCompletions('bar', monday, slotKey: slots.last.key), isEmpty);

    await database.saveShiftPattern(
      pattern.copyWith(tagIds: {'pizzeria'}, commuteMinutes: 45, windDownMinutes: 20),
    );
    final saved = (await database.watchShiftPatterns().first).single;
    expect(saved.tagIds, {'pizzeria'});
    expect(saved.commuteMinutes, 45);
    expect(saved.windDownMinutes, 20);

    final version = await database.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.single, 7);
  });

  test('migrates real v6 rows to shopping order and purchase history', () async {
    final directory = await Directory.systemTemp.createTemp('mane-migration-v6');
    final path = '${directory.path}/mane.sqlite';
    final createdAt = DateTime.utc(2026, 11, 1).millisecondsSinceEpoch ~/ 1000;

    final raw = sqlite3.open(path);
    raw.execute(File('test/fixtures/schema_v6.sql').readAsStringSync());
    raw.execute(
      'INSERT INTO space_records (id, name, color, position, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?)',
      ['home', 'Home', 0xFF5B7F6B, 0, createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO home_item_records '
      '(id, name, category, location, quantity, unit, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      ['rice', 'Rice', 'Pantry', 'Kitchen', 2.0, 'kg', createdAt, createdAt],
    );
    raw.execute(
      'INSERT INTO shopping_item_records '
      '(id, name, quantity, unit, checked, note, home_item_id, created_at, updated_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      ['rice-buy', 'Rice', 3.0, 'kg', 0, '', 'rice', createdAt, createdAt],
    );
    raw.dispose();

    final database = AppDatabase(NativeDatabase(File(path)), defaultTimeZone: 'Europe/Madrid');
    addTearDown(() async {
      await database.close();
      await directory.delete(recursive: true);
    });

    final shopping = (await database.watchShoppingItems().first).single;
    expect(shopping.name, 'Rice');
    expect(shopping.position, 0);

    await database.setShoppingChecked('rice-buy', true);
    var items = await database.watchHomeItems().first;
    expect(items.single.quantity, 5.0);
    expect(await database.readPurchaseHistory('rice'), hasLength(1));

    await database.setShoppingChecked('rice-buy', false);
    items = await database.watchHomeItems().first;
    expect(items.single.quantity, 2.0);
    expect(await database.readPurchaseHistory('rice'), isEmpty);

    await database.adjustHomeQuantity('rice', 1.5, note: 'Shop run');
    items = await database.watchHomeItems().first;
    expect(items.single.quantity, 3.5);
    final history = await database.readPurchaseHistory('rice');
    expect(history.single.quantity, 1.5);
    expect(history.single.note, 'Shop run');

    final version = await database.customSelect('PRAGMA user_version').getSingle();
    expect(version.data.values.single, 7);
  });
}

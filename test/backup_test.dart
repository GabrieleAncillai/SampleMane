import 'dart:convert';
import 'dart:ffi';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/backup/backup_service.dart';
import 'package:mane/models/local_identity.dart';
import 'package:mane/models/paired_device.dart';
import 'package:mane/models/reminder.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane_core/mane_core.dart';
import 'package:sqlite3/open.dart';

void main() {
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
    initializeTimeZones();
    // The round-trip test deliberately keeps a source and target database.
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  late AppDatabase source;

  setUp(() async {
    source = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    await source.seedDefaults();
  });

  tearDown(() => source.close());

  Future<void> seedRealData(AppDatabase database) async {
    final now = DateTime.utc(2026, 11, 1, 8);
    await database.saveTag(const Tag(id: 'job-a', spaceId: 'work', name: 'Job A', colorValue: 0xFF4A6FA5));
    await database.saveTag(const Tag(id: 'old-tag', name: 'Old', colorValue: 0xFF8A5A5A));
    await database.saveEntry(
      Entry(
        id: 'bins',
        spaceId: 'home',
        title: 'Bins',
        notes: 'Tuesday night',
        date: LocalDate.parse('2026-11-09'),
        allDay: true,
        tagIds: const {'old-tag'},
        recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {1}),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.saveEntry(
      Entry(
        id: 'shift',
        spaceId: 'work',
        title: 'Late shift',
        date: LocalDate.parse('2026-11-09'),
        startMinute: 23 * 60,
        endMinute: 24 * 60,
        timeZone: 'America/New_York',
        tagIds: const {'job-a'},
        status: EntryStatus.done,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.saveEntry(
      Entry(
        id: 'old-entry',
        spaceId: 'personal',
        title: 'Old note',
        date: LocalDate.parse('2026-11-08'),
        allDay: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.softDeleteEntry('old-entry');
    await database.softDeleteTag('old-tag');
    await database.setOccurrenceCompleted('bins', LocalDate.parse('2026-11-09'), completed: true);
    await database.saveRemindersForEntry('shift', const [
      Reminder(id: 'shift:15', entryId: 'shift', offsetMinutes: 15),
      Reminder(id: 'shift:60', entryId: 'shift', offsetMinutes: 60),
    ]);
    await database.saveShiftPattern(
      ShiftPattern(
        id: 'rotation',
        spaceId: 'work',
        name: 'Rotation',
        timeZone: 'Europe/Madrid',
        cycleDays: 14,
        anchorDate: LocalDate.parse('2026-11-09'),
        slots: const [
          ShiftSlot(dayIndex: 0, label: 'Open', startMinute: 540, endMinute: 900),
          ShiftSlot(dayIndex: 5, label: 'Long', startMinute: 600, endMinute: 1380),
        ],
        exceptions: [
          ShiftException(
            date: LocalDate.parse('2026-11-14'),
            type: ShiftExceptionType.override,
            startMinute: 480,
            endMinute: 720,
            note: 'Training',
          ),
        ],
      ),
    );
    await database.writeSetting('themeMode', 'dark');
    await database.writeSetting('locale', 'es');
    await database.writeSetting('weekStart', '7');
  }

  test('backups exclude the pairing identity, certificates and shared keys', () async {
    final now = DateTime.utc(2026, 11, 1, 8);
    await source.saveIdentity(
      LocalIdentity(
        deviceId: 'self',
        deviceName: 'Linux',
        username: 'muffin',
        pinSalt: 'c2FsdA==',
        pinHash: 'cGluaGFzaA==',
        certificatePem: '-----BEGIN CERTIFICATE-----\nsecret\n-----END CERTIFICATE-----',
        privateKeyPem: '-----BEGIN PRIVATE KEY-----\nsecret\n-----END PRIVATE KEY-----',
        mcpToken: 'mcp-secret',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await source.savePairedDevice(
      PairedDevice(
        id: 'phone',
        name: 'Phone',
        username: 'muffin',
        certificateFingerprint: 'a' * 64,
        sharedKey: 'c2hhcmVkLXNlY3JldA==',
        host: '192.168.1.20',
        port: 8766,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final exported = await BackupService(source).exportJson();
    final payload = jsonDecode(exported) as Map<String, dynamic>;
    expect(payload['schemaVersion'], 5);
    expect(payload.containsKey('identity'), isFalse);
    expect(payload.containsKey('pairedDevices'), isFalse);
    expect(exported, isNot(contains('cGluaGFzaA==')));
    expect(exported, isNot(contains('c2hhcmVkLXNlY3JldA==')));
    expect(exported, isNot(contains('BEGIN PRIVATE KEY')));

    final target = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    addTearDown(target.close);
    await BackupService(target).importJson(exported);
    expect(await target.readIdentity(), isNull);
    expect(await target.readPairedDevices(), isEmpty);
  });

  test('export, clear and import round-trips every table', () async {
    await seedRealData(source);
    final exported = await BackupService(source).exportJson();

    final target = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    addTearDown(target.close);
    await BackupService(target).importJson(exported);

    final before = Map<String, Object?>.from(jsonDecode(exported) as Map);
    final after = Map<String, Object?>.from(jsonDecode(await BackupService(target).exportJson()) as Map);
    before.remove('exportedAt');
    after.remove('exportedAt');

    expect(after, before);
  });

  test('rejects a corrupt file without touching existing data', () async {
    await source.saveEntry(
      Entry(
        id: 'keep',
        spaceId: 'home',
        title: 'Keep me',
        date: LocalDate.parse('2026-11-09'),
        allDay: true,
        createdAt: DateTime.utc(2026, 11, 1),
        updatedAt: DateTime.utc(2026, 11, 1),
      ),
    );

    await expectLater(BackupService(source).importJson('{not json'), throwsA(isA<BackupFormatException>()));

    final entries = await source
        .watchEntriesBetween(LocalDate.parse('2026-11-09'), LocalDate.parse('2026-11-09'), 'Europe/Madrid')
        .first;
    expect(entries.single.entry.id, 'keep');
  });

  test('rejects a future schema version without touching existing data', () async {
    await source.saveEntry(
      Entry(
        id: 'keep',
        spaceId: 'home',
        title: 'Keep me',
        date: LocalDate.parse('2026-11-09'),
        allDay: true,
        createdAt: DateTime.utc(2026, 11, 1),
        updatedAt: DateTime.utc(2026, 11, 1),
      ),
    );
    final payload = jsonDecode(await BackupService(source).exportJson()) as Map<String, Object?>;
    payload['schemaVersion'] = 999;

    await expectLater(
      BackupService(source).importJson(jsonEncode(payload)),
      throwsA(isA<BackupVersionException>()),
    );

    final entries = await source
        .watchEntriesBetween(LocalDate.parse('2026-11-09'), LocalDate.parse('2026-11-09'), 'Europe/Madrid')
        .first;
    expect(entries.single.entry.id, 'keep');
  });

  test('rolls back when a row is malformed mid-import', () async {
    await source.saveEntry(
      Entry(
        id: 'keep',
        spaceId: 'home',
        title: 'Keep me',
        date: LocalDate.parse('2026-11-09'),
        allDay: true,
        createdAt: DateTime.utc(2026, 11, 1),
        updatedAt: DateTime.utc(2026, 11, 1),
      ),
    );
    final payload = jsonDecode(await BackupService(source).exportJson()) as Map<String, Object?>;
    final entries = payload['entries']! as List<Object?>;
    (entries.single! as Map<String, Object?>)['title'] = 42;

    await expectLater(
      BackupService(source).importJson(jsonEncode(payload)),
      throwsA(isA<BackupFormatException>()),
    );

    final loaded = await source
        .watchEntriesBetween(LocalDate.parse('2026-11-09'), LocalDate.parse('2026-11-09'), 'Europe/Madrid')
        .first;
    expect(loaded.single.entry.id, 'keep');
  });
}

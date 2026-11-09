import 'dart:convert';
import 'dart:ffi';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/import/gymmane_import.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane/services/planner_repository.dart';
import 'package:mane_core/mane_core.dart';
import 'package:sqlite3/open.dart';

void main() {
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
    initializeTimeZones();
  });

  late AppDatabase database;
  late PlannerRepository repository;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    await database.seedDefaults();
    repository = PlannerRepository(database);
  });

  tearDown(() => database.close());

  String backup({int? trainAt}) {
    final data = <String, Object?>{
      'routines': [
        {'id': 'push', 'n': 'Push day', 'g': 'Strength'},
        {'id': 'legs', 'n': 'Leg day', 'g': 'Strength'},
        {'id': 'old', 'n': 'Old routine', 'a': true},
      ],
      'weeklyPlan': {'1': 'push', '3': 'legs', '5': 'old', '6': 'missing'},
    };
    if (trainAt != null) data['trainAt'] = trainAt;
    return jsonEncode(data);
  }

  test('imports weekly gym blocks read-only and deduplicates', () async {
    final service = GymManeImportService(repository);
    final report = await service.importJson(
      backup(trainAt: 18 * 60),
      spaceId: 'personal',
      today: LocalDate.parse('2026-11-09'),
      timeZone: 'Europe/Madrid',
    );
    expect(report.imported, 2);
    expect(report.timed, 2);
    expect(report.allDay, 0);
    expect(report.skipped, 2);

    final entries = await database
        .watchEntriesBetween(LocalDate.parse('2026-11-09'), LocalDate.parse('2026-11-15'), 'Europe/Madrid')
        .first;
    final push = entries.where((item) => item.entry.title == 'Push day').toList();
    expect(push, isNotEmpty);
    expect(push.first.entry.readOnly, isTrue);
    expect(push.first.entry.source, 'gymmane');
    expect(push.first.entry.allDay, isFalse);
    expect(push.first.entry.startMinute, 18 * 60);
    expect(push.first.entry.endMinute, 19 * 60);
    expect(push.first.entry.recurrence?.weekdays, {1});

    final again = await service.importJson(
      backup(trainAt: 18 * 60),
      spaceId: 'personal',
      today: LocalDate.parse('2026-11-09'),
      timeZone: 'Europe/Madrid',
    );
    expect(again.imported, 0);
    expect(again.duplicates, 2);
  });

  test('falls back to all-day blocks when GymMane has no trainAt', () async {
    final report = await GymManeImportService(repository).importJson(
      backup(),
      spaceId: 'personal',
      today: LocalDate.parse('2026-11-09'),
      timeZone: 'Europe/Madrid',
    );
    expect(report.imported, 2);
    expect(report.allDay, 2);
    expect(report.timed, 0);

    final entries = await database
        .watchEntriesBetween(LocalDate.parse('2026-11-09'), LocalDate.parse('2026-11-15'), 'Europe/Madrid')
        .first;
    expect(entries.every((item) => item.entry.allDay), isTrue);
    expect(entries.every((item) => item.entry.notes.contains('GymMane')), isTrue);
  });

  test('rejects a payload without a GymMane weekly plan', () async {
    await expectLater(
      GymManeImportService(repository).importJson(
        '{"hello":"world"}',
        spaceId: 'personal',
        today: LocalDate.parse('2026-11-09'),
        timeZone: 'Europe/Madrid',
      ),
      throwsA(isA<GymManeImportException>()),
    );
  });
}

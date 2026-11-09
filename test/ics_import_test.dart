import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/import/ics_import_service.dart';
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
  late IcsImportService importer;
  late String source;

  final now = DateTime.utc(2026, 11, 9, 12);

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    await database.seedDefaults();
    importer = IcsImportService(PlannerRepository(database), clock: () => now);
    source = File('test/fixtures/calendar_basic.ics').readAsStringSync();
  });

  tearDown(() => database.close());

  test('imports events as read-only entries with their timezone and recurrence', () async {
    final report = await importer.importText(
      source,
      spaceId: 'personal',
      defaultTimeZone: 'Europe/Madrid',
      fallbackTitle: 'Imported calendar event',
    );
    expect(report.imported, 5);
    expect(report.duplicates, 0);
    expect(report.skipped, hasLength(2));

    final standup =
        (await database
                .watchEntriesBetween(
                  LocalDate.parse('2026-11-09'),
                  LocalDate.parse('2026-11-09'),
                  'Europe/Madrid',
                )
                .first)
            .singleWhere((item) => item.entry.title == 'Standup');
    expect(standup.entry.readOnly, isTrue);
    expect(standup.entry.source, 'ics');
    expect(standup.entry.externalId, 'uid:standup@example.com');
    expect(standup.entry.timeZone, 'Europe/Madrid');
    expect(standup.entry.recurrence?.frequency, RecurrenceFrequency.weekly);
    expect(standup.startAt, DateTime.utc(2026, 11, 9, 8));
    expect(standup.entry.spaceId, 'personal');

    final birthday =
        (await database
                .watchEntriesBetween(
                  LocalDate.parse('2026-11-14'),
                  LocalDate.parse('2026-11-14'),
                  'Europe/Madrid',
                )
                .first)
            .singleWhere((item) => item.entry.title == 'Alex birthday');
    expect(birthday.entry.allDay, isTrue);
    expect(birthday.entry.startAt, isNull);

    final holiday =
        (await database
                .watchEntriesBetween(
                  LocalDate.parse('2026-12-26'),
                  LocalDate.parse('2026-12-26'),
                  'Europe/Madrid',
                )
                .first)
            .singleWhere((item) => item.entry.title == 'Winter break');
    expect(holiday.entry.endDate, LocalDate.parse('2026-12-26'));

    final meeting =
        (await database
                .watchEntriesBetween(
                  LocalDate.parse('2026-11-10'),
                  LocalDate.parse('2026-11-10'),
                  'Europe/Madrid',
                )
                .first)
            .singleWhere((item) => item.entry.title == 'UTC meeting');
    expect(meeting.entry.externalId, 'fallback:20261110:900:UTC meeting');
    expect(meeting.entry.title, 'UTC meeting');
  });

  test('re-importing the same file deduplicates every event', () async {
    final first = await importer.importText(
      source,
      spaceId: 'personal',
      defaultTimeZone: 'Europe/Madrid',
      fallbackTitle: 'Imported calendar event',
    );
    expect(first.imported, 5);

    final second = await importer.importText(
      source,
      spaceId: 'personal',
      defaultTimeZone: 'Europe/Madrid',
      fallbackTitle: 'Imported calendar event',
    );
    expect(second.imported, 0);
    expect(second.duplicates, 5);

    final all = await database
        .watchEntriesBetween(LocalDate.parse('2026-01-01'), LocalDate.parse('2027-12-31'), 'Europe/Madrid')
        .first;
    expect(all.map((item) => item.entry.id).toSet(), hasLength(5));
  });

  test('an empty file reports nothing to import', () async {
    final report = await importer.importText(
      'BEGIN:VCALENDAR\nVERSION:2.0\nEND:VCALENDAR\n',
      spaceId: 'personal',
      defaultTimeZone: 'Europe/Madrid',
      fallbackTitle: 'Imported calendar event',
    );
    expect(report.imported, 0);
    expect(report.duplicates, 0);
    expect(report.skipped, isEmpty);
  });
}

import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/import/companion_import.dart';
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
  late String source;
  final now = DateTime.utc(2026, 11, 9, 12);

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    await database.seedDefaults();
    source = File('test/fixtures/companion_basic.json').readAsStringSync();
  });

  tearDown(() => database.close());

  CompanionImportService importer() => CompanionImportService(
    PlannerRepository(database),
    clock: () => now,
    idFactory: () => 'imported-${DateTime.now().microsecondsSinceEpoch}',
  );

  test('parses the documented export and reports invalid rows', () {
    final result = parseCompanionExport(source, defaultTimeZone: 'Europe/Madrid');
    expect(result.events, hasLength(4));
    expect(result.skipped.single.reason, 'Invalid time range');

    final gym = result.events.first;
    expect(gym.title, 'Gym');
    expect(gym.startMinute, 18 * 60);
    expect(gym.endMinute, 19 * 60);
    expect(gym.timeZone, 'Europe/Madrid');
    expect(gym.notes, 'Leg day');

    final late = result.events.firstWhere((event) => event.title == 'Late session');
    expect(late.endMinute, 1500);

    final dayOff = result.events.firstWhere((event) => event.title == 'Day off');
    expect(dayOff.allDay, isTrue);
    expect(dayOff.timeZone, isNull);

    final noId = result.events.firstWhere((event) => event.title == 'No id');
    expect(noId.externalId, 'fallback:20261112:600:No id');
  });

  test('imports read-only entries and deduplicates a re-import', () async {
    final first = await importer().importText(source, spaceId: 'personal', defaultTimeZone: 'Europe/Madrid');
    expect(first.imported, 4);
    expect(first.duplicates, 0);
    expect(first.skipped, hasLength(1));

    final gym =
        (await database
                .watchEntriesBetween(
                  LocalDate.parse('2026-11-09'),
                  LocalDate.parse('2026-11-09'),
                  'Europe/Madrid',
                )
                .first)
            .singleWhere((item) => item.entry.title == 'Gym');
    expect(gym.entry.readOnly, isTrue);
    expect(gym.entry.source, 'companion');
    expect(gym.entry.externalId, 'id:gym-1');
    expect(gym.startAt, DateTime.utc(2026, 11, 9, 17));

    final second = await importer().importText(source, spaceId: 'personal', defaultTimeZone: 'Europe/Madrid');
    expect(second.imported, 0);
    expect(second.duplicates, 4);
  });

  test('rejects a file without an events list', () {
    expect(
      () => parseCompanionExport('{"app":"other"}', defaultTimeZone: 'Europe/Madrid'),
      throwsA(isA<CompanionFormatException>()),
    );
  });

  test('skips an unknown timezone instead of guessing', () {
    const text =
        '{"events":[{"title":"Gym","date":"2026-11-09","startMinute":600,'
        '"endMinute":660,"timeZone":"Mars/Olympus"}]}';
    final result = parseCompanionExport(text, defaultTimeZone: 'Europe/Madrid');
    expect(result.events, isEmpty);
    expect(result.skipped.single.reason, 'Unknown timezone');
  });
}

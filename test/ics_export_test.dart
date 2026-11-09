import 'dart:ffi';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/export/ics_export_service.dart';
import 'package:mane/features/import/ics_parser.dart';
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

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    await database.seedDefaults();
  });

  tearDown(() => database.close());

  test('exports recurring entries, exceptions and shifts as readable ICS', () async {
    final now = DateTime.utc(2026, 11, 1, 8);
    final anchor = LocalDate.parse('2026-11-02');
    await database.saveEntry(
      Entry(
        id: 'sync',
        spaceId: 'work',
        title: 'Weekly sync',
        notes: 'Bring notes',
        date: anchor,
        startMinute: 9 * 60,
        endMinute: 9 * 60 + 30,
        timeZone: 'Europe/Madrid',
        recurrence: RecurrenceRule(
          frequency: RecurrenceFrequency.weekly,
          weekdays: {DateTime.monday},
          count: 6,
          skipDates: {anchor.addDays(14)},
          overrides: [
            RecurrenceOverride(
              date: anchor.addDays(7),
              dateOverride: anchor.addDays(8),
              startMinute: 14 * 60,
              endMinute: 15 * 60,
              title: 'Moved sync',
            ),
          ],
        ),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.saveEntry(
      Entry(
        id: 'trip',
        spaceId: 'personal',
        title: 'Trip',
        kind: EntryKind.event,
        date: LocalDate.parse('2026-11-12'),
        endDate: LocalDate.parse('2026-11-14'),
        allDay: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.saveShiftPattern(
      ShiftPattern(
        id: 'bar',
        spaceId: 'work',
        name: 'Bar',
        timeZone: 'Europe/Madrid',
        cycleDays: 7,
        anchorDate: anchor,
        slots: const [ShiftSlot(dayIndex: 0, label: 'Floor', startMinute: 15 * 60, endMinute: 23 * 60)],
      ),
    );

    final service = IcsExportService(PlannerRepository(database), clock: () => now);
    final text = await service.exportRange(
      start: LocalDate.parse('2026-11-01'),
      end: LocalDate.parse('2026-11-30'),
      viewerTimeZone: 'Europe/Madrid',
    );

    expect(text, startsWith('BEGIN:VCALENDAR'));
    expect(text, contains('SUMMARY:Weekly sync'));
    expect(text, contains('RRULE:FREQ=WEEKLY;BYDAY=MO;COUNT=6'));
    expect(text, contains('EXDATE;TZID=Europe/Madrid:20261116T090000'));
    expect(text, contains('RECURRENCE-ID;TZID=Europe/Madrid:20261109T090000'));
    expect(text, contains('SUMMARY:Moved sync'));
    expect(text, contains('DTSTART;VALUE=DATE:20261112'));
    expect(text, contains('DTEND;VALUE=DATE:20261115'));
    expect(text, contains('SUMMARY:Bar · Floor'));

    final parsed = parseIcs(text, defaultTimeZone: 'Europe/Madrid');
    expect(parsed.skipped, isEmpty);
    final sync = parsed.events.firstWhere((event) => event.summary == 'Weekly sync');
    expect(sync.recurrence?.skipDates, {LocalDate.parse('2026-11-16')});
    expect(sync.recurrence?.overrides.single.title, 'Moved sync');
    final trip = parsed.events.firstWhere((event) => event.summary == 'Trip');
    expect(trip.allDay, isTrue);
    expect(trip.endDate, LocalDate.parse('2026-11-14'));
    expect(parsed.events.where((event) => event.summary == 'Bar · Floor'), isNotEmpty);
  });
}

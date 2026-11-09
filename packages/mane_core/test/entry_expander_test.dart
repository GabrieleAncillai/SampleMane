import 'package:mane_core/mane_core.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(initializeTimeZones);

  final now = DateTime.utc(2026, 11, 9, 8);
  final monday = LocalDate.parse('2026-03-02');

  Entry timed({
    required String timeZone,
    int startMinute = 9 * 60,
    int endMinute = 10 * 60,
    RecurrenceRule? recurrence,
    String id = 'timed',
  }) => Entry(
    id: id,
    spaceId: 'work',
    title: 'Shift',
    date: monday,
    startMinute: startMinute,
    endMinute: endMinute,
    timeZone: timeZone,
    recurrence: recurrence,
    createdAt: now,
    updatedAt: now,
  );

  test('expands a recurring 09:00 entry across spring-forward', () {
    final entry = timed(
      timeZone: 'America/New_York',
      recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.daily),
    );

    final occurrences = expandEntries(
      entries: [entry],
      start: LocalDate.parse('2026-03-06'),
      end: LocalDate.parse('2026-03-10'),
      viewerTimeZone: 'America/New_York',
    );

    expect(occurrences.map((item) => item.displayDate.iso), [
      '2026-03-06',
      '2026-03-07',
      '2026-03-08',
      '2026-03-09',
      '2026-03-10',
    ]);
    for (final occurrence in occurrences) {
      final local = localDateTimeAt(occurrence.startAt!, 'America/New_York');
      expect(local.hour, 9);
      expect(local.minute, 0);
    }
    expect(occurrences[1].startAt, DateTime.utc(2026, 3, 7, 14));
    expect(occurrences[2].startAt, DateTime.utc(2026, 3, 8, 13));
  });

  test('expands a recurring 09:00 entry across fall-back', () {
    final entry = timed(
      timeZone: 'America/New_York',
      recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.daily),
    );

    final occurrences = expandEntries(
      entries: [entry],
      start: LocalDate.parse('2026-10-31'),
      end: LocalDate.parse('2026-11-02'),
      viewerTimeZone: 'America/New_York',
    );

    expect(occurrences[0].startAt, DateTime.utc(2026, 10, 31, 13));
    expect(occurrences[1].startAt, DateTime.utc(2026, 11, 1, 14));
    for (final occurrence in occurrences) {
      expect(localDateTimeAt(occurrence.startAt!, 'America/New_York').hour, 9);
    }
  });

  test('travel moves a timed occurrence to the viewer date', () {
    final entry = timed(timeZone: 'America/New_York', startMinute: 23 * 60, endMinute: 23 * 60 + 60);

    final inNewYork = expandEntries(
      entries: [entry],
      start: LocalDate.parse('2026-03-02'),
      end: LocalDate.parse('2026-03-02'),
      viewerTimeZone: 'America/New_York',
    );
    final inMadrid = expandEntries(
      entries: [entry],
      start: LocalDate.parse('2026-03-03'),
      end: LocalDate.parse('2026-03-03'),
      viewerTimeZone: 'Europe/Madrid',
    );

    expect(inNewYork, hasLength(1));
    expect(inNewYork.single.displayDate, LocalDate.parse('2026-03-02'));
    expect(inMadrid, hasLength(1));
    expect(inMadrid.single.displayDate, LocalDate.parse('2026-03-03'));
    expect(inMadrid.single.date, LocalDate.parse('2026-03-02'));
  });

  test('an all-day birthday does not shift with travel', () {
    final birthday = Entry(
      id: 'birthday',
      spaceId: 'personal',
      title: 'Birthday',
      date: LocalDate.parse('2026-03-08'),
      allDay: true,
      recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.yearly),
      createdAt: now,
      updatedAt: now,
    );

    final occurrences = expandEntries(
      entries: [birthday],
      start: LocalDate.parse('2026-03-08'),
      end: LocalDate.parse('2026-03-08'),
      viewerTimeZone: 'Pacific/Auckland',
    );

    expect(occurrences, hasLength(1));
    expect(occurrences.single.displayDate, LocalDate.parse('2026-03-08'));
  });

  test('completion is keyed by the stored occurrence date', () {
    final entry = timed(
      timeZone: 'America/New_York',
      startMinute: 23 * 60,
      endMinute: 23 * 60 + 60,
      recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.daily),
    );
    final completed = {
      entry.id: {monday},
    };

    final shownInMadrid = expandEntries(
      entries: [entry],
      start: LocalDate.parse('2026-03-03'),
      end: LocalDate.parse('2026-03-03'),
      viewerTimeZone: 'Europe/Madrid',
      completions: completed,
    );

    expect(shownInMadrid.single.displayDate, LocalDate.parse('2026-03-03'));
    expect(shownInMadrid.single.completed, isTrue);
  });

  test('a multi-day all-day entry appears on every day it covers', () {
    final trip = Entry(
      id: 'trip',
      spaceId: 'personal',
      title: 'Trip',
      date: LocalDate.parse('2026-03-02'),
      endDate: LocalDate.parse('2026-03-04'),
      allDay: true,
      kind: EntryKind.event,
      createdAt: now,
      updatedAt: now,
    );

    final occurrences = expandEntries(
      entries: [trip],
      start: LocalDate.parse('2026-03-03'),
      end: LocalDate.parse('2026-03-05'),
      viewerTimeZone: 'Europe/Madrid',
    );

    expect(occurrences.map((item) => item.displayDate.iso), ['2026-03-03', '2026-03-04']);
  });

  test('all-day items sort before timed items on the same day', () {
    final allDay = Entry(
      id: 'a',
      spaceId: 'home',
      title: 'Bins',
      date: monday,
      allDay: true,
      createdAt: now,
      updatedAt: now,
    );
    final work = timed(timeZone: 'Europe/Madrid');

    final occurrences = expandEntries(
      entries: [work, allDay],
      start: monday,
      end: monday,
      viewerTimeZone: 'Europe/Madrid',
    );

    expect(occurrences.first.entry.id, 'a');
    expect(occurrences.last.entry.id, 'timed');
  });
}

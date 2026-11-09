import 'package:flutter_test/flutter_test.dart';
import 'package:mane/models/reminder.dart';
import 'package:mane/services/reminder_planner.dart';
import 'package:mane_core/mane_core.dart';

void main() {
  setUpAll(initializeTimeZones);

  final createdAt = DateTime.utc(2026, 3, 1);
  final monday = LocalDate.parse('2026-03-02');

  Entry timedEntry({RecurrenceRule? recurrence}) => Entry(
    id: 'standup',
    spaceId: 'work',
    title: 'Standup',
    date: monday,
    startMinute: 9 * 60,
    endMinute: 9 * 60 + 30,
    timeZone: 'America/New_York',
    recurrence: recurrence,
    createdAt: createdAt,
    updatedAt: createdAt,
  );

  test('schedules each reminder before a timed occurrence', () {
    final entry = timedEntry();
    final occurrences = expandEntries(
      entries: [entry],
      start: monday,
      end: monday,
      viewerTimeZone: 'America/New_York',
    );
    final plans = planReminders(
      occurrences: occurrences,
      remindersByEntry: {
        entry.id: [
          const Reminder(id: 'r60', entryId: 'standup', offsetMinutes: 60),
          const Reminder(id: 'r10', entryId: 'standup', offsetMinutes: 10),
        ],
      },
      now: DateTime.utc(2026, 3, 2, 0),
      deviceTimeZone: 'America/New_York',
    );

    expect(plans, hasLength(2));
    expect(plans.first.fireAt, DateTime.utc(2026, 3, 2, 13));
    expect(plans.last.fireAt, DateTime.utc(2026, 3, 2, 13, 50));
  });

  test('counts all-day reminders from 09:00 local and can cross to the day before', () {
    final entry = Entry(
      id: 'taxes',
      spaceId: 'personal',
      title: 'Taxes',
      date: LocalDate.parse('2026-04-10'),
      allDay: true,
      createdAt: createdAt,
      updatedAt: createdAt,
    );
    final occurrences = expandEntries(
      entries: [entry],
      start: LocalDate.parse('2026-04-09'),
      end: LocalDate.parse('2026-04-10'),
      viewerTimeZone: 'Europe/Madrid',
    );
    final plans = planReminders(
      occurrences: occurrences,
      remindersByEntry: {
        entry.id: [
          const Reminder(id: 'r0', entryId: 'taxes', offsetMinutes: 0),
          const Reminder(id: 'r1d', entryId: 'taxes', offsetMinutes: 1440),
        ],
      },
      now: DateTime.utc(2026, 4, 1),
      deviceTimeZone: 'Europe/Madrid',
    );

    expect(plans, hasLength(2));
    expect(plans.first.fireAt, DateTime.utc(2026, 4, 9, 7));
    expect(plans.last.fireAt, DateTime.utc(2026, 4, 10, 7));
  });

  test('does not schedule a completed occurrence or a past reminder', () {
    final entry = timedEntry();
    final occurrence = EntryOccurrence(
      date: monday,
      displayDate: monday,
      entry: entry,
      completed: true,
      startAt: entry.startAt,
      endAt: entry.endAt,
    );
    final plans = planReminders(
      occurrences: [occurrence],
      remindersByEntry: {
        entry.id: [const Reminder(id: 'r10', entryId: 'standup', offsetMinutes: 10)],
      },
      now: DateTime.utc(2026, 3, 2, 0),
      deviceTimeZone: 'America/New_York',
    );
    expect(plans, isEmpty);

    final open = EntryOccurrence(
      date: monday,
      displayDate: monday,
      entry: entry,
      startAt: entry.startAt,
      endAt: entry.endAt,
    );
    final past = planReminders(
      occurrences: [open],
      remindersByEntry: {
        entry.id: [const Reminder(id: 'r10', entryId: 'standup', offsetMinutes: 10)],
      },
      now: DateTime.utc(2026, 3, 3),
      deviceTimeZone: 'America/New_York',
    );
    expect(past, isEmpty);
  });

  test('a recurring reminder keeps local wall time across spring-forward', () {
    final entry = timedEntry(recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.daily));
    final occurrences = expandEntries(
      entries: [entry],
      start: LocalDate.parse('2026-03-07'),
      end: LocalDate.parse('2026-03-08'),
      viewerTimeZone: 'America/New_York',
    );
    final plans = planReminders(
      occurrences: occurrences,
      remindersByEntry: {
        entry.id: [const Reminder(id: 'r10', entryId: 'standup', offsetMinutes: 10)],
      },
      now: DateTime.utc(2026, 3, 7),
      deviceTimeZone: 'America/New_York',
    );

    expect(plans, hasLength(2));
    expect(plans[0].fireAt, DateTime.utc(2026, 3, 7, 13, 50));
    expect(plans[1].fireAt, DateTime.utc(2026, 3, 8, 12, 50));
  });

  test('a custom time fires on the occurrence day in the device zone', () {
    final entry = timedEntry();
    final occurrences = expandEntries(
      entries: [entry],
      start: monday,
      end: monday,
      viewerTimeZone: 'America/New_York',
    );
    final plans = planReminders(
      occurrences: occurrences,
      remindersByEntry: {
        entry.id: [const Reminder(id: 'at8', entryId: 'standup', offsetMinutes: 0, timeMinute: 8 * 60)],
      },
      now: DateTime.utc(2026, 3, 2, 0),
      deviceTimeZone: 'America/New_York',
    );

    expect(plans.single.fireAt, DateTime.utc(2026, 3, 2, 13));
    expect(plans.single.date, monday);
  });

  test('quiet hours suppress every reminder inside the window', () {
    final entry = timedEntry();
    final occurrences = expandEntries(
      entries: [entry],
      start: monday,
      end: monday,
      viewerTimeZone: 'America/New_York',
    );
    final plans = planReminders(
      occurrences: occurrences,
      remindersByEntry: {
        entry.id: [const Reminder(id: 'at23', entryId: 'standup', offsetMinutes: 0, timeMinute: 23 * 60)],
      },
      now: DateTime.utc(2026, 3, 2, 0),
      deviceTimeZone: 'America/New_York',
      quietHours: (start: 22 * 60, end: 7 * 60),
    );
    expect(plans, isEmpty);
  });

  test('work hours suppress work reminders but not personal ones', () {
    final work = timedEntry();
    final personal = Entry(
      id: 'dinner',
      spaceId: 'personal',
      title: 'Dinner',
      date: monday,
      startMinute: 19 * 60,
      endMinute: 20 * 60,
      timeZone: 'America/New_York',
      createdAt: createdAt,
      updatedAt: createdAt,
    );
    final occurrences = expandEntries(
      entries: [work, personal],
      start: monday,
      end: monday,
      viewerTimeZone: 'America/New_York',
    );
    final plans = planReminders(
      occurrences: occurrences,
      remindersByEntry: {
        work.id: [const Reminder(id: 'w18', entryId: 'standup', offsetMinutes: 0, timeMinute: 18 * 60)],
        personal.id: [const Reminder(id: 'p18', entryId: 'dinner', offsetMinutes: 0, timeMinute: 18 * 60)],
      },
      now: DateTime.utc(2026, 3, 2, 0),
      deviceTimeZone: 'America/New_York',
      workHours: (start: 9 * 60, end: 17 * 60),
    );

    expect(plans.map((plan) => plan.entryId), ['dinner']);
  });

  test('a custom time keeps local wall time across spring-forward', () {
    final entry = timedEntry(recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.daily));
    final occurrences = expandEntries(
      entries: [entry],
      start: LocalDate.parse('2026-03-07'),
      end: LocalDate.parse('2026-03-08'),
      viewerTimeZone: 'America/New_York',
    );
    final plans = planReminders(
      occurrences: occurrences,
      remindersByEntry: {
        entry.id: [const Reminder(id: 'at8', entryId: 'standup', offsetMinutes: 0, timeMinute: 8 * 60)],
      },
      now: DateTime.utc(2026, 3, 7),
      deviceTimeZone: 'America/New_York',
    );

    expect(plans, hasLength(2));
    expect(plans[0].fireAt, DateTime.utc(2026, 3, 7, 13));
    expect(plans[1].fireAt, DateTime.utc(2026, 3, 8, 12));
  });

  test('notification ids are stable and distinct per occurrence', () {
    final first = notificationIdFor('entry', 'entry:10', 20260302);
    final again = notificationIdFor('entry', 'entry:10', 20260302);
    final nextDay = notificationIdFor('entry', 'entry:10', 20260303);

    expect(first, again);
    expect(first, isNot(nextDay));
    expect(first, greaterThan(0));
  });
}

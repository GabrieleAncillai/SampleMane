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

  test('notification ids are stable and distinct per occurrence', () {
    final first = notificationIdFor('entry', 'entry:10', 20260302);
    final again = notificationIdFor('entry', 'entry:10', 20260302);
    final nextDay = notificationIdFor('entry', 'entry:10', 20260303);

    expect(first, again);
    expect(first, isNot(nextDay));
    expect(first, greaterThan(0));
  });
}

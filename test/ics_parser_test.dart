import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/import/ics_parser.dart';
import 'package:mane_core/mane_core.dart';

void main() {
  late IcsParseResult result;

  setUpAll(() {
    initializeTimeZones();
    final source = File('test/fixtures/calendar_basic.ics').readAsStringSync();
    result = parseIcs(source, defaultTimeZone: 'Europe/Madrid');
  });

  test('parses timed, all-day and UTC events from one file', () {
    expect(result.events, hasLength(6));
    expect(result.skipped, hasLength(1));
  });

  test('keeps the TZID, wall time and absolute instant of a timed event', () {
    final standup = result.events.firstWhere((event) => event.summary == 'Standup');
    expect(standup.uid, 'standup@example.com');
    expect(standup.allDay, isFalse);
    expect(standup.timeZone, 'Europe/Madrid');
    expect(standup.date, LocalDate.parse('2026-11-09'));
    expect(standup.startMinute, 9 * 60);
    expect(standup.endMinute, 9 * 60 + 30);
    expect(standup.startAt, DateTime.utc(2026, 11, 9, 8));
    expect(standup.endAt, DateTime.utc(2026, 11, 9, 8, 30));
    expect(standup.description, 'Daily team sync\nBring notes');
  });

  test('maps a documented weekly RRULE subset', () {
    final standup = result.events.firstWhere((event) => event.summary == 'Standup');
    final rule = standup.recurrence!;
    expect(rule.frequency, RecurrenceFrequency.weekly);
    expect(rule.weekdays, {1, 2, 3, 4, 5});
    expect(rule.count, 5);
    expect(rule.interval, 1);
  });

  test('maps monthly BYMONTHDAY when it matches the anchor day', () {
    final rent = result.events.firstWhere((event) => event.summary == 'Rent');
    final rule = rent.recurrence!;
    expect(rule.frequency, RecurrenceFrequency.monthly);
    expect(rule.monthDay, 1);
    expect(rule.count, 3);
  });

  test('turns an all-day event into dates, not midnight instants', () {
    final birthday = result.events.firstWhere((event) => event.summary == 'Alex birthday');
    expect(birthday.allDay, isTrue);
    expect(birthday.date, LocalDate.parse('2026-11-14'));
    expect(birthday.endDate, isNull);
    expect(birthday.timeZone, isNull);
    expect(birthday.startAt, isNull);

    final holiday = result.events.firstWhere((event) => event.summary == 'Winter break');
    expect(holiday.date, LocalDate.parse('2026-12-24'));
    expect(holiday.endDate, LocalDate.parse('2026-12-26'));
  });

  test('stores a UTC event as UTC wall time and an absolute instant', () {
    final meeting = result.events.firstWhere((event) => event.summary == 'UTC meeting');
    expect(meeting.uid, isEmpty);
    expect(meeting.timeZone, 'UTC');
    expect(meeting.startMinute, 15 * 60);
    expect(meeting.endMinute, 16 * 60 + 30);
    expect(meeting.startAt, DateTime.utc(2026, 11, 10, 15));
    expect(meeting.endAt, DateTime.utc(2026, 11, 10, 16, 30));
  });

  test('reports unsupported events instead of guessing', () {
    final reasons = result.skipped.map((skip) => skip.reason).join(' | ');
    expect(reasons, contains('Unknown timezone: Mars/Olympus'));
    expect(result.events.where((event) => event.summary == 'Complex recurrence'), hasLength(1));
  });

  test('parses an ordinal monthly BYDAY', () {
    final complex = result.events.firstWhere((event) => event.summary == 'Complex recurrence');
    final rule = complex.recurrence!;
    expect(rule.frequency, RecurrenceFrequency.monthly);
    expect(rule.ordinalWeekdays.single.weekday, DateTime.monday);
    expect(rule.ordinalWeekdays.single.ordinal, 1);
  });

  test('merges EXDATE, RECURRENCE-ID and Windows TZIDs', () async {
    final source = File('test/fixtures/calendar_exceptions.ics').readAsStringSync();
    final parsed = parseIcs(source, defaultTimeZone: 'Europe/Madrid');
    expect(parsed.skipped, isEmpty);
    expect(parsed.events, hasLength(2));

    final series = parsed.events.firstWhere((event) => event.summary == 'Weekly sync');
    expect(series.timeZone, 'Europe/Berlin');
    final rule = series.recurrence!;
    expect(rule.skipDates, {LocalDate.parse('2026-11-16'), LocalDate.parse('2026-11-23')});
    final moved = rule.overrides.single;
    expect(moved.date, LocalDate.parse('2026-11-09'));
    expect(moved.effectiveDate, LocalDate.parse('2026-11-10'));
    expect(moved.startMinute, 14 * 60);
    expect(moved.endMinute, 15 * 60);
    expect(moved.title, 'Moved sync');

    final trip = parsed.events.firstWhere((event) => event.summary == 'Conference');
    expect(trip.allDay, isFalse);
    expect(trip.endDate, LocalDate.parse('2026-11-14'));
    expect(trip.endMinute, 10 * 60);
    expect(trip.endAt, DateTime.utc(2026, 11, 14, 15));
  });

  test('skips cancelled events without reporting them as unsupported', () {
    expect(result.events.where((event) => event.summary == 'Cancelled meeting'), isEmpty);
    expect(result.skipped.where((skip) => skip.summary == 'Cancelled meeting'), isEmpty);
  });
}

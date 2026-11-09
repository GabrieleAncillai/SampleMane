import 'package:mane_core/mane_core.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(initializeTimeZones);

  final monday = LocalDate.parse('2026-11-09');

  ShiftPattern twoWeekRotation({
    List<ShiftException> exceptions = const <ShiftException>[],
    String timeZone = 'Europe/Madrid',
  }) => ShiftPattern(
    id: 'job-rotation',
    spaceId: 'work',
    name: 'Two-week rotation',
    timeZone: timeZone,
    cycleDays: 14,
    anchorDate: monday,
    slots: const [
      ShiftSlot(dayIndex: 0, label: 'Shop', startMinute: 900, endMinute: 1320),
      ShiftSlot(dayIndex: 1, label: 'Shop', startMinute: 900, endMinute: 1320),
      ShiftSlot(dayIndex: 2, label: 'Shop', startMinute: 900, endMinute: 1320),
      ShiftSlot(dayIndex: 3, label: 'Shop', startMinute: 900, endMinute: 1320),
      ShiftSlot(dayIndex: 4, label: 'Shop', startMinute: 900, endMinute: 1320),
      ShiftSlot(dayIndex: 5, label: 'Shop', startMinute: 600, endMinute: 1380),
      ShiftSlot(dayIndex: 7, label: 'Shop', startMinute: 900, endMinute: 1320),
      ShiftSlot(dayIndex: 8, label: 'Shop', startMinute: 900, endMinute: 1320),
      ShiftSlot(dayIndex: 9, label: 'Shop', startMinute: 900, endMinute: 1320),
      ShiftSlot(dayIndex: 10, label: 'Shop', startMinute: 900, endMinute: 1320),
      ShiftSlot(dayIndex: 11, label: 'Shop', startMinute: 900, endMinute: 1320),
      ShiftSlot(dayIndex: 13, label: 'Shop', startMinute: 600, endMinute: 1320),
    ],
    exceptions: exceptions,
  );

  group('cycle', () {
    test('finds the slots for a date inside the cycle', () {
      final pattern = twoWeekRotation();
      expect(pattern.slotsFor(monday).single.startMinute, 900);
      expect(pattern.slotsFor(monday.addDays(5)).single.startMinute, 600);
      expect(pattern.slotsFor(monday.addDays(6)), isEmpty);
      expect(pattern.slotsFor(monday.addDays(13)).single.startMinute, 600);
      expect(pattern.slotsFor(monday.addDays(14)).single.startMinute, 900);
    });

    test('handles dates before the anchor with a non-negative index', () {
      final pattern = twoWeekRotation();
      expect(pattern.cycleIndexFor(monday.addDays(-7)), 7);
      expect(pattern.slotsFor(monday.addDays(-7)).single.startMinute, 900);
    });

    test('allows several slots on the same cycle day', () {
      final pattern = ShiftPattern(
        id: 'split',
        spaceId: 'work',
        name: 'Split shift',
        timeZone: 'Europe/Madrid',
        cycleDays: 7,
        anchorDate: monday,
        slots: const [
          ShiftSlot(dayIndex: 0, label: 'Lunch', startMinute: 720, endMinute: 960),
          ShiftSlot(dayIndex: 0, label: 'Dinner', startMinute: 1140, endMinute: 1380),
        ],
      );

      expect(pattern.slotsFor(monday).map((slot) => slot.label), ['Lunch', 'Dinner']);
      expect(pattern.findConflicts(), isEmpty);
    });

    test('expands a date range', () {
      final pattern = twoWeekRotation();
      final occurrences = pattern.occurrencesBetween(monday, monday.addDays(13));
      expect(occurrences, hasLength(12));
      expect(occurrences.first.date, monday);
      expect(occurrences.map((item) => item.date).toSet(), hasLength(12));
    });

    test('expands four weeks of the 14-day pattern', () {
      final pattern = twoWeekRotation();
      final occurrences = pattern.occurrencesBetween(monday, monday.addDays(27));
      expect(occurrences, hasLength(24));
      expect(occurrences.where((item) => item.slot.startMinute == 600).map((item) => item.date.iso), [
        '2026-11-14',
        '2026-11-22',
        '2026-11-28',
        '2026-12-06',
      ]);
    });

    test('rejects a day index outside the cycle', () {
      expect(
        () => ShiftPattern(
          id: 'bad',
          spaceId: 'work',
          name: 'Bad',
          timeZone: 'Europe/Madrid',
          cycleDays: 7,
          anchorDate: monday,
          slots: const [ShiftSlot(dayIndex: 8, label: 'A', startMinute: 0, endMinute: 60)],
        ),
        throwsArgumentError,
      );
    });
  });

  group('timezone', () {
    test('resolves slot times as instants in the pattern timezone', () {
      final pattern = ShiftPattern(
        id: 'night',
        spaceId: 'work',
        name: 'Night',
        timeZone: 'America/New_York',
        cycleDays: 7,
        anchorDate: monday,
        slots: const [ShiftSlot(dayIndex: 0, label: 'Night', startMinute: 1320, endMinute: 1800)],
      );

      final occurrence = pattern.occurrencesBetween(monday, monday).single;
      expect(occurrence.startAt, DateTime.utc(2026, 11, 10, 3));
      expect(occurrence.endAt, DateTime.utc(2026, 11, 10, 11));
      expect(occurrence.slot.crossesMidnight, isTrue);
    });

    test('a viewer in another timezone sees the shift on its local date', () {
      final pattern = ShiftPattern(
        id: 'night',
        spaceId: 'work',
        name: 'Night',
        timeZone: 'America/New_York',
        cycleDays: 7,
        anchorDate: monday,
        slots: const [ShiftSlot(dayIndex: 0, label: 'Night', startMinute: 1320, endMinute: 1800)],
      );

      final occurrence = pattern.occurrencesBetween(monday, monday, viewerTimeZone: 'Asia/Tokyo').single;
      expect(occurrence.date, monday);
      expect(occurrence.displayDate, LocalDate.parse('2026-11-10'));
    });

    test('a 14:00 shift keeps its wall time across a DST change', () {
      final pattern = ShiftPattern(
        id: 'day',
        spaceId: 'work',
        name: 'Day',
        timeZone: 'America/New_York',
        cycleDays: 1,
        anchorDate: LocalDate.parse('2026-03-07'),
        slots: const [ShiftSlot(dayIndex: 0, label: 'Day', startMinute: 14 * 60, endMinute: 22 * 60)],
      );

      final occurrences = pattern.occurrencesBetween(
        LocalDate.parse('2026-03-07'),
        LocalDate.parse('2026-03-08'),
        viewerTimeZone: 'America/New_York',
      );
      expect(occurrences, hasLength(2));
      expect(occurrences[0].startAt, DateTime.utc(2026, 3, 7, 19));
      expect(occurrences[1].startAt, DateTime.utc(2026, 3, 8, 18));
      expect(localDateTimeAt(occurrences[1].startAt, 'America/New_York').hour, 14);
    });
  });

  group('exceptions', () {
    test('a free day removes the cycle slots', () {
      final pattern = twoWeekRotation(
        exceptions: [ShiftException(date: monday, type: ShiftExceptionType.free)],
      );
      expect(pattern.slotsFor(monday), isEmpty);
    });

    test('an override replaces the cycle slots for that date', () {
      final pattern = twoWeekRotation(
        exceptions: [
          ShiftException(
            date: monday,
            type: ShiftExceptionType.override,
            startMinute: 480,
            endMinute: 720,
            note: 'Training',
          ),
        ],
      );
      final slots = pattern.slotsFor(monday);
      expect(slots, hasLength(1));
      expect(slots.single.startMinute, 480);
      expect(slots.single.label, 'Training');
    });

    test('extra shifts add to the cycle slots', () {
      final pattern = twoWeekRotation(
        exceptions: [
          ShiftException(
            date: monday,
            type: ShiftExceptionType.extra,
            startMinute: 1080,
            endMinute: 1200,
            note: 'Stock take',
          ),
        ],
      );
      final slots = pattern.slotsFor(monday);
      expect(slots.map((slot) => slot.startMinute), [900, 1080]);
    });

    test('free wins over other exceptions on the same date', () {
      final pattern = twoWeekRotation(
        exceptions: [
          ShiftException(date: monday, type: ShiftExceptionType.free),
          ShiftException(date: monday, type: ShiftExceptionType.extra, startMinute: 1080, endMinute: 1200),
        ],
      );
      expect(pattern.slotsFor(monday), isEmpty);
    });

    test('rejects an override without times', () {
      expect(
        () => ShiftPattern(
          id: 'bad',
          spaceId: 'work',
          name: 'Bad',
          timeZone: 'Europe/Madrid',
          cycleDays: 7,
          anchorDate: monday,
          exceptions: [ShiftException(date: monday, type: ShiftExceptionType.override)],
        ),
        throwsArgumentError,
      );
    });
  });

  group('conflicts', () {
    test('reports overlapping slots on the same day', () {
      final pattern = ShiftPattern(
        id: 'overlap',
        spaceId: 'work',
        name: 'Overlap',
        timeZone: 'Europe/Madrid',
        cycleDays: 7,
        anchorDate: monday,
        slots: const [
          ShiftSlot(dayIndex: 0, label: 'A', startMinute: 600, endMinute: 900),
          ShiftSlot(dayIndex: 0, label: 'B', startMinute: 840, endMinute: 1020),
        ],
      );
      expect(pattern.findConflicts(horizonDays: 7), hasLength(1));
    });

    test('reports an overnight shift overlapping the next day', () {
      final pattern = ShiftPattern(
        id: 'overnight',
        spaceId: 'work',
        name: 'Overnight',
        timeZone: 'Europe/Madrid',
        cycleDays: 7,
        anchorDate: monday,
        slots: const [
          ShiftSlot(dayIndex: 0, label: 'Night', startMinute: 1320, endMinute: 1800),
          ShiftSlot(dayIndex: 1, label: 'Morning', startMinute: 300, endMinute: 720),
        ],
      );
      expect(pattern.findConflicts(horizonDays: 7), hasLength(1));
    });

    test('accepts adjacent shifts', () {
      final pattern = ShiftPattern(
        id: 'adjacent',
        spaceId: 'work',
        name: 'Adjacent',
        timeZone: 'Europe/Madrid',
        cycleDays: 7,
        anchorDate: monday,
        slots: const [
          ShiftSlot(dayIndex: 0, label: 'A', startMinute: 600, endMinute: 900),
          ShiftSlot(dayIndex: 0, label: 'B', startMinute: 900, endMinute: 1020),
        ],
      );
      expect(pattern.findConflicts(), isEmpty);
    });
  });

  group('ShiftSlot', () {
    test('detects overnight shifts', () {
      const slot = ShiftSlot(dayIndex: 0, label: 'Night', startMinute: 1320, endMinute: 1560);
      expect(slot.crossesMidnight, isTrue);
      expect(slot.durationMinutes, 240);
    });

    test('JSON round-trips', () {
      const slot = ShiftSlot(dayIndex: 2, label: 'Late', startMinute: 900, endMinute: 1380);
      final restored = ShiftSlot.fromJson(slot.toJson());
      expect(restored.dayIndex, slot.dayIndex);
      expect(restored.label, slot.label);
      expect(restored.startMinute, slot.startMinute);
      expect(restored.endMinute, slot.endMinute);
    });
  });

  group('ShiftException', () {
    test('JSON round-trips', () {
      final exception = ShiftException(
        date: monday,
        type: ShiftExceptionType.override,
        startMinute: 480,
        endMinute: 720,
        note: 'Training',
      );
      final restored = ShiftException.fromJson(exception.toJson());
      expect(restored.date, exception.date);
      expect(restored.type, exception.type);
      expect(restored.startMinute, 480);
      expect(restored.endMinute, 720);
      expect(restored.note, 'Training');
    });
  });
}

import 'package:mane_core/mane_core.dart';
import 'package:test/test.dart';

void main() {
  final monday = LocalDate.parse('2026-11-09');

  ShiftPattern twoWeekRotation() => ShiftPattern(
    id: 'job-rotation',
    spaceId: 'work',
    name: 'Two-week rotation',
    cycleDays: 14,
    anchorDate: monday,
    slots: const [
      ShiftSlot(dayIndex: 0, label: 'Bank', startMinute: 600, endMinute: 1140),
      ShiftSlot(dayIndex: 1, label: 'Bank', startMinute: 600, endMinute: 1140),
      ShiftSlot(dayIndex: 2, label: 'Bank', startMinute: 600, endMinute: 1140),
      ShiftSlot(dayIndex: 3, label: 'Bank', startMinute: 600, endMinute: 1140),
      ShiftSlot(dayIndex: 4, label: 'Bank', startMinute: 600, endMinute: 1140),
      ShiftSlot(dayIndex: 7, label: 'Pizzeria', startMinute: 900, endMinute: 1380),
      ShiftSlot(dayIndex: 8, label: 'Pizzeria', startMinute: 900, endMinute: 1380),
      ShiftSlot(dayIndex: 9, label: 'Pizzeria', startMinute: 900, endMinute: 1380),
      ShiftSlot(dayIndex: 10, label: 'Pizzeria', startMinute: 900, endMinute: 1380),
      ShiftSlot(dayIndex: 11, label: 'Pizzeria', startMinute: 900, endMinute: 1380),
    ],
  );

  group('ShiftPattern', () {
    test('finds the shift for a date inside the cycle', () {
      final pattern = twoWeekRotation();
      expect(pattern.slotFor(monday)?.label, 'Bank');
      expect(pattern.slotFor(monday.addDays(4))?.label, 'Bank');
      expect(pattern.slotFor(monday.addDays(5)), isNull);
      expect(pattern.slotFor(monday.addDays(7))?.label, 'Pizzeria');
      expect(pattern.slotFor(monday.addDays(14))?.label, 'Bank');
    });

    test('handles dates before the anchor with a non-negative cycle index', () {
      final pattern = twoWeekRotation();
      expect(pattern.slotFor(monday.addDays(-7))?.label, 'Pizzeria');
    });

    test('expands a date range', () {
      final pattern = twoWeekRotation();
      final occurrences = pattern.occurrencesBetween(monday, monday.addDays(13));
      expect(occurrences, hasLength(10));
      expect(occurrences.first.slot.label, 'Bank');
      expect(occurrences.last.slot.label, 'Pizzeria');
    });

    test('rejects duplicate cycle days', () {
      expect(
        () => ShiftPattern(
          id: 'bad',
          spaceId: 'work',
          name: 'Bad',
          cycleDays: 7,
          anchorDate: monday,
          slots: const [
            ShiftSlot(dayIndex: 0, label: 'A', startMinute: 0, endMinute: 60),
            ShiftSlot(dayIndex: 0, label: 'B', startMinute: 120, endMinute: 180),
          ],
        ),
        throwsArgumentError,
      );
    });

    test('rejects a day index outside the cycle', () {
      expect(
        () => ShiftPattern(
          id: 'bad',
          spaceId: 'work',
          name: 'Bad',
          cycleDays: 7,
          anchorDate: monday,
          slots: const [ShiftSlot(dayIndex: 8, label: 'A', startMinute: 0, endMinute: 60)],
        ),
        throwsArgumentError,
      );
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
}

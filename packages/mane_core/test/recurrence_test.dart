import 'package:mane_core/mane_core.dart';
import 'package:test/test.dart';

void main() {
  final monday = LocalDate.parse('2026-11-09');
  final wednesday = LocalDate.parse('2026-11-11');
  final friday = LocalDate.parse('2026-11-13');

  group('daily', () {
    test('every day matches the anchor and the next days', () {
      const rule = RecurrenceRule(frequency: RecurrenceFrequency.daily);
      expect(rule.occursOn(monday, monday), isTrue);
      expect(rule.occursOn(monday.addDays(1), monday), isTrue);
      expect(rule.occursOn(monday.addDays(-1), monday), isFalse);
    });

    test('an interval skips days', () {
      const rule = RecurrenceRule(frequency: RecurrenceFrequency.daily, interval: 3);
      expect(rule.occursOn(monday.addDays(3), monday), isTrue);
      expect(rule.occursOn(monday.addDays(2), monday), isFalse);
    });
  });

  group('weekly', () {
    test('matches the selected weekdays', () {
      const rule = RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {1, 3, 5});
      expect(rule.occursOn(monday, monday), isTrue);
      expect(rule.occursOn(wednesday, monday), isTrue);
      expect(rule.occursOn(friday, monday), isTrue);
      expect(rule.occursOn(monday.addDays(1), monday), isFalse);
    });

    test('an interval skips whole weeks', () {
      const rule = RecurrenceRule(frequency: RecurrenceFrequency.weekly, interval: 2, weekdays: {1});
      expect(rule.occursOn(monday.addDays(14), monday), isTrue);
      expect(rule.occursOn(monday.addDays(7), monday), isFalse);
    });
  });

  group('monthly', () {
    test('a 31st rule clamps to the end of shorter months', () {
      final january = LocalDate.parse('2026-01-31');
      const rule = RecurrenceRule(frequency: RecurrenceFrequency.monthly, interval: 1, monthDay: 31);
      expect(rule.occursOn(LocalDate.parse('2026-02-28'), january), isTrue);
      expect(rule.occursOn(LocalDate.parse('2026-03-31'), january), isTrue);
      expect(rule.occursOn(LocalDate.parse('2026-04-30'), january), isTrue);
      expect(rule.occursOn(LocalDate.parse('2026-03-30'), january), isFalse);
    });
  });

  group('yearly', () {
    test('a leap-day anniversary falls on the 28th in normal years', () {
      final leapDay = LocalDate.parse('2024-02-29');
      const rule = RecurrenceRule(frequency: RecurrenceFrequency.yearly);
      expect(rule.occursOn(LocalDate.parse('2025-02-28'), leapDay), isTrue);
      expect(rule.occursOn(LocalDate.parse('2026-02-28'), leapDay), isTrue);
      expect(rule.occursOn(LocalDate.parse('2028-02-29'), leapDay), isTrue);
      expect(rule.occursOn(LocalDate.parse('2025-03-01'), leapDay), isFalse);
    });
  });

  group('bounds', () {
    test('until is inclusive', () {
      final rule = RecurrenceRule(frequency: RecurrenceFrequency.daily, until: LocalDate.parse('2026-11-11'));
      expect(rule.occursOn(LocalDate.parse('2026-11-11'), monday), isTrue);
      expect(rule.occursOn(LocalDate.parse('2026-11-12'), monday), isFalse);
    });

    test('count includes the anchor', () {
      const rule = RecurrenceRule(frequency: RecurrenceFrequency.daily, count: 3);
      expect(rule.occursOn(monday, monday), isTrue);
      expect(rule.occursOn(monday.addDays(2), monday), isTrue);
      expect(rule.occursOn(monday.addDays(3), monday), isFalse);
    });

    test('weekly count respects a mid-week anchor and selected days', () {
      const rule = RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {1, 3, 5}, count: 4);
      expect(rule.occursOn(wednesday, wednesday), isTrue); // 1
      expect(rule.occursOn(friday, wednesday), isTrue); // 2
      expect(rule.occursOn(monday.addDays(7), wednesday), isTrue); // 3
      expect(rule.occursOn(wednesday.addDays(7), wednesday), isTrue); // 4
      expect(rule.occursOn(friday.addDays(7), wednesday), isFalse);
    });

    test('weekly count with an interval counts only matching weeks', () {
      const rule = RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
        interval: 2,
        weekdays: {1},
        count: 2,
      );
      expect(rule.occursOn(monday, monday), isTrue);
      expect(rule.occursOn(monday.addDays(7), monday), isFalse);
      expect(rule.occursOn(monday.addDays(14), monday), isTrue);
      expect(rule.occursOn(monday.addDays(28), monday), isFalse);
    });

    test('a long-running count rule expands a year quickly', () {
      final anchor = LocalDate.parse('2000-01-01');
      const rule = RecurrenceRule(frequency: RecurrenceFrequency.daily, count: 1000000);
      final start = LocalDate.parse('2026-01-01');
      final stopwatch = Stopwatch()..start();
      final result = rule.occurrencesBetween(start, start.addDays(365), anchor);
      stopwatch.stop();
      expect(result, hasLength(366));
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });

  group('helpers', () {
    test('nextOnOrAfter finds the next match', () {
      const rule = RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {1, 3, 5});
      expect(rule.nextOnOrAfter(monday.addDays(1), monday), wednesday);
      expect(rule.nextOnOrAfter(monday, monday), monday);
    });

    test('nextOnOrAfter returns null after until', () {
      final rule = RecurrenceRule(frequency: RecurrenceFrequency.daily, until: LocalDate.parse('2026-11-10'));
      expect(rule.nextOnOrAfter(LocalDate.parse('2026-11-11'), monday), isNull);
    });

    test('occurrencesBetween expands a range', () {
      const rule = RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {1, 3, 5});
      final result = rule.occurrencesBetween(monday, LocalDate.parse('2026-11-15'), monday);
      expect(result, [monday, wednesday, friday]);
    });

    test('JSON round-trips', () {
      final rule = RecurrenceRule(
        frequency: RecurrenceFrequency.weekly,
        interval: 2,
        weekdays: {1, 5},
        until: LocalDate.parse('2027-01-01'),
        count: 10,
      );
      final restored = RecurrenceRule.fromJson(rule.toJson());
      expect(restored.frequency, rule.frequency);
      expect(restored.interval, rule.interval);
      expect(restored.weekdays, rule.weekdays);
      expect(restored.until, rule.until);
      expect(restored.count, rule.count);
    });

    test('a readable description is available', () {
      const rule = RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {1, 3});
      expect(rule.describe(), 'Every week on Mon, Wed');
    });
  });
}

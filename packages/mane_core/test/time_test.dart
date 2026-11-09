import 'package:mane_core/mane_core.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(initializeTimeZones);

  group('instants', () {
    test('spring-forward changes the UTC offset', () {
      final before = instantAt(LocalDate.parse('2026-03-07'), 9 * 60, 'America/New_York');
      final after = instantAt(LocalDate.parse('2026-03-08'), 9 * 60, 'America/New_York');

      expect(before, DateTime.utc(2026, 3, 7, 14));
      expect(after, DateTime.utc(2026, 3, 8, 13));
    });

    test('fall-back changes the UTC offset', () {
      final before = instantAt(LocalDate.parse('2026-10-31'), 9 * 60, 'America/New_York');
      final after = instantAt(LocalDate.parse('2026-11-01'), 9 * 60, 'America/New_York');

      expect(before, DateTime.utc(2026, 10, 31, 13));
      expect(after, DateTime.utc(2026, 11, 1, 14));
    });

    test('a nonexistent spring-forward time is normalised forward', () {
      final instant = instantAt(LocalDate.parse('2026-03-08'), 2 * 60 + 30, 'America/New_York');
      final local = localDateTimeAt(instant, 'America/New_York');

      expect(local.hour, 3);
      expect(local.minute, 30);
    });

    test('an ambiguous fall-back time resolves to the first occurrence', () {
      final instant = instantAt(LocalDate.parse('2026-11-01'), 60 + 30, 'America/New_York');

      expect(instant, DateTime.utc(2026, 11, 1, 5, 30));
    });

    test('minutes past 1440 roll into the next local day', () {
      final instant = instantAt(LocalDate.parse('2026-03-08'), 1440 + 60, 'America/New_York');

      expect(instant, DateTime.utc(2026, 3, 9, 5));
    });

    test('unknown timezone ids fall back to UTC instead of crashing', () {
      final instant = instantAt(LocalDate.parse('2026-11-09'), 9 * 60, 'Not/AZone');

      expect(instant, DateTime.utc(2026, 11, 9, 9));
      expect(localDateTimeAt(instant, 'Not/AZone').hour, 9);
    });
  });

  group('local conversion', () {
    test('the same instant lands on different local dates', () {
      final instant = instantAt(LocalDate.parse('2026-11-09'), 23 * 60, 'America/New_York');

      expect(localDateAt(instant, 'America/New_York'), LocalDate.parse('2026-11-09'));
      expect(localDateAt(instant, 'Europe/Madrid'), LocalDate.parse('2026-11-10'));
      expect(localMinuteAt(instant, 'Europe/Madrid'), 5 * 60);
    });
  });
}

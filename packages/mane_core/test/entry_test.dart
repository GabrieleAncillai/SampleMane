import 'package:mane_core/mane_core.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(initializeTimeZones);

  final monday = LocalDate.parse('2026-11-09');
  final now = DateTime.utc(2026, 11, 9, 8);

  Entry allDay({
    LocalDate? date,
    LocalDate? endDate,
    RecurrenceRule? recurrence,
    EntryStatus status = EntryStatus.open,
    DateTime? deletedAt,
  }) => Entry(
    id: 'entry-1',
    spaceId: 'home',
    title: 'Water the plants',
    date: date ?? monday,
    endDate: endDate,
    allDay: true,
    recurrence: recurrence,
    status: status,
    createdAt: now,
    updatedAt: now,
    deletedAt: deletedAt,
  );

  Entry timed({
    LocalDate? date,
    String timeZone = 'Europe/Madrid',
    int startMinute = 9 * 60,
    int endMinute = 10 * 60,
    RecurrenceRule? recurrence,
  }) => Entry(
    id: 'shift-1',
    spaceId: 'work',
    title: 'Open the shop',
    date: date ?? monday,
    startMinute: startMinute,
    endMinute: endMinute,
    timeZone: timeZone,
    recurrence: recurrence,
    createdAt: now,
    updatedAt: now,
  );

  group('all-day entries', () {
    test('appear only on their own date', () {
      final item = allDay();
      expect(item.occursOn(monday), isTrue);
      expect(item.occursOn(monday.addDays(1)), isFalse);
      expect(item.occursOn(monday.addDays(-1)), isFalse);
    });

    test('a multi-day entry covers its range', () {
      final item = allDay(endDate: monday.addDays(2));
      expect(item.occursOn(monday), isTrue);
      expect(item.occursOn(monday.addDays(2)), isTrue);
      expect(item.occursOn(monday.addDays(3)), isFalse);
    });

    test('a recurring entry expands from its anchor', () {
      final item = allDay(
        recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {1}),
      );
      expect(item.occursOn(monday), isTrue);
      expect(item.occursOn(monday.addDays(7)), isTrue);
      expect(item.occursOn(monday.addDays(1)), isFalse);
    });

    test('never carries an instant, so travel cannot move the date', () {
      final item = allDay();
      expect(item.startAt, isNull);
      expect(item.timeZone, isNull);
      expect(item.displayDateIn('Pacific/Auckland'), monday);
      expect(item.displayDateIn('America/Los_Angeles'), monday);
    });
  });

  group('timed entries', () {
    test('resolve UTC instants from the stored wall clock', () {
      final item = timed();
      expect(item.startAt, DateTime.utc(2026, 11, 9, 8));
      expect(item.endAt, DateTime.utc(2026, 11, 9, 9));
    });

    test('display in the viewer timezone and shift with travel', () {
      final item = timed(date: LocalDate.parse('2026-11-09'), startMinute: 23 * 60, endMinute: 23 * 60 + 60);
      expect(item.displayDateIn('Europe/Madrid'), LocalDate.parse('2026-11-09'));

      final inNewYork = localDateTimeAt(item.startAt!, 'America/New_York');
      expect(inNewYork.hour, 17);
      expect(item.displayDateIn('America/New_York'), LocalDate.parse('2026-11-09'));

      final late = timed(
        date: LocalDate.parse('2026-11-09'),
        timeZone: 'America/New_York',
        startMinute: 23 * 60,
        endMinute: 23 * 60 + 60,
      );
      expect(late.displayDateIn('Europe/Madrid'), LocalDate.parse('2026-11-10'));
    });

    test('support overnight ends', () {
      final item = timed(startMinute: 22 * 60, endMinute: 26 * 60);
      expect(item.endMinute, 1560);
      expect(item.endAt!.difference(item.startAt!), const Duration(hours: 4));
    });

    test('reject a missing timezone', () {
      expect(
        () => Entry(
          id: 'bad',
          spaceId: 'work',
          title: 'Bad',
          date: monday,
          startMinute: 600,
          endMinute: 660,
          createdAt: now,
          updatedAt: now,
        ),
        throwsArgumentError,
      );
    });

    test('reject an end before the start', () {
      expect(() => timed(startMinute: 600, endMinute: 600), throwsArgumentError);
    });
  });

  test('cancelled and deleted entries never appear', () {
    expect(allDay(status: EntryStatus.cancelled).occursOn(monday), isFalse);
    expect(allDay(deletedAt: now).occursOn(monday), isFalse);
  });

  test('unscheduled entries never appear', () {
    final item = Entry(id: 'entry-2', spaceId: 'work', title: 'Someday', createdAt: now, updatedAt: now);
    expect(item.occursOn(monday), isFalse);
  });
}

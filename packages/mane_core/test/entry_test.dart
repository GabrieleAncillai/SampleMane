import 'package:mane_core/mane_core.dart';
import 'package:test/test.dart';

void main() {
  final monday = LocalDate.parse('2026-11-09');
  final now = DateTime(2026, 11, 9, 8);

  Entry entry({
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
    recurrence: recurrence,
    status: status,
    createdAt: now,
    updatedAt: now,
    deletedAt: deletedAt,
  );

  test('a normal entry appears only on its own date', () {
    final item = entry();
    expect(item.occursOn(monday), isTrue);
    expect(item.occursOn(monday.addDays(1)), isFalse);
    expect(item.occursOn(monday.addDays(-1)), isFalse);
  });

  test('a multi-day entry covers its range', () {
    final item = entry(endDate: monday.addDays(2));
    expect(item.occursOn(monday), isTrue);
    expect(item.occursOn(monday.addDays(2)), isTrue);
    expect(item.occursOn(monday.addDays(3)), isFalse);
  });

  test('a recurring entry expands from its anchor', () {
    final item = entry(
      recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {1}),
    );
    expect(item.occursOn(monday), isTrue);
    expect(item.occursOn(monday.addDays(7)), isTrue);
    expect(item.occursOn(monday.addDays(1)), isFalse);
  });

  test('cancelled and deleted entries never appear', () {
    expect(entry(status: EntryStatus.cancelled).occursOn(monday), isFalse);
    expect(entry(deletedAt: now).occursOn(monday), isFalse);
  });

  test('unscheduled entries never appear', () {
    final item = Entry(id: 'entry-2', spaceId: 'work', title: 'Someday', createdAt: now, updatedAt: now);
    expect(item.occursOn(monday), isFalse);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/home_widget/home_widget_service.dart';
import 'package:mane_core/mane_core.dart';

void main() {
  setUpAll(initializeTimeZones);

  final monday = LocalDate.parse('2026-11-09');
  final now = DateTime.utc(2026, 11, 9, 12);
  final createdAt = DateTime.utc(2026, 11, 1, 8);

  test('summarises today and the next shift for the widget', () {
    final pattern = ShiftPattern(
      id: 'bar',
      spaceId: 'work',
      name: 'Bar',
      timeZone: 'Europe/Madrid',
      cycleDays: 7,
      anchorDate: monday,
      slots: const [
        ShiftSlot(dayIndex: 0, label: 'Late', startMinute: 960, endMinute: 1320),
        ShiftSlot(dayIndex: 1, label: 'Early', startMinute: 480, endMinute: 720),
      ],
    );
    final shifts = pattern.occurrencesBetween(monday, monday.addDays(2), viewerTimeZone: 'Europe/Madrid');
    final entry = Entry(
      id: 'bins',
      spaceId: 'home',
      title: 'Bins',
      date: monday,
      allDay: true,
      createdAt: createdAt,
      updatedAt: createdAt,
    );
    final data = buildHomeWidgetData(
      todayEntries: [EntryOccurrence(date: monday, displayDate: monday, entry: entry)],
      todayShifts: [shifts.first],
      upcomingShifts: shifts,
      now: now,
      timeZone: 'Europe/Madrid',
      title: 'Today',
      emptyText: 'No plan today',
      nextPrefix: 'Next: ',
    );

    expect(data.title, 'Today');
    expect(data.plan, contains('Bar · Late'));
    expect(data.plan, contains('Bins'));
    expect(data.next, 'Next: Bar · Late');
    expect(data.updated, '13:00');
  });

  test('falls back to the empty state and omits a missing next shift', () {
    final data = buildHomeWidgetData(
      todayEntries: const [],
      todayShifts: const [],
      upcomingShifts: const [],
      now: now,
      timeZone: 'Europe/Madrid',
      title: 'Hoy',
      emptyText: 'Sin plan hoy',
      nextPrefix: 'Próximo: ',
    );
    expect(data.plan, 'Sin plan hoy');
    expect(data.next, isEmpty);
    expect(data.updated, '13:00');
  });
}

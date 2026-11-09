import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/theme/app_theme.dart';
import 'package:mane/widgets/entry_widgets.dart';
import 'package:mane/state/providers.dart';
import 'package:mane_core/mane_core.dart';

void main() {
  setUpAll(initializeTimeZones);

  final createdAt = DateTime.utc(2026, 11, 1, 8);
  final monday = LocalDate.parse('2026-11-09');
  const spaces = <Space>[Space(id: 'work', name: 'Work', colorValue: 0xFF4A6FA5)];

  Widget host(Widget child, {String timeZone = 'Europe/Madrid'}) => ProviderScope(
    overrides: [deviceTimeZoneProvider.overrideWithValue(timeZone)],
    child: MaterialApp(
      theme: ManeTheme.light,
      home: Scaffold(body: child),
    ),
  );

  testWidgets('a timed entry renders in the viewer timezone', (tester) async {
    final entry = Entry(
      id: 'late',
      spaceId: 'work',
      title: 'Late shift',
      date: monday,
      startMinute: 23 * 60,
      endMinute: 24 * 60,
      timeZone: 'America/New_York',
      createdAt: createdAt,
      updatedAt: createdAt,
    );
    final occurrence = EntryOccurrence(
      date: monday,
      displayDate: monday.addDays(1),
      entry: entry,
      startAt: entry.startAt,
      endAt: entry.endAt,
    );

    await tester.pumpWidget(host(EntryTile(occurrence: occurrence, spaces: spaces)));

    expect(find.textContaining('5:00'), findsOneWidget);
    expect(find.textContaining('6:00'), findsOneWidget);
    expect(find.textContaining('23:00'), findsNothing);
  });

  testWidgets('an all-day entry never shows a shifted time', (tester) async {
    final entry = Entry(
      id: 'birthday',
      spaceId: 'work',
      title: 'Birthday',
      date: monday,
      allDay: true,
      createdAt: createdAt,
      updatedAt: createdAt,
    );
    final occurrence = EntryOccurrence(date: monday, displayDate: monday, entry: entry);

    await tester.pumpWidget(
      host(
        EntryTile(occurrence: occurrence, spaces: spaces),
        timeZone: 'Pacific/Auckland',
      ),
    );

    expect(find.textContaining('All day'), findsOneWidget);
  });

  testWidgets('a shift renders in the viewer timezone', (tester) async {
    final pattern = ShiftPattern(
      id: 'night',
      spaceId: 'work',
      name: 'Night',
      timeZone: 'America/New_York',
      cycleDays: 7,
      anchorDate: monday,
      slots: const [ShiftSlot(dayIndex: 0, startMinute: 1320, endMinute: 1800)],
    );
    final occurrence = pattern.occurrencesBetween(monday, monday, viewerTimeZone: 'Europe/Madrid').single;

    await tester.pumpWidget(host(ShiftTile(occurrence: occurrence)));

    expect(find.text('Night'), findsOneWidget);
    expect(find.textContaining('4:00'), findsOneWidget);
    expect(find.textContaining('12:00'), findsOneWidget);
  });
}

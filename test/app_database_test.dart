import 'dart:ffi';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane_core/mane_core.dart';
import 'package:sqlite3/open.dart';

void main() {
  // Fedora ships the runtime library as libsqlite3.so.0, while package:sqlite3
  // looks for the unversioned dev symlink by default.
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
  });

  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test('seeds Home and Work once', () async {
    await database.seedDefaults();
    await database.seedDefaults();

    final spaces = await database.watchSpaces().first;
    expect(spaces.map((space) => space.id), ['home', 'work']);
  });

  test('saves and expands a weekly entry', () async {
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');
    final now = DateTime(2026, 11, 9, 8);

    await database.saveEntry(
      Entry(
        id: 'bins',
        spaceId: 'home',
        title: 'Take the bins out',
        date: monday,
        startMinute: 20 * 60,
        endMinute: 20 * 60 + 15,
        recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {1}),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final occurrences = await database.watchEntriesBetween(monday, monday.addDays(13)).first;
    expect(occurrences.map((occurrence) => occurrence.date.iso), ['2026-11-09', '2026-11-16']);
  });

  test('completing one occurrence does not complete the series', () async {
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');
    final now = DateTime(2026, 11, 9, 8);

    await database.saveEntry(
      Entry(
        id: 'bins',
        spaceId: 'home',
        title: 'Take the bins out',
        date: monday,
        recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {1}),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.setOccurrenceCompleted('bins', monday, completed: true);

    final occurrences = await database.watchEntriesBetween(monday, monday.addDays(7)).first;
    expect(occurrences, hasLength(2));
    expect(occurrences.first.completed, isTrue);
    expect(occurrences.last.completed, isFalse);
  });

  test('stores and expands a shift pattern', () async {
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');

    await database.saveShiftPattern(
      ShiftPattern(
        id: 'bank',
        spaceId: 'work',
        name: 'Main job',
        cycleDays: 7,
        anchorDate: monday,
        slots: const [ShiftSlot(dayIndex: 0, label: 'Day', startMinute: 600, endMinute: 1140)],
      ),
    );

    final shifts = await database.watchShiftsBetween(monday, monday.addDays(6)).first;
    expect(shifts, hasLength(1));
    expect(shifts.first.slot.startMinute, 600);
    expect(shifts.first.pattern.name, 'Main job');
  });

  test('soft-deleted entries disappear from the stream', () async {
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');
    final now = DateTime(2026, 11, 9, 8);

    await database.saveEntry(
      Entry(id: 'temp', spaceId: 'work', title: 'Temporary', date: monday, createdAt: now, updatedAt: now),
    );
    await database.softDeleteEntry('temp');

    final occurrences = await database.watchEntriesBetween(monday, monday).first;
    expect(occurrences, isEmpty);
  });
}

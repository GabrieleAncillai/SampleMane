import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane/models/home_item.dart';
import 'package:mane/models/reminder.dart';
import 'package:mane/models/shift_checklist.dart';
import 'package:mane/models/shopping_item.dart';
import 'package:mane_core/mane_core.dart';
import 'package:sqlite3/open.dart';

void main() {
  // Fedora ships the runtime library as libsqlite3.so.0, while package:sqlite3
  // looks for the unversioned dev symlink by default.
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
    initializeTimeZones();
    // The restart scenario intentionally opens the same file twice in sequence.
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
  });

  tearDown(() => database.close());

  test('seeds Personal, Work and Home once', () async {
    await database.seedDefaults();
    await database.seedDefaults();

    final spaces = await database.watchSpaces().first;
    expect(spaces.map((space) => space.id), ['personal', 'work', 'home']);
    expect(spaces.map((space) => space.name), ['Personal', 'Work', 'Home']);
  });

  test('saves and expands a weekly all-day entry', () async {
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');
    final now = DateTime.utc(2026, 11, 9, 8);

    await database.saveEntry(
      Entry(
        id: 'bins',
        spaceId: 'home',
        title: 'Take the bins out',
        date: monday,
        allDay: true,
        recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {1}),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final occurrences = await database.watchEntriesBetween(monday, monday.addDays(13), 'Europe/Madrid').first;
    expect(occurrences.map((occurrence) => occurrence.date.iso), ['2026-11-09', '2026-11-16']);
  });

  test('a timed entry travels with the viewer timezone but an all-day date does not', () async {
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');
    final now = DateTime.utc(2026, 11, 9, 8);

    await database.saveEntry(
      Entry(
        id: 'late',
        spaceId: 'work',
        title: 'Late shift',
        date: monday,
        startMinute: 23 * 60,
        endMinute: 24 * 60,
        timeZone: 'America/New_York',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.saveEntry(
      Entry(
        id: 'birthday',
        spaceId: 'personal',
        title: 'Birthday',
        date: monday,
        allDay: true,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final mondayInNewYork = await database.watchEntriesBetween(monday, monday, 'America/New_York').first;
    expect(mondayInNewYork.map((item) => item.entry.id), containsAll(['late', 'birthday']));
    final late = mondayInNewYork.firstWhere((item) => item.entry.id == 'late');
    expect(late.displayDate, monday);
    expect(localDateTimeAt(late.startAt!, 'America/New_York').hour, 23);

    final mondayInMadrid = await database.watchEntriesBetween(monday, monday, 'Europe/Madrid').first;
    expect(mondayInMadrid.map((item) => item.entry.id), ['birthday']);

    final tuesdayInMadrid = await database
        .watchEntriesBetween(monday.addDays(1), monday.addDays(1), 'Europe/Madrid')
        .first;
    final shiftedLate = tuesdayInMadrid.firstWhere((item) => item.entry.id == 'late');
    expect(shiftedLate.displayDate, monday.addDays(1));
    expect(shiftedLate.date, monday);
    expect(localDateTimeAt(shiftedLate.startAt!, 'Europe/Madrid').hour, 5);
  });

  test('a recurring 09:00 entry keeps its wall time across DST', () async {
    await database.seedDefaults();
    final start = LocalDate.parse('2026-03-07');
    final now = DateTime.utc(2026, 3, 1, 8);

    await database.saveEntry(
      Entry(
        id: 'standup',
        spaceId: 'work',
        title: 'Standup',
        date: start,
        startMinute: 9 * 60,
        endMinute: 10 * 60,
        timeZone: 'America/New_York',
        recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.daily),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final occurrences = await database.watchEntriesBetween(start, start.addDays(1), 'America/New_York').first;
    expect(occurrences, hasLength(2));
    expect(occurrences[0].startAt, DateTime.utc(2026, 3, 7, 14));
    expect(occurrences[1].startAt, DateTime.utc(2026, 3, 8, 13));
    for (final occurrence in occurrences) {
      expect(localDateTimeAt(occurrence.startAt!, 'America/New_York').hour, 9);
    }
  });

  test('completing one occurrence does not complete the series', () async {
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');
    final now = DateTime.utc(2026, 11, 9, 8);

    await database.saveEntry(
      Entry(
        id: 'bins',
        spaceId: 'home',
        title: 'Take the bins out',
        date: monday,
        allDay: true,
        recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {1}),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.setOccurrenceCompleted('bins', monday, completed: true);

    final occurrences = await database.watchEntriesBetween(monday, monday.addDays(7), 'Europe/Madrid').first;
    expect(occurrences, hasLength(2));
    expect(occurrences.first.completed, isTrue);
    expect(occurrences.last.completed, isFalse);
  });

  test('completion survives a database restart', () async {
    final directory = await Directory.systemTemp.createTemp('mane-restart');
    final path = '${directory.path}/mane.sqlite';
    final monday = LocalDate.parse('2026-11-09');
    final now = DateTime.utc(2026, 11, 9, 8);

    final first = AppDatabase(NativeDatabase(File(path)), defaultTimeZone: 'Europe/Madrid');
    await first.seedDefaults();
    await first.saveEntry(
      Entry(
        id: 'bins',
        spaceId: 'home',
        title: 'Take the bins out',
        date: monday,
        allDay: true,
        recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {1}),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await first.setOccurrenceCompleted('bins', monday, completed: true);
    await first.close();

    final second = AppDatabase(NativeDatabase(File(path)), defaultTimeZone: 'Europe/Madrid');
    final occurrences = await second.watchEntriesBetween(monday, monday, 'Europe/Madrid').first;
    expect(occurrences, hasLength(1));
    expect(occurrences.single.completed, isTrue);
    await second.close();
    await directory.delete(recursive: true);
  });

  test('stores a 14-day pattern with several slots and exceptions', () async {
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');

    await database.saveShiftPattern(
      ShiftPattern(
        id: 'rotation',
        spaceId: 'work',
        name: 'Two-week rotation',
        timeZone: 'Europe/Madrid',
        cycleDays: 14,
        anchorDate: monday,
        slots: const [
          ShiftSlot(dayIndex: 0, label: 'Open', startMinute: 900, endMinute: 1320),
          ShiftSlot(dayIndex: 1, label: 'Open', startMinute: 900, endMinute: 1320),
          ShiftSlot(dayIndex: 5, label: 'Long', startMinute: 600, endMinute: 1380),
        ],
        exceptions: [
          ShiftException(date: monday.addDays(5), type: ShiftExceptionType.free),
          ShiftException(
            date: monday.addDays(8),
            type: ShiftExceptionType.override,
            startMinute: 480,
            endMinute: 720,
            note: 'Training',
          ),
          ShiftException(
            date: monday.addDays(1),
            type: ShiftExceptionType.extra,
            startMinute: 1080,
            endMinute: 1200,
            note: 'Stock take',
          ),
        ],
      ),
    );

    final firstDay = await database.watchShiftsBetween(monday, monday, 'Europe/Madrid').first;
    expect(firstDay.map((item) => item.slot.label), ['Open']);

    final secondDay = await database
        .watchShiftsBetween(monday.addDays(1), monday.addDays(1), 'Europe/Madrid')
        .first;
    expect(secondDay.map((item) => item.slot.label), ['Open', 'Stock take']);
    expect(secondDay.last.startAt, DateTime.utc(2026, 11, 10, 17));

    final freedSaturday = await database
        .watchShiftsBetween(monday.addDays(5), monday.addDays(5), 'Europe/Madrid')
        .first;
    expect(freedSaturday, isEmpty);

    final weekTwo = await database
        .watchShiftsBetween(monday.addDays(7), monday.addDays(8), 'Europe/Madrid')
        .first;
    expect(weekTwo, hasLength(1));
    expect(weekTwo.single.slot.label, 'Training');
    expect(weekTwo.single.displayDate, monday.addDays(8));

    final fortnight = await database.watchShiftsBetween(monday, monday.addDays(13), 'Europe/Madrid').first;
    expect(fortnight, hasLength(4));
  });

  test('stores tags and removes them from entries when deleted', () async {
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');
    final now = DateTime.utc(2026, 11, 9, 8);

    await database.saveTag(const Tag(id: 'job-a', spaceId: 'work', name: 'Job A', colorValue: 0xFF4A6FA5));
    await database.saveEntry(
      Entry(
        id: 'shift-note',
        spaceId: 'work',
        title: 'Job A meeting',
        date: monday,
        allDay: true,
        tagIds: const {'job-a'},
        createdAt: now,
        updatedAt: now,
      ),
    );

    var entries = await database.watchEntriesBetween(monday, monday, 'Europe/Madrid').first;
    expect(entries.single.entry.tagIds, {'job-a'});
    expect((await database.watchTags().first).single.name, 'Job A');

    await database.softDeleteTag('job-a');
    entries = await database.watchEntriesBetween(monday, monday, 'Europe/Madrid').first;
    expect(entries.single.entry.tagIds, isEmpty);
    expect(await database.watchTags().first, isEmpty);
  });

  test('stores multiple reminders per entry and replaces them on save', () async {
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');
    final now = DateTime.utc(2026, 11, 9, 8);

    await database.saveEntry(
      Entry(
        id: 'bins',
        spaceId: 'home',
        title: 'Bins',
        date: monday,
        allDay: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.saveRemindersForEntry('bins', const [
      Reminder(id: 'bins:60', entryId: 'bins', offsetMinutes: 60),
      Reminder(id: 'bins:10', entryId: 'bins', offsetMinutes: 10),
    ]);

    final reminders = await database.readRemindersForEntry('bins');
    expect(reminders.map((reminder) => reminder.offsetMinutes), [10, 60]);
    expect((await database.readAllReminders())['bins'], hasLength(2));

    await database.saveRemindersForEntry('bins', const [
      Reminder(id: 'bins:30', entryId: 'bins', offsetMinutes: 30),
    ]);
    expect((await database.readRemindersForEntry('bins')).single.offsetMinutes, 30);
  });

  test('lists patterns with their slots and exceptions for the editor', () async {
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');
    await database.saveShiftPattern(
      ShiftPattern(
        id: 'editor',
        spaceId: 'work',
        name: 'Editor',
        timeZone: 'Europe/Madrid',
        cycleDays: 14,
        anchorDate: monday,
        slots: const [
          ShiftSlot(dayIndex: 0, label: 'Open', startMinute: 540, endMinute: 900),
          ShiftSlot(dayIndex: 0, label: 'Close', startMinute: 960, endMinute: 1200),
        ],
        exceptions: [ShiftException(date: monday.addDays(7), type: ShiftExceptionType.free)],
      ),
    );

    final patterns = await database.watchShiftPatterns().first;
    expect(patterns, hasLength(1));
    expect(patterns.single.slots, hasLength(2));
    expect(patterns.single.exceptions.single.type, ShiftExceptionType.free);
  });

  test('maintenance completion advances from the actual completion date', () async {
    await database.seedDefaults();
    final now = DateTime.utc(2026, 11, 1, 8);

    await database.saveEntry(
      Entry(
        id: 'filter',
        spaceId: 'home',
        title: 'Change the filter',
        date: LocalDate.parse('2026-11-09'),
        allDay: true,
        repeatAfterCompletionDays: 7,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final late = await database.completeMaintenanceEntry('filter', LocalDate.parse('2026-11-10'));
    expect(late, LocalDate.parse('2026-11-17'));

    final next = await database
        .watchEntriesBetween(LocalDate.parse('2026-11-17'), LocalDate.parse('2026-11-17'), 'Europe/Madrid')
        .first;
    expect(next.single.entry.id, 'filter');
    expect(next.single.entry.status, EntryStatus.open);
    expect(next.single.entry.lastCompletedAt, isNotNull);

    final early = await database.completeMaintenanceEntry('filter', LocalDate.parse('2026-11-15'));
    expect(early, LocalDate.parse('2026-11-22'));

    final history = await database
        .customSelect(
          'SELECT date_key FROM completion_records WHERE entry_id = ? ORDER BY date_key',
          variables: [Variable.withString('filter')],
        )
        .get();
    expect(history.map((row) => row.data['date_key']), [20261110, 20261115]);
  });

  test('a timed maintenance entry keeps its wall time after completion', () async {
    await database.seedDefaults();
    final now = DateTime.utc(2026, 11, 1, 8);
    await database.saveEntry(
      Entry(
        id: 'boiler',
        spaceId: 'home',
        title: 'Boiler service',
        date: LocalDate.parse('2026-11-09'),
        startMinute: 9 * 60,
        endMinute: 10 * 60,
        timeZone: 'Europe/Madrid',
        repeatAfterCompletionDays: 365,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final next = await database.completeMaintenanceEntry('boiler', LocalDate.parse('2026-11-10'));
    expect(next, LocalDate.parse('2027-11-10'));
    final loaded = await database
        .watchEntriesBetween(LocalDate.parse('2027-11-10'), LocalDate.parse('2027-11-10'), 'Europe/Madrid')
        .first;
    expect(loaded.single.entry.startAt, DateTime.utc(2027, 11, 10, 8));
  });

  test('shift checklist completions stay independent for each shift date', () async {
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');
    await database.saveShiftPattern(
      ShiftPattern(
        id: 'bar',
        spaceId: 'work',
        name: 'Bar shift',
        timeZone: 'Europe/Madrid',
        cycleDays: 7,
        anchorDate: monday,
        slots: const [ShiftSlot(dayIndex: 0, startMinute: 960, endMinute: 1320)],
      ),
    );
    await database.saveShiftChecklistItems('bar', const [
      ShiftChecklistItem(id: 'count', patternId: 'bar', label: 'Count the drawer'),
      ShiftChecklistItem(id: 'clean', patternId: 'bar', label: 'Clean the bar'),
    ]);

    await database.setShiftChecklistCompleted('count', monday, completed: true, slotKey: '0:540:600:A');
    expect(await database.readShiftChecklistCompletions('bar', monday, slotKey: '0:540:600:A'), {'count'});
    expect(
      await database.readShiftChecklistCompletions('bar', monday.addDays(1), slotKey: '0:540:600:A'),
      isEmpty,
    );

    // Renaming an item keeps its id, so the tick survives an edit.
    await database.saveShiftChecklistItems('bar', const [
      ShiftChecklistItem(id: 'count', patternId: 'bar', label: 'Count the till'),
      ShiftChecklistItem(id: 'clean', patternId: 'bar', label: 'Clean the bar'),
    ]);
    expect(await database.readShiftChecklistCompletions('bar', monday, slotKey: '0:540:600:A'), {'count'});
    expect((await database.readShiftChecklistItems('bar')).first.label, 'Count the till');

    await database.setShiftChecklistCompleted('count', monday, completed: false, slotKey: '0:540:600:A');
    expect(await database.readShiftChecklistCompletions('bar', monday, slotKey: '0:540:600:A'), isEmpty);
  });

  test('two slots on the same date keep independent checklist completions', () async {
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');
    final pattern = ShiftPattern(
      id: 'double',
      spaceId: 'work',
      name: 'Double shift',
      timeZone: 'Europe/Madrid',
      cycleDays: 7,
      anchorDate: monday,
      slots: const [
        ShiftSlot(dayIndex: 0, label: 'Lunch', startMinute: 720, endMinute: 960),
        ShiftSlot(dayIndex: 0, label: 'Dinner', startMinute: 1140, endMinute: 1380),
      ],
    );
    await database.saveShiftPattern(pattern);
    await database.saveShiftChecklistItems('double', const [
      ShiftChecklistItem(id: 'count', patternId: 'double', label: 'Count the drawer'),
    ]);

    final slots = pattern.slotsFor(monday);
    expect(slots, hasLength(2));
    await database.setShiftChecklistCompleted('count', monday, completed: true, slotKey: slots.first.key);

    expect(await database.readShiftChecklistCompletions('double', monday, slotKey: slots.first.key), {
      'count',
    });
    expect(await database.readShiftChecklistCompletions('double', monday, slotKey: slots.last.key), isEmpty);

    await database.setShiftChecklistCompleted('count', monday, completed: true, slotKey: slots.last.key);
    expect(await database.readShiftChecklistCompletions('double', monday, slotKey: slots.last.key), {
      'count',
    });
  });

  test('checking a linked shopping item updates and reverses the inventory quantity', () async {
    await database.seedDefaults();
    await database.saveHomeItem(
      const HomeItem(id: 'coffee', name: 'Coffee', quantity: 100, unit: 'g', reorderLevel: 100),
    );
    await database.saveShoppingItem(
      const ShoppingItem(id: 'buy-coffee', name: 'Coffee', quantity: 250, unit: 'g', homeItemId: 'coffee'),
    );

    final low = (await database.watchHomeItems().first).single;
    expect(low.isLowStock, isTrue);
    expect(low.suggestedPurchase, 100);

    await database.setShoppingChecked('buy-coffee', true);
    final stocked = (await database.watchHomeItems().first).single;
    expect(stocked.quantity, 350);
    expect(stocked.isLowStock, isFalse);
    expect(stocked.lastPurchasedAt, isNotNull);
    expect((await database.watchShoppingItems().first).single.checked, isTrue);

    await database.setShoppingChecked('buy-coffee', false);
    expect((await database.watchHomeItems().first).single.quantity, 100);
    expect((await database.watchShoppingItems().first).single.checked, isFalse);
  });

  test('searches titles, notes, tags and home items', () async {
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');
    final now = DateTime.utc(2026, 11, 9, 8);
    await database.saveTag(
      const Tag(id: 'admin', spaceId: 'personal', name: 'Admin', colorValue: 0xFFB07D5C),
    );
    await database.saveEntry(
      Entry(
        id: 'passport',
        spaceId: 'personal',
        title: 'Renew passport',
        notes: 'Book the appointment',
        date: monday,
        allDay: true,
        tagIds: const {'admin'},
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.saveEntry(
      Entry(
        id: 'deleted',
        spaceId: 'personal',
        title: 'Cancelled passport',
        date: monday,
        allDay: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.softDeleteEntry('deleted');
    await database.saveHomeItem(
      const HomeItem(id: 'coffee', name: 'Coffee beans', location: 'Kitchen', quantity: 250),
    );

    expect((await database.search('passport')).entries.single.id, 'passport');
    expect((await database.search('appointment')).entries.single.id, 'passport');
    expect((await database.search('admin')).entries.single.id, 'passport');
    expect((await database.search('kitchen')).homeItems.single.id, 'coffee');
    expect((await database.search('nothing')).isEmpty, isTrue);
    expect((await database.search('   ')).isEmpty, isTrue);
  });

  test('soft-deleted entries disappear from the stream', () async {
    await database.seedDefaults();
    final monday = LocalDate.parse('2026-11-09');
    final now = DateTime.utc(2026, 11, 9, 8);

    await database.saveEntry(
      Entry(
        id: 'temp',
        spaceId: 'work',
        title: 'Temporary',
        date: monday,
        allDay: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.softDeleteEntry('temp');

    final occurrences = await database.watchEntriesBetween(monday, monday, 'Europe/Madrid').first;
    expect(occurrences, isEmpty);
  });
}

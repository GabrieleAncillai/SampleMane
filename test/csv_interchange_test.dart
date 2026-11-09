import 'dart:ffi';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/export/csv_interchange.dart';
import 'package:mane/models/home_item.dart';
import 'package:mane/models/shopping_item.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane/services/planner_repository.dart';
import 'package:mane_core/mane_core.dart';
import 'package:sqlite3/open.dart';

void main() {
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
    initializeTimeZones();
  });

  late AppDatabase database;
  late PlannerRepository repository;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    await database.seedDefaults();
    repository = PlannerRepository(database);
  });

  tearDown(() => database.close());

  test('CSV parser handles quotes, commas and newlines', () {
    final rows = CsvInterchangeService.decodeCsv(
      'name,note\r\n'
      '"Rice, basmati","Line one\nLine two"\r\n'
      '"He said ""hi""",plain\r\n',
    );
    expect(rows, [
      ['name', 'note'],
      ['Rice, basmati', 'Line one\nLine two'],
      ['He said "hi"', 'plain'],
    ]);
  });

  test('entry export and import keeps dates, times and tags', () async {
    final now = DateTime.utc(2026, 11, 1, 8);
    await database.saveTag(const Tag(id: 'job', spaceId: 'work', name: 'Job A', colorValue: 0xFF4A6FA5));
    await database.saveEntry(
      Entry(
        id: 'standup',
        spaceId: 'work',
        title: 'Standup, daily',
        notes: 'Bring notes\nand coffee',
        kind: EntryKind.event,
        date: LocalDate.parse('2026-11-09'),
        startMinute: 9 * 60,
        endMinute: 9 * 60 + 30,
        timeZone: 'Europe/Madrid',
        tagIds: const {'job'},
        recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {1}),
        createdAt: now,
        updatedAt: now,
      ),
    );

    final csv = await CsvInterchangeService(repository).exportEntries(
      start: LocalDate.parse('2026-11-09'),
      end: LocalDate.parse('2026-11-15'),
      viewerTimeZone: 'Europe/Madrid',
    );
    expect(csv, contains('"Standup, daily"'));

    final target = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    addTearDown(target.close);
    await target.seedDefaults();
    await target.saveTag(const Tag(id: 'job', spaceId: 'work', name: 'Job A', colorValue: 0xFF4A6FA5));
    final report = await CsvInterchangeService(
      PlannerRepository(target),
    ).importEntries(csv, defaultTimeZone: 'Europe/Madrid');
    expect(report.imported, 1);

    final entries = await target
        .watchEntriesBetween(LocalDate.parse('2026-11-09'), LocalDate.parse('2026-11-09'), 'Europe/Madrid')
        .first;
    final entry = entries.single.entry;
    expect(entry.title, 'Standup, daily');
    expect(entry.notes, 'Bring notes\nand coffee');
    expect(entry.spaceId, 'work');
    expect(entry.startMinute, 9 * 60);
    expect(entry.endMinute, 9 * 60 + 30);
    expect(entry.timeZone, 'Europe/Madrid');
    expect(entry.tagIds, {'job'});
    expect(entry.recurrence, isNotNull);
    expect(entry.source, 'csv');
  });

  test('re-importing the same entry CSV deduplicates', () async {
    final now = DateTime.utc(2026, 11, 1, 8);
    await database.saveEntry(
      Entry(
        id: 'bins',
        spaceId: 'home',
        title: 'Bins',
        date: LocalDate.parse('2026-11-09'),
        allDay: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
    final service = CsvInterchangeService(repository);
    final csv = await service.exportEntries(
      start: LocalDate.parse('2026-11-09'),
      end: LocalDate.parse('2026-11-09'),
      viewerTimeZone: 'Europe/Madrid',
    );
    final first = await service.importEntries(csv, defaultTimeZone: 'Europe/Madrid');
    final second = await service.importEntries(csv, defaultTimeZone: 'Europe/Madrid');
    expect(first.imported, 1);
    expect(second.imported, 0);
    expect(second.duplicates, 1);
  });

  test('shopping and inventory CSV round-trip and dedupe', () async {
    await database.saveHomeItem(
      const HomeItem(
        id: 'rice',
        name: 'Rice',
        category: 'Pantry',
        location: 'Kitchen',
        quantity: 2,
        unit: 'kg',
        reorderLevel: 1,
      ),
    );
    await database.saveShoppingItem(
      const ShoppingItem(
        id: 'rice-buy',
        name: 'Rice',
        quantity: 3,
        unit: 'kg',
        note: 'Basmati',
        homeItemId: 'rice',
      ),
    );
    final service = CsvInterchangeService(repository);
    final shoppingCsv = await service.exportShopping();
    final inventoryCsv = await service.exportInventory();
    expect(shoppingCsv, contains('Basmati'));

    final target = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    addTearDown(target.close);
    await target.seedDefaults();
    final targetService = CsvInterchangeService(PlannerRepository(target));
    final inventoryReport = await targetService.importInventory(inventoryCsv);
    expect(inventoryReport.imported, 1);
    final shoppingReport = await targetService.importShopping(shoppingCsv);
    expect(shoppingReport.imported, 1);

    final shopping = (await target.watchShoppingItems().first).single;
    final home = (await target.watchHomeItems().first).single;
    expect(shopping.name, 'Rice');
    expect(shopping.quantity, 3);
    expect(shopping.homeItemId, home.id);
    expect(home.category, 'Pantry');

    final duplicate = await targetService.importInventory(inventoryCsv);
    expect(duplicate.duplicates, 1);
  });
}

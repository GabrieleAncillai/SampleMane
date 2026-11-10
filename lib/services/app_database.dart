import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mane_core/mane_core.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/home_item.dart';
import '../models/home_purchase.dart';
import '../models/local_identity.dart';
import '../models/paired_device.dart';
import '../models/remote_snapshot.dart';
import '../models/reminder.dart';
import '../models/search_results.dart';
import '../models/shift_checklist.dart';
import '../models/shopping_item.dart';

part 'app_database.g.dart';

@DataClassName('SpaceRow')
class SpaceRecords extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get color => integer()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TagRow')
class TagRecords extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text().nullable().references(SpaceRecords, #id)();
  TextColumn get name => text()();
  IntColumn get color => integer()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('EntryTagRow')
class EntryTagRecords extends Table {
  TextColumn get entryId => text().references(EntryRecords, #id)();
  TextColumn get tagId => text().references(TagRecords, #id)();

  @override
  Set<Column<Object>> get primaryKey => {entryId, tagId};
}

@DataClassName('ShiftChecklistItemRow')
class ShiftChecklistItemRecords extends Table {
  TextColumn get id => text()();
  TextColumn get patternId => text().references(ShiftPatternRecords, #id)();
  TextColumn get label => text()();
  IntColumn get position => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ShiftChecklistCompletionRow')
class ShiftChecklistCompletionRecords extends Table {
  TextColumn get itemId => text().references(ShiftChecklistItemRecords, #id)();
  IntColumn get dateKey => integer()();

  /// Identity of the shift slot inside the pattern. An empty value is the
  /// legacy single-slot key and is backfilled during the v5 to v6 migration.
  TextColumn get slotKey => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {itemId, dateKey, slotKey};
}

@DataClassName('HomeItemRow')
class HomeItemRecords extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text().withDefault(const Constant(''))();
  TextColumn get location => text().withDefault(const Constant(''))();
  RealColumn get quantity => real().withDefault(const Constant(0))();

  /// Threshold at or below which the item is low stock. Null means no alert.
  RealColumn get reorderLevel => real().nullable()();
  TextColumn get unit => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get lastPurchasedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ShoppingItemRow')
class ShoppingItemRecords extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get quantity => real().withDefault(const Constant(1))();
  TextColumn get unit => text().withDefault(const Constant(''))();
  BoolColumn get checked => boolean().withDefault(const Constant(false))();
  TextColumn get note => text().withDefault(const Constant(''))();
  TextColumn get homeItemId => text().nullable().references(HomeItemRecords, #id)();

  /// Manual order inside the list. Lower values come first.
  IntColumn get position => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Stock that entered the household inventory, from a shopping line or a
/// manual quantity adjustment. Kept deliberately small.
@DataClassName('HomePurchaseRow')
class HomePurchaseRecords extends Table {
  TextColumn get id => text()();
  TextColumn get homeItemId => text().references(HomeItemRecords, #id)();
  TextColumn get shoppingItemId => text().nullable().references(ShoppingItemRecords, #id)();
  RealColumn get quantity => real()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get purchasedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// This device's pairing identity. One row, id = 1.
@DataClassName('IdentityRow')
class IdentityRecords extends Table {
  IntColumn get id => integer()();
  TextColumn get deviceId => text()();
  TextColumn get deviceName => text()();
  TextColumn get username => text()();
  TextColumn get pinSalt => text()();
  TextColumn get pinHash => text()();
  TextColumn get certificatePem => text()();
  TextColumn get privateKeyPem => text()();
  TextColumn get mcpToken => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Devices paired with this one. Excluded from JSON backups on purpose.
@DataClassName('PairedDeviceRow')
class PairedDeviceRecords extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get username => text()();
  TextColumn get certificateFingerprint => text()();
  TextColumn get sharedKey => text()();
  TextColumn get host => text().withDefault(const Constant(''))();
  IntColumn get port => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSeenAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('EntryRow')
class EntryRecords extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text().references(SpaceRecords, #id)();
  TextColumn get title => text()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  /// One of [EntryKind]. Stored as text so the database stays readable.
  TextColumn get kind => text()();

  /// Anchor date as `YYYYMMDD`, in [timeZone] for timed entries.
  IntColumn get dateKey => integer().nullable()();

  /// End date for multi-day all-day entries.
  IntColumn get endDateKey => integer().nullable()();

  /// Local minutes from midnight, null for all-day entries. An end of 1440 or
  /// more means the entry crosses midnight.
  IntColumn get startMinute => integer().nullable()();
  IntColumn get endMinute => integer().nullable()();

  /// IANA timezone for the wall-clock fields, null for all-day entries.
  TextColumn get timeZone => text().nullable()();

  /// Resolved anchor instants in UTC, null for all-day entries.
  DateTimeColumn get startAt => dateTime().nullable()();
  DateTimeColumn get endAt => dateTime().nullable()();

  BoolColumn get allDay => boolean().withDefault(const Constant(false))();

  /// One of [EntryStatus].
  TextColumn get status => text()();

  /// Serialized [RecurrenceRule], null for one-off entries.
  TextColumn get recurrenceJson => text().nullable()();

  /// Import source such as `ics`, null for user entries.
  TextColumn get source => text().nullable()();
  TextColumn get externalId => text().nullable()();
  BoolColumn get readOnly => boolean().withDefault(const Constant(false))();

  DateTimeColumn get lastCompletedAt => dateTime().nullable()();
  IntColumn get repeatAfterCompletionDays => integer().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ReminderRow')
class ReminderRecords extends Table {
  TextColumn get id => text()();
  TextColumn get entryId => text().references(EntryRecords, #id)();
  IntColumn get offsetMinutes => integer()();

  /// A local time of day instead of an offset. Null uses [offsetMinutes].
  IntColumn get timeMinute => integer().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ShiftPatternRow')
class ShiftPatternRecords extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text().references(SpaceRecords, #id)();
  TextColumn get name => text()();

  /// IANA timezone the slot times are defined in.
  TextColumn get timeZone => text().withDefault(const Constant('UTC'))();

  IntColumn get cycleDays => integer()();
  IntColumn get anchorDateKey => integer()();

  /// Per-pattern sleep overrides in minutes. Null uses the global buffer.
  IntColumn get commuteMinutes => integer().nullable()();
  IntColumn get windDownMinutes => integer().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ShiftSlotRow')
class ShiftSlotRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get patternId => text().references(ShiftPatternRecords, #id)();
  IntColumn get dayIndex => integer()();
  TextColumn get label => text().withDefault(const Constant(''))();
  IntColumn get startMinute => integer()();
  IntColumn get endMinute => integer()();
}

@DataClassName('ShiftPatternTagRow')
class ShiftPatternTagRecords extends Table {
  TextColumn get patternId => text().references(ShiftPatternRecords, #id)();
  TextColumn get tagId => text().references(TagRecords, #id)();

  @override
  Set<Column<Object>> get primaryKey => {patternId, tagId};
}

@DataClassName('ShiftExceptionRow')
class ShiftExceptionRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get patternId => text().references(ShiftPatternRecords, #id)();
  IntColumn get dateKey => integer()();

  /// One of [ShiftExceptionType].
  TextColumn get type => text()();
  IntColumn get startMinute => integer().nullable()();
  IntColumn get endMinute => integer().nullable()();
  TextColumn get note => text().withDefault(const Constant(''))();
}

/// Read-only snapshots from paired devices. Display data only; never merged.
@DataClassName('RemoteSnapshotRow')
class RemoteSnapshotRecords extends Table {
  TextColumn get deviceId => text()();
  TextColumn get deviceName => text()();
  DateTimeColumn get fetchedAt => dateTime()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {deviceId};
}

@DataClassName('CompletionRow')
class CompletionRecords extends Table {
  TextColumn get entryId => text().references(EntryRecords, #id)();
  IntColumn get dateKey => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {entryId, dateKey};
}

@DataClassName('SettingRow')
class SettingRecords extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    SpaceRecords,
    EntryRecords,
    TagRecords,
    EntryTagRecords,
    CompletionRecords,
    ReminderRecords,
    ShiftPatternRecords,
    ShiftSlotRecords,
    ShiftPatternTagRecords,
    ShiftExceptionRecords,
    ShiftChecklistItemRecords,
    ShiftChecklistCompletionRecords,
    HomeItemRecords,
    ShoppingItemRecords,
    IdentityRecords,
    PairedDeviceRecords,
    SettingRecords,
    HomePurchaseRecords,
    RemoteSnapshotRecords,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e, {this.defaultTimeZone = 'UTC'});

  AppDatabase.open({this.defaultTimeZone = 'UTC'}) : super(_openConnection());

  /// Used to interpret legacy wall-clock rows during the v1 to v2 migration.
  final String defaultTimeZone;

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Add the v4 entry columns first so the v1/v2 backfill can read rows with
      // the current generated entry mapper.
      if (from < 4) await _addV4EntryColumns(m);
      if (from < 2) await _migrateToV2(m);
      if (from < 3) await _migrateToV3(m);
      if (from < 4) await _migrateToV4(m);
      if (from < 5) await _migrateToV5(m);
      if (from < 6) await _migrateToV6(m);
      if (from < 7) await _migrateToV7(m);
      if (from < 8) await _migrateToV8(m);
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Personal, Work and Home exist on first launch. No sample life data is
  /// inserted. Missing defaults are added individually so a partially seeded
  /// database still ends up complete.
  Future<void> seedDefaults() async {
    final existing = await select(spaceRecords).get();
    final ids = existing.map((row) => row.id).toSet();
    final missing = _defaultSpaces.where((space) => !ids.contains(space.id)).toList();
    if (missing.isEmpty) return;

    final now = DateTime.now();
    await batch((batch) {
      batch.insertAll(spaceRecords, [
        for (final space in missing)
          SpaceRecordsCompanion.insert(
            id: space.id,
            name: space.name,
            color: space.colorValue,
            position: Value(space.position),
            createdAt: now,
            updatedAt: now,
          ),
      ]);
    });
  }

  Stream<List<Space>> watchSpaces() {
    final query = select(spaceRecords)..where((row) => row.deletedAt.isNull());
    return query.watch().map((rows) {
      final spaces = rows.map(_spaceFromRow).toList()..sort((a, b) => a.position.compareTo(b.position));
      return spaces;
    });
  }

  Future<Map<String, String>> readSettings() async {
    final rows = await select(settingRecords).get();
    return {for (final row in rows) row.key: row.value};
  }

  Future<void> writeSetting(String key, String value) =>
      into(settingRecords).insertOnConflictUpdate(SettingRecordsCompanion.insert(key: key, value: value));

  Stream<List<EntryOccurrence>> watchEntriesBetween(LocalDate start, LocalDate end, String viewerTimeZone) {
    final query = _entriesQuery(start, end);
    return query.watch().map((rows) => _expandEntryRows(rows, start, end, viewerTimeZone));
  }

  Future<List<EntryOccurrence>> loadEntriesBetween(
    LocalDate start,
    LocalDate end,
    String viewerTimeZone,
  ) async {
    final rows = await _entriesQuery(start, end).get();
    return _expandEntryRows(rows, start, end, viewerTimeZone);
  }

  JoinedSelectStatement _entriesQuery(LocalDate start, LocalDate end) => select(entryRecords).join([
    leftOuterJoin(
      completionRecords,
      completionRecords.entryId.equalsExp(entryRecords.id) &
          completionRecords.dateKey.isBetweenValues(start.addDays(-2).key, end.addDays(2).key),
    ),
    leftOuterJoin(entryTagRecords, entryTagRecords.entryId.equalsExp(entryRecords.id)),
  ])..where(entryRecords.deletedAt.isNull());

  List<EntryOccurrence> _expandEntryRows(
    List<TypedResult> rows,
    LocalDate start,
    LocalDate end,
    String viewerTimeZone,
  ) {
    final entryRows = <String, EntryRow>{};
    final completions = <String, Set<LocalDate>>{};
    final tagIds = <String, Set<String>>{};

    for (final row in rows) {
      final entryRow = row.readTable(entryRecords);
      entryRows[entryRow.id] = entryRow;
      final completion = row.readTableOrNull(completionRecords);
      if (completion != null) {
        (completions[entryRow.id] ??= <LocalDate>{}).add(LocalDate.fromKey(completion.dateKey));
      }
      final tag = row.readTableOrNull(entryTagRecords);
      if (tag != null) {
        (tagIds[entryRow.id] ??= <String>{}).add(tag.tagId);
      }
    }

    final entries = <String, Entry>{
      for (final row in entryRows.values)
        row.id: _entryFromRow(row, tagIds: tagIds[row.id] ?? const <String>{}),
    };

    return expandEntries(
      entries: entries.values,
      start: start,
      end: end,
      viewerTimeZone: viewerTimeZone,
      completions: completions,
    );
  }

  Stream<List<ShiftOccurrence>> watchShiftsBetween(LocalDate start, LocalDate end, String viewerTimeZone) {
    final query = select(shiftPatternRecords).join([
      leftOuterJoin(shiftSlotRecords, shiftSlotRecords.patternId.equalsExp(shiftPatternRecords.id)),
      leftOuterJoin(shiftExceptionRecords, shiftExceptionRecords.patternId.equalsExp(shiftPatternRecords.id)),
      leftOuterJoin(
        shiftPatternTagRecords,
        shiftPatternTagRecords.patternId.equalsExp(shiftPatternRecords.id),
      ),
    ])..where(shiftPatternRecords.deletedAt.isNull() & shiftPatternRecords.enabled.equals(true));

    return query.watch().map((rows) {
      final occurrences = <ShiftOccurrence>[];
      for (final pattern in _patternsFromRows(rows)) {
        for (final occurrence in pattern.occurrencesBetween(
          start.addDays(-2),
          end.addDays(2),
          viewerTimeZone: viewerTimeZone,
        )) {
          if (occurrence.displayDate.isBefore(start) || occurrence.displayDate.isAfter(end)) {
            continue;
          }
          occurrences.add(occurrence);
        }
      }

      occurrences.sort((a, b) {
        final byDate = a.displayDate.compareTo(b.displayDate);
        if (byDate != 0) return byDate;
        return a.startAt.compareTo(b.startAt);
      });
      return occurrences;
    });
  }

  Stream<List<ShiftPattern>> watchShiftPatterns() {
    final query = select(shiftPatternRecords).join([
      leftOuterJoin(shiftSlotRecords, shiftSlotRecords.patternId.equalsExp(shiftPatternRecords.id)),
      leftOuterJoin(shiftExceptionRecords, shiftExceptionRecords.patternId.equalsExp(shiftPatternRecords.id)),
      leftOuterJoin(
        shiftPatternTagRecords,
        shiftPatternTagRecords.patternId.equalsExp(shiftPatternRecords.id),
      ),
    ])..where(shiftPatternRecords.deletedAt.isNull());

    return query.watch().map((rows) {
      final patterns = _patternsFromRows(rows);
      patterns.sort((a, b) {
        final bySpace = a.spaceId.compareTo(b.spaceId);
        if (bySpace != 0) return bySpace;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
      return patterns;
    });
  }

  Future<void> saveEntry(Entry entry) {
    return transaction(() async {
      await into(entryRecords).insertOnConflictUpdate(_entryCompanion(entry));
      await (delete(entryTagRecords)..where((row) => row.entryId.equals(entry.id))).go();
      for (final tagId in entry.tagIds) {
        await into(entryTagRecords).insert(
          EntryTagRecordsCompanion.insert(entryId: entry.id, tagId: tagId),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  Stream<List<Tag>> watchTags() {
    final query = select(tagRecords)..where((row) => row.deletedAt.isNull());
    return query.watch().map((rows) {
      final tags = rows.map(_tagFromRow).toList()
        ..sort((a, b) {
          final byPosition = a.position.compareTo(b.position);
          if (byPosition != 0) return byPosition;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      return tags;
    });
  }

  Future<void> saveTag(Tag tag) async {
    final now = DateTime.now();
    final existing = await (select(tagRecords)..where((row) => row.id.equals(tag.id))).getSingleOrNull();
    await into(tagRecords).insertOnConflictUpdate(
      TagRecordsCompanion(
        id: Value(tag.id),
        spaceId: Value(tag.spaceId),
        name: Value(tag.name),
        color: Value(tag.colorValue),
        position: Value(tag.position),
        createdAt: Value(existing?.createdAt ?? now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> softDeleteTag(String id) {
    return transaction(() async {
      final now = DateTime.now();
      await (delete(entryTagRecords)..where((row) => row.tagId.equals(id))).go();
      await (update(tagRecords)..where((row) => row.id.equals(id))).write(
        TagRecordsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
    });
  }

  Stream<List<HomeItem>> watchHomeItems() {
    final query = select(homeItemRecords)..where((row) => row.deletedAt.isNull());
    return query.watch().map((rows) {
      final items = rows.map(_homeItemFromRow).toList()
        ..sort((a, b) {
          final byCategory = a.category.toLowerCase().compareTo(b.category.toLowerCase());
          if (byCategory != 0) return byCategory;
          final byLocation = a.location.toLowerCase().compareTo(b.location.toLowerCase());
          if (byLocation != 0) return byLocation;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      return items;
    });
  }

  Future<void> saveHomeItem(HomeItem item) async {
    final now = DateTime.now();
    final existing = await (select(
      homeItemRecords,
    )..where((row) => row.id.equals(item.id))).getSingleOrNull();
    await into(homeItemRecords).insertOnConflictUpdate(
      HomeItemRecordsCompanion(
        id: Value(item.id),
        name: Value(item.name),
        category: Value(item.category),
        location: Value(item.location),
        quantity: Value(item.quantity),
        reorderLevel: Value(item.reorderLevel),
        unit: Value(item.unit),
        notes: Value(item.notes),
        lastPurchasedAt: Value(item.lastPurchasedAt),
        createdAt: Value(existing?.createdAt ?? now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> archiveHomeItem(String id) async {
    final now = DateTime.now();
    await (update(homeItemRecords)..where((row) => row.id.equals(id))).write(
      HomeItemRecordsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  Stream<List<ShoppingItem>> watchShoppingItems() {
    final query = select(shoppingItemRecords)..where((row) => row.deletedAt.isNull());
    return query.watch().map((rows) {
      final items = rows.map(_shoppingItemFromRow).toList()
        ..sort((a, b) {
          if (a.checked != b.checked) return a.checked ? 1 : -1;
          final byPosition = a.position.compareTo(b.position);
          if (byPosition != 0) return byPosition;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      return items;
    });
  }

  Future<void> saveShoppingItem(ShoppingItem item) async {
    final now = DateTime.now();
    final existing = await (select(
      shoppingItemRecords,
    )..where((row) => row.id.equals(item.id))).getSingleOrNull();
    var position = item.position;
    if (existing == null) {
      final rows = await select(shoppingItemRecords).get();
      final highest = rows.isEmpty ? -1 : rows.map((row) => row.position).reduce((a, b) => a > b ? a : b);
      if (position <= 0) position = highest + 1;
    }
    await into(shoppingItemRecords).insertOnConflictUpdate(
      ShoppingItemRecordsCompanion(
        id: Value(item.id),
        name: Value(item.name),
        quantity: Value(item.quantity),
        unit: Value(item.unit),
        checked: Value(item.checked),
        note: Value(item.note),
        homeItemId: Value(item.homeItemId),
        position: Value(position),
        createdAt: Value(existing?.createdAt ?? now),
        updatedAt: Value(now),
      ),
    );
  }

  /// Moves a line one slot up or down inside the unchecked part of the list.
  /// Positions are renumbered so repeated moves stay stable.
  Future<void> moveShoppingItem(String id, int delta) async {
    await transaction(() async {
      final rows = await (select(shoppingItemRecords)..where((row) => row.deletedAt.isNull())).get();
      final ordered = rows.toList()
        ..sort((a, b) {
          if (a.checked != b.checked) return a.checked ? 1 : -1;
          final byPosition = a.position.compareTo(b.position);
          if (byPosition != 0) return byPosition;
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      final index = ordered.indexWhere((row) => row.id == id);
      if (index < 0) return;
      final target = index + delta;
      if (target < 0 || target >= ordered.length) return;
      final moved = ordered.removeAt(index);
      ordered.insert(target, moved);
      final now = DateTime.now();
      for (var i = 0; i < ordered.length; i++) {
        await (update(shoppingItemRecords)..where((row) => row.id.equals(ordered[i].id))).write(
          ShoppingItemRecordsCompanion(position: Value(i), updatedAt: Value(now)),
        );
      }
    });
  }

  Future<void> clearCheckedShopping() async {
    final now = DateTime.now();
    await (update(shoppingItemRecords)..where((row) => row.checked.equals(true) & row.deletedAt.isNull()))
        .write(ShoppingItemRecordsCompanion(deletedAt: Value(now), updatedAt: Value(now)));
  }

  Future<void> deleteShoppingItem(String id) async {
    final now = DateTime.now();
    await (update(shoppingItemRecords)..where((row) => row.id.equals(id))).write(
      ShoppingItemRecordsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  /// Checking a linked shopping item updates the household quantity, the
  /// last-purchased time and the lightweight purchase history. Unchecking
  /// reverses the quantity change and removes that history row.
  Future<void> setShoppingChecked(String id, bool checked) {
    return transaction(() async {
      final now = DateTime.now();
      final row = await (select(shoppingItemRecords)..where((item) => item.id.equals(id))).getSingleOrNull();
      if (row == null || row.checked == checked) return;

      final homeId = row.homeItemId;
      if (homeId != null) {
        final home = await (select(
          homeItemRecords,
        )..where((item) => item.id.equals(homeId))).getSingleOrNull();
        if (home != null) {
          final delta = checked ? row.quantity : -row.quantity;
          final quantity = (home.quantity + delta).clamp(0.0, double.infinity).toDouble();
          await (update(homeItemRecords)..where((item) => item.id.equals(homeId))).write(
            HomeItemRecordsCompanion(
              quantity: Value(quantity),
              lastPurchasedAt: Value(checked ? now : home.lastPurchasedAt),
              updatedAt: Value(now),
            ),
          );
          if (checked) {
            await into(homePurchaseRecords).insert(
              HomePurchaseRecordsCompanion.insert(
                id: const Uuid().v4(),
                homeItemId: homeId,
                shoppingItemId: Value(id),
                quantity: row.quantity,
                purchasedAt: now,
              ),
            );
          } else {
            final matches = await (select(
              homePurchaseRecords,
            )..where((purchase) => purchase.shoppingItemId.equals(id))).get();
            for (final purchase in matches) {
              await (delete(homePurchaseRecords)..where((row) => row.id.equals(purchase.id))).go();
            }
          }
        }
      }

      await (update(shoppingItemRecords)..where((item) => item.id.equals(id))).write(
        ShoppingItemRecordsCompanion(checked: Value(checked), updatedAt: Value(now)),
      );
    });
  }

  /// Applies a manual stock adjustment and keeps a purchase row for increases.
  Future<void> adjustHomeQuantity(String id, double delta, {String note = ''}) {
    return transaction(() async {
      final now = DateTime.now();
      final home = await (select(homeItemRecords)..where((item) => item.id.equals(id))).getSingleOrNull();
      if (home == null) return;
      final quantity = (home.quantity + delta).clamp(0.0, double.infinity).toDouble();
      await (update(homeItemRecords)..where((item) => item.id.equals(id))).write(
        HomeItemRecordsCompanion(
          quantity: Value(quantity),
          lastPurchasedAt: Value(delta > 0 ? now : home.lastPurchasedAt),
          updatedAt: Value(now),
        ),
      );
      if (delta > 0) {
        await into(homePurchaseRecords).insert(
          HomePurchaseRecordsCompanion.insert(
            id: const Uuid().v4(),
            homeItemId: id,
            quantity: delta,
            note: Value(note),
            purchasedAt: now,
          ),
        );
      }
    });
  }

  Future<List<HomePurchase>> readPurchaseHistory(String homeItemId, {int limit = 30}) async {
    final rows = await (select(homePurchaseRecords)..where((row) => row.homeItemId.equals(homeItemId))).get();
    final purchases = rows.map(_homePurchaseFromRow).toList()
      ..sort((a, b) => b.purchasedAt.compareTo(a.purchasedAt));
    return purchases.take(limit).toList();
  }

  Future<List<ShiftChecklistItem>> readShiftChecklistItems(String patternId) async {
    final rows = await (select(
      shiftChecklistItemRecords,
    )..where((row) => row.patternId.equals(patternId))).get();
    final items = rows.map(_checklistItemFromRow).toList()..sort((a, b) => a.position.compareTo(b.position));
    return items;
  }

  Future<void> saveShiftChecklistItems(String patternId, List<ShiftChecklistItem> items) {
    return transaction(() async {
      final existing = await (select(
        shiftChecklistItemRecords,
      )..where((row) => row.patternId.equals(patternId))).get();
      final keepIds = items.map((item) => item.id).toSet();
      final removedIds = [
        for (final row in existing)
          if (!keepIds.contains(row.id)) row.id,
      ];
      if (removedIds.isNotEmpty) {
        await (delete(shiftChecklistCompletionRecords)..where((row) => row.itemId.isIn(removedIds))).go();
        await (delete(shiftChecklistItemRecords)..where((row) => row.id.isIn(removedIds))).go();
      }
      for (var index = 0; index < items.length; index++) {
        final item = items[index];
        final exists = existing.any((row) => row.id == item.id);
        if (exists) {
          await (update(shiftChecklistItemRecords)..where((row) => row.id.equals(item.id))).write(
            ShiftChecklistItemRecordsCompanion(label: Value(item.label), position: Value(index)),
          );
          continue;
        }
        await into(shiftChecklistItemRecords).insert(
          ShiftChecklistItemRecordsCompanion(
            id: Value(item.id),
            patternId: Value(patternId),
            label: Value(item.label),
            position: Value(index),
          ),
        );
      }
    });
  }

  Future<Set<String>> readShiftChecklistCompletions(
    String patternId,
    LocalDate date, {
    required String slotKey,
  }) async {
    final itemRows = await (select(
      shiftChecklistItemRecords,
    )..where((row) => row.patternId.equals(patternId))).get();
    final itemIds = itemRows.map((row) => row.id).toList();
    if (itemIds.isEmpty) return <String>{};
    final rows =
        await (select(shiftChecklistCompletionRecords)..where(
              (row) =>
                  row.dateKey.equals(date.key) &
                  row.itemId.isIn(itemIds) &
                  (row.slotKey.equals(slotKey) | row.slotKey.equals('')),
            ))
            .get();
    return {for (final row in rows) row.itemId};
  }

  Future<void> setShiftChecklistCompleted(
    String itemId,
    LocalDate date, {
    required bool completed,
    required String slotKey,
  }) async {
    if (completed) {
      await into(shiftChecklistCompletionRecords).insertOnConflictUpdate(
        ShiftChecklistCompletionRecordsCompanion.insert(
          itemId: itemId,
          dateKey: date.key,
          slotKey: Value(slotKey),
          createdAt: DateTime.now(),
        ),
      );
      return;
    }
    await (delete(shiftChecklistCompletionRecords)..where(
          (row) =>
              row.itemId.equals(itemId) &
              row.dateKey.equals(date.key) &
              (row.slotKey.equals(slotKey) | row.slotKey.equals('')),
        ))
        .go();
  }

  Future<LocalIdentity?> readIdentity() async {
    final row = await (select(identityRecords)..where((row) => row.id.equals(1))).getSingleOrNull();
    return row == null ? null : _identityFromRow(row);
  }

  Future<void> saveIdentity(LocalIdentity identity) async {
    await into(identityRecords).insertOnConflictUpdate(
      IdentityRecordsCompanion(
        id: const Value(1),
        deviceId: Value(identity.deviceId),
        deviceName: Value(identity.deviceName),
        username: Value(identity.username),
        pinSalt: Value(identity.pinSalt),
        pinHash: Value(identity.pinHash),
        certificatePem: Value(identity.certificatePem),
        privateKeyPem: Value(identity.privateKeyPem),
        mcpToken: Value(identity.mcpToken),
        createdAt: Value(identity.createdAt),
        updatedAt: Value(identity.updatedAt),
      ),
    );
  }

  Stream<List<PairedDevice>> watchPairedDevices() {
    final query = select(pairedDeviceRecords);
    return query.watch().map(
      (rows) =>
          rows.map(_pairedDeviceFromRow).toList()
            ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())),
    );
  }

  Future<List<PairedDevice>> readPairedDevices() async {
    final rows = await select(pairedDeviceRecords).get();
    return rows.map(_pairedDeviceFromRow).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future<void> savePairedDevice(PairedDevice device) async {
    await into(pairedDeviceRecords).insertOnConflictUpdate(
      PairedDeviceRecordsCompanion(
        id: Value(device.id),
        name: Value(device.name),
        username: Value(device.username),
        certificateFingerprint: Value(device.certificateFingerprint),
        sharedKey: Value(device.sharedKey),
        host: Value(device.host),
        port: Value(device.port),
        lastSeenAt: Value(device.lastSeenAt),
        createdAt: Value(device.createdAt),
        updatedAt: Value(device.updatedAt),
      ),
    );
  }

  Future<void> removePairedDevice(String id) async {
    await (delete(pairedDeviceRecords)..where((row) => row.id.equals(id))).go();
  }

  Future<void> updatePairedDevicePresence(
    String id, {
    required String host,
    required int port,
    required DateTime seenAt,
  }) async {
    await (update(pairedDeviceRecords)..where((row) => row.id.equals(id))).write(
      PairedDeviceRecordsCompanion(
        host: Value(host),
        port: Value(port),
        lastSeenAt: Value(seenAt),
        updatedAt: Value(seenAt),
      ),
    );
  }

  Stream<List<RemoteSnapshot>> watchRemoteSnapshots() {
    return select(remoteSnapshotRecords).watch().map((rows) {
      final snapshots = [for (final row in rows) _remoteSnapshotFromRow(row)]
        ..sort((a, b) => a.deviceName.toLowerCase().compareTo(b.deviceName.toLowerCase()));
      return snapshots;
    });
  }

  Future<List<RemoteSnapshot>> readRemoteSnapshots() async {
    final rows = await select(remoteSnapshotRecords).get();
    return [for (final row in rows) _remoteSnapshotFromRow(row)];
  }

  Future<void> saveRemoteSnapshot(RemoteSnapshot snapshot) async {
    await into(remoteSnapshotRecords).insertOnConflictUpdate(
      RemoteSnapshotRecordsCompanion(
        deviceId: Value(snapshot.deviceId),
        deviceName: Value(snapshot.deviceName),
        fetchedAt: Value(snapshot.fetchedAt),
        payloadJson: Value(jsonEncode(snapshot.payload)),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> pruneRemoteSnapshots(Set<String> keepDeviceIds) async {
    final rows = await select(remoteSnapshotRecords).get();
    final stale = [
      for (final row in rows)
        if (!keepDeviceIds.contains(row.deviceId)) row.deviceId,
    ];
    if (stale.isEmpty) return;
    await (delete(remoteSnapshotRecords)..where((row) => row.deviceId.isIn(stale))).go();
  }

  Future<void> deleteRemoteSnapshot(String deviceId) async {
    await (delete(remoteSnapshotRecords)..where((row) => row.deviceId.equals(deviceId))).go();
  }

  /// Global search over entry titles and notes, tag names, and household item
  /// name, category, location and notes.
  Future<SearchResults> search(String query) async {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return const SearchResults(entries: [], homeItems: []);

    final matchingEntries =
        await (select(entryRecords)..where(
              (row) =>
                  row.deletedAt.isNull() &
                  (row.title.lower().contains(term) | row.notes.lower().contains(term)),
            ))
            .get();
    final matchingTags = await (select(
      tagRecords,
    )..where((row) => row.deletedAt.isNull() & row.name.lower().contains(term))).get();

    final entryIds = <String>{for (final row in matchingEntries) row.id};
    if (matchingTags.isNotEmpty) {
      final links = await (select(
        entryTagRecords,
      )..where((row) => row.tagId.isIn(matchingTags.map((tag) => tag.id).toList()))).get();
      entryIds.addAll(links.map((row) => row.entryId));
    }

    final entries = <Entry>[];
    if (entryIds.isNotEmpty) {
      final rows = await (select(
        entryRecords,
      )..where((row) => row.id.isIn(entryIds) & row.deletedAt.isNull())).get();
      final links = await (select(entryTagRecords)..where((row) => row.entryId.isIn(entryIds))).get();
      final tagIds = <String, Set<String>>{};
      for (final link in links) {
        (tagIds[link.entryId] ??= <String>{}).add(link.tagId);
      }
      entries.addAll(rows.map((row) => _entryFromRow(row, tagIds: tagIds[row.id] ?? const <String>{})));
      entries.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    }

    final homeRows =
        await (select(homeItemRecords)..where(
              (row) =>
                  row.deletedAt.isNull() &
                  (row.name.lower().contains(term) |
                      row.category.lower().contains(term) |
                      row.location.lower().contains(term) |
                      row.notes.lower().contains(term)),
            ))
            .get();
    final homeItems = homeRows.map(_homeItemFromRow).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return SearchResults(entries: entries, homeItems: homeItems);
  }

  Future<bool> hasImportedEntry(String source, String externalId) async {
    final row = await (select(
      entryRecords,
    )..where((row) => row.source.equals(source) & row.externalId.equals(externalId))).getSingleOrNull();
    return row != null;
  }

  /// Whether a live entry already matches the identifying fields a CSV row can
  /// express. CSV has no stable ids, so matching user entries as well as
  /// earlier imports is what keeps a round-trip from duplicating the plan.
  Future<bool> hasEntryLike({
    required String title,
    required String spaceId,
    required LocalDate date,
    required bool allDay,
    required int? startMinute,
    required int? endMinute,
  }) async {
    final row =
        await (select(entryRecords)..where(
              (row) =>
                  row.deletedAt.isNull() &
                  row.title.equals(title) &
                  row.spaceId.equals(spaceId) &
                  row.dateKey.equals(date.key) &
                  row.allDay.equals(allDay) &
                  row.startMinute.equalsNullable(startMinute) &
                  row.endMinute.equalsNullable(endMinute),
            ))
            .getSingleOrNull();
    return row != null;
  }

  Future<Entry?> readImportedEntry(String source, String externalId) async {
    final row = await (select(
      entryRecords,
    )..where((row) => row.source.equals(source) & row.externalId.equals(externalId))).getSingleOrNull();
    if (row == null) return null;
    final tags = await (select(entryTagRecords)..where((tag) => tag.entryId.equals(row.id))).get();
    return _entryFromRow(row, tagIds: {for (final tag in tags) tag.tagId});
  }

  /// Completes a maintenance task and moves its date forward from the day it
  /// was actually completed. Records the completion as history.
  Future<LocalDate?> completeMaintenanceEntry(String id, LocalDate completionDate) async {
    final row = await (select(entryRecords)..where((entry) => entry.id.equals(id))).getSingleOrNull();
    final interval = row?.repeatAfterCompletionDays;
    if (row == null || row.readOnly || interval == null || interval <= 0) return null;
    final currentDate = row.dateKey == null ? null : LocalDate.fromKey(row.dateKey!);
    if (currentDate == null) return null;

    final now = DateTime.now();
    final nextDate = completionDate.addDays(interval);
    final endShift = row.endDateKey == null ? null : row.endDateKey! - row.dateKey!;
    DateTime? startAt;
    DateTime? endAt;
    if (!row.allDay && row.timeZone != null && row.startMinute != null && row.endMinute != null) {
      startAt = instantAt(nextDate, row.startMinute!, row.timeZone!);
      endAt = instantAt(nextDate, row.endMinute!, row.timeZone!);
    }

    await transaction(() async {
      await into(completionRecords).insertOnConflictUpdate(
        CompletionRecordsCompanion.insert(entryId: id, dateKey: completionDate.key, createdAt: now),
      );
      await (update(entryRecords)..where((entry) => entry.id.equals(id))).write(
        EntryRecordsCompanion(
          dateKey: Value(nextDate.key),
          endDateKey: Value(endShift == null ? null : nextDate.addDays(endShift).key),
          startAt: Value(startAt),
          endAt: Value(endAt),
          lastCompletedAt: Value(now),
          status: Value(EntryStatus.open.name),
          updatedAt: Value(now),
        ),
      );
    });
    return nextDate;
  }

  Future<void> setEntryStatus(String id, EntryStatus status) async {
    await (update(entryRecords)..where((row) => row.id.equals(id))).write(
      EntryRecordsCompanion(status: Value(status.name), updatedAt: Value(DateTime.now())),
    );
  }

  Future<Entry?> readEntry(String id) async {
    final row = await (select(entryRecords)..where((entry) => entry.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final tags = await (select(entryTagRecords)..where((tag) => tag.entryId.equals(id))).get();
    return _entryFromRow(row, tagIds: {for (final tag in tags) tag.tagId});
  }

  Future<List<Reminder>> readRemindersForEntry(String entryId) async {
    final rows = await (select(reminderRecords)..where((row) => row.entryId.equals(entryId))).get();
    final reminders = rows.map(_reminderFromRow).toList()
      ..sort((a, b) => a.offsetMinutes.compareTo(b.offsetMinutes));
    return reminders;
  }

  Future<Map<String, List<Reminder>>> readAllReminders() async {
    final rows = await (select(reminderRecords)..where((row) => row.enabled.equals(true))).get();
    final byEntry = <String, List<Reminder>>{};
    for (final row in rows) {
      (byEntry[row.entryId] ??= <Reminder>[]).add(_reminderFromRow(row));
    }
    for (final reminders in byEntry.values) {
      reminders.sort((a, b) => a.offsetMinutes.compareTo(b.offsetMinutes));
    }
    return byEntry;
  }

  Future<void> saveRemindersForEntry(String entryId, List<Reminder> reminders) {
    return transaction(() async {
      await (delete(reminderRecords)..where((row) => row.entryId.equals(entryId))).go();
      for (final reminder in reminders) {
        await into(reminderRecords).insert(
          ReminderRecordsCompanion.insert(
            id: reminder.id.isEmpty ? Reminder.idFor(entryId, reminder.offsetMinutes) : reminder.id,
            entryId: entryId,
            offsetMinutes: reminder.offsetMinutes,
            timeMinute: Value(reminder.timeMinute),
            enabled: Value(reminder.enabled),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Marks one occurrence of a recurring entry done without touching the
  /// others. Used by daily chores and shift checklists.
  Future<void> setOccurrenceCompleted(String entryId, LocalDate date, {required bool completed}) async {
    if (completed) {
      await into(completionRecords).insertOnConflictUpdate(
        CompletionRecordsCompanion.insert(entryId: entryId, dateKey: date.key, createdAt: DateTime.now()),
      );
      return;
    }

    await (delete(
      completionRecords,
    )..where((row) => row.entryId.equals(entryId) & row.dateKey.equals(date.key))).go();
  }

  Future<void> softDeleteEntry(String id) async {
    final now = DateTime.now();
    await (update(entryRecords)..where((row) => row.id.equals(id))).write(
      EntryRecordsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  Future<void> saveShiftPattern(ShiftPattern pattern) {
    return transaction(() async {
      final now = DateTime.now();
      final existing = await (select(
        shiftPatternRecords,
      )..where((row) => row.id.equals(pattern.id))).getSingleOrNull();
      await into(shiftPatternRecords).insertOnConflictUpdate(
        ShiftPatternRecordsCompanion(
          id: Value(pattern.id),
          spaceId: Value(pattern.spaceId),
          name: Value(pattern.name),
          timeZone: Value(pattern.timeZone),
          cycleDays: Value(pattern.cycleDays),
          anchorDateKey: Value(pattern.anchorDate.key),
          commuteMinutes: Value(pattern.commuteMinutes),
          windDownMinutes: Value(pattern.windDownMinutes),
          enabled: Value(pattern.enabled),
          createdAt: Value(existing?.createdAt ?? now),
          updatedAt: Value(now),
        ),
      );

      await (delete(shiftSlotRecords)..where((row) => row.patternId.equals(pattern.id))).go();
      await (delete(shiftExceptionRecords)..where((row) => row.patternId.equals(pattern.id))).go();
      await (delete(shiftPatternTagRecords)..where((row) => row.patternId.equals(pattern.id))).go();

      for (final tagId in pattern.tagIds) {
        await into(shiftPatternTagRecords).insert(
          ShiftPatternTagRecordsCompanion.insert(patternId: pattern.id, tagId: tagId),
          mode: InsertMode.insertOrIgnore,
        );
      }

      for (final slot in pattern.slots) {
        await into(shiftSlotRecords).insert(
          ShiftSlotRecordsCompanion.insert(
            patternId: pattern.id,
            dayIndex: slot.dayIndex,
            label: Value(slot.label),
            startMinute: slot.startMinute,
            endMinute: slot.endMinute,
          ),
        );
      }

      for (final exception in pattern.exceptions) {
        await into(shiftExceptionRecords).insert(
          ShiftExceptionRecordsCompanion.insert(
            patternId: pattern.id,
            dateKey: exception.date.key,
            type: exception.type.name,
            startMinute: Value(exception.startMinute),
            endMinute: Value(exception.endMinute),
            note: Value(exception.note),
          ),
        );
      }
    });
  }

  Future<void> softDeleteShiftPattern(String id) async {
    final now = DateTime.now();
    await (update(shiftPatternRecords)..where((row) => row.id.equals(id))).write(
      ShiftPatternRecordsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  List<ShiftPattern> _patternsFromRows(Iterable<TypedResult> rows) {
    final patternRows = <String, ShiftPatternRow>{};
    final slots = <String, Map<int, ShiftSlot>>{};
    final exceptions = <String, Map<int, ShiftException>>{};
    final tagIds = <String, Set<String>>{};

    for (final row in rows) {
      final patternRow = row.readTable(shiftPatternRecords);
      patternRows[patternRow.id] = patternRow;

      final tagRow = row.readTableOrNull(shiftPatternTagRecords);
      if (tagRow != null) {
        (tagIds[patternRow.id] ??= <String>{}).add(tagRow.tagId);
      }

      final slotRow = row.readTableOrNull(shiftSlotRecords);
      if (slotRow != null) {
        (slots[patternRow.id] ??= <int, ShiftSlot>{})[slotRow.id] = ShiftSlot(
          dayIndex: slotRow.dayIndex,
          label: slotRow.label,
          startMinute: slotRow.startMinute,
          endMinute: slotRow.endMinute,
        );
      }

      final exceptionRow = row.readTableOrNull(shiftExceptionRecords);
      if (exceptionRow != null) {
        (exceptions[patternRow.id] ??= <int, ShiftException>{})[exceptionRow.id] = ShiftException(
          date: LocalDate.fromKey(exceptionRow.dateKey),
          type: ShiftExceptionType.values.byName(exceptionRow.type),
          startMinute: exceptionRow.startMinute,
          endMinute: exceptionRow.endMinute,
          note: exceptionRow.note,
        );
      }
    }

    return [
      for (final row in patternRows.values)
        _patternFromRow(
          row,
          slots[row.id]?.values.toList() ?? const <ShiftSlot>[],
          exceptions[row.id]?.values.toList() ?? const <ShiftException>[],
          tagIds[row.id] ?? const <String>{},
        ),
    ];
  }

  Future<void> _migrateToV2(Migrator m) async {
    final safeZone = isKnownTimeZone(defaultTimeZone) ? defaultTimeZone : 'UTC';

    // The old one-slot JSON has to be read before alterTable drops the column.
    final legacyPatterns = await customSelect('SELECT id, slots_json FROM shift_pattern_records').get();

    await m.addColumn(entryRecords, entryRecords.timeZone);
    await m.addColumn(entryRecords, entryRecords.startAt);
    await m.addColumn(entryRecords, entryRecords.endAt);
    await m.createTable(shiftSlotRecords);
    await m.createTable(shiftExceptionRecords);
    await m.addColumn(shiftPatternRecords, shiftPatternRecords.timeZone);

    await update(shiftPatternRecords).write(ShiftPatternRecordsCompanion(timeZone: Value(safeZone)));

    final patternColumns = await customSelect('PRAGMA table_info(shift_pattern_records)').get();
    final hasLegacySlots = patternColumns.any((row) => row.read<String>('name') == 'slots_json');

    for (final row in legacyPatterns) {
      final patternId = row.read<String>('id');
      final raw = row.readNullable<String>('slots_json');
      if (raw == null || raw.isEmpty) continue;
      final decoded = jsonDecode(raw);
      if (decoded is! List) continue;

      for (final value in decoded) {
        if (value is! Map) continue;
        final ShiftSlot slot;
        try {
          slot = ShiftSlot.fromJson(Map<String, Object?>.from(value));
        } on FormatException {
          // One malformed legacy slot must not make the whole plan unopenable.
          continue;
        }
        await into(shiftSlotRecords).insert(
          ShiftSlotRecordsCompanion.insert(
            patternId: patternId,
            dayIndex: slot.dayIndex,
            label: Value(slot.label),
            startMinute: slot.startMinute,
            endMinute: slot.endMinute,
          ),
        );
      }
    }

    if (hasLegacySlots) {
      await customStatement('ALTER TABLE shift_pattern_records DROP COLUMN slots_json');
    }

    final legacyEntries = await select(entryRecords).get();
    for (final row in legacyEntries) {
      final date = row.dateKey == null ? null : LocalDate.fromKey(row.dateKey!);
      final startMinute = row.startMinute;
      if (row.allDay || date == null || startMinute == null) {
        if (!row.allDay && date != null && startMinute == null) {
          await (update(entryRecords)..where((entry) => entry.id.equals(row.id))).write(
            const EntryRecordsCompanion(allDay: Value(true)),
          );
        }
        continue;
      }

      final endMinute = row.endMinute == null || row.endMinute! <= startMinute
          ? startMinute + 60
          : row.endMinute!;
      await (update(entryRecords)..where((entry) => entry.id.equals(row.id))).write(
        EntryRecordsCompanion(
          timeZone: Value(safeZone),
          startAt: Value(instantAt(date, startMinute, safeZone)),
          endAt: Value(instantAt(date, endMinute, safeZone)),
        ),
      );
    }

    final personal = await (select(
      spaceRecords,
    )..where((row) => row.id.equals('personal'))).getSingleOrNull();
    if (personal == null) {
      final now = DateTime.now();
      await into(spaceRecords).insert(
        SpaceRecordsCompanion.insert(
          id: 'personal',
          name: 'Personal',
          color: 0xFFB07D5C,
          position: const Value(0),
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
    await (update(
      spaceRecords,
    )..where((row) => row.id.equals('work'))).write(const SpaceRecordsCompanion(position: Value(1)));
    await (update(
      spaceRecords,
    )..where((row) => row.id.equals('home'))).write(const SpaceRecordsCompanion(position: Value(2)));
  }

  Future<void> _migrateToV3(Migrator m) async {
    await m.createTable(tagRecords);
    await m.createTable(entryTagRecords);
  }

  Future<void> _migrateToV4(Migrator m) async {
    await m.createTable(shiftChecklistItemRecords);
    await m.createTable(shiftChecklistCompletionRecords);
    await m.createTable(homeItemRecords);
    await m.createTable(shoppingItemRecords);
  }

  Future<void> _migrateToV5(Migrator m) async {
    await m.createTable(identityRecords);
    await m.createTable(pairedDeviceRecords);
  }

  Future<void> _migrateToV6(Migrator m) async {
    final patternColumns = await customSelect('PRAGMA table_info(shift_pattern_records)').get();
    final patternNames = patternColumns.map((row) => row.read<String>('name')).toSet();
    if (!patternNames.contains('commute_minutes')) {
      await m.addColumn(shiftPatternRecords, shiftPatternRecords.commuteMinutes);
    }
    if (!patternNames.contains('wind_down_minutes')) {
      await m.addColumn(shiftPatternRecords, shiftPatternRecords.windDownMinutes);
    }

    final tables = await customSelect('SELECT name FROM sqlite_master WHERE type = \'table\'').get();
    final tableNames = tables.map((row) => row.read<String>('name')).toSet();
    if (!tableNames.contains('shift_pattern_tag_records')) {
      await m.createTable(shiftPatternTagRecords);
    }

    final completionColumns = await customSelect(
      'PRAGMA table_info(shift_checklist_completion_records)',
    ).get();
    final completionNames = completionColumns.map((row) => row.read<String>('name')).toSet();
    if (!completionNames.contains('slot_key')) {
      await customStatement('ALTER TABLE shift_checklist_completion_records RENAME TO _completion_v5');
      await customStatement('''
        CREATE TABLE "shift_checklist_completion_records" (
          "item_id" TEXT NOT NULL REFERENCES shift_checklist_item_records (id),
          "date_key" INTEGER NOT NULL,
          "slot_key" TEXT NOT NULL DEFAULT '',
          "created_at" INTEGER NOT NULL,
          PRIMARY KEY ("item_id", "date_key", "slot_key")
        )
      ''');
      await customStatement('''
        INSERT INTO shift_checklist_completion_records (item_id, date_key, slot_key, created_at)
        SELECT item_id, date_key, '', created_at FROM _completion_v5
      ''');
      await customStatement('DROP TABLE _completion_v5');
    }

    await _backfillShiftChecklistSlotKeys();
  }

  /// Existing completions were keyed by pattern + date. Assign them to the
  /// first slot of that date so a single-slot history survives the v6 key.
  Future<void> _backfillShiftChecklistSlotKeys() async {
    final legacy = await customSelect(
      "SELECT item_id, date_key FROM shift_checklist_completion_records WHERE slot_key = ''",
    ).get();
    if (legacy.isEmpty) return;

    final patterns = <String, ShiftPattern?>{};
    for (final row in legacy) {
      final itemId = row.read<String>('item_id');
      final dateKey = row.read<int>('date_key');
      final item = await (select(
        shiftChecklistItemRecords,
      )..where((table) => table.id.equals(itemId))).getSingleOrNull();
      if (item == null) continue;
      final pattern = patterns.putIfAbsent(item.patternId, () => null);
      if (pattern == null && !patterns.containsKey(item.patternId)) {
        patterns[item.patternId] = await _loadPattern(item.patternId);
      }
      final resolved = patterns[item.patternId] ?? await _loadPattern(item.patternId);
      patterns[item.patternId] = resolved;
      if (resolved == null) continue;
      final slots = resolved.slotsFor(LocalDate.fromKey(dateKey));
      if (slots.isEmpty) continue;
      await customUpdate(
        'UPDATE shift_checklist_completion_records SET slot_key = ? '
        'WHERE item_id = ? AND date_key = ? AND slot_key = \'\'',
        variables: [
          Variable.withString(slots.first.key),
          Variable.withString(itemId),
          Variable.withInt(dateKey),
        ],
        updates: {shiftChecklistCompletionRecords},
      );
    }
  }

  /// v7 adds manual shopping order and the lightweight purchase history.
  Future<void> _migrateToV7(Migrator m) async {
    final shoppingColumns = await customSelect('PRAGMA table_info(shopping_item_records)').get();
    final shoppingNames = shoppingColumns.map((row) => row.read<String>('name')).toSet();
    if (!shoppingNames.contains('position')) {
      await m.addColumn(shoppingItemRecords, shoppingItemRecords.position);
    }

    final tables = await customSelect('SELECT name FROM sqlite_master WHERE type = \'table\'').get();
    final tableNames = tables.map((row) => row.read<String>('name')).toSet();
    if (!tableNames.contains('home_purchase_records')) {
      await m.createTable(homePurchaseRecords);
    }
  }

  /// v8 adds absolute reminder times and persistent read-only LAN snapshots.
  Future<void> _migrateToV8(Migrator m) async {
    final reminderColumns = await customSelect('PRAGMA table_info(reminder_records)').get();
    final reminderNames = reminderColumns.map((row) => row.read<String>('name')).toSet();
    if (!reminderNames.contains('time_minute')) {
      await m.addColumn(reminderRecords, reminderRecords.timeMinute);
    }

    final tables = await customSelect('SELECT name FROM sqlite_master WHERE type = \'table\'').get();
    final tableNames = tables.map((row) => row.read<String>('name')).toSet();
    if (!tableNames.contains('remote_snapshot_records')) {
      await m.createTable(remoteSnapshotRecords);
    }
  }

  Future<ShiftPattern?> _loadPattern(String id) async {
    final row = await (select(shiftPatternRecords)..where((table) => table.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final slotRows = await (select(shiftSlotRecords)..where((table) => table.patternId.equals(id))).get();
    final exceptionRows = await (select(
      shiftExceptionRecords,
    )..where((table) => table.patternId.equals(id))).get();
    return _patternFromRow(
      row,
      [
        for (final slot in slotRows)
          ShiftSlot(
            dayIndex: slot.dayIndex,
            label: slot.label,
            startMinute: slot.startMinute,
            endMinute: slot.endMinute,
          ),
      ],
      [
        for (final exception in exceptionRows)
          ShiftException(
            date: LocalDate.fromKey(exception.dateKey),
            type: ShiftExceptionType.values.byName(exception.type),
            startMinute: exception.startMinute,
            endMinute: exception.endMinute,
            note: exception.note,
          ),
      ],
      const <String>{},
    );
  }

  Future<void> _addV4EntryColumns(Migrator m) async {
    await m.addColumn(entryRecords, entryRecords.source);
    await m.addColumn(entryRecords, entryRecords.externalId);
    await m.addColumn(entryRecords, entryRecords.readOnly);
    await m.addColumn(entryRecords, entryRecords.lastCompletedAt);
    await m.addColumn(entryRecords, entryRecords.repeatAfterCompletionDays);
  }
}

const _defaultSpaces = <Space>[
  Space(id: 'personal', name: 'Personal', colorValue: 0xFFB07D5C, position: 0),
  Space(id: 'work', name: 'Work', colorValue: 0xFF4A6FA5, position: 1),
  Space(id: 'home', name: 'Home', colorValue: 0xFF5B7F6B, position: 2),
];

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, 'mane.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

Space _spaceFromRow(SpaceRow row) =>
    Space(id: row.id, name: row.name, colorValue: row.color, position: row.position);

Tag _tagFromRow(TagRow row) =>
    Tag(id: row.id, spaceId: row.spaceId, name: row.name, colorValue: row.color, position: row.position);

Reminder _reminderFromRow(ReminderRow row) => Reminder(
  id: row.id,
  entryId: row.entryId,
  offsetMinutes: row.offsetMinutes,
  timeMinute: row.timeMinute,
  enabled: row.enabled,
);

RemoteSnapshot _remoteSnapshotFromRow(RemoteSnapshotRow row) {
  Map<String, Object?> payload = const {};
  try {
    final decoded = jsonDecode(row.payloadJson);
    if (decoded is Map) payload = Map<String, Object?>.from(decoded);
  } on FormatException {
    // A damaged display snapshot must never prevent the app from opening.
  }
  return RemoteSnapshot.fromPayload(
    deviceId: row.deviceId,
    deviceName: row.deviceName,
    fetchedAt: row.fetchedAt,
    data: payload,
  );
}

HomeItem _homeItemFromRow(HomeItemRow row) => HomeItem(
  id: row.id,
  name: row.name,
  category: row.category,
  location: row.location,
  quantity: row.quantity,
  unit: row.unit,
  reorderLevel: row.reorderLevel,
  notes: row.notes,
  lastPurchasedAt: row.lastPurchasedAt,
);

ShoppingItem _shoppingItemFromRow(ShoppingItemRow row) => ShoppingItem(
  id: row.id,
  name: row.name,
  quantity: row.quantity,
  unit: row.unit,
  checked: row.checked,
  note: row.note,
  homeItemId: row.homeItemId,
  position: row.position,
);

HomePurchase _homePurchaseFromRow(HomePurchaseRow row) => HomePurchase(
  id: row.id,
  homeItemId: row.homeItemId,
  shoppingItemId: row.shoppingItemId,
  quantity: row.quantity,
  note: row.note,
  purchasedAt: row.purchasedAt,
);

ShiftChecklistItem _checklistItemFromRow(ShiftChecklistItemRow row) =>
    ShiftChecklistItem(id: row.id, patternId: row.patternId, label: row.label, position: row.position);

LocalIdentity _identityFromRow(IdentityRow row) => LocalIdentity(
  deviceId: row.deviceId,
  deviceName: row.deviceName,
  username: row.username,
  pinSalt: row.pinSalt,
  pinHash: row.pinHash,
  certificatePem: row.certificatePem,
  privateKeyPem: row.privateKeyPem,
  mcpToken: row.mcpToken,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
);

PairedDevice _pairedDeviceFromRow(PairedDeviceRow row) => PairedDevice(
  id: row.id,
  name: row.name,
  username: row.username,
  certificateFingerprint: row.certificateFingerprint,
  sharedKey: row.sharedKey,
  host: row.host,
  port: row.port,
  lastSeenAt: row.lastSeenAt,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
);

Entry _entryFromRow(EntryRow row, {Set<String> tagIds = const <String>{}}) => Entry(
  id: row.id,
  spaceId: row.spaceId,
  title: row.title,
  notes: row.notes,
  kind: EntryKind.values.byName(row.kind),
  date: row.dateKey == null ? null : LocalDate.fromKey(row.dateKey!),
  endDate: row.endDateKey == null ? null : LocalDate.fromKey(row.endDateKey!),
  startMinute: row.startMinute,
  endMinute: row.endMinute,
  timeZone: row.timeZone,
  tagIds: tagIds,
  allDay: row.allDay,
  status: EntryStatus.values.byName(row.status),
  recurrence: row.recurrenceJson == null
      ? null
      : RecurrenceRule.fromJson(Map<String, Object?>.from(jsonDecode(row.recurrenceJson!) as Map)),
  source: row.source,
  externalId: row.externalId,
  readOnly: row.readOnly,
  lastCompletedAt: row.lastCompletedAt?.toUtc(),
  repeatAfterCompletionDays: row.repeatAfterCompletionDays,
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
  deletedAt: row.deletedAt,
  startAt: row.startAt?.toUtc(),
  endAt: row.endAt?.toUtc(),
);

EntryRecordsCompanion _entryCompanion(Entry entry) => EntryRecordsCompanion(
  id: Value(entry.id),
  spaceId: Value(entry.spaceId),
  title: Value(entry.title),
  notes: Value(entry.notes),
  kind: Value(entry.kind.name),
  dateKey: Value(entry.date?.key),
  endDateKey: Value(entry.endDate?.key),
  startMinute: Value(entry.startMinute),
  endMinute: Value(entry.endMinute),
  timeZone: Value(entry.timeZone),
  startAt: Value(entry.startAt),
  endAt: Value(entry.endAt),
  allDay: Value(entry.allDay),
  status: Value(entry.status.name),
  recurrenceJson: Value(entry.recurrence == null ? null : jsonEncode(entry.recurrence!.toJson())),
  source: Value(entry.source),
  externalId: Value(entry.externalId),
  readOnly: Value(entry.readOnly),
  lastCompletedAt: Value(entry.lastCompletedAt),
  repeatAfterCompletionDays: Value(entry.repeatAfterCompletionDays),
  createdAt: Value(entry.createdAt),
  updatedAt: Value(entry.updatedAt),
  deletedAt: Value(entry.deletedAt),
);

ShiftPattern _patternFromRow(
  ShiftPatternRow row,
  List<ShiftSlot> slots,
  List<ShiftException> exceptions,
  Set<String> tagIds,
) => ShiftPattern(
  id: row.id,
  spaceId: row.spaceId,
  name: row.name,
  timeZone: row.timeZone,
  cycleDays: row.cycleDays,
  anchorDate: LocalDate.fromKey(row.anchorDateKey),
  slots: slots,
  exceptions: exceptions,
  tagIds: tagIds,
  commuteMinutes: row.commuteMinutes,
  windDownMinutes: row.windDownMinutes,
  enabled: row.enabled,
);

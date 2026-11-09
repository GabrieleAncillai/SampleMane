import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mane_core/mane_core.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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

@DataClassName('EntryRow')
class EntryRecords extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text().references(SpaceRecords, #id)();
  TextColumn get title => text()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  /// One of [EntryKind]. Stored as text so the database stays readable.
  TextColumn get kind => text()();

  /// Start date as `YYYYMMDD`, null when the entry is unscheduled.
  IntColumn get dateKey => integer().nullable()();

  /// End date for multi-day entries.
  IntColumn get endDateKey => integer().nullable()();

  /// Minutes from midnight, null for all-day entries.
  IntColumn get startMinute => integer().nullable()();
  IntColumn get endMinute => integer().nullable()();

  BoolColumn get allDay => boolean().withDefault(const Constant(false))();

  /// One of [EntryStatus].
  TextColumn get status => text()();

  /// Serialized [RecurrenceRule], null for one-off entries.
  TextColumn get recurrenceJson => text().nullable()();

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
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ShiftPatternRow')
class ShiftPatternRecords extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text().references(SpaceRecords, #id)();
  TextColumn get name => text()();
  IntColumn get cycleDays => integer()();
  IntColumn get anchorDateKey => integer()();

  /// Serialized list of [ShiftSlot].
  TextColumn get slotsJson => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
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
    CompletionRecords,
    ReminderRecords,
    ShiftPatternRecords,
    SettingRecords,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.open() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Home and Work exist on first launch. No sample life data is inserted.
  Future<void> seedDefaults() async {
    final existing = await (select(spaceRecords)..where((row) => row.deletedAt.isNull())).get();
    if (existing.isNotEmpty) return;

    final now = DateTime.now();
    await batch((batch) {
      batch.insertAll(spaceRecords, [
        SpaceRecordsCompanion.insert(
          id: 'home',
          name: 'Home',
          color: 0xFF5B7F6B,
          position: const Value(0),
          createdAt: now,
          updatedAt: now,
        ),
        SpaceRecordsCompanion.insert(
          id: 'work',
          name: 'Work',
          color: 0xFF4A6FA5,
          position: const Value(1),
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

  Stream<List<EntryOccurrence>> watchEntriesBetween(LocalDate start, LocalDate end) {
    final query = select(entryRecords).join([
      leftOuterJoin(
        completionRecords,
        completionRecords.entryId.equalsExp(entryRecords.id) &
            completionRecords.dateKey.isBetweenValues(start.key, end.key),
      ),
    ])..where(entryRecords.deletedAt.isNull());

    return query.watch().map((rows) {
      final entries = <String, Entry>{};
      final completions = <String, Set<LocalDate>>{};

      for (final row in rows) {
        final entryRow = row.readTable(entryRecords);
        final entry = entries.putIfAbsent(entryRow.id, () => _entryFromRow(entryRow));
        final completion = row.readTableOrNull(completionRecords);
        if (completion != null) {
          (completions[entry.id] ??= <LocalDate>{}).add(LocalDate.fromKey(completion.dateKey));
        }
      }

      final occurrences = <EntryOccurrence>[];
      for (final entry in entries.values) {
        if (entry.status == EntryStatus.cancelled) continue;
        final anchor = entry.date;
        if (anchor == null) continue;

        if (entry.recurrence == null) {
          final last = entry.endDate ?? anchor;
          if (!anchor.isAfter(end) && !last.isBefore(start)) {
            occurrences.add(
              EntryOccurrence(date: anchor, entry: entry, completed: entry.status == EntryStatus.done),
            );
          }
          continue;
        }

        for (final date in entry.recurrence!.occurrencesBetween(start, end, anchor)) {
          occurrences.add(
            EntryOccurrence(
              date: date,
              entry: entry,
              completed: completions[entry.id]?.contains(date) ?? false,
            ),
          );
        }
      }
      occurrences.sort(_compareOccurrences);
      return occurrences;
    });
  }

  Stream<List<ShiftOccurrence>> watchShiftsBetween(LocalDate start, LocalDate end) {
    final query = select(shiftPatternRecords)
      ..where((row) => row.deletedAt.isNull() & row.enabled.equals(true));
    return query.watch().map((rows) {
      final occurrences = <ShiftOccurrence>[];
      for (final row in rows) {
        final pattern = _patternFromRow(row);
        occurrences.addAll(pattern.occurrencesBetween(start, end));
      }
      occurrences.sort((a, b) {
        final byDate = a.date.compareTo(b.date);
        if (byDate != 0) return byDate;
        return a.slot.startMinute.compareTo(b.slot.startMinute);
      });
      return occurrences;
    });
  }

  Future<void> saveEntry(Entry entry) {
    return into(entryRecords).insertOnConflictUpdate(_entryCompanion(entry));
  }

  Future<void> setEntryStatus(String id, EntryStatus status) async {
    await (update(entryRecords)..where((row) => row.id.equals(id))).write(
      EntryRecordsCompanion(status: Value(status.name), updatedAt: Value(DateTime.now())),
    );
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
    final now = DateTime.now();
    return into(shiftPatternRecords).insertOnConflictUpdate(
      ShiftPatternRecordsCompanion(
        id: Value(pattern.id),
        spaceId: Value(pattern.spaceId),
        name: Value(pattern.name),
        cycleDays: Value(pattern.cycleDays),
        anchorDateKey: Value(pattern.anchorDate.key),
        slotsJson: Value(jsonEncode(pattern.slots.map((slot) => slot.toJson()).toList())),
        enabled: Value(pattern.enabled),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> softDeleteShiftPattern(String id) async {
    final now = DateTime.now();
    await (update(shiftPatternRecords)..where((row) => row.id.equals(id))).write(
      ShiftPatternRecordsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, 'mane.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

Space _spaceFromRow(SpaceRow row) =>
    Space(id: row.id, name: row.name, colorValue: row.color, position: row.position);

Entry _entryFromRow(EntryRow row) => Entry(
  id: row.id,
  spaceId: row.spaceId,
  title: row.title,
  notes: row.notes,
  kind: EntryKind.values.byName(row.kind),
  date: row.dateKey == null ? null : LocalDate.fromKey(row.dateKey!),
  endDate: row.endDateKey == null ? null : LocalDate.fromKey(row.endDateKey!),
  startMinute: row.startMinute,
  endMinute: row.endMinute,
  allDay: row.allDay,
  status: EntryStatus.values.byName(row.status),
  recurrence: row.recurrenceJson == null
      ? null
      : RecurrenceRule.fromJson(Map<String, Object?>.from(jsonDecode(row.recurrenceJson!) as Map)),
  createdAt: row.createdAt,
  updatedAt: row.updatedAt,
  deletedAt: row.deletedAt,
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
  allDay: Value(entry.allDay),
  status: Value(entry.status.name),
  recurrenceJson: Value(entry.recurrence == null ? null : jsonEncode(entry.recurrence!.toJson())),
  createdAt: Value(entry.createdAt),
  updatedAt: Value(entry.updatedAt),
  deletedAt: Value(entry.deletedAt),
);

ShiftPattern _patternFromRow(ShiftPatternRow row) => ShiftPattern(
  id: row.id,
  spaceId: row.spaceId,
  name: row.name,
  cycleDays: row.cycleDays,
  anchorDate: LocalDate.fromKey(row.anchorDateKey),
  slots: (jsonDecode(row.slotsJson) as List)
      .map((slot) => ShiftSlot.fromJson(Map<String, Object?>.from(slot as Map)))
      .toList(),
  enabled: row.enabled,
);

int _compareOccurrences(EntryOccurrence a, EntryOccurrence b) {
  final byDate = a.date.compareTo(b.date);
  if (byDate != 0) return byDate;
  final byTime = (a.entry.startMinute ?? -1).compareTo(b.entry.startMinute ?? -1);
  if (byTime != 0) return byTime;
  return a.entry.title.compareTo(b.entry.title);
}

import 'package:mane_core/mane_core.dart';

import '../models/reminder.dart';
import 'app_database.dart';

/// The single read/write seam for the planner.
///
/// UI and, later, the LAN server and MCP adapter call this instead of touching
/// Drift directly. That keeps the agent-facing tools on the same rules as the
/// screens.
class PlannerRepository {
  PlannerRepository(this._database);

  final AppDatabase _database;

  Stream<List<Space>> watchSpaces() => _database.watchSpaces();

  Stream<List<Tag>> watchTags() => _database.watchTags();

  Future<void> saveTag(Tag tag) => _database.saveTag(tag);

  Future<void> deleteTag(String id) => _database.softDeleteTag(id);

  Future<Map<String, String>> readSettings() => _database.readSettings();

  Future<void> writeSetting(String key, String value) => _database.writeSetting(key, value);

  /// Entries whose viewer-local date falls between [start] and [end].
  Stream<List<EntryOccurrence>> watchEntries(LocalDate start, LocalDate end, String viewerTimeZone) =>
      _database.watchEntriesBetween(start, end, viewerTimeZone);

  Future<List<EntryOccurrence>> loadEntries(LocalDate start, LocalDate end, String viewerTimeZone) =>
      _database.loadEntriesBetween(start, end, viewerTimeZone);

  /// Shifts whose viewer-local date falls between [start] and [end].
  Stream<List<ShiftOccurrence>> watchShifts(LocalDate start, LocalDate end, String viewerTimeZone) =>
      _database.watchShiftsBetween(start, end, viewerTimeZone);

  Stream<List<ShiftPattern>> watchShiftPatterns() => _database.watchShiftPatterns();

  Future<void> saveEntry(Entry entry) => _database.saveEntry(entry);

  Future<Entry?> readEntry(String id) => _database.readEntry(id);

  Future<List<Reminder>> readRemindersForEntry(String entryId) => _database.readRemindersForEntry(entryId);

  Future<Map<String, List<Reminder>>> readAllReminders() => _database.readAllReminders();

  Future<void> saveRemindersForEntry(String entryId, List<Reminder> reminders) =>
      _database.saveRemindersForEntry(entryId, reminders);

  Future<void> setEntryStatus(String id, EntryStatus status) => _database.setEntryStatus(id, status);

  Future<void> setOccurrenceCompleted(String entryId, LocalDate date, bool completed) =>
      _database.setOccurrenceCompleted(entryId, date, completed: completed);

  Future<void> deleteEntry(String id) => _database.softDeleteEntry(id);

  Future<void> saveShiftPattern(ShiftPattern pattern) => _database.saveShiftPattern(pattern);

  Future<void> deleteShiftPattern(String id) => _database.softDeleteShiftPattern(id);
}

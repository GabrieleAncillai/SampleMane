import 'package:mane_core/mane_core.dart';

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

  /// Entries whose viewer-local date falls between [start] and [end].
  Stream<List<EntryOccurrence>> watchEntries(LocalDate start, LocalDate end, String viewerTimeZone) =>
      _database.watchEntriesBetween(start, end, viewerTimeZone);

  /// Shifts whose viewer-local date falls between [start] and [end].
  Stream<List<ShiftOccurrence>> watchShifts(LocalDate start, LocalDate end, String viewerTimeZone) =>
      _database.watchShiftsBetween(start, end, viewerTimeZone);

  Future<void> saveEntry(Entry entry) => _database.saveEntry(entry);

  Future<void> setEntryStatus(String id, EntryStatus status) => _database.setEntryStatus(id, status);

  Future<void> setOccurrenceCompleted(String entryId, LocalDate date, bool completed) =>
      _database.setOccurrenceCompleted(entryId, date, completed: completed);

  Future<void> deleteEntry(String id) => _database.softDeleteEntry(id);

  Future<void> saveShiftPattern(ShiftPattern pattern) => _database.saveShiftPattern(pattern);

  Future<void> deleteShiftPattern(String id) => _database.softDeleteShiftPattern(id);
}

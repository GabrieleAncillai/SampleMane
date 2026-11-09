import 'package:mane_core/mane_core.dart';

import '../models/home_item.dart';
import '../models/local_identity.dart';
import '../models/paired_device.dart';
import '../models/reminder.dart';
import '../models/search_results.dart';
import '../models/shift_checklist.dart';
import '../models/shopping_item.dart';
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

  Stream<List<HomeItem>> watchHomeItems() => _database.watchHomeItems();

  Future<void> saveHomeItem(HomeItem item) => _database.saveHomeItem(item);

  Future<void> archiveHomeItem(String id) => _database.archiveHomeItem(id);

  Stream<List<ShoppingItem>> watchShoppingItems() => _database.watchShoppingItems();

  Future<void> saveShoppingItem(ShoppingItem item) => _database.saveShoppingItem(item);

  Future<void> deleteShoppingItem(String id) => _database.deleteShoppingItem(id);

  Future<void> setShoppingChecked(String id, bool checked) => _database.setShoppingChecked(id, checked);

  Future<List<ShiftChecklistItem>> readShiftChecklistItems(String patternId) =>
      _database.readShiftChecklistItems(patternId);

  Future<void> saveShiftChecklistItems(String patternId, List<ShiftChecklistItem> items) =>
      _database.saveShiftChecklistItems(patternId, items);

  Future<Set<String>> readShiftChecklistCompletions(String patternId, LocalDate date) =>
      _database.readShiftChecklistCompletions(patternId, date);

  Future<void> setShiftChecklistCompleted(String itemId, LocalDate date, bool completed) =>
      _database.setShiftChecklistCompleted(itemId, date, completed: completed);

  Future<bool> hasImportedEntry(String source, String externalId) =>
      _database.hasImportedEntry(source, externalId);

  Future<LocalDate?> completeMaintenanceEntry(String id, LocalDate completionDate) =>
      _database.completeMaintenanceEntry(id, completionDate);

  Future<Map<String, String>> readSettings() => _database.readSettings();

  Future<LocalIdentity?> readIdentity() => _database.readIdentity();

  Future<void> saveIdentity(LocalIdentity identity) => _database.saveIdentity(identity);

  Stream<List<PairedDevice>> watchPairedDevices() => _database.watchPairedDevices();

  Future<List<PairedDevice>> readPairedDevices() => _database.readPairedDevices();

  Future<void> savePairedDevice(PairedDevice device) => _database.savePairedDevice(device);

  Future<void> removePairedDevice(String id) => _database.removePairedDevice(id);

  Future<void> updatePairedDevicePresence(
    String id, {
    required String host,
    required int port,
    required DateTime seenAt,
  }) => _database.updatePairedDevicePresence(id, host: host, port: port, seenAt: seenAt);

  Future<void> writeSetting(String key, String value) => _database.writeSetting(key, value);

  /// Entries whose viewer-local date falls between [start] and [end].
  Stream<List<EntryOccurrence>> watchEntries(LocalDate start, LocalDate end, String viewerTimeZone) =>
      _database.watchEntriesBetween(start, end, viewerTimeZone);

  Future<List<EntryOccurrence>> loadEntries(LocalDate start, LocalDate end, String viewerTimeZone) =>
      _database.loadEntriesBetween(start, end, viewerTimeZone);

  Future<SearchResults> search(String query) => _database.search(query);

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

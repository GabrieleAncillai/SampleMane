import 'package:mane_core/mane_core.dart';

import '../../models/home_item.dart';
import '../../models/shopping_item.dart';
import '../../services/planner_repository.dart';

/// Wire formats shared by the LAN query endpoint and the MCP adapter.
abstract final class SyncPayloads {
  static Map<String, Object?> spaceJson(Space space) => {
    'id': space.id,
    'name': space.name,
    'color': space.colorValue,
    'position': space.position,
  };

  static Map<String, Object?> tagJson(Tag tag) => {
    'id': tag.id,
    'spaceId': tag.spaceId,
    'name': tag.name,
    'color': tag.colorValue,
    'position': tag.position,
  };

  static Map<String, Object?> entryJson(Entry entry) => {
    'id': entry.id,
    'spaceId': entry.spaceId,
    'title': entry.title,
    'notes': entry.notes,
    'kind': entry.kind.name,
    'date': entry.date?.iso,
    'endDate': entry.endDate?.iso,
    'startMinute': entry.startMinute,
    'endMinute': entry.endMinute,
    'timeZone': entry.timeZone,
    'startAt': entry.startAt?.toIso8601String(),
    'endAt': entry.endAt?.toIso8601String(),
    'allDay': entry.allDay,
    'status': entry.status.name,
    'recurrence': entry.recurrence?.toJson(),
    'source': entry.source,
    'externalId': entry.externalId,
    'readOnly': entry.readOnly,
    'lastCompletedAt': entry.lastCompletedAt?.toIso8601String(),
    'repeatAfterCompletionDays': entry.repeatAfterCompletionDays,
    'tagIds': entry.tagIds.toList()..sort(),
  };

  static Map<String, Object?> occurrenceJson(EntryOccurrence occurrence) => {
    'date': occurrence.date.iso,
    'displayDate': occurrence.displayDate.iso,
    'completed': occurrence.completed,
    'startAt': occurrence.startAt?.toIso8601String(),
    'endAt': occurrence.endAt?.toIso8601String(),
    'entry': entryJson(occurrence.entry),
  };

  static Map<String, Object?> shiftJson(ShiftOccurrence occurrence) => {
    'date': occurrence.date.iso,
    'displayDate': occurrence.displayDate.iso,
    'patternId': occurrence.pattern.id,
    'patternName': occurrence.pattern.name,
    'label': occurrence.slot.label,
    'startAt': occurrence.startAt.toIso8601String(),
    'endAt': occurrence.endAt.toIso8601String(),
  };

  static Map<String, Object?> homeItemJson(HomeItem item) => {
    'id': item.id,
    'name': item.name,
    'category': item.category,
    'location': item.location,
    'quantity': item.quantity,
    'unit': item.unit,
    'reorderLevel': item.reorderLevel,
    'notes': item.notes,
    'lastPurchasedAt': item.lastPurchasedAt?.toIso8601String(),
    'lowStock': item.isLowStock,
  };

  static Map<String, Object?> shoppingItemJson(ShoppingItem item) => {
    'id': item.id,
    'name': item.name,
    'quantity': item.quantity,
    'unit': item.unit,
    'checked': item.checked,
    'note': item.note,
    'homeItemId': item.homeItemId,
  };

  static Future<Map<String, Object?>> summary({
    required PlannerRepository repository,
    required DateTime now,
    required String timeZone,
  }) async {
    final today = localDateAt(now, timeZone);
    final entries = await repository.loadEntries(today, today, timeZone);
    final shifts = await repository.watchShifts(today, today, timeZone).first;
    final upcoming = await repository.watchShifts(today, today.addDays(30), timeZone).first;
    final openShopping = (await repository.watchShoppingItems().first).where((item) => !item.checked).length;

    final next = upcoming.where((shift) => shift.startAt.isAfter(now)).toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));

    return {
      'date': today.iso,
      'generatedAt': now.toUtc().toIso8601String(),
      'today': {
        'entries': [for (final occurrence in entries) occurrenceJson(occurrence)],
        'shifts': [for (final shift in shifts) shiftJson(shift)],
      },
      'nextShifts': [for (final shift in next.take(5)) shiftJson(shift)],
      'openShopping': openShopping,
    };
  }

  /// A richer read-only snapshot for the Devices page. It keeps the compact
  /// summary keys and adds the next week of entries and shifts plus the tag,
  /// space, inventory and shopping lists. Nothing here is written locally.
  static Future<Map<String, Object?>> fullSnapshot({
    required PlannerRepository repository,
    required DateTime now,
    required String timeZone,
  }) async {
    final base = await summary(repository: repository, now: now, timeZone: timeZone);
    final today = localDateAt(now, timeZone);
    final end = today.addDays(7);
    final entries = await repository.loadEntries(today, end, timeZone);
    final shifts = await repository.watchShifts(today, end, timeZone).first;
    final spaces = await repository.watchSpaces().first;
    final tags = await repository.watchTags().first;
    final home = await repository.watchHomeItems().first;
    final shopping = await repository.watchShoppingItems().first;

    return {
      ...base,
      'range': {'start': today.iso, 'end': end.iso},
      'spaces': [for (final space in spaces) spaceJson(space)],
      'tags': [for (final tag in tags) tagJson(tag)],
      'entries': [for (final occurrence in entries) occurrenceJson(occurrence)],
      'shifts': [for (final shift in shifts) shiftJson(shift)],
      'home': [for (final item in home) homeItemJson(item)],
      'shopping': [for (final item in shopping) shoppingItemJson(item)],
    };
  }
}

import 'dart:convert';

import 'package:drift/drift.dart';

import '../../services/app_database.dart';

class BackupFormatException implements Exception {
  const BackupFormatException(this.message);

  final String message;

  @override
  String toString() => 'BackupFormatException: $message';
}

class BackupVersionException implements Exception {
  const BackupVersionException(this.version);

  final int version;

  @override
  String toString() => 'BackupVersionException: $version';
}

/// Versioned JSON export and a transactional, validated import.
///
/// The export is a readable document rather than a database copy: identifiers,
/// timestamps, IANA zones, recurrence rules and soft deletes are preserved so
/// a round trip is lossless.
class BackupService {
  BackupService(this._database);

  static const appTag = 'mane';
  static const currentSchemaVersion = 5;

  final AppDatabase _database;

  Future<String> exportJson() async {
    final spaces = await _database.select(_database.spaceRecords).get();
    final tags = await _database.select(_database.tagRecords).get();
    final entries = await _database.select(_database.entryRecords).get();
    final entryTags = await _database.select(_database.entryTagRecords).get();
    final completions = await _database.select(_database.completionRecords).get();
    final reminders = await _database.select(_database.reminderRecords).get();
    final patterns = await _database.select(_database.shiftPatternRecords).get();
    final slots = await _database.select(_database.shiftSlotRecords).get();
    final exceptions = await _database.select(_database.shiftExceptionRecords).get();
    final checklistItems = await _database.select(_database.shiftChecklistItemRecords).get();
    final checklistCompletions = await _database.select(_database.shiftChecklistCompletionRecords).get();
    final homeItems = await _database.select(_database.homeItemRecords).get();
    final shoppingItems = await _database.select(_database.shoppingItemRecords).get();
    final settings = await _database.select(_database.settingRecords).get();

    spaces.sort((a, b) {
      final byPosition = a.position.compareTo(b.position);
      return byPosition != 0 ? byPosition : a.id.compareTo(b.id);
    });
    tags.sort((a, b) => a.id.compareTo(b.id));
    entries.sort((a, b) => a.id.compareTo(b.id));
    entryTags.sort((a, b) {
      final byEntry = a.entryId.compareTo(b.entryId);
      return byEntry != 0 ? byEntry : a.tagId.compareTo(b.tagId);
    });
    completions.sort((a, b) {
      final byEntry = a.entryId.compareTo(b.entryId);
      return byEntry != 0 ? byEntry : a.dateKey.compareTo(b.dateKey);
    });
    reminders.sort((a, b) => a.id.compareTo(b.id));
    patterns.sort((a, b) => a.id.compareTo(b.id));
    slots.sort((a, b) => a.id.compareTo(b.id));
    exceptions.sort((a, b) => a.id.compareTo(b.id));
    checklistItems.sort((a, b) {
      final byPattern = a.patternId.compareTo(b.patternId);
      return byPattern != 0 ? byPattern : a.position.compareTo(b.position);
    });
    checklistCompletions.sort((a, b) {
      final byItem = a.itemId.compareTo(b.itemId);
      return byItem != 0 ? byItem : a.dateKey.compareTo(b.dateKey);
    });
    homeItems.sort((a, b) => a.id.compareTo(b.id));
    shoppingItems.sort((a, b) => a.id.compareTo(b.id));
    settings.sort((a, b) => a.key.compareTo(b.key));

    final payload = <String, Object?>{
      'app': appTag,
      'schemaVersion': currentSchemaVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'spaces': [
        for (final row in spaces)
          {
            'id': row.id,
            'name': row.name,
            'color': row.color,
            'position': row.position,
            'createdAt': _date(row.createdAt),
            'updatedAt': _date(row.updatedAt),
            'deletedAt': _nullableDate(row.deletedAt),
          },
      ],
      'tags': [
        for (final row in tags)
          {
            'id': row.id,
            'spaceId': row.spaceId,
            'name': row.name,
            'color': row.color,
            'position': row.position,
            'createdAt': _date(row.createdAt),
            'updatedAt': _date(row.updatedAt),
            'deletedAt': _nullableDate(row.deletedAt),
          },
      ],
      'entries': [
        for (final row in entries)
          {
            'id': row.id,
            'spaceId': row.spaceId,
            'title': row.title,
            'notes': row.notes,
            'kind': row.kind,
            'dateKey': row.dateKey,
            'endDateKey': row.endDateKey,
            'startMinute': row.startMinute,
            'endMinute': row.endMinute,
            'timeZone': row.timeZone,
            'startAt': _nullableDate(row.startAt),
            'endAt': _nullableDate(row.endAt),
            'allDay': row.allDay,
            'status': row.status,
            'recurrenceJson': row.recurrenceJson,
            'source': row.source,
            'externalId': row.externalId,
            'readOnly': row.readOnly,
            'lastCompletedAt': _nullableDate(row.lastCompletedAt),
            'repeatAfterCompletionDays': row.repeatAfterCompletionDays,
            'createdAt': _date(row.createdAt),
            'updatedAt': _date(row.updatedAt),
            'deletedAt': _nullableDate(row.deletedAt),
          },
      ],
      'entryTags': [
        for (final row in entryTags) {'entryId': row.entryId, 'tagId': row.tagId},
      ],
      'completions': [
        for (final row in completions)
          {'entryId': row.entryId, 'dateKey': row.dateKey, 'createdAt': _date(row.createdAt)},
      ],
      'reminders': [
        for (final row in reminders)
          {'id': row.id, 'entryId': row.entryId, 'offsetMinutes': row.offsetMinutes, 'enabled': row.enabled},
      ],
      'shiftPatterns': [
        for (final row in patterns)
          {
            'id': row.id,
            'spaceId': row.spaceId,
            'name': row.name,
            'timeZone': row.timeZone,
            'cycleDays': row.cycleDays,
            'anchorDateKey': row.anchorDateKey,
            'enabled': row.enabled,
            'createdAt': _date(row.createdAt),
            'updatedAt': _date(row.updatedAt),
            'deletedAt': _nullableDate(row.deletedAt),
          },
      ],
      'shiftSlots': [
        for (final row in slots)
          {
            'id': row.id,
            'patternId': row.patternId,
            'dayIndex': row.dayIndex,
            'label': row.label,
            'startMinute': row.startMinute,
            'endMinute': row.endMinute,
          },
      ],
      'shiftExceptions': [
        for (final row in exceptions)
          {
            'id': row.id,
            'patternId': row.patternId,
            'dateKey': row.dateKey,
            'type': row.type,
            'startMinute': row.startMinute,
            'endMinute': row.endMinute,
            'note': row.note,
          },
      ],
      'shiftChecklistItems': [
        for (final row in checklistItems)
          {'id': row.id, 'patternId': row.patternId, 'label': row.label, 'position': row.position},
      ],
      'shiftChecklistCompletions': [
        for (final row in checklistCompletions)
          {'itemId': row.itemId, 'dateKey': row.dateKey, 'createdAt': _date(row.createdAt)},
      ],
      'homeItems': [
        for (final row in homeItems)
          {
            'id': row.id,
            'name': row.name,
            'category': row.category,
            'location': row.location,
            'quantity': row.quantity,
            'reorderLevel': row.reorderLevel,
            'unit': row.unit,
            'notes': row.notes,
            'lastPurchasedAt': _nullableDate(row.lastPurchasedAt),
            'createdAt': _date(row.createdAt),
            'updatedAt': _date(row.updatedAt),
            'deletedAt': _nullableDate(row.deletedAt),
          },
      ],
      'shoppingItems': [
        for (final row in shoppingItems)
          {
            'id': row.id,
            'name': row.name,
            'quantity': row.quantity,
            'unit': row.unit,
            'checked': row.checked,
            'note': row.note,
            'homeItemId': row.homeItemId,
            'createdAt': _date(row.createdAt),
            'updatedAt': _date(row.updatedAt),
            'deletedAt': _nullableDate(row.deletedAt),
          },
      ],
      'settings': {for (final row in settings) row.key: row.value},
    };

    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  Future<void> importJson(String source) async {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException {
      throw const BackupFormatException('Not valid JSON');
    }
    if (decoded is! Map) throw const BackupFormatException('Root is not an object');
    final payload = Map<String, Object?>.from(decoded);

    if (payload['app'] != appTag) throw const BackupFormatException('Not a Mane backup');
    final version = payload['schemaVersion'];
    if (version is! int) throw const BackupFormatException('Missing schema version');
    if (version > currentSchemaVersion) throw BackupVersionException(version);
    if (version != currentSchemaVersion) {
      throw BackupFormatException('Unsupported schema version $version');
    }

    final spaces = _maps(payload, 'spaces');
    final tags = _maps(payload, 'tags');
    final entries = _maps(payload, 'entries');
    final entryTags = _maps(payload, 'entryTags');
    final completions = _maps(payload, 'completions');
    final reminders = _maps(payload, 'reminders');
    final patterns = _maps(payload, 'shiftPatterns');
    final slots = _maps(payload, 'shiftSlots');
    final exceptions = _maps(payload, 'shiftExceptions');
    final checklistItems = _maps(payload, 'shiftChecklistItems');
    final checklistCompletions = _maps(payload, 'shiftChecklistCompletions');
    final homeItems = _maps(payload, 'homeItems');
    final shoppingItems = _maps(payload, 'shoppingItems');
    final settings = _map(payload, 'settings');

    await _database.transaction(() async {
      await _database.delete(_database.shiftChecklistCompletionRecords).go();
      await _database.delete(_database.shiftChecklistItemRecords).go();
      await _database.delete(_database.shoppingItemRecords).go();
      await _database.delete(_database.homeItemRecords).go();
      await _database.delete(_database.entryTagRecords).go();
      await _database.delete(_database.completionRecords).go();
      await _database.delete(_database.reminderRecords).go();
      await _database.delete(_database.shiftSlotRecords).go();
      await _database.delete(_database.shiftExceptionRecords).go();
      await _database.delete(_database.entryRecords).go();
      await _database.delete(_database.shiftPatternRecords).go();
      await _database.delete(_database.tagRecords).go();
      await _database.delete(_database.spaceRecords).go();
      await _database.delete(_database.settingRecords).go();

      for (final row in spaces) {
        await _database
            .into(_database.spaceRecords)
            .insert(
              SpaceRecordsCompanion(
                id: Value(_string(row, 'id')),
                name: Value(_string(row, 'name')),
                color: Value(_integer(row, 'color')),
                position: Value(_integer(row, 'position')),
                createdAt: Value(_dateTime(row, 'createdAt')),
                updatedAt: Value(_dateTime(row, 'updatedAt')),
                deletedAt: Value(_optionalDateTime(row, 'deletedAt')),
              ),
            );
      }

      for (final row in tags) {
        await _database
            .into(_database.tagRecords)
            .insert(
              TagRecordsCompanion(
                id: Value(_string(row, 'id')),
                spaceId: Value(_optionalString(row, 'spaceId')),
                name: Value(_string(row, 'name')),
                color: Value(_integer(row, 'color')),
                position: Value(_integer(row, 'position')),
                createdAt: Value(_dateTime(row, 'createdAt')),
                updatedAt: Value(_dateTime(row, 'updatedAt')),
                deletedAt: Value(_optionalDateTime(row, 'deletedAt')),
              ),
            );
      }

      for (final row in homeItems) {
        await _database
            .into(_database.homeItemRecords)
            .insert(
              HomeItemRecordsCompanion(
                id: Value(_string(row, 'id')),
                name: Value(_string(row, 'name')),
                category: Value(_string(row, 'category')),
                location: Value(_string(row, 'location')),
                quantity: Value(_number(row, 'quantity')),
                reorderLevel: Value(_optionalNumber(row, 'reorderLevel')),
                unit: Value(_string(row, 'unit')),
                notes: Value(_string(row, 'notes')),
                lastPurchasedAt: Value(_optionalDateTime(row, 'lastPurchasedAt')),
                createdAt: Value(_dateTime(row, 'createdAt')),
                updatedAt: Value(_dateTime(row, 'updatedAt')),
                deletedAt: Value(_optionalDateTime(row, 'deletedAt')),
              ),
            );
      }

      for (final row in shoppingItems) {
        await _database
            .into(_database.shoppingItemRecords)
            .insert(
              ShoppingItemRecordsCompanion(
                id: Value(_string(row, 'id')),
                name: Value(_string(row, 'name')),
                quantity: Value(_number(row, 'quantity')),
                unit: Value(_string(row, 'unit')),
                checked: Value(_boolean(row, 'checked')),
                note: Value(_string(row, 'note')),
                homeItemId: Value(_optionalString(row, 'homeItemId')),
                createdAt: Value(_dateTime(row, 'createdAt')),
                updatedAt: Value(_dateTime(row, 'updatedAt')),
                deletedAt: Value(_optionalDateTime(row, 'deletedAt')),
              ),
            );
      }

      for (final row in entries) {
        await _database
            .into(_database.entryRecords)
            .insert(
              EntryRecordsCompanion(
                id: Value(_string(row, 'id')),
                spaceId: Value(_string(row, 'spaceId')),
                title: Value(_string(row, 'title')),
                notes: Value(_string(row, 'notes')),
                kind: Value(_string(row, 'kind')),
                dateKey: Value(_optionalInteger(row, 'dateKey')),
                endDateKey: Value(_optionalInteger(row, 'endDateKey')),
                startMinute: Value(_optionalInteger(row, 'startMinute')),
                endMinute: Value(_optionalInteger(row, 'endMinute')),
                timeZone: Value(_optionalString(row, 'timeZone')),
                startAt: Value(_optionalDateTime(row, 'startAt')),
                endAt: Value(_optionalDateTime(row, 'endAt')),
                allDay: Value(_boolean(row, 'allDay')),
                status: Value(_string(row, 'status')),
                recurrenceJson: Value(_optionalString(row, 'recurrenceJson')),
                source: Value(_optionalString(row, 'source')),
                externalId: Value(_optionalString(row, 'externalId')),
                readOnly: Value(_boolean(row, 'readOnly')),
                lastCompletedAt: Value(_optionalDateTime(row, 'lastCompletedAt')),
                repeatAfterCompletionDays: Value(_optionalInteger(row, 'repeatAfterCompletionDays')),
                createdAt: Value(_dateTime(row, 'createdAt')),
                updatedAt: Value(_dateTime(row, 'updatedAt')),
                deletedAt: Value(_optionalDateTime(row, 'deletedAt')),
              ),
            );
      }

      for (final row in entryTags) {
        await _database
            .into(_database.entryTagRecords)
            .insert(
              EntryTagRecordsCompanion.insert(entryId: _string(row, 'entryId'), tagId: _string(row, 'tagId')),
              mode: InsertMode.insertOrIgnore,
            );
      }

      for (final row in completions) {
        await _database
            .into(_database.completionRecords)
            .insert(
              CompletionRecordsCompanion.insert(
                entryId: _string(row, 'entryId'),
                dateKey: _integer(row, 'dateKey'),
                createdAt: _dateTime(row, 'createdAt'),
              ),
            );
      }

      for (final row in reminders) {
        await _database
            .into(_database.reminderRecords)
            .insert(
              ReminderRecordsCompanion.insert(
                id: _string(row, 'id'),
                entryId: _string(row, 'entryId'),
                offsetMinutes: _integer(row, 'offsetMinutes'),
                enabled: Value(_boolean(row, 'enabled')),
              ),
            );
      }

      for (final row in patterns) {
        await _database
            .into(_database.shiftPatternRecords)
            .insert(
              ShiftPatternRecordsCompanion(
                id: Value(_string(row, 'id')),
                spaceId: Value(_string(row, 'spaceId')),
                name: Value(_string(row, 'name')),
                timeZone: Value(_string(row, 'timeZone')),
                cycleDays: Value(_integer(row, 'cycleDays')),
                anchorDateKey: Value(_integer(row, 'anchorDateKey')),
                enabled: Value(_boolean(row, 'enabled')),
                createdAt: Value(_dateTime(row, 'createdAt')),
                updatedAt: Value(_dateTime(row, 'updatedAt')),
                deletedAt: Value(_optionalDateTime(row, 'deletedAt')),
              ),
            );
      }

      for (final row in slots) {
        await _database
            .into(_database.shiftSlotRecords)
            .insert(
              ShiftSlotRecordsCompanion(
                id: Value(_integer(row, 'id')),
                patternId: Value(_string(row, 'patternId')),
                dayIndex: Value(_integer(row, 'dayIndex')),
                label: Value(_string(row, 'label')),
                startMinute: Value(_integer(row, 'startMinute')),
                endMinute: Value(_integer(row, 'endMinute')),
              ),
            );
      }

      for (final row in exceptions) {
        await _database
            .into(_database.shiftExceptionRecords)
            .insert(
              ShiftExceptionRecordsCompanion(
                id: Value(_integer(row, 'id')),
                patternId: Value(_string(row, 'patternId')),
                dateKey: Value(_integer(row, 'dateKey')),
                type: Value(_string(row, 'type')),
                startMinute: Value(_optionalInteger(row, 'startMinute')),
                endMinute: Value(_optionalInteger(row, 'endMinute')),
                note: Value(_string(row, 'note')),
              ),
            );
      }

      for (final row in checklistItems) {
        await _database
            .into(_database.shiftChecklistItemRecords)
            .insert(
              ShiftChecklistItemRecordsCompanion(
                id: Value(_string(row, 'id')),
                patternId: Value(_string(row, 'patternId')),
                label: Value(_string(row, 'label')),
                position: Value(_integer(row, 'position')),
              ),
            );
      }

      for (final row in checklistCompletions) {
        await _database
            .into(_database.shiftChecklistCompletionRecords)
            .insert(
              ShiftChecklistCompletionRecordsCompanion.insert(
                itemId: _string(row, 'itemId'),
                dateKey: _integer(row, 'dateKey'),
                createdAt: _dateTime(row, 'createdAt'),
              ),
            );
      }

      for (final entry in settings.entries) {
        await _database
            .into(_database.settingRecords)
            .insert(SettingRecordsCompanion.insert(key: entry.key, value: '${entry.value}'));
      }
    });
  }

  static String _date(DateTime value) => value.toUtc().toIso8601String();

  static String? _nullableDate(DateTime? value) => value?.toUtc().toIso8601String();

  static List<Map<String, Object?>> _maps(Map<String, Object?> payload, String key) {
    final value = payload[key];
    if (value is! List) throw BackupFormatException('$key is not a list');
    return [
      for (final row in value)
        if (row is Map)
          Map<String, Object?>.from(row)
        else
          throw BackupFormatException('$key contains a non-object'),
    ];
  }

  static Map<String, Object?> _map(Map<String, Object?> payload, String key) {
    final value = payload[key];
    if (value is! Map) throw BackupFormatException('$key is not an object');
    return Map<String, Object?>.from(value);
  }

  static String _string(Map<String, Object?> row, String key) {
    final value = row[key];
    if (value is String) return value;
    throw BackupFormatException('$key is not a string');
  }

  static String? _optionalString(Map<String, Object?> row, String key) {
    final value = row[key];
    if (value == null) return null;
    if (value is String) return value;
    throw BackupFormatException('$key is not a string');
  }

  static int _integer(Map<String, Object?> row, String key) {
    final value = row[key];
    if (value is int) return value;
    if (value is num && value == value.roundToDouble()) return value.toInt();
    throw BackupFormatException('$key is not an integer');
  }

  static int? _optionalInteger(Map<String, Object?> row, String key) {
    if (row[key] == null) return null;
    return _integer(row, key);
  }

  static double _number(Map<String, Object?> row, String key) {
    final value = row[key];
    if (value is num) return value.toDouble();
    throw BackupFormatException('$key is not a number');
  }

  static double? _optionalNumber(Map<String, Object?> row, String key) {
    if (row[key] == null) return null;
    return _number(row, key);
  }

  static bool _boolean(Map<String, Object?> row, String key) {
    final value = row[key];
    if (value is bool) return value;
    throw BackupFormatException('$key is not a boolean');
  }

  static DateTime _dateTime(Map<String, Object?> row, String key) {
    final value = _string(row, key);
    final parsed = DateTime.tryParse(value);
    if (parsed == null) throw BackupFormatException('$key is not a date');
    return parsed.toUtc();
  }

  static DateTime? _optionalDateTime(Map<String, Object?> row, String key) {
    if (row[key] == null) return null;
    return _dateTime(row, key);
  }
}

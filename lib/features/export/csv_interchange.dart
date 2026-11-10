import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mane_core/mane_core.dart';
import 'package:uuid/uuid.dart';

import '../../models/home_item.dart';
import '../../models/shopping_item.dart';
import '../../services/planner_repository.dart';

class CsvImportReport {
  const CsvImportReport({required this.imported, required this.duplicates, required this.skipped});

  final int imported;
  final int duplicates;
  final int skipped;
}

/// RFC 4180-ish CSV with a documented, human-readable column set for entries,
/// shopping and household inventory. No network, no hidden state.
class CsvInterchangeService {
  CsvInterchangeService(this._repository);

  static const entryColumns = [
    'title',
    'space',
    'kind',
    'allDay',
    'date',
    'endDate',
    'start',
    'end',
    'timeZone',
    'status',
    'recurrence',
    'tags',
    'notes',
  ];

  static const shoppingColumns = ['name', 'quantity', 'unit', 'checked', 'note', 'homeItem'];
  static const inventoryColumns = [
    'name',
    'category',
    'location',
    'quantity',
    'unit',
    'reorderLevel',
    'notes',
    'lastPurchased',
  ];

  final PlannerRepository _repository;

  Future<String> exportEntries({
    required LocalDate start,
    required LocalDate end,
    required String viewerTimeZone,
  }) async {
    final spaces = await _repository.watchSpaces().first;
    final tags = await _repository.watchTags().first;
    final spacesById = {for (final space in spaces) space.id: space.name};
    final tagsById = {for (final tag in tags) tag.id: tag.name};
    final occurrences = await _repository.loadEntries(start, end, viewerTimeZone);
    final seen = <String>{};
    final rows = <List<String>>[];
    for (final occurrence in occurrences) {
      final entry = occurrence.entry;
      if (!seen.add(entry.id)) continue;
      rows.add([
        entry.title,
        spacesById[entry.spaceId] ?? entry.spaceId,
        entry.kind.name,
        '${entry.allDay}',
        entry.date?.iso ?? '',
        _entryEndDate(entry),
        entry.startMinute == null ? '' : _formatMinute(entry.startMinute!),
        entry.endMinute == null ? '' : _formatMinute(entry.endMinute!),
        entry.timeZone ?? '',
        entry.status.name,
        entry.recurrence == null ? '' : jsonEncode(entry.recurrence!.toJson()),
        [for (final id in entry.tagIds) tagsById[id] ?? id].join(';'),
        entry.notes,
      ]);
    }
    return encodeCsv(entryColumns, rows);
  }

  Future<String> exportShopping() async {
    final homeItems = await _repository.watchHomeItems().first;
    final names = {for (final item in homeItems) item.id: item.name};
    final items = await _repository.watchShoppingItems().first;
    return encodeCsv(shoppingColumns, [
      for (final item in items)
        [
          item.name,
          _number(item.quantity),
          item.unit,
          '${item.checked}',
          item.note,
          names[item.homeItemId] ?? '',
        ],
    ]);
  }

  Future<String> exportInventory() async {
    final items = await _repository.watchHomeItems().first;
    return encodeCsv(inventoryColumns, [
      for (final item in items)
        [
          item.name,
          item.category,
          item.location,
          _number(item.quantity),
          item.unit,
          item.reorderLevel == null ? '' : _number(item.reorderLevel!),
          item.notes,
          item.lastPurchasedAt?.toUtc().toIso8601String() ?? '',
        ],
    ]);
  }

  Future<CsvImportReport> importEntries(String csv, {required String defaultTimeZone}) async {
    final table = decodeCsv(csv);
    if (table.isEmpty) return const CsvImportReport(imported: 0, duplicates: 0, skipped: 0);
    final header = _header(table.first);
    final spaces = await _repository.watchSpaces().first;
    final tags = await _repository.watchTags().first;
    final spacesByName = {for (final space in spaces) space.name.toLowerCase(): space};
    final tagsByName = {for (final tag in tags) tag.name.toLowerCase(): tag};
    final fallbackSpace = spaces.isEmpty ? 'personal' : spaces.first.id;

    var imported = 0;
    var duplicates = 0;
    var skipped = 0;
    for (final row in table.skip(1)) {
      final values = _rowMap(header, row);
      final title = values['title']?.trim() ?? '';
      final dateValue = values['date']?.trim() ?? '';
      if (title.isEmpty || dateValue.isEmpty) {
        skipped++;
        continue;
      }
      final date = _parseDate(dateValue);
      if (date == null) {
        skipped++;
        continue;
      }
      final allDayValue = values['allday']?.toLowerCase() == 'true';
      final spaceName = (values['space'] ?? '').trim().toLowerCase();
      final space = spacesByName[spaceName];
      final spaceId = space?.id ?? fallbackSpace;
      final startMinute = _parseMinute(values['start']);
      final rawEnd = _parseMinute(values['end']);
      final endDate = _parseDate(values['enddate']?.trim() ?? '');
      // A hand-edited row without times is a date, not a broken timed entry.
      final allDay = allDayValue || startMinute == null || rawEnd == null;
      var endMinute = rawEnd;
      if (!allDay && endMinute != null) {
        final dayOffset = endDate == null ? 0 : endDate.differenceInDays(date);
        if (dayOffset > 0) endMinute += dayOffset * 24 * 60;
        if (endMinute <= startMinute) endMinute = startMinute + 60;
      }
      final kind = _enumByName(EntryKind.values, values['kind']) ?? EntryKind.task;
      final status = _enumByName(EntryStatus.values, values['status']) ?? EntryStatus.open;
      final timeZone = (values['timezone'] ?? '').trim();
      final recurrence = _parseRecurrence(values['recurrence'] ?? '');
      final tagIds = {
        for (final name in (values['tags'] ?? '').split(';'))
          if (tagsByName[name.trim().toLowerCase()] != null) tagsByName[name.trim().toLowerCase()]!.id,
      };

      final externalId = _entryFingerprint(
        title: title,
        spaceId: spaceId,
        date: date,
        allDay: allDay,
        startMinute: startMinute,
        endMinute: endMinute,
      );
      final storedStart = allDay ? null : startMinute;
      final storedEnd = allDay ? null : endMinute;
      if (await _repository.hasEntryLike(
        title: title,
        spaceId: spaceId,
        date: date,
        allDay: allDay,
        startMinute: storedStart,
        endMinute: storedEnd,
      )) {
        duplicates++;
        continue;
      }

      final now = DateTime.now();
      final entry = Entry(
        id: const Uuid().v4(),
        spaceId: spaceId,
        title: title,
        notes: values['notes'] ?? '',
        kind: kind,
        date: date,
        endDate: allDay ? endDate : null,
        startMinute: allDay ? null : startMinute,
        endMinute: allDay ? null : endMinute,
        timeZone: allDay ? null : (timeZone.isEmpty ? defaultTimeZone : timeZone),
        tagIds: tagIds,
        allDay: allDay,
        status: status,
        recurrence: recurrence,
        source: 'csv',
        externalId: externalId,
        createdAt: now,
        updatedAt: now,
      );
      await _repository.saveEntry(entry);
      imported++;
    }
    return CsvImportReport(imported: imported, duplicates: duplicates, skipped: skipped);
  }

  Future<CsvImportReport> importShopping(String csv) async {
    final table = decodeCsv(csv);
    if (table.isEmpty) return const CsvImportReport(imported: 0, duplicates: 0, skipped: 0);
    final header = _header(table.first);
    final existing = await _repository.watchShoppingItems().first;
    final homeItems = await _repository.watchHomeItems().first;
    final homeByName = {for (final item in homeItems) item.name.toLowerCase(): item.id};
    final seen = {for (final item in existing) item.name.trim().toLowerCase()};
    var imported = 0;
    var duplicates = 0;
    var skipped = 0;
    var position = existing.length;
    for (final row in table.skip(1)) {
      final values = _rowMap(header, row);
      final name = values['name']?.trim() ?? '';
      if (name.isEmpty) {
        skipped++;
        continue;
      }
      if (!seen.add(name.toLowerCase())) {
        duplicates++;
        continue;
      }
      final quantity = double.tryParse((values['quantity'] ?? '').trim()) ?? 1;
      final homeName = (values['homeitem'] ?? '').trim().toLowerCase();
      final homeId = homeName.isEmpty ? null : homeByName[homeName];
      await _repository.saveShoppingItem(
        ShoppingItem(
          id: const Uuid().v4(),
          name: name,
          quantity: quantity <= 0 ? 1 : quantity,
          unit: values['unit'] ?? '',
          checked: (values['checked'] ?? '').toLowerCase() == 'true',
          note: values['note'] ?? '',
          homeItemId: homeId,
          position: position++,
        ),
      );
      imported++;
    }
    return CsvImportReport(imported: imported, duplicates: duplicates, skipped: skipped);
  }

  Future<CsvImportReport> importInventory(String csv) async {
    final table = decodeCsv(csv);
    if (table.isEmpty) return const CsvImportReport(imported: 0, duplicates: 0, skipped: 0);
    final header = _header(table.first);
    final existing = await _repository.watchHomeItems().first;
    final seen = {for (final item in existing) item.name.trim().toLowerCase()};
    var imported = 0;
    var duplicates = 0;
    var skipped = 0;
    for (final row in table.skip(1)) {
      final values = _rowMap(header, row);
      final name = values['name']?.trim() ?? '';
      if (name.isEmpty) {
        skipped++;
        continue;
      }
      if (!seen.add(name.toLowerCase())) {
        duplicates++;
        continue;
      }
      final reorder = double.tryParse((values['reorderlevel'] ?? '').trim());
      await _repository.saveHomeItem(
        HomeItem(
          id: const Uuid().v4(),
          name: name,
          category: values['category'] ?? '',
          location: values['location'] ?? '',
          quantity: double.tryParse((values['quantity'] ?? '').trim()) ?? 0,
          unit: values['unit'] ?? '',
          reorderLevel: reorder,
          notes: values['notes'] ?? '',
          lastPurchasedAt: DateTime.tryParse((values['lastpurchased'] ?? '').trim()),
        ),
      );
      imported++;
    }
    return CsvImportReport(imported: imported, duplicates: duplicates, skipped: skipped);
  }

  static String encodeCsv(List<String> columns, List<List<String>> rows) {
    final buffer = StringBuffer()..writeln(columns.map(_escape).join(','));
    for (final row in rows) {
      buffer.writeln(row.map(_escape).join(','));
    }
    return buffer.toString();
  }

  /// Parses quoted fields, doubled quotes and CRLF line endings.
  static List<List<String>> decodeCsv(String source) {
    final rows = <List<String>>[];
    final row = <String>[];
    final field = StringBuffer();
    var quoted = false;
    for (var index = 0; index < source.length; index++) {
      final char = source[index];
      if (quoted) {
        if (char == '"') {
          if (index + 1 < source.length && source[index + 1] == '"') {
            field.write('"');
            index++;
          } else {
            quoted = false;
          }
        } else {
          field.write(char);
        }
        continue;
      }
      if (char == '"') {
        quoted = true;
      } else if (char == ',') {
        row.add(field.toString());
        field.clear();
      } else if (char == '\n') {
        row.add(field.toString());
        field.clear();
        if (row.any((value) => value.isNotEmpty)) rows.add(List.of(row));
        row.clear();
      } else if (char != '\r') {
        field.write(char);
      }
    }
    if (field.isNotEmpty || row.isNotEmpty) {
      row.add(field.toString());
      if (row.any((value) => value.isNotEmpty)) rows.add(row);
    }
    return rows;
  }

  static String _escape(String value) {
    if (!value.contains(RegExp('[,"\\n\\r]'))) return value;
    return '"${value.replaceAll('"', '""')}"';
  }

  static Map<String, String> _header(List<String> row) {
    final header = <String, String>{};
    for (var index = 0; index < row.length; index++) {
      header[row[index].trim().toLowerCase()] = '$index';
    }
    return header;
  }

  static Map<String, String> _rowMap(Map<String, String> header, List<String> row) {
    final values = <String, String>{};
    for (final entry in header.entries) {
      final index = int.tryParse(entry.value) ?? -1;
      if (index >= 0 && index < row.length) values[entry.key] = row[index];
    }
    return values;
  }

  static int? _parseMinute(String? value) {
    final clean = value?.trim() ?? '';
    if (clean.isEmpty) return null;
    final parts = clean.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return hour * 60 + minute;
  }

  static String _formatMinute(int value) {
    final hour = (value ~/ 60) % 24;
    final minute = value % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  static String _number(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : value.toString();

  static String _entryEndDate(Entry entry) {
    final date = entry.date;
    if (date == null) return '';
    if (entry.endDate != null) return entry.endDate!.iso;
    final endMinute = entry.endMinute;
    if (entry.allDay || endMinute == null || endMinute < 1440) return '';
    return date.addDays(endMinute ~/ 1440).iso;
  }

  static LocalDate? _parseDate(String value) {
    if (value.isEmpty) return null;
    try {
      return LocalDate.parse(value);
    } on FormatException {
      return null;
    }
  }

  static T? _enumByName<T extends Enum>(List<T> values, String? name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }

  static String _entryFingerprint({
    required String title,
    required String spaceId,
    required LocalDate date,
    required bool allDay,
    required int? startMinute,
    required int? endMinute,
  }) => sha1.convert(utf8.encode('$title|$spaceId|${date.iso}|$allDay|$startMinute|$endMinute')).toString();

  static RecurrenceRule? _parseRecurrence(String value) {
    final clean = value.trim();
    if (clean.isEmpty) return null;
    try {
      final decoded = jsonDecode(clean);
      if (decoded is Map) return RecurrenceRule.fromJson(Map<String, Object?>.from(decoded));
    } catch (_) {
      // A malformed recurrence must not make the whole CSV unimportable.
    }
    return null;
  }
}

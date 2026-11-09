import 'dart:convert';

import 'package:mane_core/mane_core.dart';
import 'package:uuid/uuid.dart';

import '../../services/planner_repository.dart';

class CompanionEvent {
  const CompanionEvent({
    required this.externalId,
    required this.title,
    required this.notes,
    required this.allDay,
    required this.date,
    this.startMinute,
    this.endMinute,
    this.timeZone,
  });

  final String externalId;
  final String title;
  final String notes;
  final bool allDay;
  final LocalDate date;
  final int? startMinute;
  final int? endMinute;
  final String? timeZone;
}

class CompanionSkip {
  const CompanionSkip({required this.title, required this.reason});

  final String title;
  final String reason;
}

class CompanionParseResult {
  const CompanionParseResult({required this.events, required this.skipped});

  final List<CompanionEvent> events;
  final List<CompanionSkip> skipped;
}

class CompanionFormatException implements Exception {
  const CompanionFormatException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Parses the small, documented companion export format:
///
/// ```json
/// {"app":"companion","events":[
///   {"id":"gym-1","title":"Gym","date":"2026-11-09",
///    "startMinute":1080,"endMinute":1140,"timeZone":"Europe/Madrid",
///    "notes":"Leg day"}
/// ]}
/// ```
///
/// `allDay` defaults to false. Invalid rows are reported instead of aborting
/// the whole file. No network, no ContentProvider permission and no background
/// service are involved: the user selects the file once.
CompanionParseResult parseCompanionExport(String source, {required String defaultTimeZone}) {
  if (!isKnownTimeZone(defaultTimeZone)) {
    throw ArgumentError.value(defaultTimeZone, 'defaultTimeZone', 'unknown IANA timezone');
  }
  final Object? decoded;
  try {
    decoded = jsonDecode(source);
  } on FormatException {
    throw const CompanionFormatException('This file is not valid JSON');
  }
  if (decoded is! Map || decoded['events'] is! List) {
    throw const CompanionFormatException('This file has no events list');
  }

  final events = <CompanionEvent>[];
  final skipped = <CompanionSkip>[];
  for (final raw in decoded['events'] as List) {
    if (raw is! Map) {
      skipped.add(const CompanionSkip(title: '', reason: 'Not an object'));
      continue;
    }
    final title = raw['title'];
    if (title is! String || title.trim().isEmpty) {
      skipped.add(const CompanionSkip(title: '', reason: 'Missing title'));
      continue;
    }
    final dateRaw = raw['date'];
    final LocalDate date;
    try {
      date = LocalDate.parse('$dateRaw');
    } on FormatException {
      skipped.add(CompanionSkip(title: title, reason: 'Invalid date'));
      continue;
    }

    final allDay = raw['allDay'] == true;
    final zone = allDay ? null : (raw['timeZone'] as String? ?? defaultTimeZone);
    if (zone != null && !isKnownTimeZone(zone)) {
      skipped.add(CompanionSkip(title: title, reason: 'Unknown timezone'));
      continue;
    }
    final startMinute = allDay ? null : raw['startMinute'];
    final endMinute = allDay ? null : raw['endMinute'];
    if (!allDay) {
      if (startMinute is! int ||
          endMinute is! int ||
          startMinute < 0 ||
          startMinute >= 1440 ||
          endMinute <= startMinute ||
          endMinute - startMinute > 1440) {
        skipped.add(CompanionSkip(title: title, reason: 'Invalid time range'));
        continue;
      }
    }

    final id = raw['id'] is String && (raw['id'] as String).trim().isNotEmpty
        ? 'id:${(raw['id'] as String).trim()}'
        : 'fallback:${date.key}:${startMinute ?? -1}:${title.trim()}';
    events.add(
      CompanionEvent(
        externalId: id,
        title: title.trim(),
        notes: raw['notes'] is String ? raw['notes'] as String : '',
        allDay: allDay,
        date: date,
        startMinute: startMinute as int?,
        endMinute: endMinute as int?,
        timeZone: zone,
      ),
    );
  }

  return CompanionParseResult(events: events, skipped: skipped);
}

class CompanionImportReport {
  const CompanionImportReport({required this.imported, required this.duplicates, required this.skipped});

  final int imported;
  final int duplicates;
  final List<CompanionSkip> skipped;
}

class CompanionImportService {
  CompanionImportService(this._repository, {DateTime Function()? clock, String Function()? idFactory})
    : _clock = clock ?? DateTime.now,
      _idFactory = idFactory ?? (() => const Uuid().v4());

  final PlannerRepository _repository;
  final DateTime Function() _clock;
  final String Function() _idFactory;

  static const source = 'companion';

  Future<CompanionImportReport> importText(
    String text, {
    required String spaceId,
    required String defaultTimeZone,
  }) async {
    final parsed = parseCompanionExport(text, defaultTimeZone: defaultTimeZone);
    var imported = 0;
    var duplicates = 0;
    for (final event in parsed.events) {
      if (await _repository.hasImportedEntry(source, event.externalId)) {
        duplicates++;
        continue;
      }
      final now = _clock().toUtc();
      await _repository.saveEntry(
        Entry(
          id: _idFactory(),
          spaceId: spaceId,
          title: event.title,
          notes: event.notes,
          kind: EntryKind.event,
          date: event.date,
          allDay: event.allDay,
          startMinute: event.startMinute,
          endMinute: event.endMinute,
          timeZone: event.timeZone,
          source: source,
          externalId: event.externalId,
          readOnly: true,
          createdAt: now,
          updatedAt: now,
        ),
      );
      imported++;
    }
    return CompanionImportReport(imported: imported, duplicates: duplicates, skipped: parsed.skipped);
  }
}

import 'dart:convert';

import 'package:mane_core/mane_core.dart';
import 'package:uuid/uuid.dart';

import '../../services/planner_repository.dart';
import 'ics_parser.dart';

class IcsImportReport {
  const IcsImportReport({
    required this.imported,
    required this.updated,
    required this.duplicates,
    required this.skipped,
  });

  final int imported;
  final int updated;
  final int duplicates;
  final List<IcsSkip> skipped;
}

/// Reads a local iCalendar file into read-only planner entries.
///
/// Re-importing the same file updates changed events, leaves unchanged rows
/// untouched and deduplicates by `source` plus `externalId`. UID is used when
/// present; otherwise a stable hash of the date, time and summary stands in.
class IcsImportService {
  IcsImportService(this._repository, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final PlannerRepository _repository;
  final DateTime Function() _clock;

  static const source = 'ics';

  Future<IcsImportReport> importText(
    String text, {
    required String spaceId,
    required String defaultTimeZone,
    required String fallbackTitle,
  }) async {
    final parsed = parseIcs(text, defaultTimeZone: defaultTimeZone);
    var imported = 0;
    var updated = 0;
    var duplicates = 0;

    for (final event in parsed.events) {
      final externalId = event.uid.trim().isNotEmpty
          ? 'uid:${event.uid.trim()}'
          : 'fallback:${event.date.key}:${event.startMinute ?? -1}:${event.summary}';
      final now = _clock().toUtc();
      final candidate = Entry(
        id: const Uuid().v4(),
        spaceId: spaceId,
        title: event.summary.trim().isEmpty ? fallbackTitle : event.summary.trim(),
        notes: event.description,
        kind: EntryKind.event,
        date: event.date,
        endDate: event.endDate,
        startMinute: event.startMinute,
        endMinute: event.endMinute,
        timeZone: event.timeZone,
        allDay: event.allDay,
        source: source,
        externalId: externalId,
        readOnly: true,
        recurrence: event.recurrence,
        createdAt: now,
        updatedAt: now,
        startAt: event.startAt,
        endAt: event.endAt,
      );

      final existing = await _repository.readImportedEntry(source, externalId);
      if (existing == null) {
        await _repository.saveEntry(candidate);
        imported++;
        continue;
      }
      if (_sameShape(existing, candidate)) {
        duplicates++;
        continue;
      }

      await _repository.saveEntry(
        Entry(
          id: existing.id,
          spaceId: spaceId,
          title: candidate.title,
          notes: candidate.notes,
          kind: EntryKind.event,
          date: candidate.date,
          endDate: candidate.endDate,
          startMinute: candidate.startMinute,
          endMinute: candidate.endMinute,
          timeZone: candidate.timeZone,
          allDay: candidate.allDay,
          source: source,
          externalId: externalId,
          readOnly: true,
          recurrence: candidate.recurrence,
          status: existing.status,
          createdAt: existing.createdAt,
          updatedAt: now,
          startAt: candidate.startAt,
          endAt: candidate.endAt,
        ),
      );
      updated++;
    }

    return IcsImportReport(
      imported: imported,
      updated: updated,
      duplicates: duplicates,
      skipped: parsed.skipped,
    );
  }

  static bool _sameShape(Entry a, Entry b) =>
      a.title == b.title &&
      a.notes == b.notes &&
      a.date == b.date &&
      a.endDate == b.endDate &&
      a.startMinute == b.startMinute &&
      a.endMinute == b.endMinute &&
      a.timeZone == b.timeZone &&
      a.allDay == b.allDay &&
      a.startAt == b.startAt &&
      a.endAt == b.endAt &&
      _recurrenceJson(a.recurrence) == _recurrenceJson(b.recurrence);

  static String _recurrenceJson(RecurrenceRule? rule) => rule == null ? '' : jsonEncode(rule.toJson());
}

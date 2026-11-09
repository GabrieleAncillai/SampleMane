import 'package:mane_core/mane_core.dart';
import 'package:uuid/uuid.dart';

import '../../services/planner_repository.dart';
import 'ics_parser.dart';

class IcsImportReport {
  const IcsImportReport({required this.imported, required this.duplicates, required this.skipped});

  final int imported;
  final int duplicates;
  final List<IcsSkip> skipped;
}

/// Reads a local iCalendar file into read-only planner entries.
///
/// The importer is deliberately stateless: re-importing the same file skips
/// rows already stored by `source` and `externalId`. UID is used when present;
/// otherwise a stable hash of the date, time and summary stands in for it.
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
    var duplicates = 0;

    for (final event in parsed.events) {
      final externalId = event.uid.trim().isNotEmpty
          ? 'uid:${event.uid.trim()}'
          : 'fallback:${event.date.key}:${event.startMinute ?? -1}:${event.summary}';
      if (await _repository.hasImportedEntry(source, externalId)) {
        duplicates++;
        continue;
      }

      final now = _clock().toUtc();
      await _repository.saveEntry(
        Entry(
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
        ),
      );
      imported++;
    }

    return IcsImportReport(imported: imported, duplicates: duplicates, skipped: parsed.skipped);
  }
}

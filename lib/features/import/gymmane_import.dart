import 'dart:convert';

import 'package:mane_core/mane_core.dart';
import 'package:uuid/uuid.dart';

import '../../services/planner_repository.dart';

class GymManeImportException implements Exception {
  const GymManeImportException(this.message);

  final String message;

  @override
  String toString() => message;
}

class GymManeImportReport {
  const GymManeImportReport({
    required this.imported,
    required this.duplicates,
    required this.skipped,
    required this.timed,
    required this.allDay,
  });

  final int imported;
  final int duplicates;
  final int skipped;

  /// Blocks placed at GymMane's `trainAt` time. Others fall back to all-day.
  final int timed;
  final int allDay;
}

/// Read-only import of GymMane's weekly plan.
///
/// GymMane stores `weeklyPlan` as weekday (1 = Monday) to routine id, plus one
/// global `trainAt` minute-of-day. The routines themselves carry the display
/// name. When no time is present the block is imported all-day rather than
/// guessing a time. Nothing is written back to GymMane.
class GymManeImportService {
  GymManeImportService(this._repository);

  static const source = 'gymmane';

  /// GymMane has no per-routine duration, so a timed block is one hour.
  static const blockMinutes = 60;

  final PlannerRepository _repository;

  Future<GymManeImportReport> importJson(
    String payloadSource, {
    required String spaceId,
    required LocalDate today,
    required String timeZone,
  }) async {
    final Object? decoded;
    try {
      decoded = jsonDecode(payloadSource);
    } on FormatException {
      throw const GymManeImportException('Not valid JSON');
    }
    if (decoded is! Map) throw const GymManeImportException('Not a GymMane backup');
    final payload = Map<String, Object?>.from(decoded);
    final routines = payload['routines'];
    final weeklyPlan = payload['weeklyPlan'];
    if (routines is! List || weeklyPlan is! Map) {
      throw const GymManeImportException('No GymMane weekly plan found');
    }

    final routinesById = <String, Map<String, Object?>>{};
    for (final item in routines) {
      if (item is! Map) continue;
      final routine = Map<String, Object?>.from(item);
      final id = routine['id'];
      if (id is String && id.isNotEmpty) routinesById[id] = routine;
    }
    if (routinesById.isEmpty) throw const GymManeImportException('The backup has no routines');

    final trainAt = payload['trainAt'];
    final startMinute = trainAt is num ? trainAt.toInt() : null;
    final hasTime = startMinute != null && startMinute >= 0 && startMinute < 24 * 60;

    var imported = 0;
    var duplicates = 0;
    var skipped = 0;
    var timed = 0;
    var allDay = 0;

    for (final entry in weeklyPlan.entries) {
      final weekday = int.tryParse('${entry.key}');
      final routineId = '${entry.value}';
      final routine = routinesById[routineId];
      if (weekday == null || weekday < 1 || weekday > 7 || routine == null) {
        skipped++;
        continue;
      }
      if (routine['a'] == true) {
        skipped++;
        continue;
      }
      final name = _routineName(routine);
      if (name.isEmpty) {
        skipped++;
        continue;
      }
      final externalId = '$source:$routineId:$weekday';
      if (await _repository.hasImportedEntry(source, externalId)) {
        duplicates++;
        continue;
      }

      final anchor = today.addDays((weekday - today.weekday) % 7);
      final now = DateTime.now();
      await _repository.saveEntry(
        Entry(
          id: const Uuid().v4(),
          spaceId: spaceId,
          title: name,
          notes: _notes(routine),
          kind: EntryKind.event,
          date: anchor,
          startMinute: hasTime ? startMinute : null,
          endMinute: hasTime ? startMinute + blockMinutes : null,
          timeZone: hasTime ? timeZone : null,
          allDay: !hasTime,
          recurrence: RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {weekday}),
          source: source,
          externalId: externalId,
          readOnly: true,
          createdAt: now,
          updatedAt: now,
        ),
      );
      imported++;
      if (hasTime) {
        timed++;
      } else {
        allDay++;
      }
    }

    return GymManeImportReport(
      imported: imported,
      duplicates: duplicates,
      skipped: skipped,
      timed: timed,
      allDay: allDay,
    );
  }

  static String _routineName(Map<String, Object?> routine) {
    final name = '${routine['n'] ?? ''}'.trim();
    if (name.isNotEmpty) return name;
    return '${routine['g'] ?? ''}'.trim();
  }

  static String _notes(Map<String, Object?> routine) {
    final group = '${routine['g'] ?? ''}'.trim();
    final imported = 'Imported from GymMane';
    return group.isEmpty ? imported : '$imported · $group';
  }
}

import 'package:mane_core/mane_core.dart';

import '../../services/planner_repository.dart';

/// Writes a read-only iCalendar file for sharing. No account or network is
/// involved.
///
/// Entries keep their recurrence, skip dates and moved occurrences. Shifts are
/// exported as concrete background events for the requested range, because an
/// arbitrary cycle is not expressible as a portable RRULE.
class IcsExportService {
  IcsExportService(this._repository, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final PlannerRepository _repository;
  final DateTime Function() _clock;

  Future<String> exportRange({
    required LocalDate start,
    required LocalDate end,
    required String viewerTimeZone,
  }) async {
    final entries = await _repository.loadEntries(start, end, viewerTimeZone);
    final shifts = await _repository.watchShifts(start, end, viewerTimeZone).first;
    final stamp = _formatUtc(_clock().toUtc());
    final lines = <String>[
      'BEGIN:VCALENDAR',
      'VERSION:2.0',
      'PRODID:-//Mane//Planner//EN',
      'CALSCALE:GREGORIAN',
      'METHOD:PUBLISH',
    ];

    final seen = <String>{};
    for (final occurrence in entries) {
      final entry = occurrence.entry;
      if (!seen.add(entry.id)) continue;
      lines.addAll(_entry(entry, stamp));
      for (final override in entry.recurrence?.overrides ?? const <RecurrenceOverride>[]) {
        if (entry.recurrence?.skipDates.contains(override.date) ?? false) continue;
        lines.addAll(_override(entry, override, stamp));
      }
    }
    for (final shift in shifts) {
      lines.addAll(_shift(shift, stamp));
    }

    lines.add('END:VCALENDAR');
    return '${lines.map(_fold).join('\r\n')}\r\n';
  }

  List<String> _entry(Entry entry, String stamp) {
    final lines = <String>[
      'BEGIN:VEVENT',
      'UID:${_uid(entry.id)}',
      'DTSTAMP:$stamp',
      'SUMMARY:${_escape(entry.title)}',
      if (entry.notes.isNotEmpty) 'DESCRIPTION:${_escape(entry.notes)}',
      ..._startEnd(entry),
    ];
    final rule = entry.recurrence;
    if (rule != null) {
      lines.add('RRULE:${_rrule(rule, entry.allDay)}');
      final skip = rule.skipDates.toList()..sort();
      if (skip.isNotEmpty) {
        lines.add(
          entry.allDay
              ? 'EXDATE;VALUE=DATE:${skip.map((date) => _dateValue(date)).join(',')}'
              : 'EXDATE;TZID=${entry.timeZone}:${skip.map((date) => _timedDateValue(date, entry.startMinute ?? 0)).join(',')}',
        );
      }
    }
    lines.add('END:VEVENT');
    return lines;
  }

  List<String> _override(Entry entry, RecurrenceOverride override, String stamp) {
    final allDay = override.allDay ?? entry.allDay;
    final date = override.effectiveDate;
    final startMinute = override.startMinute ?? entry.startMinute;
    final endMinute = override.endMinute ?? entry.endMinute;
    final lines = <String>[
      'BEGIN:VEVENT',
      'UID:${_uid(entry.id)}',
      'DTSTAMP:$stamp',
      _recurrenceId(entry, override.date),
      'SUMMARY:${_escape(override.title ?? entry.title)}',
      if ((override.notes ?? entry.notes).isNotEmpty) 'DESCRIPTION:${_escape(override.notes ?? entry.notes)}',
    ];
    if (allDay) {
      final last = entry.endDate == null ? date : date.addDays(entry.endDayOffset);
      lines
        ..add('DTSTART;VALUE=DATE:${_dateValue(date)}')
        ..add('DTEND;VALUE=DATE:${_dateValue(last.addDays(1))}');
    } else {
      final zone = entry.timeZone ?? 'UTC';
      lines
        ..add('DTSTART;TZID=$zone:${_timedDateValue(date, startMinute ?? 0)}')
        ..add('DTEND;TZID=$zone:${_timedDateValue(date, endMinute ?? (startMinute ?? 0) + 60)}');
    }
    lines.add('END:VEVENT');
    return lines;
  }

  List<String> _shift(ShiftOccurrence shift, String stamp) {
    final zone = shift.pattern.timeZone;
    final start = localDateTimeAt(shift.startAt, zone);
    final end = localDateTimeAt(shift.endAt, zone);
    final label = shift.slot.label.isEmpty
        ? shift.pattern.name
        : '${shift.pattern.name} · ${shift.slot.label}';
    return [
      'BEGIN:VEVENT',
      'UID:mane-shift-${shift.pattern.id}-${shift.date.iso}-${shift.slot.key}@local',
      'DTSTAMP:$stamp',
      'SUMMARY:${_escape(label)}',
      'DTSTART;TZID=$zone:${_timedValue(start)}',
      'DTEND;TZID=$zone:${_timedValue(end)}',
      'TRANSP:TRANSPARENT',
      'END:VEVENT',
    ];
  }

  List<String> _startEnd(Entry entry) {
    if (entry.allDay) {
      final date = entry.date;
      if (date == null) return const [];
      final last = entry.endDate ?? date;
      return ['DTSTART;VALUE=DATE:${_dateValue(date)}', 'DTEND;VALUE=DATE:${_dateValue(last.addDays(1))}'];
    }
    final date = entry.date;
    final startMinute = entry.startMinute;
    final endMinute = entry.endMinute;
    final zone = entry.timeZone;
    if (date == null || startMinute == null || endMinute == null || zone == null) return const [];
    final endDate = entry.endDate ?? date.addDays(endMinute ~/ 1440);
    return [
      'DTSTART;TZID=$zone:${_timedDateValue(date, startMinute)}',
      'DTEND;TZID=$zone:${_timedDateValue(endDate, endMinute % 1440)}',
    ];
  }

  String _recurrenceId(Entry entry, LocalDate date) {
    if (entry.allDay) return 'RECURRENCE-ID;VALUE=DATE:${_dateValue(date)}';
    final zone = entry.timeZone ?? 'UTC';
    return 'RECURRENCE-ID;TZID=$zone:${_timedDateValue(date, entry.startMinute ?? 0)}';
  }

  String _rrule(RecurrenceRule rule, bool allDay) {
    final parts = <String>[
      'FREQ=${switch (rule.frequency) {
        RecurrenceFrequency.daily => 'DAILY',
        RecurrenceFrequency.weekly => 'WEEKLY',
        RecurrenceFrequency.monthly => 'MONTHLY',
        RecurrenceFrequency.yearly => 'YEARLY',
      }}',
    ];
    if (rule.interval != 1) parts.add('INTERVAL=${rule.interval}');
    if (rule.ordinalWeekdays.isNotEmpty) {
      parts.add(
        'BYDAY=${rule.ordinalWeekdays.map((item) => '${item.ordinal}${_weekday(item.weekday)}').join(',')}',
      );
    } else if (rule.weekdays.isNotEmpty) {
      parts.add('BYDAY=${(rule.weekdays.toList()..sort()).map(_weekday).join(',')}');
    }
    if (rule.monthDay != null) parts.add('BYMONTHDAY=${rule.monthDay}');
    if (rule.setPositions.isNotEmpty) parts.add('BYSETPOS=${rule.setPositions.join(',')}');
    if (rule.count != null) parts.add('COUNT=${rule.count}');
    final until = rule.until;
    if (until != null) {
      parts.add(allDay ? 'UNTIL=${_dateValue(until)}' : 'UNTIL=${_dateValue(until)}T235959Z');
    }
    return parts.join(';');
  }

  String _uid(String id) => 'mane-entry-$id@local';

  static String _weekday(int weekday) => const ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'][weekday - 1];

  static String _dateValue(LocalDate date) =>
      '${date.year.toString().padLeft(4, '0')}'
      '${date.month.toString().padLeft(2, '0')}'
      '${date.day.toString().padLeft(2, '0')}';

  static String _timedDateValue(LocalDate date, int minute) {
    final normalized = minute % (24 * 60);
    return '${_dateValue(date)}T'
        '${(normalized ~/ 60).toString().padLeft(2, '0')}'
        '${(normalized % 60).toString().padLeft(2, '0')}'
        '00';
  }

  static String _timedValue(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}'
      '${value.month.toString().padLeft(2, '0')}'
      '${value.day.toString().padLeft(2, '0')}T'
      '${value.hour.toString().padLeft(2, '0')}'
      '${value.minute.toString().padLeft(2, '0')}'
      '00';

  static String _formatUtc(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}'
      '${value.month.toString().padLeft(2, '0')}'
      '${value.day.toString().padLeft(2, '0')}T'
      '${value.hour.toString().padLeft(2, '0')}'
      '${value.minute.toString().padLeft(2, '0')}'
      '${value.second.toString().padLeft(2, '0')}Z';

  static String _escape(String value) => value
      .replaceAll('\\', '\\\\')
      .replaceAll(';', '\\;')
      .replaceAll(',', '\\,')
      .replaceAll('\r\n', '\\n')
      .replaceAll('\n', '\\n');

  static String _fold(String line) {
    if (line.length <= 75) return line;
    final parts = <String>[];
    var rest = line;
    parts.add(rest.substring(0, 75));
    rest = rest.substring(75);
    while (rest.isNotEmpty) {
      final take = rest.length > 74 ? 74 : rest.length;
      parts.add(' ${rest.substring(0, take)}');
      rest = rest.substring(take);
    }
    return parts.join('\r\n');
  }
}

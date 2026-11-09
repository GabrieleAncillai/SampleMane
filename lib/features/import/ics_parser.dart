import 'package:mane_core/mane_core.dart';

/// One event parsed from an iCalendar file.
class IcsEvent {
  const IcsEvent({
    required this.uid,
    required this.summary,
    required this.description,
    required this.allDay,
    required this.date,
    this.endDate,
    this.startMinute,
    this.endMinute,
    this.timeZone,
    this.startAt,
    this.endAt,
    this.recurrence,
  });

  final String uid;
  final String summary;
  final String description;
  final bool allDay;

  /// Start date in [timeZone], or the all-day date.
  final LocalDate date;

  /// Last day of a multi-day all-day event.
  final LocalDate? endDate;

  final int? startMinute;
  final int? endMinute;
  final String? timeZone;
  final DateTime? startAt;
  final DateTime? endAt;
  final RecurrenceRule? recurrence;
}

/// An event the importer refused to guess about, with the reason.
class IcsSkip {
  const IcsSkip({required this.summary, required this.reason});

  final String summary;
  final String reason;
}

class IcsParseResult {
  const IcsParseResult({required this.events, required this.skipped});

  final List<IcsEvent> events;
  final List<IcsSkip> skipped;
}

/// Thrown for an event whose shape the supported subset cannot represent.
class _UnsupportedEvent implements Exception {
  const _UnsupportedEvent(this.reason);

  final String reason;
}

/// Parses the documented iCalendar subset.
///
/// Supported: multiple `VEVENT`s, `UID`, `SUMMARY`, `DESCRIPTION`, `DTSTART`,
/// `DTEND`, `DURATION`, `TZID`, UTC times, floating times, all-day dates and an
/// `RRULE` subset (daily, weekly, monthly and yearly; `INTERVAL`, `COUNT`,
/// `UNTIL`, `BYDAY` for weekly rules). Unsupported events are reported in
/// [IcsParseResult.skipped] instead of being imported with a guessed shape.
IcsParseResult parseIcs(String source, {required String defaultTimeZone}) {
  if (!isKnownTimeZone(defaultTimeZone)) {
    throw ArgumentError.value(defaultTimeZone, 'defaultTimeZone', 'unknown IANA timezone');
  }

  final events = <IcsEvent>[];
  final skipped = <IcsSkip>[];
  final lines = _unfold(source);

  List<String>? block;
  for (final line in lines) {
    final upper = line.toUpperCase();
    if (upper == 'BEGIN:VEVENT') {
      block = <String>[];
      continue;
    }
    if (upper == 'END:VEVENT') {
      if (block == null) continue;
      try {
        final event = _parseEvent(block, defaultTimeZone);
        if (event != null) events.add(event);
      } on _UnsupportedEvent catch (error) {
        skipped.add(IcsSkip(summary: _summaryOf(block), reason: error.reason));
      } on FormatException catch (error) {
        skipped.add(IcsSkip(summary: _summaryOf(block), reason: error.message));
      }
      block = null;
      continue;
    }
    block?.add(line);
  }

  return IcsParseResult(events: events, skipped: skipped);
}

String _summaryOf(List<String> block) {
  for (final line in block) {
    final property = _property(line);
    if (property?.name == 'SUMMARY') return _unescape(property!.value);
  }
  return '';
}

IcsEvent? _parseEvent(List<String> block, String defaultTimeZone) {
  final properties = <String, _Property>{};
  for (final line in block) {
    final property = _property(line);
    if (property == null) continue;
    if (property.name == 'SUMMARY' ||
        property.name == 'DESCRIPTION' ||
        property.name == 'DTSTART' ||
        property.name == 'DTEND' ||
        property.name == 'DURATION' ||
        property.name == 'RRULE' ||
        property.name == 'UID') {
      properties[property.name] = property;
    } else if (property.name == 'RECURRENCE-ID') {
      throw const _UnsupportedEvent('RECURRENCE-ID exceptions are not supported');
    } else if (property.name == 'STATUS') {
      if (property.value.toUpperCase() == 'CANCELLED') return null;
    }
  }

  final startProperty = properties['DTSTART'];
  if (startProperty == null) throw const _UnsupportedEvent('Missing DTSTART');

  final start = _dateTime(startProperty, defaultTimeZone);
  final summary = _unescape(properties['SUMMARY']?.value ?? '');
  final description = _unescape(properties['DESCRIPTION']?.value ?? '');
  final uid = _unescape(properties['UID']?.value ?? '');

  if (start.allDay) {
    final endProperty = properties['DTEND'];
    LocalDate? endDate;
    if (endProperty != null) {
      final end = _dateTime(endProperty, defaultTimeZone);
      if (end.allDay) endDate = end.date;
      final lastInclusive = endDate?.addDays(-1);
      endDate = lastInclusive == null || lastInclusive.isBefore(start.date) || lastInclusive == start.date
          ? null
          : lastInclusive;
    } else {
      final duration = properties['DURATION']?.value;
      if (duration != null) {
        final parsed = _duration(duration);
        if (parsed.inMinutes % (24 * 60) != 0) {
          throw const _UnsupportedEvent('An all-day event needs a whole-day duration');
        }
        endDate = start.date.addDays(parsed.inDays - 1);
      }
    }
    return IcsEvent(
      uid: uid,
      summary: summary,
      description: description,
      allDay: true,
      date: start.date,
      endDate: endDate,
      recurrence: _recurrence(properties['RRULE'], start, defaultTimeZone),
    );
  }

  final zone = start.timeZone!;
  DateTime endAt;
  final endProperty = properties['DTEND'];
  final duration = properties['DURATION']?.value;
  if (endProperty != null) {
    final end = _dateTime(endProperty, defaultTimeZone);
    if (end.allDay) throw const _UnsupportedEvent('A timed event cannot end on a date value');
    endAt = end.instant!;
  } else if (duration != null) {
    endAt = start.instant!.add(_duration(duration));
  } else {
    endAt = start.instant!.add(const Duration(minutes: 1));
  }

  if (!endAt.isAfter(start.instant!)) {
    throw const _UnsupportedEvent('DTEND must be after DTSTART');
  }
  final durationMinutes = endAt.difference(start.instant!).inMinutes;
  if (durationMinutes > 24 * 60) {
    throw const _UnsupportedEvent('Timed events longer than 24 hours are not supported');
  }

  final startAt = start.instant!;
  final endLocal = localDateTimeAt(endAt, zone);
  final dayOffset = LocalDate.fromDateTime(endLocal).differenceInDays(start.date);
  final endMinute = endLocal.hour * 60 + endLocal.minute + dayOffset * 1440;
  if (endMinute <= start.minute) {
    throw const _UnsupportedEvent('DTEND must be after DTSTART');
  }

  return IcsEvent(
    uid: uid,
    summary: summary,
    description: description,
    allDay: false,
    date: start.date,
    startMinute: start.minute,
    endMinute: endMinute,
    timeZone: zone,
    startAt: startAt,
    endAt: endAt,
    recurrence: _recurrence(properties['RRULE'], start, defaultTimeZone),
  );
}

RecurrenceRule? _recurrence(_Property? property, _DateTimeValue start, String defaultTimeZone) {
  if (property == null) return null;

  final values = <String, String>{};
  for (final part in property.value.split(';')) {
    final index = part.indexOf('=');
    if (index <= 0) continue;
    values[part.substring(0, index).toUpperCase()] = part.substring(index + 1);
  }

  const accepted = {'FREQ', 'INTERVAL', 'COUNT', 'UNTIL', 'BYDAY', 'WKST', 'BYMONTHDAY', 'BYMONTH'};
  final unknown = values.keys.where((key) => !accepted.contains(key)).toList();
  if (unknown.isNotEmpty) {
    throw _UnsupportedEvent('Unsupported RRULE parts: ${unknown.join(', ')}');
  }

  final frequency = switch (values['FREQ']?.toUpperCase()) {
    'DAILY' => RecurrenceFrequency.daily,
    'WEEKLY' => RecurrenceFrequency.weekly,
    'MONTHLY' => RecurrenceFrequency.monthly,
    'YEARLY' => RecurrenceFrequency.yearly,
    final other => throw _UnsupportedEvent('Unsupported RRULE frequency: ${other ?? 'missing'}'),
  };

  final interval = values['INTERVAL'] == null ? 1 : int.tryParse(values['INTERVAL']!);
  if (interval == null || interval <= 0) throw const _UnsupportedEvent('Invalid RRULE interval');
  final count = values['COUNT'] == null ? null : int.tryParse(values['COUNT']!);
  if (values['COUNT'] != null && (count == null || count <= 0)) {
    throw const _UnsupportedEvent('Invalid RRULE count');
  }

  final weekdays = <int>{};
  final byDay = values['BYDAY'];
  if (byDay != null) {
    if (frequency != RecurrenceFrequency.weekly) {
      throw const _UnsupportedEvent('BYDAY is only supported for weekly rules');
    }
    for (final token in byDay.split(',')) {
      final day = _weekday(token.trim());
      if (day == null) throw _UnsupportedEvent('Unsupported BYDAY value: $token');
      weekdays.add(day);
    }
  }

  final monthDay = values['BYMONTHDAY'] == null ? null : int.tryParse(values['BYMONTHDAY']!);
  if (monthDay != null && (frequency != RecurrenceFrequency.monthly || monthDay != start.date.day)) {
    throw const _UnsupportedEvent('Only the anchor day is supported for monthly rules');
  }
  final month = values['BYMONTH'] == null ? null : int.tryParse(values['BYMONTH']!);
  if (month != null && (frequency != RecurrenceFrequency.yearly || month != start.date.month)) {
    throw const _UnsupportedEvent('Only the anchor month is supported for yearly rules');
  }

  LocalDate? until;
  final rawUntil = values['UNTIL'];
  if (rawUntil != null) {
    final value = _dateTime(_Property(name: 'UNTIL', params: const {}, value: rawUntil), defaultTimeZone);
    until = value.allDay ? value.date : localDateAt(value.instant!, start.timeZone ?? defaultTimeZone);
  }

  return RecurrenceRule(
    frequency: frequency,
    interval: interval,
    weekdays: weekdays,
    monthDay: monthDay,
    until: until,
    count: count,
  );
}

int? _weekday(String token) => switch (token.toUpperCase()) {
  'MO' => DateTime.monday,
  'TU' => DateTime.tuesday,
  'WE' => DateTime.wednesday,
  'TH' => DateTime.thursday,
  'FR' => DateTime.friday,
  'SA' => DateTime.saturday,
  'SU' => DateTime.sunday,
  _ => null,
};

class _DateTimeValue {
  const _DateTimeValue({
    required this.date,
    required this.minute,
    required this.allDay,
    this.timeZone,
    this.instant,
  });

  final LocalDate date;
  final int minute;
  final bool allDay;
  final String? timeZone;
  final DateTime? instant;
}

_DateTimeValue _dateTime(_Property property, String defaultTimeZone) {
  final value = property.value.trim();
  final dateOnly = property.params['VALUE']?.toUpperCase() == 'DATE' || !value.contains('T');
  if (dateOnly) {
    final date = _date(value);
    if (date == null) throw FormatException('Invalid DATE value: $value');
    return _DateTimeValue(date: date, minute: 0, allDay: true);
  }

  final match = RegExp(r'^(\d{8})T(\d{2})(\d{2})(\d{2})?(Z)?$').firstMatch(value.toUpperCase());
  if (match == null) throw FormatException('Invalid DATE-TIME value: $value');
  final date = _date(match.group(1)!);
  if (date == null) throw FormatException('Invalid DATE value: $value');
  final hour = int.parse(match.group(2)!);
  final minute = int.parse(match.group(3)!);
  if (hour > 23 || minute > 59) throw FormatException('Invalid time value: $value');
  final totalMinutes = hour * 60 + minute;

  final utc = match.group(5) == 'Z';
  if (utc) {
    final instant = DateTime.utc(date.year, date.month, date.day, hour, minute);
    return _DateTimeValue(date: date, minute: totalMinutes, allDay: false, timeZone: 'UTC', instant: instant);
  }

  final zone = (property.params['TZID'] ?? defaultTimeZone).replaceAll('"', '');
  if (!isKnownTimeZone(zone)) throw _UnsupportedEvent('Unknown timezone: $zone');
  return _DateTimeValue(
    date: date,
    minute: totalMinutes,
    allDay: false,
    timeZone: zone,
    instant: instantAt(date, totalMinutes, zone),
  );
}

LocalDate? _date(String value) {
  if (!RegExp(r'^\d{8}$').hasMatch(value)) return null;
  return LocalDate.parse('${value.substring(0, 4)}-${value.substring(4, 6)}-${value.substring(6, 8)}');
}

Duration _duration(String value) {
  final match = RegExp(
    r'^P(?:(\d+)W)?(?:(\d+)D)?(?:T(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?)?$',
    caseSensitive: false,
  ).firstMatch(value.trim());
  if (match == null) throw FormatException('Invalid DURATION value: $value');
  final weeks = int.tryParse(match.group(1) ?? '') ?? 0;
  final days = int.tryParse(match.group(2) ?? '') ?? 0;
  final hours = int.tryParse(match.group(3) ?? '') ?? 0;
  final minutes = int.tryParse(match.group(4) ?? '') ?? 0;
  final seconds = int.tryParse(match.group(5) ?? '') ?? 0;
  return Duration(days: days + weeks * 7, hours: hours, minutes: minutes, seconds: seconds);
}

class _Property {
  const _Property({required this.name, required this.params, required this.value});

  final String name;
  final Map<String, String> params;
  final String value;
}

_Property? _property(String line) {
  final colon = _indexOfUnquoted(line, ':');
  if (colon <= 0) return null;
  final head = line.substring(0, colon);
  final value = line.substring(colon + 1);
  final parts = _splitUnquoted(head, ';');
  if (parts.isEmpty) return null;
  final name = parts.first.toUpperCase();
  final params = <String, String>{};
  for (final part in parts.skip(1)) {
    final index = part.indexOf('=');
    if (index <= 0) continue;
    params[part.substring(0, index).toUpperCase()] = part.substring(index + 1);
  }
  return _Property(name: name, params: params, value: value);
}

int _indexOfUnquoted(String value, String needle) {
  var quoted = false;
  for (var index = 0; index < value.length; index++) {
    final char = value[index];
    if (char == '"') quoted = !quoted;
    if (!quoted && char == needle) return index;
  }
  return -1;
}

List<String> _splitUnquoted(String value, String separator) {
  final result = <String>[];
  var quoted = false;
  var start = 0;
  for (var index = 0; index < value.length; index++) {
    final char = value[index];
    if (char == '"') quoted = !quoted;
    if (!quoted && char == separator) {
      result.add(value.substring(start, index));
      start = index + 1;
    }
  }
  result.add(value.substring(start));
  return result;
}

List<String> _unfold(String source) {
  final normalized = source.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  final result = <String>[];
  for (final line in normalized.split('\n')) {
    if (line.isNotEmpty && (line.startsWith(' ') || line.startsWith('\t')) && result.isNotEmpty) {
      result[result.length - 1] += line.substring(1);
    } else {
      result.add(line);
    }
  }
  return result;
}

String _unescape(String value) => value
    .replaceAll(r'\n', '\n')
    .replaceAll(r'\N', '\n')
    .replaceAll(r'\,', ',')
    .replaceAll(r'\;', ';')
    .replaceAll(r'\\', r'\');

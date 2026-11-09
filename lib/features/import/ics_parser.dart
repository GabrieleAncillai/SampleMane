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
    this.recurrenceId,
    this.exDates = const [],
    this.cancelled = false,
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

  /// Raw `RECURRENCE-ID` value while the parser groups a UID.
  final IcsDateTimeValue? recurrenceId;

  /// Raw `EXDATE` values while the parser groups a UID.
  final List<IcsDateTimeValue> exDates;

  final bool cancelled;
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
/// `DTEND`, `DURATION`, `TZID`, UTC and floating times, all-day and multi-day
/// dates, `EXDATE`, `RECURRENCE-ID` cancellations and moved occurrences,
/// Windows timezone aliases and an RRULE subset (daily, weekly, monthly and
/// yearly; `INTERVAL`, `COUNT`, `UNTIL`, `BYDAY`, ordinal `BYDAY`,
/// `BYMONTHDAY` including negative days and `BYSETPOS`). Anything outside the
/// subset is reported in [IcsParseResult.skipped] instead of being guessed.
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
        final parsed = _parseEvent(block, defaultTimeZone);
        if (parsed != null) events.add(parsed);
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

  return IcsParseResult(events: _mergeExceptions(events, skipped), skipped: skipped);
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
  final exDates = <IcsDateTimeValue>[];
  _Property? recurrenceProperty;
  for (final line in block) {
    final property = _property(line);
    if (property == null) continue;
    switch (property.name) {
      case 'SUMMARY':
      case 'DESCRIPTION':
      case 'DTSTART':
      case 'DTEND':
      case 'DURATION':
      case 'RRULE':
      case 'UID':
      case 'STATUS':
        properties[property.name] = property;
      case 'RECURRENCE-ID':
        recurrenceProperty = property;
      case 'EXDATE':
        for (final value in property.value.split(',')) {
          if (value.trim().isEmpty) continue;
          exDates.add(
            _dateTime(
              _Property(name: 'EXDATE', params: property.params, value: value.trim()),
              defaultTimeZone,
            ),
          );
        }
    }
  }

  final status = properties['STATUS']?.value.toUpperCase();
  final cancelled = status == 'CANCELLED';
  final recurrenceValue = recurrenceProperty == null ? null : _dateTime(recurrenceProperty, defaultTimeZone);
  if (cancelled && recurrenceValue == null) return null;

  final startProperty = properties['DTSTART'];
  if (startProperty == null) {
    if (cancelled) {
      final fallback = recurrenceValue!;
      return _buildEvent(
        properties: properties,
        start: fallback,
        defaultTimeZone: defaultTimeZone,
        cancelled: true,
        exDates: exDates,
        recurrenceId: recurrenceValue,
      );
    }
    throw const _UnsupportedEvent('Missing DTSTART');
  }

  final start = _dateTime(startProperty, defaultTimeZone);
  return _buildEvent(
    properties: properties,
    start: start,
    defaultTimeZone: defaultTimeZone,
    cancelled: cancelled,
    exDates: exDates,
    recurrenceId: recurrenceValue,
  );
}

IcsEvent _buildEvent({
  required Map<String, _Property> properties,
  required IcsDateTimeValue start,
  required String defaultTimeZone,
  required bool cancelled,
  required List<IcsDateTimeValue> exDates,
  required IcsDateTimeValue? recurrenceId,
}) {
  final summary = _unescape(properties['SUMMARY']?.value ?? '');
  final description = _unescape(properties['DESCRIPTION']?.value ?? '');
  final uid = _unescape(properties['UID']?.value ?? '');

  if (start.allDay) {
    final endProperty = properties['DTEND'];
    LocalDate? endDate;
    if (endProperty != null) {
      final end = _dateTime(endProperty, defaultTimeZone);
      if (!end.allDay) throw const _UnsupportedEvent('An all-day event cannot end on a time value');
      final lastInclusive = end.date.addDays(-1);
      endDate = lastInclusive.isBefore(start.date) || lastInclusive == start.date ? null : lastInclusive;
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
      recurrenceId: recurrenceId,
      exDates: exDates,
      cancelled: cancelled,
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

  final endLocal = localDateTimeAt(endAt, zone);
  final endDate = LocalDate.fromDateTime(endLocal);
  final endMinute = endLocal.hour * 60 + endLocal.minute;
  final multiDay = endDate.isAfter(start.date);

  return IcsEvent(
    uid: uid,
    summary: summary,
    description: description,
    allDay: false,
    date: start.date,
    endDate: multiDay ? endDate : null,
    startMinute: start.minute,
    endMinute: multiDay ? endMinute : endMinute + (endDate == start.date ? 0 : 1440),
    timeZone: zone,
    startAt: start.instant,
    endAt: endAt,
    recurrence: _recurrence(properties['RRULE'], start, defaultTimeZone),
    recurrenceId: recurrenceId,
    exDates: exDates,
    cancelled: cancelled,
  );
}

List<IcsEvent> _mergeExceptions(List<IcsEvent> parsed, List<IcsSkip> skipped) {
  final groups = <String, List<IcsEvent>>{};
  final order = <String>[];
  for (final event in parsed) {
    final key = event.uid.trim().isEmpty
        ? 'fallback:${event.date.key}:${event.startMinute ?? -1}:${event.summary}'
        : 'uid:${event.uid.trim()}';
    if (!groups.containsKey(key)) order.add(key);
    (groups[key] ??= []).add(event);
  }

  final result = <IcsEvent>[];
  for (final key in order) {
    final group = groups[key]!;
    IcsEvent? base;
    for (final event in group) {
      if (event.recurrenceId == null && !event.cancelled) {
        base = event;
        break;
      }
    }
    if (base == null) {
      // A cancelled override without a base, or a group of orphan exceptions,
      // has no shape we can place honestly.
      if (group.any((event) => !event.cancelled)) {
        skipped.add(
          IcsSkip(summary: group.first.summary, reason: 'Recurrence exception without a base event'),
        );
      }
      continue;
    }

    var rule = base.recurrence;
    final skipDates = <LocalDate>{};
    final overrides = <RecurrenceOverride>[];

    for (final date in base.exDates) {
      final resolved = _resolveExceptionDate(date, base);
      if (resolved != null) skipDates.add(resolved);
    }
    for (final exception in group.where((event) => event.recurrenceId != null)) {
      final original = _resolveExceptionDate(exception.recurrenceId!, base);
      if (original == null) continue;
      if (exception.cancelled) {
        skipDates.add(original);
        continue;
      }
      if (base.allDay) {
        overrides.add(
          RecurrenceOverride(
            date: original,
            dateOverride: exception.date == original ? null : exception.date,
            allDay: true,
            title: exception.summary.isEmpty || exception.summary == base.summary ? null : exception.summary,
            notes: exception.description.isEmpty || exception.description == base.description
                ? null
                : exception.description,
          ),
        );
        continue;
      }
      final zone = base.timeZone!;
      final startInstant = exception.startAt!;
      final startLocal = localDateTimeAt(startInstant, zone);
      final endLocal = localDateTimeAt(exception.endAt!, zone);
      final startDate = LocalDate.fromDateTime(startLocal);
      final endDate = LocalDate.fromDateTime(endLocal);
      final startMinute = startLocal.hour * 60 + startLocal.minute;
      final endMinute = endLocal.hour * 60 + endLocal.minute + endDate.differenceInDays(startDate) * 1440;
      overrides.add(
        RecurrenceOverride(
          date: original,
          dateOverride: startDate == original ? null : startDate,
          startMinute: startMinute,
          endMinute: endMinute,
          title: exception.summary.isEmpty || exception.summary == base.summary ? null : exception.summary,
          notes: exception.description.isEmpty || exception.description == base.description
              ? null
              : exception.description,
        ),
      );
    }

    if (skipDates.isNotEmpty || overrides.isNotEmpty) {
      rule = (rule ?? RecurrenceRule(frequency: RecurrenceFrequency.daily)).copyWith(
        skipDates: skipDates,
        overrides: overrides,
      );
      if (base.recurrence == null) {
        skipped.add(IcsSkip(summary: base.summary, reason: 'Exceptions without an RRULE are not supported'));
        rule = null;
      }
    }

    result.add(
      IcsEvent(
        uid: base.uid,
        summary: base.summary,
        description: base.description,
        allDay: base.allDay,
        date: base.date,
        endDate: base.endDate,
        startMinute: base.startMinute,
        endMinute: base.endMinute,
        timeZone: base.timeZone,
        startAt: base.startAt,
        endAt: base.endAt,
        recurrence: rule,
      ),
    );
  }
  return result;
}

LocalDate? _resolveExceptionDate(IcsDateTimeValue value, IcsEvent base) {
  if (base.allDay || value.allDay) return value.date;
  final zone = base.timeZone;
  if (zone == null) return value.date;
  final instant = value.instant;
  return instant == null ? value.date : localDateAt(instant, zone);
}

RecurrenceRule? _recurrence(_Property? property, IcsDateTimeValue start, String defaultTimeZone) {
  if (property == null) return null;

  final values = <String, String>{};
  for (final part in property.value.split(';')) {
    final index = part.indexOf('=');
    if (index <= 0) continue;
    values[part.substring(0, index).toUpperCase()] = part.substring(index + 1);
  }

  const accepted = {
    'FREQ',
    'INTERVAL',
    'COUNT',
    'UNTIL',
    'BYDAY',
    'WKST',
    'BYMONTHDAY',
    'BYMONTH',
    'BYSETPOS',
  };
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
  final ordinals = <WeekdayOrdinal>[];
  final byDay = values['BYDAY'];
  if (byDay != null) {
    for (final token in byDay.split(',')) {
      final trimmed = token.trim();
      final match = RegExp(
        r'^([+-]?\d{1,2})?(MO|TU|WE|TH|FR|SA|SU)$',
        caseSensitive: false,
      ).firstMatch(trimmed);
      if (match == null) throw _UnsupportedEvent('Unsupported BYDAY value: $token');
      final day = _weekday(match.group(2)!);
      if (day == null) throw _UnsupportedEvent('Unsupported BYDAY value: $token');
      final ordinalText = match.group(1);
      if (ordinalText == null) {
        weekdays.add(day);
        continue;
      }
      if (frequency != RecurrenceFrequency.monthly && frequency != RecurrenceFrequency.yearly) {
        throw const _UnsupportedEvent('Ordinal BYDAY is only supported for monthly or yearly rules');
      }
      final ordinal = int.tryParse(ordinalText);
      if (ordinal == null || ordinal == 0 || ordinal.abs() > 5) {
        throw _UnsupportedEvent('Unsupported BYDAY ordinal: $token');
      }
      ordinals.add(WeekdayOrdinal(weekday: day, ordinal: ordinal));
    }
  }

  int? monthDay;
  final rawMonthDay = values['BYMONTHDAY'];
  if (rawMonthDay != null) {
    if (rawMonthDay.contains(',')) {
      throw const _UnsupportedEvent('Multiple BYMONTHDAY values are not supported');
    }
    monthDay = int.tryParse(rawMonthDay);
    if (monthDay == null || monthDay == 0 || monthDay.abs() > 31) {
      throw _UnsupportedEvent('Unsupported BYMONTHDAY value: $rawMonthDay');
    }
    if (frequency != RecurrenceFrequency.monthly && frequency != RecurrenceFrequency.yearly) {
      throw const _UnsupportedEvent('BYMONTHDAY is only supported for monthly or yearly rules');
    }
  }

  final positions = <int>[];
  final rawPositions = values['BYSETPOS'];
  if (rawPositions != null) {
    for (final token in rawPositions.split(',')) {
      final value = int.tryParse(token.trim());
      if (value == null || value == 0) throw _UnsupportedEvent('Unsupported BYSETPOS value: $token');
      positions.add(value);
    }
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
    ordinalWeekdays: ordinals,
    setPositions: positions,
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

/// Maps the Windows timezone identifiers and vendor-prefixed values that
/// Google, Microsoft and Mozilla exports actually contain.
String normalizeIcsTimeZone(String raw) {
  var zone = raw.replaceAll('"', '').trim();
  if (zone.startsWith('/')) {
    final parts = zone.split('/').where((part) => part.isNotEmpty).toList();
    for (var index = 0; index < parts.length; index++) {
      final candidate = parts.sublist(index).join('/');
      if (isKnownTimeZone(candidate)) return candidate;
    }
  }
  final alias = _windowsZones[zone];
  if (alias != null) return alias;
  return zone;
}

const _windowsZones = <String, String>{
  'Dateline Standard Time': 'Etc/GMT+12',
  'UTC-11': 'Etc/GMT+11',
  'Hawaiian Standard Time': 'Pacific/Honolulu',
  'Alaskan Standard Time': 'America/Anchorage',
  'Pacific Standard Time': 'America/Los_Angeles',
  'Pacific Daylight Time': 'America/Los_Angeles',
  'Mountain Standard Time': 'America/Denver',
  'Mountain Daylight Time': 'America/Denver',
  'US Mountain Standard Time': 'America/Phoenix',
  'Central Standard Time': 'America/Chicago',
  'Central Daylight Time': 'America/Chicago',
  'Central America Standard Time': 'America/Guatemala',
  'Canada Central Standard Time': 'America/Regina',
  'SA Pacific Standard Time': 'America/Bogota',
  'Eastern Standard Time': 'America/New_York',
  'Eastern Daylight Time': 'America/New_York',
  'US Eastern Standard Time': 'America/Indiana/Indianapolis',
  'Atlantic Standard Time': 'America/Halifax',
  'Newfoundland Standard Time': 'America/St_Johns',
  'Argentina Standard Time': 'America/Argentina/Buenos_Aires',
  'SA Eastern Standard Time': 'America/Cayenne',
  'Greenwich Standard Time': 'Atlantic/Reykjavik',
  'GMT Standard Time': 'Europe/London',
  'GMT Daylight Time': 'Europe/London',
  'W. Europe Standard Time': 'Europe/Berlin',
  'Central Europe Standard Time': 'Europe/Budapest',
  'Central European Standard Time': 'Europe/Warsaw',
  'Romance Standard Time': 'Europe/Paris',
  'E. Europe Standard Time': 'Europe/Chisinau',
  'FLE Standard Time': 'Europe/Kyiv',
  'Russian Standard Time': 'Europe/Moscow',
  'Turkey Standard Time': 'Europe/Istanbul',
  'Israel Standard Time': 'Asia/Jerusalem',
  'Arabian Standard Time': 'Asia/Dubai',
  'India Standard Time': 'Asia/Kolkata',
  'China Standard Time': 'Asia/Shanghai',
  'Tokyo Standard Time': 'Asia/Tokyo',
  'Korea Standard Time': 'Asia/Seoul',
  'AUS Eastern Standard Time': 'Australia/Sydney',
  'AUS Eastern Daylight Time': 'Australia/Sydney',
  'New Zealand Standard Time': 'Pacific/Auckland',
  'New Zealand Daylight Time': 'Pacific/Auckland',
  'UTC': 'UTC',
  'Etc/UTC': 'UTC',
};

class IcsDateTimeValue {
  const IcsDateTimeValue({
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

IcsDateTimeValue _dateTime(_Property property, String defaultTimeZone) {
  final value = property.value.trim();
  final dateOnly = property.params['VALUE']?.toUpperCase() == 'DATE' || !value.contains('T');
  if (dateOnly) {
    final date = _date(value);
    if (date == null) throw FormatException('Invalid DATE value: $value');
    return IcsDateTimeValue(date: date, minute: 0, allDay: true);
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
    return IcsDateTimeValue(
      date: date,
      minute: totalMinutes,
      allDay: false,
      timeZone: 'UTC',
      instant: instant,
    );
  }

  final zone = normalizeIcsTimeZone(property.params['TZID'] ?? defaultTimeZone);
  if (!isKnownTimeZone(zone)) throw _UnsupportedEvent('Unknown timezone: $zone');
  return IcsDateTimeValue(
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

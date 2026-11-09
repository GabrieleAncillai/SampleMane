import 'local_date.dart';

/// How often a recurring entry comes back.
enum RecurrenceFrequency { daily, weekly, monthly, yearly }

/// An ordinal weekday inside a month or year, for rules like `1MO` or `-1FR`.
class WeekdayOrdinal {
  const WeekdayOrdinal({required this.weekday, required this.ordinal})
    : assert(weekday >= 1 && weekday <= 7),
      assert(ordinal >= -5 && ordinal <= 5 && ordinal != 0);

  /// ISO weekday, 1 = Monday and 7 = Sunday.
  final int weekday;

  /// 1 is the first matching weekday, -1 is the last.
  final int ordinal;

  /// The date this ordinal selects in [month].
  LocalDate? dateIn(LocalDate month) {
    final matches = <LocalDate>[];
    var cursor = LocalDate(month.year, month.month, 1);
    while (cursor.month == month.month) {
      if (cursor.weekday == weekday) matches.add(cursor);
      cursor = cursor.addDays(1);
    }
    if (matches.isEmpty) return null;
    final index = ordinal > 0 ? ordinal - 1 : matches.length + ordinal;
    return index >= 0 && index < matches.length ? matches[index] : null;
  }

  Map<String, Object?> toJson() => {'weekday': weekday, 'ordinal': ordinal};

  factory WeekdayOrdinal.fromJson(Map<String, Object?> json) {
    final weekday = json['weekday'];
    final ordinal = json['ordinal'];
    if (weekday is! int || ordinal is! int) {
      throw const FormatException('Invalid weekday ordinal');
    }
    return WeekdayOrdinal(weekday: weekday, ordinal: ordinal);
  }

  @override
  bool operator ==(Object other) =>
      other is WeekdayOrdinal && other.weekday == weekday && other.ordinal == ordinal;

  @override
  int get hashCode => Object.hash(weekday, ordinal);

  static String describe(int weekday, int ordinal) {
    final day = _dayName(weekday);
    final prefix = switch (ordinal) {
      1 => 'First',
      2 => 'Second',
      3 => 'Third',
      4 => 'Fourth',
      5 => 'Fifth',
      -1 => 'Last',
      -2 => 'Second-to-last',
      _ => '${ordinal.abs()}th-from-${ordinal < 0 ? 'last' : 'first'}',
    };
    return '$prefix $day';
  }

  static String _dayName(int weekday) =>
      const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'][weekday - 1];
}

/// A replacement for one occurrence of a recurring entry.
///
/// The original date identifies the occurrence. A moved occurrence carries a
/// [dateOverride]; a time-only change leaves the date alone. The expander
/// applies these rules before placing the entry on the calendar.
class RecurrenceOverride {
  const RecurrenceOverride({
    required this.date,
    this.dateOverride,
    this.startMinute,
    this.endMinute,
    this.allDay,
    this.title,
    this.notes,
  });

  /// Original occurrence date in the entry's stored timezone.
  final LocalDate date;
  final LocalDate? dateOverride;
  final int? startMinute;
  final int? endMinute;
  final bool? allDay;
  final String? title;
  final String? notes;

  LocalDate get effectiveDate => dateOverride ?? date;

  Map<String, Object?> toJson() => {
    'date': date.iso,
    if (dateOverride != null) 'dateOverride': dateOverride!.iso,
    if (startMinute != null) 'startMinute': startMinute,
    if (endMinute != null) 'endMinute': endMinute,
    if (allDay != null) 'allDay': allDay,
    if (title != null) 'title': title,
    if (notes != null) 'notes': notes,
  };

  factory RecurrenceOverride.fromJson(Map<String, Object?> json) {
    final rawDate = json['date'];
    if (rawDate is! String) throw const FormatException('Override is missing its date');
    final rawDateOverride = json['dateOverride'];
    final rawStart = json['startMinute'];
    final rawEnd = json['endMinute'];
    final rawAllDay = json['allDay'];
    final rawTitle = json['title'];
    final rawNotes = json['notes'];
    return RecurrenceOverride(
      date: LocalDate.parse(rawDate),
      dateOverride: rawDateOverride is String ? LocalDate.parse(rawDateOverride) : null,
      startMinute: rawStart is int ? rawStart : null,
      endMinute: rawEnd is int ? rawEnd : null,
      allDay: rawAllDay is bool ? rawAllDay : null,
      title: rawTitle is String ? rawTitle : null,
      notes: rawNotes is String ? rawNotes : null,
    );
  }

  @override
  bool operator ==(Object other) => other is RecurrenceOverride && other.date == date;

  @override
  int get hashCode => date.hashCode;
}

/// A small, explicit recurrence rule.
///
/// The rule is anchored to the entry's first date. It supports daily, weekly,
/// monthly and yearly rules, ordinal weekdays (`1MO`, `-1FR`), negative month
/// days, `BYSETPOS`, skip dates and modified occurrences. Anything more complex
/// is reported by the importers instead of being guessed.
class RecurrenceRule {
  const RecurrenceRule({
    required this.frequency,
    this.interval = 1,
    this.weekdays = const <int>{},
    this.monthDay,
    this.until,
    this.count,
    this.skipDates = const <LocalDate>{},
    this.overrides = const <RecurrenceOverride>[],
    this.ordinalWeekdays = const <WeekdayOrdinal>[],
    this.setPositions = const <int>[],
  }) : assert(interval > 0),
       assert(monthDay == null || (monthDay != 0 && monthDay >= -31 && monthDay <= 31)),
       assert(count == null || count > 0);

  final RecurrenceFrequency frequency;
  final int interval;

  /// ISO weekdays (1 = Monday ... 7 = Sunday), used by weekly and monthly rules.
  final Set<int> weekdays;

  /// Day of the month, used by monthly and yearly rules. Negative values count
  /// from the end: -1 is the last day of the month.
  final int? monthDay;

  /// Last date the rule may produce, inclusive.
  final LocalDate? until;

  /// Maximum number of occurrences, counting the anchor as the first one.
  final int? count;

  /// Explicit dates to remove, the equivalent of iCalendar `EXDATE`.
  final Set<LocalDate> skipDates;

  /// Modified occurrences, the equivalent of iCalendar `RECURRENCE-ID`.
  final List<RecurrenceOverride> overrides;

  /// Ordinal weekday rules for monthly and yearly frequencies.
  final List<WeekdayOrdinal> ordinalWeekdays;

  /// iCalendar `BYSETPOS`: pick these positions from the matching dates in the
  /// period. 1 is first, -1 is last.
  final List<int> setPositions;

  bool get hasAdvancedRules => ordinalWeekdays.isNotEmpty || setPositions.isNotEmpty;

  bool occursOn(LocalDate date, LocalDate anchor) {
    if (date.isBefore(anchor)) return false;
    final limit = until;
    if (limit != null && date.isAfter(limit)) return false;
    if (skipDates.contains(date)) return false;
    if (!_matches(date, anchor)) return false;
    final max = count;
    if (max == null) return true;
    return _ordinal(date, anchor) <= max;
  }

  LocalDate? nextOnOrAfter(LocalDate from, LocalDate anchor) {
    var cursor = LocalDate.max(from, anchor);
    final limit = until;
    if (limit != null && cursor.isAfter(limit)) return null;
    for (var i = 0; i < 366 * 30; i++) {
      if (occursOn(cursor, anchor)) return cursor;
      if (limit != null && cursor.isAfter(limit)) return null;
      cursor = cursor.addDays(1);
    }
    return null;
  }

  List<LocalDate> occurrencesBetween(LocalDate start, LocalDate end, LocalDate anchor) {
    final from = LocalDate.max(start, anchor);
    final limit = until;
    final to = limit == null ? end : LocalDate.min(end, limit);
    if (from.isAfter(to)) return const <LocalDate>[];
    final result = <LocalDate>[];
    var cursor = from;
    while (cursor.isOnOrBefore(to)) {
      if (occursOn(cursor, anchor)) result.add(cursor);
      cursor = cursor.addDays(1);
    }
    return result;
  }

  bool _matches(LocalDate date, LocalDate anchor) {
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return date.differenceInDays(anchor) % interval == 0;
      case RecurrenceFrequency.weekly:
        if (!_periodMatches(date, anchor)) return false;
        if (setPositions.isNotEmpty) return _matchesSetPosition(date, anchor, weekly: true);
        final days = weekdays.isEmpty ? <int>{anchor.weekday} : weekdays;
        return days.contains(date.weekday);
      case RecurrenceFrequency.monthly:
        if (!_monthIntervalMatches(date, anchor)) return false;
        return _monthlyMatches(date, anchor);
      case RecurrenceFrequency.yearly:
        if ((date.year - anchor.year) % interval != 0) return false;
        if (ordinalWeekdays.isNotEmpty) {
          return ordinalWeekdays.any(
            (rule) =>
                rule.weekday == date.weekday && rule.dateIn(LocalDate(date.year, anchor.month, 1)) == date,
          );
        }
        if (setPositions.isNotEmpty) return _matchesSetPosition(date, anchor, weekly: false);
        if (date.month != anchor.month) return false;
        final targetDay = monthDay ?? anchor.day;
        final resolved = targetDay < 0 ? date.daysInMonth + 1 + targetDay : targetDay;
        return date.day == _clampedDay(date, resolved);
    }
  }

  bool _weeklyIntervalMatches(LocalDate date, LocalDate anchor) {
    final weeks = date.mondayOfWeek.differenceInDays(anchor.mondayOfWeek) ~/ 7;
    return weeks % interval == 0;
  }

  bool _periodMatches(LocalDate date, LocalDate anchor) => _weeklyIntervalMatches(date, anchor);

  bool _monthIntervalMatches(LocalDate date, LocalDate anchor) =>
      date.differenceInMonths(anchor) % interval == 0;

  bool _monthlyMatches(LocalDate date, LocalDate anchor) {
    if (ordinalWeekdays.isNotEmpty) {
      return ordinalWeekdays.any(
        (rule) => rule.weekday == date.weekday && rule.dateIn(LocalDate(date.year, date.month, 1)) == date,
      );
    }
    if (setPositions.isNotEmpty) return _matchesSetPosition(date, anchor, weekly: false);
    final targetDay = monthDay ?? anchor.day;
    final resolved = targetDay < 0 ? date.daysInMonth + 1 + targetDay : targetDay;
    return date.day == _clampedDay(date, resolved);
  }

  bool _matchesSetPosition(LocalDate date, LocalDate anchor, {required bool weekly}) {
    final days = weekdays.isEmpty ? <int>{anchor.weekday} : weekdays;
    final candidates = <LocalDate>[];
    if (weekly) {
      var cursor = date.mondayOfWeek;
      for (var i = 0; i < 7; i++) {
        if (days.contains(cursor.weekday)) candidates.add(cursor);
        cursor = cursor.addDays(1);
      }
    } else if (frequency == RecurrenceFrequency.yearly) {
      var cursor = LocalDate(date.year, anchor.month, 1);
      while (cursor.month == anchor.month) {
        if (days.contains(cursor.weekday)) candidates.add(cursor);
        cursor = cursor.addDays(1);
      }
    } else {
      var cursor = LocalDate(date.year, date.month, 1);
      while (cursor.month == date.month) {
        if (days.contains(cursor.weekday)) candidates.add(cursor);
        cursor = cursor.addDays(1);
      }
    }
    final selected = <LocalDate>{};
    for (final position in setPositions) {
      final index = position > 0 ? position - 1 : candidates.length + position;
      if (index >= 0 && index < candidates.length) selected.add(candidates[index]);
    }
    return selected.contains(date);
  }

  int _clampedDay(LocalDate date, int targetDay) =>
      targetDay > date.daysInMonth ? date.daysInMonth : targetDay;

  /// How many occurrences the rule has produced up to and including [date].
  ///
  /// Constant time for the fixed shapes. Advanced rules fall back to a bounded
  /// scan, because ordinal and set-position rules are rare and a personal
  /// planner never needs decades of history at once.
  int _ordinal(LocalDate date, LocalDate anchor) {
    if (hasAdvancedRules) {
      var count = 0;
      var cursor = anchor;
      while (cursor.isOnOrBefore(date)) {
        if (_matches(cursor, anchor)) count++;
        cursor = cursor.addDays(1);
      }
      return count;
    }
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return date.differenceInDays(anchor) ~/ interval + 1;
      case RecurrenceFrequency.weekly:
        final days = weekdays.isEmpty ? <int>{anchor.weekday} : weekdays;
        final weeks = date.mondayOfWeek.differenceInDays(anchor.mondayOfWeek) ~/ 7;
        if (weeks == 0) {
          return days.where((day) => day >= anchor.weekday && day <= date.weekday).length;
        }
        var total = days.where((day) => day >= anchor.weekday).length;
        total += ((weeks - 1) ~/ interval) * days.length;
        if (weeks % interval == 0) {
          total += days.where((day) => day <= date.weekday).length;
        }
        return total;
      case RecurrenceFrequency.monthly:
        return date.differenceInMonths(anchor) ~/ interval + 1;
      case RecurrenceFrequency.yearly:
        return (date.year - anchor.year) ~/ interval + 1;
    }
  }

  RecurrenceRule copyWith({
    RecurrenceFrequency? frequency,
    int? interval,
    Set<int>? weekdays,
    Object? monthDay = _unset,
    Object? until = _unset,
    Object? count = _unset,
    Set<LocalDate>? skipDates,
    List<RecurrenceOverride>? overrides,
    List<WeekdayOrdinal>? ordinalWeekdays,
    List<int>? setPositions,
  }) => RecurrenceRule(
    frequency: frequency ?? this.frequency,
    interval: interval ?? this.interval,
    weekdays: weekdays ?? this.weekdays,
    monthDay: identical(monthDay, _unset) ? this.monthDay : monthDay as int?,
    until: identical(until, _unset) ? this.until : until as LocalDate?,
    count: identical(count, _unset) ? this.count : count as int?,
    skipDates: skipDates ?? this.skipDates,
    overrides: overrides ?? this.overrides,
    ordinalWeekdays: ordinalWeekdays ?? this.ordinalWeekdays,
    setPositions: setPositions ?? this.setPositions,
  );

  static const _unset = Object();

  Map<String, Object?> toJson() => <String, Object?>{
    'frequency': frequency.name,
    'interval': interval,
    if (weekdays.isNotEmpty) 'weekdays': (weekdays.toList()..sort()),
    if (monthDay != null) 'monthDay': monthDay,
    if (until != null) 'until': until!.iso,
    if (count != null) 'count': count,
    if (skipDates.isNotEmpty) 'skipDates': (skipDates.map((date) => date.iso).toList()..sort()),
    if (overrides.isNotEmpty) 'overrides': [for (final override in overrides) override.toJson()],
    if (ordinalWeekdays.isNotEmpty) 'ordinalWeekdays': [for (final rule in ordinalWeekdays) rule.toJson()],
    if (setPositions.isNotEmpty) 'setPositions': setPositions,
  };

  factory RecurrenceRule.fromJson(Map<String, Object?> json) {
    final frequencyName = json['frequency'];
    if (frequencyName is! String) {
      throw const FormatException('Recurrence is missing a frequency');
    }
    final frequency = RecurrenceFrequency.values.firstWhere(
      (value) => value.name == frequencyName,
      orElse: () => throw FormatException('Unknown recurrence frequency: $frequencyName'),
    );

    final rawWeekdays = json['weekdays'];
    final weekdays = <int>{};
    if (rawWeekdays != null) {
      if (rawWeekdays is! List) {
        throw const FormatException('weekdays must be a list');
      }
      for (final value in rawWeekdays) {
        if (value is! int || value < 1 || value > 7) {
          throw const FormatException('weekdays must be between 1 and 7');
        }
        weekdays.add(value);
      }
    }

    final rawMonthDay = json['monthDay'];
    final rawCount = json['count'];
    final rawUntil = json['until'];
    final rawSkipDates = json['skipDates'];
    final skipDates = <LocalDate>{};
    if (rawSkipDates is List) {
      for (final value in rawSkipDates) {
        if (value is String) skipDates.add(LocalDate.parse(value));
      }
    }
    final rawOverrides = json['overrides'];
    final overrides = <RecurrenceOverride>[];
    if (rawOverrides is List) {
      for (final value in rawOverrides) {
        if (value is Map) {
          overrides.add(RecurrenceOverride.fromJson(Map<String, Object?>.from(value)));
        }
      }
    }
    final rawOrdinals = json['ordinalWeekdays'];
    final ordinals = <WeekdayOrdinal>[];
    if (rawOrdinals is List) {
      for (final value in rawOrdinals) {
        if (value is Map) {
          ordinals.add(WeekdayOrdinal.fromJson(Map<String, Object?>.from(value)));
        }
      }
    }
    final rawPositions = json['setPositions'];
    final positions = <int>[];
    if (rawPositions is List) {
      for (final value in rawPositions) {
        if (value is int && value != 0) positions.add(value);
      }
    }

    return RecurrenceRule(
      frequency: frequency,
      interval: json['interval'] as int? ?? 1,
      weekdays: weekdays,
      monthDay: rawMonthDay is int ? rawMonthDay : null,
      until: rawUntil is String ? LocalDate.parse(rawUntil) : null,
      count: rawCount is int ? rawCount : null,
      skipDates: skipDates,
      overrides: overrides,
      ordinalWeekdays: ordinals,
      setPositions: positions,
    );
  }

  /// Short human label for lists and the entry editor.
  String describe() {
    final single = interval == 1;
    switch (frequency) {
      case RecurrenceFrequency.daily:
        return single ? 'Every day' : 'Every $interval days';
      case RecurrenceFrequency.weekly:
        final days = weekdays.isEmpty ? '' : ' on ${(weekdays.toList()..sort()).map(_shortDay).join(', ')}';
        return single ? 'Every week$days' : 'Every $interval weeks$days';
      case RecurrenceFrequency.monthly:
        if (ordinalWeekdays.isNotEmpty) {
          final label = ordinalWeekdays
              .map((rule) => WeekdayOrdinal.describe(rule.weekday, rule.ordinal))
              .join(', ');
          return single ? 'Monthly on $label' : 'Every $interval months on $label';
        }
        final day = monthDay == null ? '' : ' on ${_dayLabel(monthDay!)}';
        return single ? 'Every month$day' : 'Every $interval months$day';
      case RecurrenceFrequency.yearly:
        return single ? 'Every year' : 'Every $interval years';
    }
  }

  static String _dayLabel(int day) {
    if (day > 0) return 'day $day';
    if (day == -1) return 'the last day';
    return '${day.abs()} days before the end';
  }

  static String _shortDay(int weekday) =>
      const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday - 1];
}

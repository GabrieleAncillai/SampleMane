import 'local_date.dart';

/// How often a recurring entry comes back.
enum RecurrenceFrequency { daily, weekly, monthly, yearly }

/// A small, explicit recurrence rule.
///
/// The rule is anchored to the entry's first date. It deliberately supports
/// only the shapes a personal planner needs; "last Friday of the month" and
/// similar ordinal rules can be added later without changing existing data.
class RecurrenceRule {
  const RecurrenceRule({
    required this.frequency,
    this.interval = 1,
    this.weekdays = const <int>{},
    this.monthDay,
    this.until,
    this.count,
  }) : assert(interval > 0),
       assert(monthDay == null || (monthDay >= 1 && monthDay <= 31)),
       assert(count == null || count > 0);

  final RecurrenceFrequency frequency;
  final int interval;

  /// ISO weekdays (1 = Monday ... 7 = Sunday), used by weekly rules.
  final Set<int> weekdays;

  /// Day of the month, used by monthly rules. Defaults to the anchor's day.
  final int? monthDay;

  /// Last date the rule may produce, inclusive.
  final LocalDate? until;

  /// Maximum number of occurrences, counting the anchor as the first one.
  final int? count;

  bool occursOn(LocalDate date, LocalDate anchor) {
    if (date.isBefore(anchor)) return false;
    final limit = until;
    if (limit != null && date.isAfter(limit)) return false;
    if (!_matches(date, anchor)) return false;
    final max = count;
    if (max == null) return true;
    return _countUpTo(date, anchor) <= max;
  }

  LocalDate? nextOnOrAfter(LocalDate from, LocalDate anchor) {
    var cursor = LocalDate.max(from, anchor);
    final limit = until;
    if (limit != null && cursor.isAfter(limit)) return null;
    // A generous bound: enough for any personal rule, cheap enough to run.
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
        final days = weekdays.isEmpty ? <int>{anchor.weekday} : weekdays;
        if (!days.contains(date.weekday)) return false;
        final weeks = date.mondayOfWeek.differenceInDays(anchor.mondayOfWeek) ~/ 7;
        return weeks % interval == 0;
      case RecurrenceFrequency.monthly:
        final targetDay = monthDay ?? anchor.day;
        if (date.day != _clampedDay(date, targetDay)) return false;
        return date.differenceInMonths(anchor) % interval == 0;
      case RecurrenceFrequency.yearly:
        if (date.month != anchor.month) return false;
        if (date.day != _clampedDay(date, anchor.day)) return false;
        return (date.year - anchor.year) % interval == 0;
    }
  }

  int _clampedDay(LocalDate date, int targetDay) =>
      targetDay > date.daysInMonth ? date.daysInMonth : targetDay;

  int _countUpTo(LocalDate date, LocalDate anchor) {
    var total = 0;
    var cursor = anchor;
    final days = date.differenceInDays(anchor);
    for (var i = 0; i <= days; i++) {
      if (_matches(cursor, anchor)) total++;
      cursor = cursor.addDays(1);
    }
    return total;
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'frequency': frequency.name,
    'interval': interval,
    if (weekdays.isNotEmpty) 'weekdays': (weekdays.toList()..sort()),
    if (monthDay != null) 'monthDay': monthDay,
    if (until != null) 'until': until!.iso,
    if (count != null) 'count': count,
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

    return RecurrenceRule(
      frequency: frequency,
      interval: json['interval'] as int? ?? 1,
      weekdays: weekdays,
      monthDay: rawMonthDay is int ? rawMonthDay : null,
      until: rawUntil is String ? LocalDate.parse(rawUntil) : null,
      count: rawCount is int ? rawCount : null,
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
        final day = monthDay == null ? '' : ' on day $monthDay';
        return single ? 'Every month$day' : 'Every $interval months$day';
      case RecurrenceFrequency.yearly:
        return single ? 'Every year' : 'Every $interval years';
    }
  }

  static String _shortDay(int weekday) =>
      const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday - 1];
}

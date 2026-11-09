import 'local_date.dart';
import 'time.dart';

/// One shift inside a repeating cycle.
///
/// Minutes are counted from midnight in the pattern's timezone. An end past
/// 1440 means the shift crosses midnight (22:00 to 02:00 is 1320 to 1560).
class ShiftSlot {
  const ShiftSlot({
    required this.dayIndex,
    this.label = '',
    required this.startMinute,
    required this.endMinute,
  }) : assert(dayIndex >= 0),
       assert(startMinute >= 0 && startMinute < 1440),
       assert(endMinute > startMinute && endMinute <= 2880);

  final int dayIndex;
  final String label;
  final int startMinute;
  final int endMinute;

  bool get crossesMidnight => endMinute >= 1440;

  int get durationMinutes => endMinute - startMinute;

  /// Stable identity for this slot inside a pattern. Checklist completions use
  /// it so two slots on the same day stay independent.
  String get key => '$dayIndex:$startMinute:$endMinute:$label';

  ShiftSlot copyWith({int? dayIndex, String? label, int? startMinute, int? endMinute}) => ShiftSlot(
    dayIndex: dayIndex ?? this.dayIndex,
    label: label ?? this.label,
    startMinute: startMinute ?? this.startMinute,
    endMinute: endMinute ?? this.endMinute,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'dayIndex': dayIndex,
    'label': label,
    'startMinute': startMinute,
    'endMinute': endMinute,
  };

  factory ShiftSlot.fromJson(Map<String, Object?> json) {
    final dayIndex = json['dayIndex'];
    final label = json['label'];
    final startMinute = json['startMinute'];
    final endMinute = json['endMinute'];
    if (dayIndex is! int || label is! String || startMinute is! int || endMinute is! int) {
      throw const FormatException('Invalid shift slot');
    }
    return ShiftSlot(dayIndex: dayIndex, label: label, startMinute: startMinute, endMinute: endMinute);
  }
}

enum ShiftExceptionType { free, override, extra }

/// A date-level change to a shift pattern.
///
/// `free` removes every shift on the date. `override` replaces the cycle
/// slots for the date. `extra` adds a shift without removing the cycle slots.
class ShiftException {
  const ShiftException({
    required this.date,
    required this.type,
    this.startMinute,
    this.endMinute,
    this.note = '',
  });

  final LocalDate date;
  final ShiftExceptionType type;
  final int? startMinute;
  final int? endMinute;
  final String note;

  bool get hasTimes => startMinute != null && endMinute != null;

  Map<String, Object?> toJson() => <String, Object?>{
    'date': date.iso,
    'type': type.name,
    if (startMinute != null) 'startMinute': startMinute,
    if (endMinute != null) 'endMinute': endMinute,
    if (note.isNotEmpty) 'note': note,
  };

  factory ShiftException.fromJson(Map<String, Object?> json) {
    final rawDate = json['date'];
    final rawType = json['type'];
    if (rawDate is! String || rawType is! String) {
      throw const FormatException('Invalid shift exception');
    }
    final type = ShiftExceptionType.values.firstWhere(
      (value) => value.name == rawType,
      orElse: () => throw FormatException('Unknown shift exception type: $rawType'),
    );
    final startMinute = json['startMinute'];
    final endMinute = json['endMinute'];
    final note = json['note'];
    return ShiftException(
      date: LocalDate.parse(rawDate),
      type: type,
      startMinute: startMinute is int ? startMinute : null,
      endMinute: endMinute is int ? endMinute : null,
      note: note is String ? note : '',
    );
  }
}

/// A repeating work schedule such as a two-week early/late rotation.
///
/// A weekly fixed schedule is just a cycle of 7 days. A pattern may have zero,
/// one or several slots on the same cycle day, and its slots may cross
/// midnight. Shifts are context, not tasks: they are rendered as background
/// blocks and never checked off.
class ShiftPattern {
  ShiftPattern({
    required this.id,
    required this.spaceId,
    required this.name,
    required this.timeZone,
    required this.cycleDays,
    required this.anchorDate,
    List<ShiftSlot> slots = const <ShiftSlot>[],
    List<ShiftException> exceptions = const <ShiftException>[],
    Set<String> tagIds = const <String>{},
    this.commuteMinutes,
    this.windDownMinutes,
    this.enabled = true,
  }) : slots = List.unmodifiable(slots),
       exceptions = List.unmodifiable(exceptions),
       tagIds = Set.unmodifiable(tagIds) {
    if (cycleDays < 1) {
      throw ArgumentError.value(cycleDays, 'cycleDays', 'must be at least 1');
    }
    if (timeZone.trim().isEmpty) {
      throw ArgumentError.value(timeZone, 'timeZone', 'must not be empty');
    }
    for (final slot in slots) {
      if (slot.dayIndex >= cycleDays) {
        throw ArgumentError.value(slot.dayIndex, 'slots', 'dayIndex must be smaller than cycleDays');
      }
    }
    for (final exception in exceptions) {
      _checkException(exception);
    }
    if (commuteMinutes != null && (commuteMinutes! < 0 || commuteMinutes! > 24 * 60)) {
      throw ArgumentError.value(commuteMinutes, 'commuteMinutes', 'must be between 0 and 1440');
    }
    if (windDownMinutes != null && (windDownMinutes! < 0 || windDownMinutes! > 24 * 60)) {
      throw ArgumentError.value(windDownMinutes, 'windDownMinutes', 'must be between 0 and 1440');
    }
  }

  final String id;
  final String spaceId;
  final String name;

  /// IANA timezone the wall-clock slot times are defined in.
  final String timeZone;

  final int cycleDays;
  final LocalDate anchorDate;
  final List<ShiftSlot> slots;
  final List<ShiftException> exceptions;

  /// Tags attached to this pattern, such as a job. The join rows live in
  /// `shift_pattern_tag_records`.
  final Set<String> tagIds;

  /// Per-pattern sleep overrides in minutes. Null means use the global buffer.
  final int? commuteMinutes;
  final int? windDownMinutes;

  final bool enabled;

  /// The cycle position of [date], always in `0 .. cycleDays - 1`.
  int cycleIndexFor(LocalDate date) {
    final offset = date.differenceInDays(anchorDate);
    return ((offset % cycleDays) + cycleDays) % cycleDays;
  }

  /// The slots for [date] after applying exceptions.
  ///
  /// Precedence: a `free` exception empties the day, then `override` rows
  /// replace the cycle slots, then `extra` rows are added.
  List<ShiftSlot> slotsFor(LocalDate date) {
    if (!enabled) return const <ShiftSlot>[];

    final onDate = exceptions.where((exception) => exception.date == date);
    if (onDate.any((exception) => exception.type == ShiftExceptionType.free)) {
      return const <ShiftSlot>[];
    }

    final overrides = onDate.where((exception) => exception.type == ShiftExceptionType.override);
    final extras = onDate.where((exception) => exception.type == ShiftExceptionType.extra);
    final index = cycleIndexFor(date);

    final result =
        <ShiftSlot>[
          if (overrides.isNotEmpty)
            ...overrides.map((exception) => _slotFor(exception, index))
          else
            ...slots.where((slot) => slot.dayIndex == index),
          ...extras.map((exception) => _slotFor(exception, index)),
        ]..sort((a, b) {
          final byStart = a.startMinute.compareTo(b.startMinute);
          if (byStart != 0) return byStart;
          final byEnd = a.endMinute.compareTo(b.endMinute);
          if (byEnd != 0) return byEnd;
          return a.label.compareTo(b.label);
        });
    return result;
  }

  /// Expands the pattern between [start] and [end] inclusive.
  ///
  /// Occurrence dates are in the pattern's timezone. [viewerTimeZone] only
  /// changes the reported display date; it never changes the schedule itself.
  List<ShiftOccurrence> occurrencesBetween(LocalDate start, LocalDate end, {String? viewerTimeZone}) {
    if (!enabled || start.isAfter(end)) return const <ShiftOccurrence>[];

    final viewer = viewerTimeZone ?? timeZone;
    final result = <ShiftOccurrence>[];
    var cursor = start;
    while (cursor.isOnOrBefore(end)) {
      for (final slot in slotsFor(cursor)) {
        final startAt = instantAt(cursor, slot.startMinute, timeZone);
        final endAt = instantAt(cursor, slot.endMinute, timeZone);
        result.add(
          ShiftOccurrence(
            date: cursor,
            displayDate: localDateAt(startAt, viewer),
            pattern: this,
            slot: slot,
            startAt: startAt,
            endAt: endAt,
          ),
        );
      }
      cursor = cursor.addDays(1);
    }
    result.sort((a, b) {
      final byDate = a.displayDate.compareTo(b.displayDate);
      if (byDate != 0) return byDate;
      return a.startAt.compareTo(b.startAt);
    });
    return result;
  }

  /// Every pair of shifts that overlap, including overnight and exception
  /// combinations. Returns an empty list when the pattern is valid.
  ///
  /// [horizonDays] defaults to two full cycles from the anchor. Every
  /// exception date is checked as well, with the days around it, because an
  /// overnight shift can collide with the previous or next day.
  List<ShiftConflict> findConflicts({int horizonDays = 0}) {
    if (!enabled) return const <ShiftConflict>[];

    final span = horizonDays > 0 ? horizonDays : cycleDays * 2;
    final dates = <LocalDate>{};
    for (var offset = 0; offset < span; offset++) {
      dates.add(anchorDate.addDays(offset));
    }
    for (final exception in exceptions) {
      dates
        ..add(exception.date.addDays(-1))
        ..add(exception.date)
        ..add(exception.date.addDays(1));
    }

    final placed = <_PlacedShift>[];
    final sortedDates = dates.toList()..sort();
    for (final date in sortedDates) {
      final dayOffset = date.differenceInDays(anchorDate);
      for (final slot in slotsFor(date)) {
        placed.add(
          _PlacedShift(
            date: date,
            slot: slot,
            start: dayOffset * 1440 + slot.startMinute,
            end: dayOffset * 1440 + slot.endMinute,
          ),
        );
      }
    }
    placed.sort((a, b) => a.start.compareTo(b.start));

    final conflicts = <ShiftConflict>[];
    for (var i = 0; i < placed.length; i++) {
      for (var j = i + 1; j < placed.length; j++) {
        if (placed[j].start >= placed[i].end) break;
        conflicts.add(
          ShiftConflict(
            firstDate: placed[i].date,
            firstSlot: placed[i].slot,
            secondDate: placed[j].date,
            secondSlot: placed[j].slot,
          ),
        );
      }
    }
    return conflicts;
  }

  ShiftPattern copyWith({
    String? name,
    String? timeZone,
    int? cycleDays,
    LocalDate? anchorDate,
    List<ShiftSlot>? slots,
    List<ShiftException>? exceptions,
    Set<String>? tagIds,
    Object? commuteMinutes = _unset,
    Object? windDownMinutes = _unset,
    bool? enabled,
  }) => ShiftPattern(
    id: id,
    spaceId: spaceId,
    name: name ?? this.name,
    timeZone: timeZone ?? this.timeZone,
    cycleDays: cycleDays ?? this.cycleDays,
    anchorDate: anchorDate ?? this.anchorDate,
    slots: slots ?? this.slots,
    exceptions: exceptions ?? this.exceptions,
    tagIds: tagIds ?? this.tagIds,
    commuteMinutes: identical(commuteMinutes, _unset) ? this.commuteMinutes : commuteMinutes as int?,
    windDownMinutes: identical(windDownMinutes, _unset) ? this.windDownMinutes : windDownMinutes as int?,
    enabled: enabled ?? this.enabled,
  );

  static const _unset = Object();

  static ShiftSlot _slotFor(ShiftException exception, int dayIndex) => ShiftSlot(
    dayIndex: dayIndex,
    label: exception.note,
    startMinute: exception.startMinute!,
    endMinute: exception.endMinute!,
  );

  static void _checkException(ShiftException exception) {
    if (exception.type == ShiftExceptionType.free) {
      if (exception.startMinute != null || exception.endMinute != null) {
        throw ArgumentError('A free day cannot carry shift times');
      }
      return;
    }
    final start = exception.startMinute;
    final end = exception.endMinute;
    if (start == null || end == null || start < 0 || start >= 1440 || end <= start || end > 2880) {
      throw ArgumentError('An override or extra shift needs valid start and end times');
    }
  }
}

class ShiftOccurrence {
  const ShiftOccurrence({
    required this.date,
    required this.displayDate,
    required this.pattern,
    required this.slot,
    required this.startAt,
    required this.endAt,
  });

  /// Date in the pattern's timezone.
  final LocalDate date;

  /// Date in the viewer's timezone.
  final LocalDate displayDate;

  final ShiftPattern pattern;
  final ShiftSlot slot;
  final DateTime startAt;
  final DateTime endAt;

  /// Stable per-slot checklist key for this occurrence.
  String get slotKey => slot.key;
}

/// Two shifts that occupy the same time.
class ShiftConflict {
  const ShiftConflict({
    required this.firstDate,
    required this.firstSlot,
    required this.secondDate,
    required this.secondSlot,
  });

  final LocalDate firstDate;
  final ShiftSlot firstSlot;
  final LocalDate secondDate;
  final ShiftSlot secondSlot;
}

class _PlacedShift {
  const _PlacedShift({required this.date, required this.slot, required this.start, required this.end});

  final LocalDate date;
  final ShiftSlot slot;
  final int start;
  final int end;
}

import 'local_date.dart';

/// One shift inside a repeating cycle.
///
/// Minutes are counted from midnight. An end past 1440 means the shift crosses
/// midnight (for example 22:00 to 02:00 is 1320 to 1560).
class ShiftSlot {
  const ShiftSlot({
    required this.dayIndex,
    required this.label,
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

/// A repeating work schedule such as a two-week early/late rotation.
///
/// A weekly fixed schedule is just a cycle of 7 days. Shifts are context, not
/// tasks: they are rendered as background blocks and never checked off.
class ShiftPattern {
  ShiftPattern({
    required this.id,
    required this.spaceId,
    required this.name,
    required this.cycleDays,
    required this.anchorDate,
    required this.slots,
    this.enabled = true,
  }) {
    if (cycleDays < 1) {
      throw ArgumentError.value(cycleDays, 'cycleDays', 'must be at least 1');
    }
    final seen = <int>{};
    for (final slot in slots) {
      if (slot.dayIndex >= cycleDays) {
        throw ArgumentError.value(slot.dayIndex, 'slots', 'dayIndex must be smaller than cycleDays');
      }
      if (!seen.add(slot.dayIndex)) {
        throw ArgumentError.value(slot.dayIndex, 'slots', 'only one shift per cycle day is supported');
      }
    }
  }

  final String id;
  final String spaceId;
  final String name;
  final int cycleDays;
  final LocalDate anchorDate;
  final List<ShiftSlot> slots;
  final bool enabled;

  ShiftSlot? slotFor(LocalDate date) {
    if (!enabled) return null;
    final index = date.differenceInDays(anchorDate) % cycleDays;
    for (final slot in slots) {
      if (slot.dayIndex == index) return slot;
    }
    return null;
  }

  List<ShiftOccurrence> occurrencesBetween(LocalDate start, LocalDate end) {
    if (!enabled || start.isAfter(end)) return const <ShiftOccurrence>[];
    final result = <ShiftOccurrence>[];
    var cursor = start;
    while (cursor.isOnOrBefore(end)) {
      final slot = slotFor(cursor);
      if (slot != null) {
        result.add(ShiftOccurrence(date: cursor, pattern: this, slot: slot));
      }
      cursor = cursor.addDays(1);
    }
    return result;
  }
}

class ShiftOccurrence {
  const ShiftOccurrence({required this.date, required this.pattern, required this.slot});

  final LocalDate date;
  final ShiftPattern pattern;
  final ShiftSlot slot;
}

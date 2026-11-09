import 'local_date.dart';
import 'recurrence.dart';

enum EntryKind { task, event, obligation, deadline }

enum EntryStatus { open, done, cancelled }

/// One thing on the plan.
///
/// Times are wall-clock: [date] plus [startMinute] and [endMinute] from
/// midnight. That keeps a 10:00 shift at 10:00 across time zones.
class Entry {
  const Entry({
    required this.id,
    required this.spaceId,
    required this.title,
    this.notes = '',
    this.kind = EntryKind.task,
    this.date,
    this.endDate,
    this.startMinute,
    this.endMinute,
    this.allDay = false,
    this.status = EntryStatus.open,
    this.recurrence,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String spaceId;
  final String title;
  final String notes;
  final EntryKind kind;

  /// First date of the entry. Null means unscheduled.
  final LocalDate? date;

  /// Last date for a multi-day event. Null means a single day.
  final LocalDate? endDate;

  /// Minutes from midnight, null for an all-day entry.
  final int? startMinute;
  final int? endMinute;

  final bool allDay;
  final EntryStatus status;
  final RecurrenceRule? recurrence;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  bool get isRecurring => recurrence != null;

  bool get isDone => status == EntryStatus.done;

  /// Whether this entry appears on [day].
  ///
  /// Recurring entries are expanded by their start dates. A multi-day
  /// recurring entry is not supported yet; that needs an explicit end offset
  /// per occurrence, which is a later decision.
  bool occursOn(LocalDate day) {
    if (deletedAt != null || status == EntryStatus.cancelled) return false;
    final anchor = date;
    if (anchor == null) return false;
    if (recurrence != null) return recurrence!.occursOn(day, anchor);
    final last = endDate ?? anchor;
    return day.isOnOrAfter(anchor) && day.isOnOrBefore(last);
  }

  Entry copyWith({
    String? title,
    String? notes,
    EntryKind? kind,
    LocalDate? date,
    LocalDate? endDate,
    int? startMinute,
    int? endMinute,
    bool? allDay,
    EntryStatus? status,
    RecurrenceRule? recurrence,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) => Entry(
    id: id,
    spaceId: spaceId,
    title: title ?? this.title,
    notes: notes ?? this.notes,
    kind: kind ?? this.kind,
    date: date ?? this.date,
    endDate: endDate ?? this.endDate,
    startMinute: startMinute ?? this.startMinute,
    endMinute: endMinute ?? this.endMinute,
    allDay: allDay ?? this.allDay,
    status: status ?? this.status,
    recurrence: recurrence ?? this.recurrence,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt ?? this.deletedAt,
  );
}

/// An entry placed on a specific date by the recurrence expander.
class EntryOccurrence {
  const EntryOccurrence({required this.date, required this.entry, this.completed = false});

  final LocalDate date;
  final Entry entry;

  /// Completion is per occurrence for recurring entries, so checking this
  /// week's bins does not check next week's.
  final bool completed;
}

import 'local_date.dart';
import 'recurrence.dart';
import 'time.dart';

enum EntryKind { task, event, obligation, deadline }

enum EntryStatus { open, done, cancelled }

/// One thing on the plan.
///
/// Timed entries keep the wall-clock [date], [startMinute] and [endMinute] in
/// [timeZone], plus the resolved UTC anchor instants [startAt] and [endAt].
/// The wall-clock fields are the recurrence template; the instants are what
/// the app shows, schedules and syncs.
///
/// All-day entries keep only [date] (and optional [endDate]). A date is not an
/// instant: a birthday or a tax deadline must not shift by a day when the
/// device timezone changes.
class Entry {
  Entry({
    required this.id,
    required this.spaceId,
    required this.title,
    this.notes = '',
    this.kind = EntryKind.task,
    this.date,
    this.endDate,
    this.startMinute,
    this.endMinute,
    this.timeZone,
    this.tagIds = const <String>{},
    this.allDay = false,
    this.status = EntryStatus.open,
    this.recurrence,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    DateTime? startAt,
    DateTime? endAt,
  }) : startAt = startAt ?? _resolve(date, startMinute, timeZone, allDay),
       endAt = endAt ?? _resolve(date, endMinute, timeZone, allDay) {
    _check();
  }

  static const _unset = Object();

  final String id;
  final String spaceId;
  final String title;
  final String notes;
  final EntryKind kind;

  /// Anchor date in the entry's own timezone. Null means unscheduled.
  final LocalDate? date;

  /// Last date for a multi-day all-day entry.
  final LocalDate? endDate;

  /// Local minutes from midnight in [timeZone], null for an all-day entry.
  /// An end of 1440 or more means the entry crosses midnight.
  final int? startMinute;
  final int? endMinute;

  /// IANA timezone the wall-clock fields are defined in. Null for all-day.
  final String? timeZone;

  /// Tags attached to this entry. The join rows live in `entry_tags`.
  final Set<String> tagIds;

  /// Resolved anchor instants in UTC. Null for all-day or unscheduled entries.
  final DateTime? startAt;
  final DateTime? endAt;

  final bool allDay;
  final EntryStatus status;
  final RecurrenceRule? recurrence;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  bool get isRecurring => recurrence != null;

  bool get isDone => status == EntryStatus.done;

  bool get isTimed => !allDay && date != null && startMinute != null;

  /// The date this entry appears on when viewed in [viewerTimeZone].
  ///
  /// All-day entries return their stored date unchanged. Timed entries return
  /// the device-local date of their start instant, so travelling can move
  /// them by a day.
  LocalDate displayDateIn(String viewerTimeZone) {
    final anchor = date;
    if (anchor == null) {
      throw StateError('An unscheduled entry has no display date');
    }
    final start = startAt;
    return start == null ? anchor : localDateAt(start, viewerTimeZone);
  }

  /// Whether this entry appears on [day] in its stored timezone.
  ///
  /// Recurring entries are expanded by their start dates. A multi-day
  /// recurring entry is not supported; that needs an explicit end offset per
  /// occurrence, which is a later decision.
  bool occursOn(LocalDate day) {
    if (deletedAt != null || status == EntryStatus.cancelled) return false;
    final anchor = date;
    if (anchor == null) return false;
    if (recurrence != null) return recurrence!.occursOn(day, anchor);
    final last = allDay ? (endDate ?? anchor) : anchor;
    return day.isOnOrAfter(anchor) && day.isOnOrBefore(last);
  }

  Entry copyWith({
    String? title,
    String? notes,
    EntryKind? kind,
    Object? date = _unset,
    Object? endDate = _unset,
    Object? startMinute = _unset,
    Object? endMinute = _unset,
    Object? timeZone = _unset,
    Set<String>? tagIds,
    bool? allDay,
    EntryStatus? status,
    Object? recurrence = _unset,
    DateTime? updatedAt,
    Object? deletedAt = _unset,
  }) => Entry(
    id: id,
    spaceId: spaceId,
    title: title ?? this.title,
    notes: notes ?? this.notes,
    kind: kind ?? this.kind,
    date: identical(date, _unset) ? this.date : date as LocalDate?,
    endDate: identical(endDate, _unset) ? this.endDate : endDate as LocalDate?,
    startMinute: identical(startMinute, _unset) ? this.startMinute : startMinute as int?,
    endMinute: identical(endMinute, _unset) ? this.endMinute : endMinute as int?,
    timeZone: identical(timeZone, _unset) ? this.timeZone : timeZone as String?,
    tagIds: tagIds ?? this.tagIds,
    allDay: allDay ?? this.allDay,
    status: status ?? this.status,
    recurrence: identical(recurrence, _unset) ? this.recurrence : recurrence as RecurrenceRule?,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: identical(deletedAt, _unset) ? this.deletedAt : deletedAt as DateTime?,
  );

  static DateTime? _resolve(LocalDate? date, int? minute, String? timeZone, bool allDay) {
    if (allDay || date == null || minute == null || timeZone == null) {
      return null;
    }
    return instantAt(date, minute, timeZone);
  }

  void _check() {
    final anchor = date;
    if (allDay) {
      if (timeZone != null || startMinute != null || endMinute != null) {
        throw ArgumentError('An all-day entry cannot carry a time or timezone');
      }
      if (startAt != null || endAt != null) {
        throw ArgumentError('An all-day entry cannot carry an instant');
      }
      if (anchor != null && endDate != null && endDate!.isBefore(anchor)) {
        throw ArgumentError.value(endDate, 'endDate', 'must not be before date');
      }
      return;
    }

    if (anchor == null) {
      if (startMinute != null || endMinute != null || timeZone != null) {
        throw ArgumentError('An unscheduled entry cannot carry a time');
      }
      if (startAt != null || endAt != null) {
        throw ArgumentError('An unscheduled entry cannot carry an instant');
      }
      return;
    }

    if (timeZone == null || timeZone!.isEmpty) {
      throw ArgumentError('A timed entry needs an IANA timezone');
    }
    final start = startMinute;
    final end = endMinute;
    if (start == null || start < 0 || start >= 1440) {
      throw ArgumentError.value(startMinute, 'startMinute', 'must be between 0 and 1439');
    }
    if (end == null || end <= start || end - start > 1440) {
      throw ArgumentError.value(endMinute, 'endMinute', 'must be after start and at most 24 hours later');
    }
    if (endDate != null) {
      throw ArgumentError('Use endMinute for a timed entry that crosses midnight');
    }
    if (startAt == null || endAt == null || !startAt!.isUtc || !endAt!.isUtc) {
      throw ArgumentError('A timed entry needs resolved UTC instants');
    }
  }
}

/// An entry placed on a date by the recurrence expander.
class EntryOccurrence {
  const EntryOccurrence({
    required this.date,
    required this.displayDate,
    required this.entry,
    this.completed = false,
    this.startAt,
    this.endAt,
  });

  /// Date in the entry's stored timezone.
  final LocalDate date;

  /// Date in the viewer's timezone. This is what lists and calendars group by.
  final LocalDate displayDate;

  final Entry entry;

  /// Completion is per occurrence for recurring entries, so checking this
  /// week's bins does not check next week's.
  final bool completed;

  /// Resolved instants for this occurrence, null for all-day entries.
  final DateTime? startAt;
  final DateTime? endAt;
}

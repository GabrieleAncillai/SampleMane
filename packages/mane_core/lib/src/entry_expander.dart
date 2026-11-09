import 'entry.dart';
import 'local_date.dart';
import 'recurrence.dart';
import 'time.dart';

/// Completion dates keyed by entry id.
///
/// The key is the occurrence date in the entry's stored timezone, not the
/// viewer's date. Changing the device timezone must not lose checked days.
typedef EntryCompletions = Map<String, Set<LocalDate>>;

/// Places every entry on the calendar between [start] and [end] inclusive.
///
/// All-day entries are grouped by their stored date. Timed entries expand in
/// their stored IANA timezone, then convert each occurrence to an instant and
/// group it by its date in [viewerTimeZone]. That is what makes a 09:00 shift
/// move when the device travels and a birthday stay put.
///
/// Multi-day entries produce one occurrence per displayed day. Overnight timed
/// entries also produce the tail day, so a 22:00–02:00 block is visible on both
/// days. Recurrence skip dates are removed and modified occurrences are moved
/// to their replacement date/time before placement.
///
/// The caller pads recurrence expansion by two days in each direction, so an
/// occurrence whose viewer date lands inside the range is still found.
List<EntryOccurrence> expandEntries({
  required Iterable<Entry> entries,
  required LocalDate start,
  required LocalDate end,
  required String viewerTimeZone,
  EntryCompletions completions = const <String, Set<LocalDate>>{},
}) {
  if (start.isAfter(end)) return const <EntryOccurrence>[];

  final result = <EntryOccurrence>[];
  final paddedStart = start.addDays(-2);
  final paddedEnd = end.addDays(2);

  for (final entry in entries) {
    if (entry.deletedAt != null || entry.status == EntryStatus.cancelled) {
      continue;
    }
    final anchor = entry.date;
    if (anchor == null) continue;
    final doneDates = completions[entry.id] ?? const <LocalDate>{};
    final rule = entry.recurrence;

    final overrides = <LocalDate, RecurrenceOverride>{
      for (final override in rule?.overrides ?? const <RecurrenceOverride>[]) override.date: override,
    };

    final dates = <LocalDate>{};
    if (rule == null) {
      dates.add(anchor);
    } else {
      dates.addAll(rule.occurrencesBetween(paddedStart, paddedEnd, anchor));
      for (final override in rule.overrides) {
        if (!rule.skipDates.contains(override.date) &&
            _inRange(override.effectiveDate, paddedStart, paddedEnd)) {
          dates.add(override.date);
        }
      }
    }

    for (final date in dates) {
      final override = overrides[date];
      final effectiveDate = override?.dateOverride ?? date;
      final occurrenceEntry = override == null
          ? entry
          : entry.copyWith(title: override.title, notes: override.notes);

      if (entry.allDay || (override?.allDay ?? false)) {
        final last = entry.endDate;
        final span = last == null ? 0 : last.differenceInDays(anchor);
        var cursor = effectiveDate;
        final lastDay = effectiveDate.addDays(span);
        while (cursor.isOnOrBefore(lastDay)) {
          if (_inRange(cursor, start, end)) {
            result.add(
              EntryOccurrence(
                date: cursor,
                displayDate: cursor,
                entry: occurrenceEntry,
                completed: entry.status == EntryStatus.done || doneDates.contains(cursor),
              ),
            );
          }
          cursor = cursor.addDays(1);
        }
        continue;
      }

      final timeZone = entry.timeZone;
      final startMinute = override?.startMinute ?? entry.startMinute;
      final baseEndMinute = override?.endMinute ?? entry.endMinute;
      if (timeZone == null || startMinute == null || baseEndMinute == null) continue;

      final startAt = instantAt(effectiveDate, startMinute, timeZone);
      final endAt = entry.endDate == null
          ? instantAt(effectiveDate, baseEndMinute, timeZone)
          : instantAt(effectiveDate.addDays(entry.endDayOffset), baseEndMinute, timeZone);
      if (!endAt.isAfter(startAt)) continue;

      final firstDisplay = localDateAt(startAt, viewerTimeZone);
      final lastDisplay = localDateAt(endAt.subtract(const Duration(seconds: 1)), viewerTimeZone);
      var display = firstDisplay;
      while (display.isOnOrBefore(lastDisplay)) {
        if (_inRange(display, start, end)) {
          result.add(
            EntryOccurrence(
              date: date,
              displayDate: display,
              entry: occurrenceEntry,
              completed: rule == null ? entry.status == EntryStatus.done : doneDates.contains(date),
              startAt: startAt,
              endAt: endAt,
            ),
          );
        }
        display = display.addDays(1);
      }
    }
  }

  result.sort(compareEntryOccurrences);
  return result;
}

bool _inRange(LocalDate date, LocalDate start, LocalDate end) =>
    date.isOnOrAfter(start) && date.isOnOrBefore(end);

/// All-day items first, then timed items by instant, then title.
int compareEntryOccurrences(EntryOccurrence a, EntryOccurrence b) {
  final byDate = a.displayDate.compareTo(b.displayDate);
  if (byDate != 0) return byDate;
  final aStart = a.startAt;
  final bStart = b.startAt;
  if (aStart == null && bStart != null) return -1;
  if (aStart != null && bStart == null) return 1;
  if (aStart != null && bStart != null) {
    final byTime = aStart.compareTo(bStart);
    if (byTime != 0) return byTime;
  }
  return a.entry.title.compareTo(b.entry.title);
}

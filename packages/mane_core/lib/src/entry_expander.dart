import 'entry.dart';
import 'local_date.dart';
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
  for (final entry in entries) {
    if (entry.deletedAt != null || entry.status == EntryStatus.cancelled) {
      continue;
    }
    final anchor = entry.date;
    if (anchor == null) continue;
    final doneDates = completions[entry.id] ?? const <LocalDate>{};

    if (entry.allDay) {
      final rule = entry.recurrence;
      if (rule != null) {
        for (final date in rule.occurrencesBetween(start, end, anchor)) {
          result.add(
            EntryOccurrence(
              date: date,
              displayDate: date,
              entry: entry,
              completed: entry.status == EntryStatus.done || doneDates.contains(date),
            ),
          );
        }
        continue;
      }

      final last = entry.endDate ?? anchor;
      final from = LocalDate.max(start, anchor);
      final to = LocalDate.min(end, last);
      if (from.isAfter(to)) continue;
      var cursor = from;
      while (cursor.isOnOrBefore(to)) {
        result.add(
          EntryOccurrence(
            date: cursor,
            displayDate: cursor,
            entry: entry,
            completed: entry.status == EntryStatus.done || doneDates.contains(cursor),
          ),
        );
        cursor = cursor.addDays(1);
      }
      continue;
    }

    final timeZone = entry.timeZone;
    final startMinute = entry.startMinute;
    final endMinute = entry.endMinute;
    if (timeZone == null || startMinute == null || endMinute == null) continue;

    final paddedStart = start.addDays(-2);
    final paddedEnd = end.addDays(2);
    final rule = entry.recurrence;
    final dates = rule == null
        ? <LocalDate>[anchor]
        : rule.occurrencesBetween(paddedStart, paddedEnd, anchor);

    for (final date in dates) {
      final startAt = instantAt(date, startMinute, timeZone);
      final endAt = instantAt(date, endMinute, timeZone);
      final displayDate = localDateAt(startAt, viewerTimeZone);
      if (displayDate.isBefore(start) || displayDate.isAfter(end)) continue;
      result.add(
        EntryOccurrence(
          date: date,
          displayDate: displayDate,
          entry: entry,
          completed: rule == null ? entry.status == EntryStatus.done : doneDates.contains(date),
          startAt: startAt,
          endAt: endAt,
        ),
      );
    }
  }

  result.sort(compareEntryOccurrences);
  return result;
}

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

import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'local_date.dart';

/// Loads the embedded IANA timezone database.
///
/// Call once before resolving a timezone. The app calls it in `main()`; tests
/// call it in `setUpAll` so every run is deterministic.
void initializeTimeZones() => tzdata.initializeTimeZones();

/// Whether [timeZoneId] exists in the loaded IANA database.
bool isKnownTimeZone(String timeZoneId) {
  try {
    tz.getLocation(timeZoneId);
    return true;
  } on tz.LocationNotFoundException {
    return false;
  }
}

/// Resolves [timeZoneId], falling back to UTC for unknown ids.
///
/// Stored data is owned by the user, so a bad timezone must not make the whole
/// plan unreadable. Editors validate ids before saving; display and expansion
/// stay tolerant.
tz.Location timeZoneLocation(String timeZoneId) {
  try {
    return tz.getLocation(timeZoneId);
  } on tz.LocationNotFoundException {
    return tz.UTC;
  }
}

/// The absolute UTC instant for a wall-clock time in [timeZoneId].
///
/// [minutesFromMidnight] may be 1440 or more to express a time on a following
/// day, which is how overnight entries and shifts are stored. Nonexistent
/// local times (the spring-forward gap) are normalised forward by the IANA
/// rules; ambiguous times resolve to the first occurrence.
DateTime instantAt(LocalDate date, int minutesFromMidnight, String timeZoneId) {
  if (minutesFromMidnight < 0) {
    throw ArgumentError.value(minutesFromMidnight, 'minutesFromMidnight', 'must not be negative');
  }
  final location = timeZoneLocation(timeZoneId);
  final day = date.addDays(minutesFromMidnight ~/ 1440);
  final minuteOfDay = minutesFromMidnight % 1440;
  return tz.TZDateTime(location, day.year, day.month, day.day, minuteOfDay ~/ 60, minuteOfDay % 60).toUtc();
}

/// The local date of [instant] in [timeZoneId].
LocalDate localDateAt(DateTime instant, String timeZoneId) {
  final local = tz.TZDateTime.from(instant, timeZoneLocation(timeZoneId));
  return LocalDate.fromDateTime(local);
}

/// The local wall-clock time of [instant] in [timeZoneId].
///
/// The returned value implements [DateTime]; read `year`, `month`, `day`,
/// `hour` and `minute` to render it.
DateTime localDateTimeAt(DateTime instant, String timeZoneId) =>
    tz.TZDateTime.from(instant, timeZoneLocation(timeZoneId));

/// The local minute of [instant] in [timeZoneId], counted from midnight.
int localMinuteAt(DateTime instant, String timeZoneId) {
  final local = tz.TZDateTime.from(instant, timeZoneLocation(timeZoneId));
  return local.hour * 60 + local.minute;
}

/// Whether [minute] falls in the half-open local window [startMinute, endMinute).
///
/// A window whose start is later than its end wraps midnight, which is how
/// quiet hours such as 22:00–07:00 are expressed. Equal bounds mean an empty
/// window, not all day.
bool isMinuteInWindow(int minute, int startMinute, int endMinute) {
  if (minute < 0 || minute >= 24 * 60) return false;
  if (startMinute == endMinute) return false;
  if (startMinute < endMinute) {
    return minute >= startMinute && minute < endMinute;
  }
  return minute >= startMinute || minute < endMinute;
}

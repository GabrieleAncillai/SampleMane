/// A date on the calendar, with no time and no time zone.
///
/// Mane stores wall-clock dates and minutes from midnight, not instants.
/// A 09:00 habit should stay at 09:00 when the device changes time zone, and
/// a UTC-4 / UTC-5 work schedule should not drift by an hour.
class LocalDate implements Comparable<LocalDate> {
  const LocalDate(this.year, this.month, this.day)
    : assert(month >= 1 && month <= 12),
      assert(day >= 1 && day <= 31);

  /// Reads the local calendar date from [dateTime].
  factory LocalDate.fromDateTime(DateTime dateTime) => LocalDate(dateTime.year, dateTime.month, dateTime.day);

  /// Parses a `YYYY-MM-DD` string.
  factory LocalDate.parse(String value) {
    final match = _isoPattern.firstMatch(value);
    if (match == null) {
      throw FormatException('Expected a date like 2026-11-09', value);
    }
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    if (month < 1 || month > 12 || day < 1) {
      throw FormatException('Invalid calendar date', value);
    }
    final date = LocalDate(year, month, day);
    if (day > date.daysInMonth) {
      throw FormatException('Invalid calendar date', value);
    }
    return date;
  }

  /// Builds a date from the compact `YYYYMMDD` key used by the database.
  factory LocalDate.fromKey(int key) => LocalDate(key ~/ 10000, (key ~/ 100) % 100, key % 100);

  static final RegExp _isoPattern = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
  static const List<int> _monthLengths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  final int year;
  final int month;
  final int day;

  bool get isLeapYear => (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;

  int get daysInMonth => month == 2 && isLeapYear ? 29 : _monthLengths[month - 1];

  /// 1 = Monday ... 7 = Sunday.
  int get weekday => DateTime.utc(year, month, day).weekday;

  /// Compact `YYYYMMDD`, handy for range queries.
  int get key => year * 10000 + month * 100 + day;

  /// The Monday of this date's ISO week.
  LocalDate get mondayOfWeek => addDays(1 - weekday);

  /// The first day of this date's week when weeks start on [weekStart]
  /// (1 = Monday ... 7 = Sunday).
  LocalDate startOfWeek(int weekStart) {
    final start = weekStart >= 1 && weekStart <= 7 ? weekStart : DateTime.monday;
    return addDays(-((weekday - start) % 7));
  }

  LocalDate addDays(int days) {
    final shifted = DateTime.utc(year, month, day).add(Duration(days: days));
    return LocalDate(shifted.year, shifted.month, shifted.day);
  }

  /// Whole days from [other] to this date.
  int differenceInDays(LocalDate other) =>
      DateTime.utc(year, month, day).difference(DateTime.utc(other.year, other.month, other.day)).inDays;

  /// Whole calendar months from [other] to this date.
  int differenceInMonths(LocalDate other) => (year * 12 + month) - (other.year * 12 + other.month);

  DateTime toDateTime({int hour = 0, int minute = 0}) => DateTime(year, month, day, hour, minute);

  String get iso =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';

  bool isBefore(LocalDate other) => compareTo(other) < 0;

  bool isAfter(LocalDate other) => compareTo(other) > 0;

  bool isOnOrBefore(LocalDate other) => compareTo(other) <= 0;

  bool isOnOrAfter(LocalDate other) => compareTo(other) >= 0;

  static LocalDate min(LocalDate a, LocalDate b) => a.isBefore(b) ? a : b;

  static LocalDate max(LocalDate a, LocalDate b) => a.isAfter(b) ? a : b;

  @override
  int compareTo(LocalDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  @override
  bool operator ==(Object other) =>
      other is LocalDate && year == other.year && month == other.month && day == other.day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => iso;
}

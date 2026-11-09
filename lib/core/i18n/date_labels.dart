import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// ISO weekdays in display order, starting from [weekStart] (1 = Monday).
List<int> weekdaysFrom(int weekStart) {
  final start = weekStart >= 1 && weekStart <= 7 ? weekStart : DateTime.monday;
  return [for (var offset = 0; offset < 7; offset++) ((start - 1 + offset) % 7) + 1];
}

/// A short weekday label in the current locale.
///
/// 2024-01-01 is a Monday, which keeps the arithmetic independent of the
/// current date.
String shortWeekday(BuildContext context, int weekday) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final date = DateTime.utc(2024, 1, 1).add(Duration(days: weekday - 1));
  return DateFormat.E(locale).format(date);
}

String shortWeekdayList(BuildContext context, Iterable<int> weekdays) =>
    (weekdays.toList()..sort()).map((day) => shortWeekday(context, day)).join(', ');

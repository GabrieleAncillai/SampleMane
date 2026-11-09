import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/date_labels.dart';
import '../../../core/i18n/l10n.dart';

/// A six-week month grid with per-day markers.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    super.key,
    required this.month,
    required this.selected,
    required this.today,
    required this.weekStart,
    required this.markers,
    required this.shiftDays,
    required this.onSelected,
  });

  /// First day of the visible month.
  final LocalDate month;
  final LocalDate selected;
  final LocalDate today;
  final int weekStart;

  /// Date key to the space colors present on that day.
  final Map<int, Set<int>> markers;
  final Set<int> shiftDays;
  final ValueChanged<LocalDate> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final first = month.startOfWeek(weekStart);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dayFormat = DateFormat.MMMd(locale);
    final weekdays = weekdaysFrom(weekStart);

    return Column(
      children: [
        Row(
          children: [
            for (final weekday in weekdays)
              Expanded(
                child: Center(
                  child: Text(
                    shortWeekday(context, weekday).toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        for (var row = 0; row < 6; row++)
          Row(
            children: [
              for (var column = 0; column < 7; column++)
                Expanded(
                  child: _DayCell(
                    date: first.addDays(row * 7 + column),
                    month: month,
                    selected: selected,
                    today: today,
                    markerColors: markers[first.addDays(row * 7 + column).key] ?? const <int>{},
                    hasShift: shiftDays.contains(first.addDays(row * 7 + column).key),
                    semanticsDate: dayFormat.format(first.addDays(row * 7 + column).toDateTime()),
                    onTap: () => onSelected(first.addDays(row * 7 + column)),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.month,
    required this.selected,
    required this.today,
    required this.markerColors,
    required this.hasShift,
    required this.semanticsDate,
    required this.onTap,
  });

  final LocalDate date;
  final LocalDate month;
  final LocalDate selected;
  final LocalDate today;
  final Set<int> markerColors;
  final bool hasShift;
  final String semanticsDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inMonth = date.month == month.month && date.year == month.year;
    final isSelected = date == selected;
    final isToday = date == today;
    final selectedInk = theme.colorScheme.onPrimary;
    final textColor = isSelected
        ? selectedInk
        : inMonth
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4);
    final count = markerColors.length + (hasShift ? 1 : 0);
    final height = 50 * MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.45);

    return Semantics(
      button: true,
      selected: isSelected,
      label: context.l10n.calendarDaySemantics(semanticsDate, count),
      child: InkWell(
        key: ValueKey('calendar-day-${date.iso}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: height,
          margin: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : null,
            borderRadius: BorderRadius.circular(10),
            border: isToday && !isSelected
                ? Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.55), width: 1.4)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${date.day}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight: isSelected || isToday ? FontWeight.w600 : null,
                ),
              ),
              const SizedBox(height: 3),
              SizedBox(
                height: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (inMonth)
                      for (final color in markerColors.take(3))
                        Container(
                          width: 5,
                          height: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(color: Color(color), shape: BoxShape.circle),
                        ),
                  ],
                ),
              ),
              SizedBox(
                height: 2,
                child: hasShift && inMonth
                    ? Container(
                        width: 16,
                        decoration: BoxDecoration(
                          color: isSelected ? selectedInk.withValues(alpha: 0.7) : theme.colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

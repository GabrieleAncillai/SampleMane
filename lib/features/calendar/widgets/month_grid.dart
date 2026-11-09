import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/date_labels.dart';
import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/pressable.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

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
    final c = context.mc;
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
                    style: ManeType.label(9.5, color: c.textTertiary),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
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
    final c = context.mc;
    final inMonth = date.month == month.month && date.year == month.year;
    final isSelected = date == selected;
    final isToday = date == today;
    final selectedInk = c.onAccent;
    final textColor = isSelected
        ? selectedInk
        : inMonth
        ? c.text
        : c.textTertiary.withValues(alpha: 0.55);
    final count = markerColors.length + (hasShift ? 1 : 0);
    final height = 48 * MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.45);

    return Semantics(
      button: true,
      selected: isSelected,
      label: context.l10n.calendarDaySemantics(semanticsDate, count),
      child: Pressable(
        key: ValueKey('calendar-day-${date.iso}'),
        onTap: onTap,
        scale: 0.93,
        child: Container(
          height: height,
          margin: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            color: isSelected ? c.accent : null,
            borderRadius: BorderRadius.circular(12),
            border: isToday && !isSelected
                ? Border.all(color: c.accent.withValues(alpha: 0.55), width: 1.3)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${date.day}',
                style: ManeType.body(13.5, weight: FontWeight.w600, color: textColor),
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
                          width: 4.5,
                          height: 4.5,
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
                        width: 14,
                        decoration: BoxDecoration(
                          color: isSelected ? selectedInk.withValues(alpha: 0.7) : c.work,
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

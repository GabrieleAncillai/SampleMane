import 'package:flutter/material.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/date_labels.dart';
import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/pressable.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class WeekStrip extends StatelessWidget {
  const WeekStrip({
    super.key,
    required this.selected,
    required this.today,
    required this.weekStart,
    required this.markers,
    required this.shiftDays,
    required this.onSelected,
  });

  final LocalDate selected;
  final LocalDate today;
  final int weekStart;
  final Map<int, Set<int>> markers;
  final Set<int> shiftDays;
  final ValueChanged<LocalDate> onSelected;

  @override
  Widget build(BuildContext context) {
    final start = selected.startOfWeek(weekStart);

    return Row(
      children: [
        for (var index = 0; index < 7; index++)
          Expanded(
            child: _WeekDay(
              date: start.addDays(index),
              selected: selected,
              today: today,
              markerColors: markers[start.addDays(index).key] ?? const <int>{},
              hasShift: shiftDays.contains(start.addDays(index).key),
              onTap: () => onSelected(start.addDays(index)),
            ),
          ),
      ],
    );
  }
}

class _WeekDay extends StatelessWidget {
  const _WeekDay({
    required this.date,
    required this.selected,
    required this.today,
    required this.markerColors,
    required this.hasShift,
    required this.onTap,
  });

  final LocalDate date;
  final LocalDate selected;
  final LocalDate today;
  final Set<int> markerColors;
  final bool hasShift;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    final isSelected = date == selected;
    final isToday = date == today;
    final ink = isSelected ? c.onAccent : c.text;
    final count = markerColors.length + (hasShift ? 1 : 0);
    final height = 78 * MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.45);

    return Semantics(
      button: true,
      selected: isSelected,
      label: context.l10n.calendarDaySemantics('${shortWeekday(context, date.weekday)} ${date.day}', count),
      child: Pressable(
        key: ValueKey('week-day-${date.iso}'),
        onTap: onTap,
        scale: 0.94,
        child: Container(
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isSelected ? c.accent : c.surfaceAlt,
            borderRadius: BorderRadius.circular(15),
            border: isToday && !isSelected
                ? Border.all(color: c.accent.withValues(alpha: 0.55), width: 1.3)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                shortWeekday(context, date.weekday).toUpperCase(),
                style: ManeType.label(9.5, color: isSelected ? ink.withValues(alpha: 0.8) : c.textTertiary),
              ),
              const SizedBox(height: 2),
              Text(
                '${date.day}',
                style: ManeType.title(
                  15.5,
                  color: ink,
                ).copyWith(fontWeight: isSelected || isToday ? FontWeight.w800 : FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final color in markerColors.take(3))
                    Container(
                      width: 4.5,
                      height: 4.5,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(color: Color(color), shape: BoxShape.circle),
                    ),
                  if (hasShift)
                    Container(
                      width: 11,
                      height: 2,
                      margin: const EdgeInsets.only(left: 3),
                      decoration: BoxDecoration(
                        color: isSelected ? ink.withValues(alpha: 0.7) : c.work,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

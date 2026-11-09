import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../state/providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../shifts/widgets/shift_checklist_view.dart';

/// A 24-hour day view. Shifts are drawn as background blocks; entries sit in
/// front, so a collision is visible without opening anything.
class DayTimeline extends ConsumerWidget {
  const DayTimeline({
    super.key,
    required this.day,
    required this.entries,
    required this.shifts,
    required this.spaces,
    required this.onAdd,
  });

  final LocalDate day;
  final List<EntryOccurrence> entries;
  final List<ShiftOccurrence> shifts;
  final List<Space> spaces;
  final VoidCallback onAdd;

  static const _hourHeight = 54.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.mc;
    final l10n = context.l10n;
    final timeZone = ref.watch(deviceTimeZoneProvider);
    final now = ref.watch(nowProvider);
    final dayStart = instantAt(day, 0, timeZone);
    final dayEnd = instantAt(day.addDays(1), 0, timeZone);
    final allDayEntries = entries.where((entry) => entry.startAt == null).toList();
    final timedEntries = entries.where((entry) => entry.startAt != null).toList();
    final timelineHeight = _hourHeight * 24;
    final nowOffset = now.difference(dayStart).inMinutes / 60 * _hourHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                DateFormat.yMMMMEEEEd(
                  Localizations.localeOf(context).toLanguageTag(),
                ).format(day.toDateTime()),
                style: ManeType.title(15, color: c.text),
              ),
            ),
            GlassIconButton(icon: Icons.add, tooltip: l10n.addOnThisDay, size: 34, onTap: onAdd),
          ],
        ),
        if (allDayEntries.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final entry in allDayEntries)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: c.softForSpace(entry.entry.spaceId),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: c.forSpace(entry.entry.spaceId).withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    entry.entry.title,
                    style: ManeType.body(11.5, weight: FontWeight.w700, color: c.text),
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: 10),
        if (timedEntries.isEmpty && shifts.isEmpty && allDayEntries.isEmpty)
          AppEmptyState(icon: Icons.event_available_outlined, title: l10n.noEntriesOnDay, compact: true)
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: timelineHeight,
              color: c.surfaceAlt.withValues(alpha: 0.45),
              child: Stack(
                children: [
                  for (var hour = 0; hour <= 24; hour++)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: hour * _hourHeight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 42,
                            child: Transform.translate(
                              offset: Offset(0, hour == 0 ? 2 : -6),
                              child: Text(
                                hour == 24 ? '' : TimeOfDay(hour: hour, minute: 0).format(context),
                                textAlign: TextAlign.right,
                                style: ManeType.label(9.5, color: c.textTertiary),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 6),
                              height: 1,
                              color: hour == 24 ? Colors.transparent : c.border,
                            ),
                          ),
                        ],
                      ),
                    ),
                  for (final shift in shifts)
                    _shiftBlock(context, shift, dayStart, dayEnd, c, timelineHeight),
                  for (final entry in timedEntries)
                    _entryBlock(context, entry, dayStart, dayEnd, c, timelineHeight),
                  if (now.isAfter(dayStart) && now.isBefore(dayEnd))
                    Positioned(
                      left: 42,
                      right: 8,
                      top: nowOffset.clamp(0, timelineHeight - 1),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(color: c.danger, shape: BoxShape.circle),
                          ),
                          Expanded(child: Container(height: 1.4, color: c.danger)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        if (shifts.isNotEmpty) ...[
          const SizedBox(height: 12),
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel(l10n.shiftChecklist),
                for (final shift in shifts)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ShiftChecklistSection(
                      patternId: shift.pattern.id,
                      date: shift.date,
                      slotKey: shift.slotKey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _shiftBlock(
    BuildContext context,
    ShiftOccurrence shift,
    DateTime dayStart,
    DateTime dayEnd,
    ManeColors c,
    double height,
  ) {
    final start = shift.startAt.isBefore(dayStart) ? dayStart : shift.startAt;
    final end = shift.endAt.isAfter(dayEnd) ? dayEnd : shift.endAt;
    if (!end.isAfter(start)) return const SizedBox.shrink();
    final top = start.difference(dayStart).inMinutes / 60 * _hourHeight;
    final blockHeight = (end.difference(start).inMinutes / 60 * _hourHeight).clamp(18.0, height);
    final color = c.forSpace(shift.pattern.spaceId);
    return Positioned(
      left: 46,
      right: 8,
      top: top,
      child: Container(
        height: blockHeight,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: c.softForSpace(shift.pattern.spaceId),
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: color, width: 3)),
        ),
        child: Text(
          shift.pattern.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: ManeType.body(11, weight: FontWeight.w700, color: color),
        ),
      ),
    );
  }

  Widget _entryBlock(
    BuildContext context,
    EntryOccurrence entry,
    DateTime dayStart,
    DateTime dayEnd,
    ManeColors c,
    double height,
  ) {
    final start = entry.startAt!;
    final end = entry.endAt ?? start;
    final clippedStart = start.isBefore(dayStart) ? dayStart : start;
    final clippedEnd = end.isAfter(dayEnd) ? dayEnd : end;
    if (!clippedEnd.isAfter(clippedStart)) return const SizedBox.shrink();
    final top = clippedStart.difference(dayStart).inMinutes / 60 * _hourHeight;
    final blockHeight = (clippedEnd.difference(clippedStart).inMinutes / 60 * _hourHeight).clamp(
      22.0,
      height,
    );
    final color = c.forSpace(entry.entry.spaceId);
    return Positioned(
      left: 64,
      right: 20,
      top: top,
      child: Container(
        height: blockHeight,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.45)),
          boxShadow: [BoxShadow(color: c.shadow, blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Text(
          entry.entry.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: ManeType.body(11.5, weight: FontWeight.w700, color: c.text),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../core/i18n/l10n.dart';
import '../core/i18n/recurrence_label.dart';
import '../screens/entry_editor.dart';
import '../state/providers.dart';

/// Formats a UTC instant as a local time in [viewerTimeZone].
String formatInstantTime(BuildContext context, DateTime instant, String viewerTimeZone) {
  final local = localDateTimeAt(instant, viewerTimeZone);
  return TimeOfDay(hour: local.hour, minute: local.minute).format(context);
}

String _formatRange(BuildContext context, DateTime startAt, DateTime endAt, String viewerTimeZone) {
  final start = formatInstantTime(context, startAt, viewerTimeZone);
  final end = formatInstantTime(context, endAt, viewerTimeZone);
  final startLocal = localDateTimeAt(startAt, viewerTimeZone);
  final endLocal = localDateTimeAt(endAt, viewerTimeZone);
  final crossesDay =
      startLocal.year != endLocal.year ||
      startLocal.month != endLocal.month ||
      startLocal.day != endLocal.day;
  return crossesDay ? '$start – $end ${context.l10n.overnightSuffix}' : '$start – $end';
}

String formatEntryTime(BuildContext context, EntryOccurrence occurrence, String viewerTimeZone) {
  final entry = occurrence.entry;
  if (entry.allDay) return context.l10n.allDay;
  final startAt = occurrence.startAt ?? entry.startAt;
  final endAt = occurrence.endAt ?? entry.endAt;
  if (startAt == null || endAt == null) return context.l10n.allDay;
  return _formatRange(context, startAt, endAt, viewerTimeZone);
}

String formatShiftTime(BuildContext context, ShiftOccurrence occurrence, String viewerTimeZone) =>
    _formatRange(context, occurrence.startAt, occurrence.endAt, viewerTimeZone);

class EntryTile extends ConsumerWidget {
  const EntryTile({super.key, required this.occurrence, required this.spaces, this.dense = false});

  final EntryOccurrence occurrence;
  final List<Space> spaces;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = occurrence.entry;
    final space = spaces.firstWhere(
      (value) => value.id == entry.spaceId,
      orElse: () => Space(id: entry.spaceId, name: entry.spaceId, colorValue: 0xFF888888),
    );
    final canComplete = entry.kind != EntryKind.event;
    final isCompleted = occurrence.completed;
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final viewerTimeZone = ref.watch(deviceTimeZoneProvider);

    final details = <String>[
      space.name,
      formatEntryTime(context, occurrence, viewerTimeZone),
      if (entry.recurrence != null)
        recurrenceLabel(context, entry.recurrence!, entry.date ?? occurrence.date),
      if (!dense && entry.notes.isNotEmpty) entry.notes,
    ];

    return ListTile(
      dense: dense,
      contentPadding: EdgeInsets.symmetric(horizontal: dense ? 0 : 4, vertical: dense ? 0 : 2),
      leading: canComplete
          ? Checkbox(
              value: isCompleted,
              onChanged: (value) async {
                if (entry.recurrence == null) {
                  await ref
                      .read(repositoryProvider)
                      .setEntryStatus(entry.id, value == true ? EntryStatus.done : EntryStatus.open);
                } else {
                  await ref
                      .read(repositoryProvider)
                      .setOccurrenceCompleted(entry.id, occurrence.date, value == true);
                }
              },
              semanticLabel: context.l10n.markAsDone(entry.title),
            )
          : Icon(Icons.event_outlined, color: muted),
      title: Text(
        entry.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyLarge?.copyWith(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
          color: isCompleted ? muted : null,
        ),
      ),
      subtitle: Text(
        details.join(' · '),
        maxLines: dense ? 1 : 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(color: muted),
      ),
      trailing: entry.recurrence == null ? null : Icon(Icons.repeat, size: 18, color: muted),
      onTap: () => showEntryEditor(context, entry: entry, initialDate: occurrence.date, spaces: spaces),
    );
  }
}

class ShiftTile extends ConsumerWidget {
  const ShiftTile({super.key, required this.occurrence});

  final ShiftOccurrence occurrence;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.tertiary;
    final viewerTimeZone = ref.watch(deviceTimeZoneProvider);
    final slot = occurrence.slot;
    final title = slot.label.isEmpty ? occurrence.pattern.name : '${occurrence.pattern.name} · ${slot.label}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.labelLarge),
                  const SizedBox(height: 2),
                  Text(
                    formatShiftTime(context, occurrence, viewerTimeZone),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class ShiftChip extends ConsumerWidget {
  const ShiftChip({super.key, required this.occurrence});

  final ShiftOccurrence occurrence;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final viewerTimeZone = ref.watch(deviceTimeZoneProvider);
    final label = occurrence.slot.label.isEmpty
        ? occurrence.pattern.name
        : '${occurrence.slot.label} · ${occurrence.pattern.name}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label · ${formatShiftTime(context, occurrence, viewerTimeZone)}',
        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}

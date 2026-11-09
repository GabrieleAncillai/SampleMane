import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../screens/entry_editor.dart';
import '../state/providers.dart';

/// Formats minutes from midnight as a local time, and marks overnight ends.
String formatMinutes(BuildContext context, int minutes, {bool markOvernight = false}) {
  final normalized = minutes % 1440;
  final time = TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
  final label = time.format(context);
  if (markOvernight && minutes >= 1440) return '$label (+1)';
  return label;
}

String formatEntryTime(BuildContext context, Entry entry) {
  if (entry.allDay || entry.startMinute == null) return 'All day';
  final start = formatMinutes(context, entry.startMinute!);
  final end = entry.endMinute == null ? null : formatMinutes(context, entry.endMinute!, markOvernight: true);
  return end == null ? start : '$start – $end';
}

String kindLabel(EntryKind kind) => switch (kind) {
  EntryKind.task => 'Task',
  EntryKind.event => 'Event',
  EntryKind.obligation => 'Obligation',
  EntryKind.deadline => 'Deadline',
};

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

    final details = <String>[
      space.name,
      formatEntryTime(context, entry),
      if (entry.recurrence != null) entry.recurrence!.describe(),
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
              semanticLabel: 'Mark ${entry.title} as done',
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

class ShiftTile extends StatelessWidget {
  const ShiftTile({super.key, required this.occurrence});

  final ShiftOccurrence occurrence;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.tertiary;
    final slot = occurrence.slot;

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
                  Text('${occurrence.pattern.name} · ${slot.label}', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 2),
                  Text(
                    '${formatMinutes(context, slot.startMinute)} – '
                    '${formatMinutes(context, slot.endMinute, markOvernight: true)}',
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

class ShiftChip extends StatelessWidget {
  const ShiftChip({super.key, required this.occurrence});

  final ShiftOccurrence occurrence;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${occurrence.slot.label} · '
        '${formatMinutes(context, occurrence.slot.startMinute)}–'
        '${formatMinutes(context, occurrence.slot.endMinute, markOvernight: true)}',
        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}

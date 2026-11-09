import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../core/i18n/l10n.dart';
import '../core/i18n/recurrence_label.dart';
import '../core/widgets/ui_kit.dart';
import '../screens/entry_editor.dart';
import '../state/providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

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
    final c = context.mc;
    final space = spaces.firstWhere(
      (value) => value.id == entry.spaceId,
      orElse: () => Space(id: entry.spaceId, name: entry.spaceId, colorValue: c.accent.toARGB32()),
    );
    final canComplete = entry.kind != EntryKind.event && !entry.readOnly;
    final isCompleted = entry.isMaintenance ? false : occurrence.completed;
    final viewerTimeZone = ref.watch(deviceTimeZoneProvider);
    final muted = c.textSecondary;

    final details = <String>[
      space.name,
      formatEntryTime(context, occurrence, viewerTimeZone),
      if (entry.recurrence != null)
        recurrenceLabel(context, entry.recurrence!, entry.date ?? occurrence.date),
      if (!dense && entry.notes.isNotEmpty) entry.notes,
    ];

    return Pressable(
      onTap: () {
        if (entry.readOnly) {
          _showReadOnly(context, entry);
          return;
        }
        showEntryEditor(context, entry: entry, initialDate: occurrence.date, spaces: spaces);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: dense ? 7 : 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (canComplete)
              SizedBox(
                width: 34,
                height: 34,
                child: Checkbox(
                  value: isCompleted,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (value) async {
                    try {
                      if (entry.isMaintenance) {
                        final today = localDateAt(ref.read(nowProvider), ref.read(deviceTimeZoneProvider));
                        await ref.read(repositoryProvider).completeMaintenanceEntry(entry.id, today);
                        await ref.read(reminderCoordinatorProvider).reschedule();
                      } else if (entry.recurrence == null) {
                        await ref
                            .read(repositoryProvider)
                            .setEntryStatus(entry.id, value == true ? EntryStatus.done : EntryStatus.open);
                      } else {
                        await ref
                            .read(repositoryProvider)
                            .setOccurrenceCompleted(entry.id, occurrence.date, value == true);
                      }
                    } catch (error) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(context.l10n.couldNotComplete('$error'))));
                    }
                  },
                  semanticLabel: context.l10n.markAsDone(entry.title),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(7, 6, 11, 6),
                child: Icon(Icons.event_outlined, size: 18, color: c.textTertiary),
              ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ManeType.body(
                      14.5,
                      weight: FontWeight.w700,
                      color: isCompleted ? muted : c.text,
                    ).copyWith(decoration: isCompleted ? TextDecoration.lineThrough : null),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    details.join(' · '),
                    maxLines: dense ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: ManeType.body(11.5, color: muted),
                  ),
                ],
              ),
            ),
            if (entry.readOnly)
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 6, 2, 6),
                child: Icon(Icons.lock_outline, size: 16, color: c.textTertiary),
              )
            else if (entry.recurrence != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 6, 2, 6),
                child: Icon(Icons.repeat, size: 16, color: c.textTertiary),
              ),
          ],
        ),
      ),
    );
  }
}

class ShiftTile extends ConsumerWidget {
  const ShiftTile({super.key, required this.occurrence});

  final ShiftOccurrence occurrence;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.mc;
    final color = c.forSpace(occurrence.pattern.spaceId);
    final viewerTimeZone = ref.watch(deviceTimeZoneProvider);
    final slot = occurrence.slot;
    final title = slot.label.isEmpty ? occurrence.pattern.name : '${occurrence.pattern.name} · ${slot.label}';

    return Semantics(
      container: true,
      label: '$title, ${formatShiftTime(context, occurrence, viewerTimeZone)}',
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: c.softForSpace(occurrence.pattern.spaceId),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 54,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.work_outline, size: 27, color: color.withValues(alpha: 0.8)),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: ManeType.body(13.5, weight: FontWeight.w700, color: c.text),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatShiftTime(context, occurrence, viewerTimeZone),
                      style: ManeType.body(11.5, color: c.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class ShiftChip extends ConsumerWidget {
  const ShiftChip({super.key, required this.occurrence});

  final ShiftOccurrence occurrence;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.mc;
    final viewerTimeZone = ref.watch(deviceTimeZoneProvider);
    final label = occurrence.slot.label.isEmpty
        ? occurrence.pattern.name
        : '${occurrence.slot.label} · ${occurrence.pattern.name}';
    final color = c.forSpace(occurrence.pattern.spaceId);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.softForSpace(occurrence.pattern.spaceId),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Text(
        '$label · ${formatShiftTime(context, occurrence, viewerTimeZone)}',
        style: ManeType.label(10.5, color: c.textSecondary),
      ),
    );
  }
}

void _showReadOnly(BuildContext context, Entry entry) {
  final l10n = context.l10n;
  final c = context.mc;
  showAppSheet<void>(
    context: context,
    builder: (sheetContext) => AppSheet(
      children: [
        Text(entry.title, style: ManeType.headline(21, color: c.text)),
        const SizedBox(height: 6),
        Text(l10n.importedEvent, style: ManeType.label(12, color: c.accent)),
        const SizedBox(height: 12),
        Text(l10n.readOnlyNotice, style: ManeType.body(14, color: c.textSecondary)),
        if (entry.notes.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(entry.notes, style: ManeType.body(14, color: c.text)),
        ],
        const SizedBox(height: 22),
        FilledButton(onPressed: () => Navigator.of(sheetContext).pop(), child: Text(l10n.close)),
      ],
    ),
  );
}

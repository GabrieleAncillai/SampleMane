import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../state/providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

/// Interval-after-completion tasks, grouped by due and upcoming. Completing a
/// task moves its next date forward from today and records the history.
class MaintenancePage extends ConsumerWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.mc;
    final timeZone = ref.watch(deviceTimeZoneProvider);
    final today = localDateAt(ref.watch(nowProvider), timeZone);
    final range = (start: today.addDays(-365), end: today.addDays(730));
    final occurrences = ref.watch(entriesProvider(range)).value ?? const <EntryOccurrence>[];
    final seen = <String>{};
    final tasks = <EntryOccurrence>[];
    for (final occurrence in occurrences) {
      if (!occurrence.entry.isMaintenance) continue;
      if (!seen.add(occurrence.entry.id)) continue;
      tasks.add(occurrence);
    }
    tasks.sort((a, b) => (a.entry.date ?? today).compareTo(b.entry.date ?? today));
    final due = [
      for (final task in tasks)
        if (!(task.entry.date ?? today).isAfter(today)) task,
    ];
    final upcoming = [
      for (final task in tasks)
        if ((task.entry.date ?? today).isAfter(today)) task,
    ];

    return ManePage(
      title: l10n.maintenance,
      subtitle: l10n.maintenanceSubtitle,
      child: tasks.isEmpty
          ? AppEmptyState(
              icon: Icons.build_circle_outlined,
              title: l10n.maintenanceNone,
              message: l10n.maintenanceSubtitle,
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                if (due.isNotEmpty) ...[
                  SectionLabel(l10n.maintenanceDue),
                  SoftCard(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    clip: true,
                    child: Column(
                      children: [
                        for (var index = 0; index < due.length; index++) ...[
                          if (index > 0) const Divider(height: 1, indent: 52),
                          _MaintenanceRow(task: due[index], today: today),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                if (upcoming.isNotEmpty) ...[
                  SectionLabel(l10n.maintenanceUpcoming),
                  SoftCard(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    clip: true,
                    child: Column(
                      children: [
                        for (var index = 0; index < upcoming.length; index++) ...[
                          if (index > 0) const Divider(height: 1, indent: 52),
                          _MaintenanceRow(task: upcoming[index], today: today),
                        ],
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(l10n.maintenanceSubtitle, style: ManeType.body(12, color: c.textTertiary)),
                ),
              ],
            ),
    );
  }
}

class _MaintenanceRow extends ConsumerWidget {
  const _MaintenanceRow({required this.task, required this.today});

  final EntryOccurrence task;
  final LocalDate today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.mc;
    final entry = task.entry;
    final date = entry.date ?? today;
    final overdue = date.isBefore(today);
    final dateLabel = MaterialLocalizations.of(context).formatMediumDate(date.toDateTime());

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 3, 6, 3),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: overdue ? c.dangerSoft : c.homeSoft,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              overdue ? Icons.warning_amber_outlined : Icons.build_outlined,
              size: 19,
              color: overdue ? c.danger : c.home,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ManeType.body(14, weight: FontWeight.w700, color: c.text),
                  ),
                  const SizedBox(height: 1),
                  Text(dateLabel, style: ManeType.body(11.5, color: overdue ? c.danger : c.textSecondary)),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.complete,
            icon: Icon(Icons.check_circle_outline, color: c.home),
            onPressed: () => _complete(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _complete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final next = await ref.read(repositoryProvider).completeMaintenanceEntry(task.entry.id, today);
    await ref.read(reminderCoordinatorProvider).reschedule();
    if (next != null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.maintenanceDone(next.iso))));
    }
  }
}

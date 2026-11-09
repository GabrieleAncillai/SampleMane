import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../../core/i18n/l10n.dart';
import '../../state/providers.dart';
import '../../state/settings_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/entry_widgets.dart';

/// A soft block showing the gap between today's last commitment and tomorrow's
/// first one. It follows the visible plan (including the tag filter) and never
/// creates a task or a notification.
class SleepWindowCard extends ConsumerWidget {
  const SleepWindowCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    if (!settings.sleepEnabled) return const SizedBox.shrink();

    final viewerTimeZone = ref.watch(deviceTimeZoneProvider);
    final today = localDateAt(ref.watch(nowProvider), viewerTimeZone);
    final range = (start: today.addDays(-1), end: today.addDays(1));
    final entries = ref.watch(entriesProvider(range)).value ?? const <EntryOccurrence>[];
    final shifts = ref.watch(shiftsProvider(range)).value ?? const <ShiftOccurrence>[];

    final lastEnds = <DateTime>[
      for (final occurrence in entries)
        if (occurrence.endAt case final endAt?)
          if (localDateAt(endAt, viewerTimeZone) == today) endAt,
      for (final occurrence in shifts)
        if (localDateAt(occurrence.endAt, viewerTimeZone) == today) occurrence.endAt,
    ];
    final firstStarts = <DateTime>[
      for (final occurrence in entries)
        if (occurrence.startAt case final startAt?)
          if (localDateAt(startAt, viewerTimeZone) == today.addDays(1)) startAt,
      for (final occurrence in shifts)
        if (localDateAt(occurrence.startAt, viewerTimeZone) == today.addDays(1)) occurrence.startAt,
    ];

    final window = computeSleepWindow(
      lastEndsToday: lastEnds,
      firstStartsTomorrow: firstStarts,
      commute: settings.commute,
      windDown: settings.windDown,
      wakeBuffer: settings.wakeBuffer,
    );
    if (window.bedtime == null && window.wakeTime == null) return const SizedBox.shrink();

    final c = context.mc;
    final color = window.warning ? c.danger : c.accent;
    final l10n = context.l10n;
    final lines = <String>[
      if (window.bedtime case final bedtime?)
        l10n.sleepBedtime(formatInstantTime(context, bedtime, viewerTimeZone)),
      if (window.wakeTime case final wakeTime?)
        l10n.sleepWake(formatInstantTime(context, wakeTime, viewerTimeZone))
      else if (window.bedtime != null)
        l10n.sleepNoEarlyStart,
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: window.warning ? c.dangerSoft : c.accentSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(Icons.bedtime_outlined, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.sleepWindow, style: ManeType.label(13, color: c.text)),
                const SizedBox(height: 2),
                Text(lines.join(' · '), style: ManeType.body(11.5, color: c.textSecondary)),
                if (window.warning) ...[
                  const SizedBox(height: 4),
                  Text(l10n.sleepWarning, style: ManeType.body(11.5, color: c.danger)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

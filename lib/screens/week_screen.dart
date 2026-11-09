import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mane_core/mane_core.dart';

import '../core/i18n/l10n.dart';
import '../state/providers.dart';
import '../state/settings_controller.dart';
import '../widgets/entry_widgets.dart';
import 'entry_editor.dart';

class WeekScreen extends ConsumerStatefulWidget {
  const WeekScreen({super.key});

  @override
  ConsumerState<WeekScreen> createState() => _WeekScreenState();
}

class _WeekScreenState extends ConsumerState<WeekScreen> {
  int _offsetWeeks = 0;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final deviceTimeZone = ref.watch(deviceTimeZoneProvider);
    final today = localDateAt(ref.watch(nowProvider), deviceTimeZone);
    final start = today.startOfWeek(settings.weekStart).addDays(7 * _offsetWeeks);
    final range = (start: start, end: start.addDays(6));
    final spaces = ref.watch(spacesProvider).value ?? fallbackSpaces;
    final allEntries = ref.watch(entriesProvider(range)).value ?? const <EntryOccurrence>[];
    final allShifts = ref.watch(shiftsProvider(range)).value ?? const <ShiftOccurrence>[];
    final entries = settings.hideWorkSpace
        ? allEntries.where((entry) => entry.entry.spaceId != 'work').toList()
        : allEntries;
    final shifts = settings.hideWorkSpace ? const <ShiftOccurrence>[] : allShifts;

    final entriesByDate = <LocalDate, List<EntryOccurrence>>{};
    for (final occurrence in entries) {
      (entriesByDate[occurrence.displayDate] ??= []).add(occurrence);
    }

    final shiftsByDate = <LocalDate, List<ShiftOccurrence>>{};
    for (final occurrence in shifts) {
      (shiftsByDate[occurrence.displayDate] ??= []).add(occurrence);
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          _WeekHeader(
            start: start,
            onPrevious: () => setState(() => _offsetWeeks--),
            onNext: () => setState(() => _offsetWeeks++),
            onToday: () => setState(() => _offsetWeeks = 0),
          ),
          const SizedBox(height: 16),
          for (var index = 0; index < 7; index++)
            _DaySection(
              date: start.addDays(index),
              isToday: start.addDays(index) == today,
              entries: entriesByDate[start.addDays(index)] ?? const [],
              shifts: shiftsByDate[start.addDays(index)] ?? const [],
              spaces: spaces,
            ),
        ],
      ),
    );
  }
}

class _WeekHeader extends StatelessWidget {
  const _WeekHeader({
    required this.start,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  final LocalDate start;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final end = start.addDays(6);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final format = DateFormat.MMMd(locale);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.week.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                '${format.format(start.toDateTime())} – ${format.format(end.toDateTime())}',
                style: theme.textTheme.headlineSmall,
              ),
            ),
            IconButton(
              onPressed: onPrevious,
              icon: const Icon(Icons.chevron_left),
              tooltip: context.l10n.previousWeek,
            ),
            IconButton(
              onPressed: onToday,
              icon: const Icon(Icons.today_outlined),
              tooltip: context.l10n.jumpToToday,
            ),
            IconButton(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right),
              tooltip: context.l10n.nextWeek,
            ),
          ],
        ),
      ],
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({
    required this.date,
    required this.isToday,
    required this.entries,
    required this.shifts,
    required this.spaces,
  });

  final LocalDate date;
  final bool isToday;
  final List<EntryOccurrence> entries;
  final List<ShiftOccurrence> shifts;
  final List<Space> spaces;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final empty = entries.isEmpty && shifts.isEmpty;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
      decoration: BoxDecoration(
        color: isToday
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35)
            : theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 46,
                child: Column(
                  children: [
                    Text(
                      DateFormat.E(locale).format(date.toDateTime()).toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isToday ? theme.colorScheme.primary : muted,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      '${date.day}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: isToday ? theme.colorScheme.primary : null,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: shifts.isEmpty
                    ? const SizedBox.shrink()
                    : Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: shifts.map((item) => ShiftChip(occurrence: item)).toList(),
                      ),
              ),
              IconButton(
                onPressed: () => showEntryEditor(context, initialDate: date, spaces: spaces),
                icon: const Icon(Icons.add, size: 20),
                tooltip: context.l10n.addOnThisDay,
              ),
            ],
          ),
          if (empty)
            Padding(
              padding: const EdgeInsets.fromLTRB(46, 2, 8, 4),
              child: Text(
                context.l10n.nothingPlanned,
                style: theme.textTheme.bodySmall?.copyWith(color: muted),
              ),
            )
          else if (entries.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: entries
                    .map((item) => EntryTile(occurrence: item, spaces: spaces, dense: true))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

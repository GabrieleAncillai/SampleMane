import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mane_core/mane_core.dart';

import '../state/providers.dart';
import '../widgets/entry_widgets.dart';
import 'entry_editor.dart';

class WeekScreen extends ConsumerWidget {
  const WeekScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = LocalDate.fromDateTime(DateTime.now());
    final monday = today.mondayOfWeek;
    final range = (start: monday, end: monday.addDays(6));
    final spaces = ref.watch(spacesProvider).value ?? fallbackSpaces;
    final entries = ref.watch(entriesProvider(range)).value ?? const [];
    final shifts = ref.watch(shiftsProvider(range)).value ?? const [];

    final entriesByDate = <LocalDate, List<EntryOccurrence>>{};
    for (final occurrence in entries) {
      (entriesByDate[occurrence.date] ??= []).add(occurrence);
    }

    final shiftsByDate = <LocalDate, List<ShiftOccurrence>>{};
    for (final occurrence in shifts) {
      (shiftsByDate[occurrence.date] ??= []).add(occurrence);
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 100),
        children: [
          _WeekHeader(monday: monday),
          const SizedBox(height: 20),
          for (var index = 0; index < 7; index++)
            _DaySection(
              date: monday.addDays(index),
              isToday: monday.addDays(index) == today,
              entries: entriesByDate[monday.addDays(index)] ?? const [],
              shifts: shiftsByDate[monday.addDays(index)] ?? const [],
              spaces: spaces,
            ),
        ],
      ),
    );
  }
}

class _WeekHeader extends StatelessWidget {
  const _WeekHeader({required this.monday});

  final LocalDate monday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sunday = monday.addDays(6);
    final format = DateFormat('d MMM');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WEEK',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${format.format(monday.toDateTime())} – '
          '${format.format(sunday.toDateTime())}',
          style: theme.textTheme.headlineMedium,
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
                      DateFormat('EEE').format(date.toDateTime()).toUpperCase(),
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
                tooltip: 'Add on this day',
              ),
            ],
          ),
          if (empty)
            Padding(
              padding: const EdgeInsets.fromLTRB(46, 2, 8, 4),
              child: Text('Nothing planned', style: theme.textTheme.bodySmall?.copyWith(color: muted)),
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

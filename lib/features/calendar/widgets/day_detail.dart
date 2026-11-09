import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/l10n.dart';
import '../../../widgets/entry_widgets.dart';
import '../../shifts/widgets/shift_checklist_view.dart';

class CalendarDayDetail extends StatelessWidget {
  const CalendarDayDetail({
    super.key,
    required this.date,
    required this.entries,
    required this.shifts,
    required this.spaces,
    required this.onAdd,
  });

  final LocalDate date;
  final List<EntryOccurrence> entries;
  final List<ShiftOccurrence> shifts;
  final List<Space> spaces;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final title = DateFormat.yMMMMEEEEd(locale).format(date.toDateTime());
    final checklistShifts = <String, ShiftOccurrence>{};
    for (final shift in shifts) {
      checklistShifts.putIfAbsent('${shift.pattern.id}:${shift.date.key}', () => shift);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 20),
              tooltip: context.l10n.addOnThisDay,
            ),
          ],
        ),
        if (shifts.isNotEmpty) ...[
          const SizedBox(height: 8),
          for (final shift in shifts) ShiftTile(occurrence: shift),
          for (final shift in checklistShifts.values)
            ShiftChecklistSection(patternId: shift.pattern.id, date: shift.date),
        ],
        if (entries.isEmpty && shifts.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              context.l10n.noEntriesOnDay,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          )
        else
          for (final entry in entries) EntryTile(occurrence: entry, spaces: spaces),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
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
    final c = context.mc;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final title = DateFormat.yMMMMEEEEd(locale).format(date.toDateTime());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(title, style: ManeType.title(15, color: c.text)),
            ),
            GlassIconButton(icon: Icons.add, tooltip: context.l10n.addOnThisDay, size: 34, onTap: onAdd),
          ],
        ),
        if (shifts.isNotEmpty) ...[
          const SizedBox(height: 10),
          for (final shift in shifts) ShiftTile(occurrence: shift),
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
        if (entries.isEmpty && shifts.isEmpty)
          AppEmptyState(
            icon: Icons.event_available_outlined,
            title: context.l10n.noEntriesOnDay,
            compact: true,
          )
        else
          for (var index = 0; index < entries.length; index++) ...[
            if (index > 0) const Divider(height: 1, indent: 44),
            EntryTile(occurrence: entries[index], spaces: spaces, dense: true),
          ],
      ],
    );
  }
}

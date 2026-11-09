import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mane_core/mane_core.dart';

import '../core/i18n/l10n.dart';
import '../core/widgets/ui_kit.dart';
import '../state/providers.dart';
import '../state/settings_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
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
    final entriesState = ref.watch(entriesProvider(range));
    final shiftsState = ref.watch(shiftsProvider(range));
    final allEntries = entriesState.value ?? const <EntryOccurrence>[];
    final allShifts = shiftsState.value ?? const <ShiftOccurrence>[];
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

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      children: [
        _WeekHeader(
          start: start,
          onPrevious: () => setState(() => _offsetWeeks--),
          onNext: () => setState(() => _offsetWeeks++),
          onToday: () => setState(() => _offsetWeeks = 0),
        ),
        const SizedBox(height: 16),
        if (entriesState.hasError) ManeNotice(text: context.l10n.couldNotLoadDay('${entriesState.error}')),
        if (shiftsState.hasError) ManeNotice(text: context.l10n.couldNotLoadShifts('${shiftsState.error}')),
        for (var index = 0; index < 7; index++) ...[
          _DaySection(
            date: start.addDays(index),
            isToday: start.addDays(index) == today,
            entries: entriesByDate[start.addDays(index)] ?? const [],
            shifts: shiftsByDate[start.addDays(index)] ?? const [],
            spaces: spaces,
          ),
          const SizedBox(height: 10),
        ],
      ],
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
    final c = context.mc;
    final end = start.addDays(6);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final format = DateFormat.MMMd(locale);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(context.l10n.week, color: c.accent),
        Row(
          children: [
            Expanded(
              child: Text(
                '${format.format(start.toDateTime())} – ${format.format(end.toDateTime())}',
                style: ManeType.headline(23, color: c.text),
              ),
            ),
            GlassIconButton(
              icon: Icons.chevron_left,
              tooltip: context.l10n.previousWeek,
              size: 36,
              onTap: onPrevious,
            ),
            const SizedBox(width: 8),
            GlassIconButton(
              icon: Icons.today_outlined,
              tooltip: context.l10n.jumpToToday,
              size: 36,
              onTap: onToday,
            ),
            const SizedBox(width: 8),
            GlassIconButton(
              icon: Icons.chevron_right,
              tooltip: context.l10n.nextWeek,
              size: 36,
              onTap: onNext,
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
    final c = context.mc;
    final empty = entries.isEmpty && shifts.isEmpty;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return SoftCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 10),
      color: isToday ? c.accentSoft : c.surface,
      borderColor: isToday ? c.accent.withValues(alpha: 0.35) : c.border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isToday ? c.accent : c.surfaceAlt,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.E(locale).format(date.toDateTime()).toUpperCase(),
                      style: ManeType.label(9.5, color: isToday ? c.onAccent : c.textTertiary),
                    ),
                    Text('${date.day}', style: ManeType.title(16, color: isToday ? c.onAccent : c.text)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: shifts.isEmpty
                    ? const SizedBox.shrink()
                    : Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: shifts.map((item) => ShiftChip(occurrence: item)).toList(),
                      ),
              ),
              GlassIconButton(
                icon: Icons.add,
                tooltip: context.l10n.addOnThisDay,
                size: 34,
                onTap: () => showEntryEditor(context, initialDate: date, spaces: spaces),
              ),
            ],
          ),
          if (empty)
            Padding(
              padding: const EdgeInsets.fromLTRB(54, 8, 8, 2),
              child: Text(context.l10n.nothingPlanned, style: ManeType.body(12, color: c.textTertiary)),
            )
          else if (entries.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 6),
              child: Column(
                children: [
                  for (var index = 0; index < entries.length; index++) ...[
                    if (index > 0) const Divider(height: 1, indent: 44),
                    EntryTile(occurrence: entries[index], spaces: spaces, dense: true),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

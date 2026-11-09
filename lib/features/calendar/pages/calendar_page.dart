import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../screens/entry_editor.dart';
import '../../../state/providers.dart';
import '../../../state/settings_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../widgets/day_detail.dart';
import '../widgets/day_timeline.dart';
import '../widgets/month_grid.dart';
import '../widgets/week_strip.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

enum _CalendarMode { month, week, day }

class _CalendarPageState extends ConsumerState<CalendarPage> {
  late LocalDate _selected;
  late LocalDate _visibleMonth;
  _CalendarMode _mode = _CalendarMode.month;

  @override
  void initState() {
    super.initState();
    final today = localDateAt(ref.read(nowProvider), ref.read(deviceTimeZoneProvider));
    _selected = today;
    _visibleMonth = LocalDate(today.year, today.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final spaces = ref.watch(spacesProvider).value ?? fallbackSpaces;
    final today = localDateAt(ref.watch(nowProvider), ref.watch(deviceTimeZoneProvider));
    final weekStart = settings.weekStart;
    final rangeStart = switch (_mode) {
      _CalendarMode.month => _visibleMonth.startOfWeek(weekStart),
      _CalendarMode.week => _selected.startOfWeek(weekStart),
      _CalendarMode.day => _selected.addDays(-1),
    };
    final rangeEnd = switch (_mode) {
      _CalendarMode.month => rangeStart.addDays(41),
      _CalendarMode.week => rangeStart.addDays(6),
      _CalendarMode.day => _selected.addDays(1),
    };
    final range = (start: rangeStart, end: rangeEnd);
    final entriesState = ref.watch(entriesProvider(range));
    final shiftsState = ref.watch(shiftsProvider(range));
    final entries = entriesState.value ?? const <EntryOccurrence>[];
    final shifts = shiftsState.value ?? const <ShiftOccurrence>[];

    final visibleEntries = settings.hideWorkSpace
        ? entries.where((entry) => entry.entry.spaceId != 'work').toList()
        : entries;
    final visibleShifts = settings.hideWorkSpace ? const <ShiftOccurrence>[] : shifts;

    final colors = {for (final space in spaces) space.id: space.colorValue};
    final markers = <int, Set<int>>{};
    for (final entry in visibleEntries) {
      (markers[entry.displayDate.key] ??= <int>{}).add(colors[entry.entry.spaceId] ?? 0xFF888888);
    }
    final shiftDays = {for (final shift in visibleShifts) shift.displayDate.key};

    final selectedEntries = visibleEntries.where((entry) => entry.displayDate == _selected).toList();
    final selectedShifts = visibleShifts.where((shift) => shift.displayDate == _selected).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      children: [
        _CalendarHeader(
          title: _title(),
          mode: _mode,
          onPrevious: () => _shift(-1),
          onNext: () => _shift(1),
          onToday: _goToToday,
          onModeChanged: (value) => setState(() {
            _mode = value;
            _visibleMonth = LocalDate(_selected.year, _selected.month, 1);
          }),
        ),
        const SizedBox(height: 14),
        if (entriesState.hasError) ManeNotice(text: context.l10n.couldNotLoadDay('${entriesState.error}')),
        if (shiftsState.hasError) ManeNotice(text: context.l10n.couldNotLoadShifts('${shiftsState.error}')),
        if (_mode == _CalendarMode.day)
          SoftCard(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: DayTimeline(
              day: _selected,
              entries: selectedEntries,
              shifts: selectedShifts,
              spaces: spaces,
              onAdd: () => showEntryEditor(context, initialDate: _selected, spaces: spaces),
            ),
          )
        else ...[
          SoftCard(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
            child: _mode == _CalendarMode.month
                ? MonthGrid(
                    month: _visibleMonth,
                    selected: _selected,
                    today: today,
                    weekStart: weekStart,
                    markers: markers,
                    shiftDays: shiftDays,
                    onSelected: _select,
                  )
                : WeekStrip(
                    selected: _selected,
                    today: today,
                    weekStart: weekStart,
                    markers: markers,
                    shiftDays: shiftDays,
                    onSelected: _select,
                  ),
          ),
          const SizedBox(height: 12),
          SoftCard(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: CalendarDayDetail(
              date: _selected,
              entries: selectedEntries,
              shifts: selectedShifts,
              spaces: spaces,
              onAdd: () => showEntryEditor(context, initialDate: _selected, spaces: spaces),
            ),
          ),
        ],
      ],
    );
  }

  String _title() {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (_mode == _CalendarMode.month) {
      return DateFormat.yMMMM(locale).format(_visibleMonth.toDateTime());
    }
    if (_mode == _CalendarMode.day) {
      return DateFormat.yMMMMEEEEd(locale).format(_selected.toDateTime());
    }
    final start = _selected.startOfWeek(ref.read(settingsProvider).weekStart);
    final end = start.addDays(6);
    final format = DateFormat.MMMd(locale);
    return '${format.format(start.toDateTime())} – ${format.format(end.toDateTime())}';
  }

  void _select(LocalDate date) {
    setState(() {
      _selected = date;
      if (date.year != _visibleMonth.year || date.month != _visibleMonth.month) {
        _visibleMonth = LocalDate(date.year, date.month, 1);
      }
    });
  }

  void _shift(int by) {
    setState(() {
      switch (_mode) {
        case _CalendarMode.month:
          _visibleMonth = _shiftedMonth(_visibleMonth, by);
          final day = _selected.day.clamp(1, _visibleMonth.daysInMonth);
          _selected = LocalDate(_visibleMonth.year, _visibleMonth.month, day);
        case _CalendarMode.week:
          _selected = _selected.addDays(7 * by);
          _visibleMonth = LocalDate(_selected.year, _selected.month, 1);
        case _CalendarMode.day:
          _selected = _selected.addDays(by);
          _visibleMonth = LocalDate(_selected.year, _selected.month, 1);
      }
    });
  }

  void _goToToday() {
    final today = localDateAt(ref.read(nowProvider), ref.read(deviceTimeZoneProvider));
    setState(() {
      _selected = today;
      _visibleMonth = LocalDate(today.year, today.month, 1);
    });
  }

  LocalDate _shiftedMonth(LocalDate month, int by) {
    final index = month.year * 12 + month.month - 1 + by;
    return LocalDate(index ~/ 12, index % 12 + 1, 1);
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.title,
    required this.mode,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
    required this.onModeChanged,
  });

  final String title;
  final _CalendarMode mode;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;
  final ValueChanged<_CalendarMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(context.l10n.calendar, color: c.accent),
        Row(
          children: [
            Expanded(
              child: Text(title, style: ManeType.headline(23, color: c.text)),
            ),
            GlassIconButton(
              icon: Icons.chevron_left,
              tooltip: mode == _CalendarMode.month ? context.l10n.previousMonth : context.l10n.previousWeek,
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
              tooltip: mode == _CalendarMode.month ? context.l10n.nextMonth : context.l10n.nextWeek,
              size: 36,
              onTap: onNext,
            ),
          ],
        ),
        const SizedBox(height: 10),
        ManeSegmented<_CalendarMode>(
          segments: [
            ManeSegment(value: _CalendarMode.month, label: context.l10n.monthView),
            ManeSegment(value: _CalendarMode.week, label: context.l10n.weekView),
            ManeSegment(value: _CalendarMode.day, label: context.l10n.dayView),
          ],
          selected: mode,
          onChanged: onModeChanged,
          compact: true,
        ),
      ],
    );
  }
}

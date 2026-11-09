import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mane_core/mane_core.dart';

import '../core/i18n/l10n.dart';
import '../core/widgets/ui_kit.dart';
import '../features/sleep/sleep_window_card.dart';
import '../state/providers.dart';
import '../state/settings_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/entry_widgets.dart';
import 'entry_editor.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceTimeZone = ref.watch(deviceTimeZoneProvider);
    final today = localDateAt(ref.watch(nowProvider), deviceTimeZone);
    final range = (start: today, end: today);
    final settings = ref.watch(settingsProvider);
    final spaces = ref.watch(spacesProvider).value ?? fallbackSpaces;
    final entriesState = ref.watch(entriesProvider(range));
    final shiftsState = ref.watch(shiftsProvider(range));
    final l10n = context.l10n;
    final c = context.mc;

    final entries = settings.hideWorkSpace
        ? (entriesState.value ?? const <EntryOccurrence>[])
              .where((entry) => entry.entry.spaceId != 'work')
              .toList()
        : entriesState.value ?? const <EntryOccurrence>[];
    final shifts = settings.hideWorkSpace
        ? const <ShiftOccurrence>[]
        : shiftsState.value ?? const <ShiftOccurrence>[];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      children: [
        _TodayHeader(date: today),
        const SizedBox(height: 18),
        const SleepWindowCard(),
        if (shifts.isNotEmpty) ...[
          const SizedBox(height: 14),
          SectionLabel(l10n.shiftsSection),
          for (final item in shifts) ShiftTile(occurrence: item),
        ],
        if (shiftsState.hasError) _ErrorNotice(text: l10n.couldNotLoadShifts('${shiftsState.error}')),
        if (entriesState.hasError)
          _ErrorNotice(text: l10n.couldNotLoadDay('${entriesState.error}'))
        else
          _EntriesSection(entries: entries, spaces: spaces),
        if (entries.isEmpty && shifts.isEmpty) ...[
          const SizedBox(height: 10),
          SoftCard(
            padding: EdgeInsets.zero,
            color: c.surface.withValues(alpha: 0.7),
            child: AppEmptyState(
              icon: Icons.event_available_outlined,
              title: l10n.noPlanToday,
              message: l10n.noPlanTodayHint,
              action: FilledButton.tonalIcon(
                onPressed: () => showEntryEditor(context, spaces: spaces),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.addSomething),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _TodayHeader extends StatelessWidget {
  const _TodayHeader({required this.date});

  final LocalDate date;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(context.l10n.today, color: c.accent),
        Text(
          DateFormat('EEEE', locale).format(date.toDateTime()),
          style: ManeType.display(31, color: c.text),
        ),
        const SizedBox(height: 2),
        Text(
          DateFormat.yMMMMd(locale).format(date.toDateTime()),
          style: ManeType.body(14, color: c.textSecondary),
        ),
      ],
    );
  }
}

class _EntriesSection extends StatelessWidget {
  const _EntriesSection({required this.entries, required this.spaces});

  final List<EntryOccurrence> entries;
  final List<Space> spaces;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();

    final grouped = <String, List<EntryOccurrence>>{};
    for (final occurrence in entries) {
      (grouped[occurrence.entry.spaceId] ??= []).add(occurrence);
    }

    final children = <Widget>[];
    for (final space in spaces) {
      final items = grouped.remove(space.id);
      if (items == null || items.isEmpty) continue;
      children
        ..add(const SizedBox(height: 10))
        ..add(_SpaceHeader(space: space))
        ..add(
          SoftCard(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            clip: true,
            child: Column(
              children: [
                for (var index = 0; index < items.length; index++) ...[
                  if (index > 0) const Divider(height: 1, indent: 44),
                  EntryTile(occurrence: items[index], spaces: spaces),
                ],
              ],
            ),
          ),
        );
    }

    if (grouped.isNotEmpty) {
      final leftovers = grouped.values.expand((items) => items).toList();
      children.addAll(leftovers.map((item) => EntryTile(occurrence: item, spaces: spaces)));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}

class _SpaceHeader extends StatelessWidget {
  const _SpaceHeader({required this.space});

  final Space space;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: Color(space.colorValue), shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(space.name.toUpperCase(), style: ManeType.kicker(color: context.mc.textTertiary)),
        ],
      ),
    );
  }
}

class _ErrorNotice extends StatelessWidget {
  const _ErrorNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.dangerSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.danger.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 18, color: c.danger),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: ManeType.body(12.5, color: c.danger)),
          ),
        ],
      ),
    );
  }
}

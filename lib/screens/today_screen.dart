import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mane_core/mane_core.dart';

import '../core/i18n/l10n.dart';
import '../state/providers.dart';
import '../state/settings_controller.dart';
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

    final entries = settings.hideWorkSpace
        ? (entriesState.value ?? const <EntryOccurrence>[])
              .where((entry) => entry.entry.spaceId != 'work')
              .toList()
        : entriesState.value ?? const <EntryOccurrence>[];
    final shifts = settings.hideWorkSpace
        ? const <ShiftOccurrence>[]
        : shiftsState.value ?? const <ShiftOccurrence>[];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 100),
        children: [
          _TodayHeader(date: today),
          const SizedBox(height: 20),
          if (shifts.isNotEmpty) ...[
            _SectionLabel(l10n.shiftsSection),
            const SizedBox(height: 8),
            ...shifts.map((item) => ShiftTile(occurrence: item)),
            const SizedBox(height: 8),
          ],
          if (shiftsState.hasError) Text(l10n.couldNotLoadShifts('${shiftsState.error}')),
          if (entriesState.hasError)
            Text(l10n.couldNotLoadDay('${entriesState.error}'))
          else
            _EntriesSection(entries: entries, spaces: spaces),
        ],
      ),
    );
  }
}

class _TodayHeader extends StatelessWidget {
  const _TodayHeader({required this.date});

  final LocalDate date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.today.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(DateFormat('EEEE', locale).format(date.toDateTime()), style: theme.textTheme.headlineMedium),
        Text(
          DateFormat.yMMMMd(locale).format(date.toDateTime()),
          style: theme.textTheme.bodyMedium?.copyWith(color: muted),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider()),
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
    if (entries.isEmpty) {
      return _EmptyState(onAdd: () => showEntryEditor(context, spaces: spaces));
    }

    final grouped = <String, List<EntryOccurrence>>{};
    for (final occurrence in entries) {
      (grouped[occurrence.entry.spaceId] ??= []).add(occurrence);
    }

    final children = <Widget>[];
    for (final space in spaces) {
      final items = grouped.remove(space.id);
      if (items == null || items.isEmpty) continue;
      children
        ..add(_SpaceHeader(space: space))
        ..addAll(items.map((item) => EntryTile(occurrence: item, spaces: spaces)));
    }

    for (final leftOver in grouped.values) {
      children.addAll(leftOver.map((item) => EntryTile(occurrence: item, spaces: spaces)));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}

class _SpaceHeader extends StatelessWidget {
  const _SpaceHeader({required this.space});

  final Space space;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: Color(space.colorValue), shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            space.name.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.event_available_outlined, size: 40, color: muted),
          const SizedBox(height: 12),
          Text(context.l10n.noPlanToday, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            context.l10n.noPlanTodayHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: muted),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(context.l10n.addSomething),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/l10n.dart';
import '../../../models/shift_checklist.dart';
import '../../../state/providers.dart';

/// The checklist for one shift date. Completions are keyed by item and date,
/// so ticking an item on one shift never changes another shift's checklist.
class ShiftChecklistSection extends ConsumerStatefulWidget {
  const ShiftChecklistSection({super.key, required this.patternId, required this.date});

  final String patternId;
  final LocalDate date;

  @override
  ConsumerState<ShiftChecklistSection> createState() => _ShiftChecklistSectionState();
}

class _ShiftChecklistSectionState extends ConsumerState<ShiftChecklistSection> {
  Future<(List<ShiftChecklistItem>, Set<String>)>? _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<(List<ShiftChecklistItem>, Set<String>)> _load() async {
    final repository = ref.read(repositoryProvider);
    final items = await repository.readShiftChecklistItems(widget.patternId);
    if (items.isEmpty) return (items, <String>{});
    final done = await repository.readShiftChecklistCompletions(widget.patternId, widget.date);
    return (items, done);
  }

  Future<void> _toggle(ShiftChecklistItem item, bool completed) async {
    try {
      await ref.read(repositoryProvider).setShiftChecklistCompleted(item.id, widget.date, completed);
      if (!mounted) return;
      setState(() => _future = _load());
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.couldNotSave('$error'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<(List<ShiftChecklistItem>, Set<String>)>(
      future: _future,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null || data.$1.isEmpty) return const SizedBox.shrink();
        final (items, done) = data;
        final completed = items.where((item) => done.contains(item.id)).length;

        return Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${context.l10n.shiftChecklist} · '
                '${context.l10n.checklistDone(completed, items.length)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 0.4,
                ),
              ),
              for (final item in items)
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: done.contains(item.id),
                  title: Text(item.label, style: theme.textTheme.bodyMedium),
                  onChanged: (value) => _toggle(item, value == true),
                ),
            ],
          ),
        );
      },
    );
  }
}

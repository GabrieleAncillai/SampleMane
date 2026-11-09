import 'package:flutter/material.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/i18n/reminder_label.dart';

const reminderOffsetChoices = <int>[0, 5, 10, 30, 60, 120, 1440];

Future<Set<int>?> showReminderOffsetSheet(BuildContext context, {required Set<int> initial}) =>
    showModalBottomSheet<Set<int>>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => ReminderOffsetSheet(initial: initial),
    );

class ReminderOffsetSheet extends StatefulWidget {
  const ReminderOffsetSheet({super.key, required this.initial});

  final Set<int> initial;

  @override
  State<ReminderOffsetSheet> createState() => _ReminderOffsetSheetState();
}

class _ReminderOffsetSheetState extends State<ReminderOffsetSheet> {
  late Set<int> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {...widget.initial};
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Row(
            children: [
              Expanded(child: Text(l10n.reminders, style: Theme.of(context).textTheme.titleLarge)),
              TextButton(onPressed: () => Navigator.of(context).pop(_selected), child: Text(l10n.save)),
            ],
          ),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final offset in reminderOffsetChoices)
                CheckboxListTile(
                  value: _selected.contains(offset),
                  title: Text(reminderOffsetLabel(context, offset)),
                  onChanged: (selected) => setState(() {
                    if (selected == true) {
                      _selected.add(offset);
                    } else {
                      _selected.remove(offset);
                    }
                  }),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

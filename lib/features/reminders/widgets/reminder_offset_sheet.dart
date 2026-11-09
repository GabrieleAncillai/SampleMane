import 'package:flutter/material.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/i18n/reminder_label.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

const reminderOffsetChoices = <int>[0, 5, 10, 30, 60, 120, 1440];

class ReminderSelection {
  const ReminderSelection({required this.offsets, required this.times});

  final Set<int> offsets;
  final Set<int> times;
}

Future<ReminderSelection?> showReminderSelectionSheet(
  BuildContext context, {
  required Set<int> offsets,
  required Set<int> times,
}) => showAppSheet<ReminderSelection>(
  context: context,
  builder: (context) => ReminderSelectionSheet(initialOffsets: offsets, initialTimes: times),
);

class ReminderSelectionSheet extends StatefulWidget {
  const ReminderSelectionSheet({super.key, required this.initialOffsets, required this.initialTimes});

  final Set<int> initialOffsets;
  final Set<int> initialTimes;

  @override
  State<ReminderSelectionSheet> createState() => _ReminderSelectionSheetState();
}

class _ReminderSelectionSheetState extends State<ReminderSelectionSheet> {
  late Set<int> _offsets;
  late Set<int> _times;

  @override
  void initState() {
    super.initState();
    _offsets = {...widget.initialOffsets};
    _times = {...widget.initialTimes};
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.mc;
    return AppSheet(
      title: l10n.reminders,
      children: [
        SectionLabel(l10n.beforeStart),
        for (final offset in reminderOffsetChoices)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _offsets.contains(offset),
            title: Text(reminderOffsetLabel(context, offset)),
            onChanged: (selected) => setState(() {
              if (selected == true) {
                _offsets.add(offset);
              } else {
                _offsets.remove(offset);
              }
            }),
          ),
        const SizedBox(height: 10),
        SectionLabel(l10n.atTimeSection),
        if (_times.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final minute in (_times.toList()..sort()))
                InputChip(
                  label: Text(_timeLabel(context, minute)),
                  onDeleted: () => setState(() => _times.remove(minute)),
                ),
            ],
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _addTime,
            icon: const Icon(Icons.schedule, size: 18),
            label: Text(l10n.addTime),
          ),
        ),
        const SizedBox(height: 8),
        Text(l10n.customReminderHint, style: ManeType.body(11.5, color: c.textTertiary)),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(ReminderSelection(offsets: _offsets, times: _times)),
          child: Text(l10n.save),
        ),
      ],
    );
  }

  Future<void> _addTime() async {
    final picked = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 9, minute: 0));
    if (picked == null) return;
    setState(() => _times.add(picked.hour * 60 + picked.minute));
  }

  static String _timeLabel(BuildContext context, int minute) =>
      MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay(hour: minute ~/ 60, minute: minute % 60));
}

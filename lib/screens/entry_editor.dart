import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mane_core/mane_core.dart';
import 'package:uuid/uuid.dart';

import '../state/providers.dart';

const _editorFallbackSpaces = <Space>[
  Space(id: 'home', name: 'Home', colorValue: 0xFF5B7F6B),
  Space(id: 'work', name: 'Work', colorValue: 0xFF4A6FA5),
];

enum _Repeat { never, daily, weekly, monthly, yearly }

Future<void> showEntryEditor(
  BuildContext context, {
  Entry? entry,
  LocalDate? initialDate,
  required List<Space> spaces,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => EntryEditorSheet(entry: entry, initialDate: initialDate, spaces: spaces),
  );
}

class EntryEditorSheet extends ConsumerStatefulWidget {
  const EntryEditorSheet({super.key, required this.spaces, this.entry, this.initialDate});

  final List<Space> spaces;
  final Entry? entry;
  final LocalDate? initialDate;

  @override
  ConsumerState<EntryEditorSheet> createState() => _EntryEditorSheetState();
}

class _EntryEditorSheetState extends ConsumerState<EntryEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late String _spaceId;
  late EntryKind _kind;
  late LocalDate _date;
  late bool _allDay;
  late int _startMinute;
  late int _endMinute;
  late _Repeat _repeat;
  bool _saving = false;

  List<Space> get _spaces => widget.spaces.isEmpty ? _editorFallbackSpaces : widget.spaces;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _titleController = TextEditingController(text: entry?.title ?? '');
    _notesController = TextEditingController(text: entry?.notes ?? '');
    _spaceId = entry != null && _spaces.any((space) => space.id == entry.spaceId)
        ? entry.spaceId
        : _spaces.first.id;
    _kind = entry?.kind ?? EntryKind.task;
    _date = entry?.date ?? widget.initialDate ?? LocalDate.fromDateTime(DateTime.now());
    _allDay = entry?.allDay ?? false;
    _startMinute = entry?.startMinute ?? 9 * 60;
    _endMinute = entry?.endMinute ?? 10 * 60;
    _repeat = _repeatFrom(entry?.recurrence);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.entry == null ? 'New entry' : 'Edit entry';

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text(title, style: theme.textTheme.headlineSmall)),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'What is it?', border: OutlineInputBorder()),
                validator: (value) => value == null || value.trim().isEmpty ? 'Give it a name' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _LabeledDropdown<String>(
                      label: 'Space',
                      value: _spaceId,
                      items: _spaces
                          .map(
                            (space) => DropdownMenuItem<String>(
                              value: space.id,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Color(space.colorValue),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(space.name),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _spaceId = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LabeledDropdown<EntryKind>(
                      label: 'Type',
                      value: _kind,
                      items: EntryKind.values
                          .map(
                            (kind) => DropdownMenuItem<EntryKind>(value: kind, child: Text(_kindLabel(kind))),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _kind = value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _PickerRow(
                icon: Icons.event_outlined,
                label: 'Date',
                value: DateFormat('EEE d MMM yyyy').format(_date.toDateTime()),
                onTap: _pickDate,
              ),
              const SizedBox(height: 4),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('All day'),
                value: _allDay,
                onChanged: (value) => setState(() => _allDay = value),
              ),
              if (!_allDay)
                Row(
                  children: [
                    Expanded(
                      child: _PickerRow(
                        icon: Icons.schedule,
                        label: 'Starts',
                        value: _timeLabel(_startMinute),
                        onTap: _pickStartTime,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PickerRow(
                        icon: Icons.schedule_outlined,
                        label: 'Ends',
                        value: _timeLabel(_endMinute),
                        onTap: _pickEndTime,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              _LabeledDropdown<_Repeat>(
                label: 'Repeat',
                value: _repeat,
                items: _Repeat.values
                    .map(
                      (repeat) => DropdownMenuItem<_Repeat>(value: repeat, child: Text(_repeatLabel(repeat))),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _repeat = value);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.entry == null ? 'Add entry' : 'Save changes'),
                ),
              ),
              if (widget.entry != null)
                TextButton(
                  onPressed: _saving ? null : _delete,
                  style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
                  child: const Text('Delete'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeLabel(int minutes) {
    final normalized = minutes % 1440;
    return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60).format(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date.toDateTime(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() => _date = LocalDate.fromDateTime(picked));
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _startMinute ~/ 60, minute: _startMinute % 60),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _startMinute = picked.hour * 60 + picked.minute;
      if (_endMinute <= _startMinute) {
        _endMinute = math.min(_startMinute + 60, 1439);
      }
    });
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: (_endMinute ~/ 60) % 24, minute: _endMinute % 60),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _endMinute = picked.hour * 60 + picked.minute;
      if (_endMinute <= _startMinute) {
        _startMinute = math.max(0, _endMinute - 60);
      }
    });
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    if (!_allDay && _endMinute <= _startMinute) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('The end time has to be after the start.')));
      return;
    }

    setState(() => _saving = true);
    final now = DateTime.now();
    final entry = Entry(
      id: widget.entry?.id ?? const Uuid().v4(),
      spaceId: _spaceId,
      title: _titleController.text.trim(),
      notes: _notesController.text.trim(),
      kind: _kind,
      date: _date,
      startMinute: _allDay ? null : _startMinute,
      endMinute: _allDay ? null : _endMinute,
      allDay: _allDay,
      status: widget.entry?.status ?? EntryStatus.open,
      recurrence: _buildRecurrence(),
      createdAt: widget.entry?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      await ref.read(repositoryProvider).saveEntry(entry);
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save: $error')));
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final entry = widget.entry;
    if (entry == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this entry?'),
        content: const Text('It will disappear from your plan.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _saving = true);
    try {
      await ref.read(repositoryProvider).deleteEntry(entry.id);
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not delete: $error')));
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  RecurrenceRule? _buildRecurrence() {
    final existing = widget.entry?.recurrence;
    final frequency = _frequencyFor(_repeat);
    if (frequency == null) return null;

    // Keep an existing rule intact when the user did not change the shape.
    if (existing != null && existing.frequency == frequency && widget.entry?.date == _date) {
      return existing;
    }

    return switch (_repeat) {
      _Repeat.never => null,
      _Repeat.daily => const RecurrenceRule(frequency: RecurrenceFrequency.daily),
      _Repeat.weekly => RecurrenceRule(frequency: RecurrenceFrequency.weekly, weekdays: {_date.weekday}),
      _Repeat.monthly => RecurrenceRule(frequency: RecurrenceFrequency.monthly, monthDay: _date.day),
      _Repeat.yearly => const RecurrenceRule(frequency: RecurrenceFrequency.yearly),
    };
  }

  _Repeat _repeatFrom(RecurrenceRule? rule) {
    return switch (rule?.frequency) {
      null => _Repeat.never,
      RecurrenceFrequency.daily => _Repeat.daily,
      RecurrenceFrequency.weekly => _Repeat.weekly,
      RecurrenceFrequency.monthly => _Repeat.monthly,
      RecurrenceFrequency.yearly => _Repeat.yearly,
    };
  }

  RecurrenceFrequency? _frequencyFor(_Repeat repeat) => switch (repeat) {
    _Repeat.never => null,
    _Repeat.daily => RecurrenceFrequency.daily,
    _Repeat.weekly => RecurrenceFrequency.weekly,
    _Repeat.monthly => RecurrenceFrequency.monthly,
    _Repeat.yearly => RecurrenceFrequency.yearly,
  };

  String _repeatLabel(_Repeat repeat) => switch (repeat) {
    _Repeat.never => 'Never',
    _Repeat.daily => 'Every day',
    _Repeat.weekly => 'Every week',
    _Repeat.monthly => 'Every month',
    _Repeat.yearly => 'Every year',
  };

  String _kindLabel(EntryKind kind) => switch (kind) {
    EntryKind.task => 'Task',
    EntryKind.event => 'Event',
    EntryKind.obligation => 'Obligation',
    EntryKind.deadline => 'Deadline',
  };
}

class _LabeledDropdown<T> extends StatelessWidget {
  const _LabeledDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          isDense: true,
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({required this.icon, required this.label, required this.value, required this.onTap});

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          border: const OutlineInputBorder(),
        ),
        child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

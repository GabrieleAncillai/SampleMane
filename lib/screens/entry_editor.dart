import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mane_core/mane_core.dart';
import 'package:uuid/uuid.dart';

import '../core/i18n/l10n.dart';
import '../core/i18n/recurrence_label.dart';
import '../core/i18n/reminder_label.dart';
import '../features/reminders/widgets/reminder_offset_sheet.dart';
import '../models/reminder.dart';
import '../state/providers.dart';
import '../state/settings_controller.dart';

const _editorFallbackSpaces = <Space>[
  Space(id: 'personal', name: 'Personal', colorValue: 0xFFB07D5C, position: 0),
  Space(id: 'work', name: 'Work', colorValue: 0xFF4A6FA5, position: 1),
  Space(id: 'home', name: 'Home', colorValue: 0xFF5B7F6B, position: 2),
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
  late String _deviceTimeZone;
  late Set<String> _tagIds;
  late Set<int> _reminderOffsets;
  bool _remindersLoaded = true;
  bool _saving = false;

  List<Space> get _spaces => widget.spaces.isEmpty ? _editorFallbackSpaces : widget.spaces;

  /// The stored timezone for an existing timed entry; the device zone for a
  /// new one. All-day entries carry no timezone at all.
  String get _timeZone => widget.entry?.timeZone ?? _deviceTimeZone;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _deviceTimeZone = ref.read(deviceTimeZoneProvider);
    _titleController = TextEditingController(text: entry?.title ?? '');
    _notesController = TextEditingController(text: entry?.notes ?? '');
    _spaceId = entry != null && _spaces.any((space) => space.id == entry.spaceId)
        ? entry.spaceId
        : _spaces.first.id;
    _kind = entry?.kind ?? EntryKind.task;
    _date = entry?.date ?? widget.initialDate ?? localDateAt(ref.read(nowProvider), _deviceTimeZone);
    _allDay = entry?.allDay ?? false;
    _startMinute = entry?.startMinute ?? 9 * 60;
    _endMinute = entry?.endMinute ?? 10 * 60;
    _repeat = _repeatFrom(entry?.recurrence);
    _tagIds = {...?entry?.tagIds};
    if (entry == null) {
      _reminderOffsets = {...ref.read(settingsProvider).defaultReminderOffsets};
    } else {
      _reminderOffsets = <int>{};
      _remindersLoaded = false;
      _loadReminders(entry.id);
    }
  }

  Future<void> _loadReminders(String entryId) async {
    try {
      final reminders = await ref.read(repositoryProvider).readRemindersForEntry(entryId);
      if (!mounted) return;
      setState(() {
        _reminderOffsets = {
          for (final reminder in reminders)
            if (reminder.enabled) reminder.offsetMinutes,
        };
        _remindersLoaded = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _remindersLoaded = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.couldNotLoadReminders('$error'))));
    }
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
    final l10n = context.l10n;
    final title = widget.entry == null ? l10n.newEntry : l10n.editEntry;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final availableTags = (ref.watch(tagsProvider).value ?? const <Tag>[])
        .where((tag) => tag.appliesTo(_spaceId))
        .toList();

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
                    tooltip: l10n.close,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.titleQuestion,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty ? l10n.titleRequired : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _LabeledDropdown<String>(
                      label: l10n.space,
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
                        if (value != null) {
                          setState(() {
                            _spaceId = value;
                            final allowed = (ref.read(tagsProvider).value ?? const <Tag>[])
                                .where((tag) => tag.appliesTo(value))
                                .map((tag) => tag.id)
                                .toSet();
                            _tagIds.removeWhere((id) => !allowed.contains(id));
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LabeledDropdown<EntryKind>(
                      label: l10n.type,
                      value: _kind,
                      items: EntryKind.values
                          .map(
                            (kind) => DropdownMenuItem<EntryKind>(
                              value: kind,
                              child: Text(entryKindLabel(context, kind)),
                            ),
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
                label: l10n.date,
                value: DateFormat.yMMMEd(locale).format(_date.toDateTime()),
                onTap: _pickDate,
              ),
              const SizedBox(height: 4),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.allDay),
                value: _allDay,
                onChanged: (value) => setState(() => _allDay = value),
              ),
              if (!_allDay)
                Row(
                  children: [
                    Expanded(
                      child: _PickerRow(
                        icon: Icons.schedule,
                        label: l10n.starts,
                        value: _timeLabel(_startMinute),
                        onTap: _pickStartTime,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PickerRow(
                        icon: Icons.schedule_outlined,
                        label: l10n.ends,
                        value: _timeLabel(_endMinute),
                        onTap: _pickEndTime,
                      ),
                    ),
                  ],
                ),
              if (!_allDay)
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 6, 0, 0),
                  child: Row(
                    children: [
                      Icon(Icons.public, size: 14, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l10n.timesDefinedIn(_timeZone),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              _LabeledDropdown<_Repeat>(
                label: l10n.repeat,
                value: _repeat,
                items: _Repeat.values
                    .map(
                      (repeat) => DropdownMenuItem<_Repeat>(
                        value: repeat,
                        child: Text(_repeatLabel(context, repeat)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _repeat = value);
                },
              ),
              const SizedBox(height: 12),
              if (availableTags.isNotEmpty) ...[
                Text(l10n.tags, style: theme.textTheme.labelLarge),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final tag in availableTags)
                      FilterChip(
                        label: Text(tag.name),
                        selected: _tagIds.contains(tag.id),
                        avatar: CircleAvatar(backgroundColor: Color(tag.colorValue), radius: 5),
                        onSelected: (selected) => setState(() {
                          if (selected) {
                            _tagIds.add(tag.id);
                          } else {
                            _tagIds.remove(tag.id);
                          }
                        }),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text(l10n.reminders, style: theme.textTheme.labelLarge)),
                  TextButton.icon(
                    onPressed: _saving ? null : _editReminders,
                    icon: const Icon(Icons.notifications_outlined, size: 18),
                    label: Text(l10n.addReminder),
                  ),
                ],
              ),
              if (_reminderOffsets.isEmpty)
                Text(
                  l10n.remindersOff,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                )
              else
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final offset in (_reminderOffsets.toList()..sort()))
                      InputChip(
                        label: Text(reminderOffsetLabel(context, offset)),
                        onDeleted: _saving ? null : () => setState(() => _reminderOffsets.remove(offset)),
                      ),
                  ],
                ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.notesOptional,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _saving || !_remindersLoaded ? null : _save,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.entry == null ? l10n.addEntry : l10n.saveChanges),
                ),
              ),
              if (widget.entry != null)
                TextButton(
                  onPressed: _saving ? null : _delete,
                  style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
                  child: Text(l10n.delete),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeLabel(int minutes) {
    final normalized = minutes % 1440;
    final label = TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60).format(context);
    return minutes >= 1440 ? '$label ${context.l10n.overnightSuffix}' : label;
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
      final duration = _endMinute - _startMinute;
      _startMinute = picked.hour * 60 + picked.minute;
      _endMinute = _startMinute + duration;
    });
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: (_endMinute ~/ 60) % 24, minute: _endMinute % 60),
    );
    if (picked == null || !mounted) return;
    setState(() {
      var end = picked.hour * 60 + picked.minute;
      // An end at or before the start means the entry runs into tomorrow.
      if (end <= _startMinute) end += 1440;
      _endMinute = end;
    });
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    if (!_allDay && _endMinute <= _startMinute) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.endAfterStartError)));
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
      timeZone: _allDay ? null : _timeZone,
      tagIds: _tagIds,
      allDay: _allDay,
      status: widget.entry?.status ?? EntryStatus.open,
      recurrence: _buildRecurrence(),
      createdAt: widget.entry?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      final repository = ref.read(repositoryProvider);
      await repository.saveEntry(entry);
      await repository.saveRemindersForEntry(entry.id, [
        for (final offset in _reminderOffsets)
          Reminder(id: Reminder.idFor(entry.id, offset), entryId: entry.id, offsetMinutes: offset),
      ]);
      if (_reminderOffsets.isNotEmpty) {
        final allowed = await ref.read(notificationServiceProvider).ensurePermissions();
        if (!allowed && mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(context.l10n.notificationPermissionDenied)));
        }
      }
      await ref.read(reminderCoordinatorProvider).reschedule();
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.couldNotSave('$error'))));
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
        title: Text(context.l10n.deleteEntryQuestion),
        content: Text(context.l10n.deleteEntryBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _saving = true);
    try {
      await ref.read(repositoryProvider).deleteEntry(entry.id);
      await ref.read(reminderCoordinatorProvider).reschedule();
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.couldNotDelete('$error'))));
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _editReminders() async {
    final result = await showReminderOffsetSheet(context, initial: _reminderOffsets);
    if (result != null && mounted) {
      setState(() => _reminderOffsets = result);
    }
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

  String _repeatLabel(BuildContext context, _Repeat repeat) => switch (repeat) {
    _Repeat.never => context.l10n.repeatNever,
    _Repeat.daily => context.l10n.repeatDaily,
    _Repeat.weekly => context.l10n.repeatWeekly,
    _Repeat.monthly => context.l10n.repeatMonthly,
    _Repeat.yearly => context.l10n.repeatYearly,
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

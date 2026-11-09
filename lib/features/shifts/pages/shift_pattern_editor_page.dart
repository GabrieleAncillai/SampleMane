import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mane_core/mane_core.dart';
import 'package:uuid/uuid.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../models/shift_checklist.dart';
import '../../../state/providers.dart';

class ShiftPatternEditorPage extends ConsumerStatefulWidget {
  const ShiftPatternEditorPage({super.key, this.pattern});

  final ShiftPattern? pattern;

  @override
  ConsumerState<ShiftPatternEditorPage> createState() => _ShiftPatternEditorPageState();
}

class _ShiftPatternEditorPageState extends ConsumerState<ShiftPatternEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _timeZoneController;
  late String _spaceId;
  late int _cycleDays;
  late LocalDate _anchorDate;
  late List<_SlotDraft> _slots;
  late List<ShiftException> _exceptions;
  late Set<String> _tagIds;
  late final TextEditingController _commuteController;
  late final TextEditingController _windDownController;
  List<_ChecklistDraft> _checklist = <_ChecklistDraft>[];
  bool _checklistLoading = false;
  late String _deviceTimeZone;
  int _nextDraftId = 0;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final pattern = widget.pattern;
    _deviceTimeZone = ref.read(deviceTimeZoneProvider);
    _nameController = TextEditingController(text: pattern?.name ?? '');
    _timeZoneController = TextEditingController(text: pattern?.timeZone ?? _deviceTimeZone);
    _spaceId = pattern?.spaceId ?? 'work';
    _cycleDays = pattern?.cycleDays ?? 7;
    _anchorDate = pattern?.anchorDate ?? localDateAt(ref.read(nowProvider), _deviceTimeZone);
    _tagIds = {...?pattern?.tagIds};
    _commuteController = TextEditingController(text: pattern?.commuteMinutes?.toString() ?? '');
    _windDownController = TextEditingController(text: pattern?.windDownMinutes?.toString() ?? '');
    _slots = [
      for (final slot in pattern?.slots ?? const <ShiftSlot>[])
        _SlotDraft(
          id: _nextDraftId++,
          dayIndex: slot.dayIndex,
          label: slot.label,
          startMinute: slot.startMinute,
          endMinute: slot.endMinute,
        ),
    ];
    _exceptions = [...?pattern?.exceptions];
    if (pattern != null) _loadChecklist(pattern.id);
  }

  Future<void> _loadChecklist(String patternId) async {
    setState(() => _checklistLoading = true);
    try {
      final items = await ref.read(repositoryProvider).readShiftChecklistItems(patternId);
      if (!mounted) return;
      setState(() {
        _checklist = [for (final item in items) _ChecklistDraft(id: item.id, label: item.label)];
        _checklistLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _checklistLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.couldNotSave('$error'))));
    }
  }

  void _addChecklistItem() {
    setState(() => _checklist.add(_ChecklistDraft(id: const Uuid().v4(), label: '')));
  }

  void _removeChecklistItem(int index) {
    setState(() => _checklist.removeAt(index));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timeZoneController.dispose();
    _commuteController.dispose();
    _windDownController.dispose();
    super.dispose();
  }

  int? _optionalMinutes(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : int.tryParse(text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final spaces = ref.watch(spacesProvider).value ?? fallbackSpaces;
    final availableTags = (ref.watch(tagsProvider).value ?? const <Tag>[])
        .where((tag) => tag.appliesTo(_spaceId))
        .toList();
    final locale = Localizations.localeOf(context).toLanguageTag();
    final activeSpace = spaces.any((space) => space.id == _spaceId) ? _spaceId : spaces.first.id;
    _spaceId = activeSpace;

    final preview = _preview();
    final conflicts = preview?.findConflicts() ?? const <ShiftConflict>[];

    return ManePage(
      title: widget.pattern == null ? l10n.newShiftPattern : l10n.editShiftPattern,
      actions: [
        if (widget.pattern != null)
          GlassIconButton(icon: Icons.delete_outline, tooltip: l10n.delete, onTap: _saving ? null : _delete),
      ],
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l10n.patternName, border: const OutlineInputBorder()),
              validator: (value) => value == null || value.trim().isEmpty ? l10n.patternNameRequired : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _spaceId,
              decoration: InputDecoration(labelText: l10n.space, border: const OutlineInputBorder()),
              items: [
                for (final space in spaces)
                  DropdownMenuItem(
                    value: space.id,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(color: Color(space.colorValue), shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Text(space.name),
                      ],
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _spaceId = value);
              },
            ),
            if (availableTags.isNotEmpty) ...[
              const SizedBox(height: 14),
              SectionLabel(l10n.shiftTags),
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
            TextFormField(
              controller: _timeZoneController,
              decoration: InputDecoration(labelText: l10n.timeZone, hintText: 'Europe/Madrid'),
              validator: (value) {
                final zone = value?.trim() ?? '';
                if (zone.isEmpty || !isKnownTimeZone(zone)) return l10n.invalidTimeZone;
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _commuteController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.commuteOverride,
                      helperText: l10n.inheritSleepBuffers,
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return null;
                      final minutes = int.tryParse(text);
                      return minutes == null || minutes < 0 || minutes > 1440 ? l10n.invalidTimeZone : null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _windDownController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.windDownOverride,
                      helperText: l10n.inheritSleepBuffers,
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) return null;
                      final minutes = int.tryParse(text);
                      return minutes == null || minutes < 0 || minutes > 1440 ? l10n.invalidTimeZone : null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Text(l10n.cycleLength, style: theme.textTheme.bodyLarge)),
                IconButton(
                  onPressed: _cycleDays > 1 ? () => _setCycleDays(_cycleDays - 1) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(l10n.cycleLengthValue(_cycleDays), style: theme.textTheme.titleMedium),
                IconButton(
                  onPressed: _cycleDays < 28 ? () => _setCycleDays(_cycleDays + 1) : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: _pickAnchorDate,
              borderRadius: BorderRadius.circular(4),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.anchorDate,
                  prefixIcon: const Icon(Icons.event_outlined, size: 20),
                ),
                child: Text(DateFormat.yMMMMEEEEd(locale).format(_anchorDate.toDateTime())),
              ),
            ),
            const SizedBox(height: 20),
            for (var index = 0; index < _cycleDays; index++) _buildDay(index, locale),
            const SizedBox(height: 8),
            _SectionHeader(title: l10n.exceptions, actionLabel: l10n.addException, onAction: _addException),
            if (_exceptions.isEmpty)
              Text(
                l10n.noExceptions,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              )
            else
              for (final exception in _exceptions) _buildException(exception, locale),
            const SizedBox(height: 20),
            _SectionHeader(
              title: l10n.shiftChecklist,
              actionLabel: l10n.addChecklistItem,
              onAction: _addChecklistItem,
            ),
            if (_checklistLoading)
              const LinearProgressIndicator()
            else if (_checklist.isEmpty)
              Text(
                l10n.noChecklistItems,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              )
            else
              for (var index = 0; index < _checklist.length; index++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: ValueKey('checklist-${_checklist[index].id}'),
                          initialValue: _checklist[index].label,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(labelText: l10n.checklistItemLabel),
                          onChanged: (value) => _checklist[index] = _checklist[index].copyWith(label: value),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeChecklistItem(index),
                        icon: const Icon(Icons.remove_circle_outline),
                        tooltip: l10n.delete,
                      ),
                    ],
                  ),
                ),
            const SizedBox(height: 20),
            _SectionHeader(title: l10n.preview),
            if (preview != null && conflicts.isNotEmpty)
              Text(
                l10n.conflictsFound,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
              )
            else if (preview != null)
              Text(
                l10n.noConflicts,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            if (preview != null && conflicts.isEmpty)
              _Preview(
                pattern: preview,
                deviceTimeZone: _deviceTimeZone,
                today: localDateAt(ref.watch(nowProvider), _deviceTimeZone),
              ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: _saving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(l10n.savePattern),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDay(int index, String locale) {
    final l10n = context.l10n;
    final date = _anchorDate.addDays(index);
    final daySlots = _slots.where((slot) => slot.dayIndex == index).toList();

    return SoftCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 6),
      radius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${l10n.cycleDay(index + 1)} · ${DateFormat.E(locale).format(date.toDateTime())}',
                  style: ManeType.title(13.5, color: context.mc.text),
                ),
              ),
              Text(
                DateFormat.MMMd(locale).format(date.toDateTime()),
                style: ManeType.body(11.5, color: context.mc.textSecondary),
              ),
            ],
          ),
          if (daySlots.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(l10n.noSlots, style: ManeType.body(11.5, color: context.mc.textTertiary)),
            ),
          for (final slot in daySlots) _buildSlot(slot),
          TextButton.icon(
            onPressed: () => _addSlot(index),
            icon: const Icon(Icons.add, size: 17),
            label: Text(l10n.addSlot),
          ),
        ],
      ),
    );
  }

  Widget _buildSlot(_SlotDraft slot) {
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.fromLTRB(10, 6, 4, 8),
      decoration: BoxDecoration(
        color: context.mc.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.mc.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  key: ValueKey('slot-label-${slot.id}'),
                  initialValue: slot.label,
                  decoration: InputDecoration(labelText: l10n.slotLabel, isDense: true),
                  onChanged: (value) => slot.label = value,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _slots.remove(slot)),
                icon: const Icon(Icons.close, size: 18),
                tooltip: l10n.removeSlot,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _TimeField(
                  label: l10n.startTime,
                  value: _timeLabel(slot.startMinute),
                  onTap: () => _pickTime(slot, true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TimeField(
                  label: l10n.endTime,
                  value: _timeLabel(slot.endMinute),
                  onTap: () => _pickTime(slot, false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildException(ShiftException exception, String locale) {
    final l10n = context.l10n;
    final type = switch (exception.type) {
      ShiftExceptionType.free => l10n.exceptionFree,
      ShiftExceptionType.override => l10n.exceptionOverride,
      ShiftExceptionType.extra => l10n.exceptionExtra,
    };
    final times = exception.hasTimes
        ? ' · ${_timeLabel(exception.startMinute!)} – ${_timeLabel(exception.endMinute!)}'
        : '';
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
      decoration: BoxDecoration(
        color: context.mc.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.mc.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${DateFormat.yMMMd(locale).format(exception.date.toDateTime())} · $type$times',
                    style: ManeType.body(12.5, color: context.mc.text),
                  ),
                  if (exception.note.isNotEmpty)
                    Text(exception.note, style: ManeType.body(11.5, color: context.mc.textSecondary)),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _exceptions.remove(exception)),
            icon: const Icon(Icons.close, size: 18),
            tooltip: l10n.delete,
          ),
        ],
      ),
    );
  }

  String _timeLabel(int minutes) {
    final normalized = minutes % 1440;
    final label = TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60).format(context);
    return minutes >= 1440 ? '$label ${context.l10n.overnightSuffix}' : label;
  }

  void _setCycleDays(int value) {
    setState(() {
      _cycleDays = value;
      _slots.removeWhere((slot) => slot.dayIndex >= value);
    });
  }

  void _addSlot(int dayIndex) {
    setState(() {
      _slots.add(
        _SlotDraft(
          id: _nextDraftId++,
          dayIndex: dayIndex,
          label: '',
          startMinute: 9 * 60,
          endMinute: 17 * 60,
        ),
      );
    });
  }

  Future<void> _pickTime(_SlotDraft slot, bool isStart) async {
    final current = isStart ? slot.startMinute : slot.endMinute;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: (current ~/ 60) % 24, minute: current % 60),
    );
    if (picked == null || !mounted) return;
    setState(() {
      final value = picked.hour * 60 + picked.minute;
      if (isStart) {
        final duration = slot.endMinute - slot.startMinute;
        slot.startMinute = value;
        slot.endMinute = value + duration;
      } else {
        slot.endMinute = value > slot.startMinute ? value : value + 1440;
      }
    });
  }

  Future<void> _pickAnchorDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _anchorDate.toDateTime(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() => _anchorDate = LocalDate.fromDateTime(picked));
  }

  Future<void> _addException() async {
    final exception = await showDialog<ShiftException>(
      context: context,
      builder: (context) => _ExceptionDialog(initialDate: _anchorDate),
    );
    if (exception != null && mounted) {
      setState(() => _exceptions.add(exception));
    }
  }

  ShiftPattern? _preview() {
    try {
      return ShiftPattern(
        id: widget.pattern?.id ?? 'preview',
        spaceId: _spaceId,
        name: _nameController.text.trim(),
        timeZone: _timeZoneController.text.trim(),
        cycleDays: _cycleDays,
        anchorDate: _anchorDate,
        slots: [
          for (final draft in _slots)
            ShiftSlot(
              dayIndex: draft.dayIndex,
              label: draft.label,
              startMinute: draft.startMinute,
              endMinute: draft.endMinute,
            ),
        ],
        exceptions: _exceptions,
        tagIds: _tagIds,
        commuteMinutes: _optionalMinutes(_commuteController),
        windDownMinutes: _optionalMinutes(_windDownController),
        enabled: true,
      );
    } on ArgumentError {
      return null;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final pattern = _preview();
    if (pattern == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.invalidTimeZone)));
      return;
    }
    if (pattern.findConflicts().isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.conflictsFound)));
      return;
    }

    setState(() => _saving = true);
    final saved = ShiftPattern(
      id: widget.pattern?.id ?? const Uuid().v4(),
      spaceId: pattern.spaceId,
      name: pattern.name,
      timeZone: pattern.timeZone,
      cycleDays: pattern.cycleDays,
      anchorDate: pattern.anchorDate,
      slots: pattern.slots,
      exceptions: pattern.exceptions,
      tagIds: pattern.tagIds,
      commuteMinutes: pattern.commuteMinutes,
      windDownMinutes: pattern.windDownMinutes,
      enabled: widget.pattern?.enabled ?? true,
    );
    try {
      await ref.read(repositoryProvider).saveShiftPattern(saved);
      await ref.read(repositoryProvider).saveShiftChecklistItems(saved.id, [
        for (final draft in _checklist)
          if (draft.label.trim().isNotEmpty)
            ShiftChecklistItem(id: draft.id, patternId: saved.id, label: draft.label.trim()),
      ]);
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
    final pattern = widget.pattern;
    if (pattern == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.deletePatternQuestion),
        content: Text(context.l10n.deletePatternBody),
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
    await ref.read(repositoryProvider).deleteShiftPattern(pattern.id);
    if (mounted) Navigator.of(context).pop();
  }
}

class _ChecklistDraft {
  const _ChecklistDraft({required this.id, required this.label});

  final String id;
  final String label;

  _ChecklistDraft copyWith({String? label}) => _ChecklistDraft(id: id, label: label ?? this.label);
}

class _SlotDraft {
  _SlotDraft({
    required this.id,
    required this.dayIndex,
    required this.label,
    required this.startMinute,
    required this.endMinute,
  });

  final int id;
  final int dayIndex;
  String label;
  int startMinute;
  int endMinute;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return SectionLabel(
      title,
      trailing: actionLabel == null ? null : TextButton(onPressed: onAction, child: Text(actionLabel!)),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({required this.label, required this.value, required this.onTap});

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, isDense: true),
        child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.pattern, required this.deviceTimeZone, required this.today});

  final ShiftPattern pattern;
  final String deviceTimeZone;
  final LocalDate today;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final occurrences = pattern.occurrencesBetween(today, today.addDays(27), viewerTimeZone: deviceTimeZone);
    if (occurrences.isEmpty) {
      return Text(l10n.noSlots, style: ManeType.body(11.5, color: c.textSecondary));
    }

    return Column(
      children: [
        for (final occurrence in occurrences.take(40))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 92,
                  child: Text(
                    DateFormat.MMMEd(locale).format(occurrence.displayDate.toDateTime()),
                    style: ManeType.body(11.5, color: c.textSecondary),
                  ),
                ),
                Expanded(
                  child: Text(
                    occurrence.slot.label.isEmpty ? pattern.name : occurrence.slot.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${_formatTime(context, occurrence.startAt, deviceTimeZone)} – '
                  '${_formatTime(context, occurrence.endAt, deviceTimeZone)}',
                  style: ManeType.body(11.5, color: c.textSecondary),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _formatTime(BuildContext context, DateTime instant, String timeZone) {
    final local = localDateTimeAt(instant, timeZone);
    return TimeOfDay(hour: local.hour, minute: local.minute).format(context);
  }
}

class _ExceptionDialog extends StatefulWidget {
  const _ExceptionDialog({required this.initialDate});

  final LocalDate initialDate;

  @override
  State<_ExceptionDialog> createState() => _ExceptionDialogState();
}

class _ExceptionDialogState extends State<_ExceptionDialog> {
  late LocalDate _date;
  ShiftExceptionType _type = ShiftExceptionType.free;
  int _startMinute = 9 * 60;
  int _endMinute = 17 * 60;
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _date = widget.initialDate;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return AlertDialog(
      title: Text(l10n.addException),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(labelText: l10n.exceptionDate),
                child: Text(DateFormat.yMMMd(locale).format(_date.toDateTime())),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<ShiftExceptionType>(
              initialValue: _type,
              decoration: InputDecoration(labelText: l10n.type, border: const OutlineInputBorder()),
              items: [
                DropdownMenuItem(value: ShiftExceptionType.free, child: Text(l10n.exceptionFree)),
                DropdownMenuItem(value: ShiftExceptionType.override, child: Text(l10n.exceptionOverride)),
                DropdownMenuItem(value: ShiftExceptionType.extra, child: Text(l10n.exceptionExtra)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _type = value);
              },
            ),
            if (_type != ShiftExceptionType.free) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _DialogTimeField(
                      label: l10n.startTime,
                      value: _timeLabel(_startMinute),
                      onTap: () => _pickTime(true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _DialogTimeField(
                      label: l10n.endTime,
                      value: _timeLabel(_endMinute),
                      onTap: () => _pickTime(false),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: l10n.exceptionNote, border: const OutlineInputBorder()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(onPressed: _save, child: Text(l10n.save)),
      ],
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
    if (picked != null && mounted) setState(() => _date = LocalDate.fromDateTime(picked));
  }

  Future<void> _pickTime(bool isStart) async {
    final current = isStart ? _startMinute : _endMinute;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: (current ~/ 60) % 24, minute: current % 60),
    );
    if (picked == null || !mounted) return;
    setState(() {
      final value = picked.hour * 60 + picked.minute;
      if (isStart) {
        final duration = _endMinute - _startMinute;
        _startMinute = value;
        _endMinute = value + duration;
      } else {
        _endMinute = value > _startMinute ? value : value + 1440;
      }
    });
  }

  void _save() {
    Navigator.of(context).pop(
      ShiftException(
        date: _date,
        type: _type,
        startMinute: _type == ShiftExceptionType.free ? null : _startMinute,
        endMinute: _type == ShiftExceptionType.free ? null : _endMinute,
        note: _noteController.text.trim(),
      ),
    );
  }
}

class _DialogTimeField extends StatelessWidget {
  const _DialogTimeField({required this.label, required this.value, required this.onTap});

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(value),
      ),
    );
  }
}

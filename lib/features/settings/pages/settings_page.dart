import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/i18n/reminder_label.dart';
import '../../../state/providers.dart';
import '../../../state/settings_controller.dart';
import '../../tags/pages/tags_page.dart';
import '../../backup/backup_files.dart';
import '../../backup/backup_service.dart';
import '../../shifts/pages/shift_patterns_page.dart';
import '../widgets/settings_rows.dart';
import 'about_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const _reminderOffsets = <int>[0, 5, 10, 30, 60, 120, 1440];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          SettingsSection(
            title: l10n.appearanceSection,
            children: [
              SettingsChoiceRow(
                icon: Icons.brightness_6_outlined,
                title: l10n.theme,
                choice: SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment(value: ThemeMode.system, label: Text(l10n.themeSystem)),
                    ButtonSegment(value: ThemeMode.light, label: Text(l10n.themeLight)),
                    ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeDark)),
                  ],
                  selected: {settings.themeMode},
                  showSelectedIcon: false,
                  onSelectionChanged: (values) => controller.setThemeMode(values.first),
                ),
              ),
              SettingsChoiceRow(
                icon: Icons.translate,
                title: l10n.language,
                choice: SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'system', label: Text(l10n.languageSystem)),
                    ButtonSegment(value: 'en', label: Text(l10n.languageEnglish)),
                    ButtonSegment(value: 'es', label: Text(l10n.languageSpanish)),
                  ],
                  selected: {settings.locale?.languageCode ?? 'system'},
                  showSelectedIcon: false,
                  onSelectionChanged: (values) =>
                      controller.setLocale(values.first == 'system' ? null : Locale(values.first)),
                ),
              ),
              SettingsChoiceRow(
                icon: Icons.calendar_view_week_outlined,
                title: l10n.weekStartsOn,
                choice: SegmentedButton<int>(
                  segments: [
                    ButtonSegment(value: DateTime.monday, label: Text(l10n.weekStartMonday)),
                    ButtonSegment(value: DateTime.saturday, label: Text(l10n.weekStartSaturday)),
                    ButtonSegment(value: DateTime.sunday, label: Text(l10n.weekStartSunday)),
                  ],
                  selected: {settings.weekStart},
                  showSelectedIcon: false,
                  onSelectionChanged: (values) => controller.setWeekStart(values.first),
                ),
              ),
            ],
          ),
          SettingsSection(
            title: l10n.plannerSection,
            children: [
              SettingsSwitchRow(
                icon: Icons.work_outline,
                title: l10n.hideWorkSpace,
                subtitle: l10n.hideWorkSpaceSubtitle,
                value: settings.hideWorkSpace,
                onChanged: controller.setHideWorkSpace,
              ),
              SettingsNavRow(
                icon: Icons.notifications_outlined,
                title: l10n.defaultReminders,
                subtitle: l10n.defaultRemindersSubtitle,
                value: settings.defaultReminderOffsets.isEmpty
                    ? l10n.notSet
                    : l10n.selectedCount(settings.defaultReminderOffsets.length),
                onTap: () => _showDefaultReminders(context, ref),
              ),
            ],
          ),
          SettingsSection(
            title: l10n.librarySection,
            children: [
              SettingsNavRow(
                icon: Icons.sell_outlined,
                title: l10n.tagsManager,
                subtitle: l10n.tagsManagerSubtitle,
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const TagsPage())),
              ),
              SettingsNavRow(
                icon: Icons.schedule,
                title: l10n.shiftPatterns,
                subtitle: l10n.shiftPatternsSubtitle,
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute<void>(builder: (_) => const ShiftPatternsPage())),
              ),
            ],
          ),
          SettingsSection(
            title: l10n.dataAndBackup,
            children: [
              SettingsNavRow(
                icon: Icons.upload_file_outlined,
                title: l10n.exportBackup,
                subtitle: l10n.exportBackupSubtitle,
                onTap: () => _exportBackup(context, ref),
              ),
              SettingsNavRow(
                icon: Icons.download_outlined,
                title: l10n.importBackup,
                subtitle: l10n.importBackupSubtitle,
                onTap: () => _importBackup(context, ref),
              ),
            ],
          ),
          SettingsSection(
            title: l10n.privacySection,
            children: [
              SettingsSwitchRow(
                icon: Icons.lan_outlined,
                title: l10n.syncEnabled,
                subtitle: l10n.syncOffInfo,
                value: settings.syncEnabled,
                onChanged: (value) async {
                  await controller.setSyncEnabled(value);
                  if (value && context.mounted) _showNotice(context, l10n.syncNotActive);
                },
              ),
              SettingsSwitchRow(
                icon: Icons.terminal,
                title: l10n.mcpEnabled,
                subtitle: l10n.mcpOffInfo,
                value: settings.mcpEnabled,
                onChanged: (value) async {
                  await controller.setMcpEnabled(value);
                  if (value && context.mounted) _showNotice(context, l10n.mcpNotActive);
                },
              ),
            ],
          ),
          SettingsSection(
            title: l10n.about,
            children: [
              SettingsNavRow(
                icon: Icons.info_outline,
                title: l10n.about,
                subtitle: l10n.aboutSubtitle,
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const AboutPage())),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNotice(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _exportBackup(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final json = await ref.read(backupServiceProvider).exportJson();
      final path = await saveBackupFile(json, dialogTitle: l10n.exportBackup);
      if (path == null) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupExported(path))));
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupFailed('$error'))));
    }
  }

  Future<void> _importBackup(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final String? source;
    try {
      source = await pickBackupText();
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupFailed('$error'))));
      return;
    }
    if (source == null || !context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.importConfirmTitle),
        content: Text(l10n.importConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.importBackup),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(backupServiceProvider).importJson(source);
      await ref.read(settingsProvider.notifier).reload();
      await ref.read(reminderCoordinatorProvider).reschedule();
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupImported)));
    } on BackupVersionException {
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupFuture)));
    } on BackupFormatException {
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupInvalid)));
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupFailed('$error'))));
    }
  }

  Future<void> _showDefaultReminders(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => _DefaultRemindersSheet(
        initial: ref.read(settingsProvider).defaultReminderOffsets,
        offsets: _reminderOffsets,
      ),
    );
  }
}

class _DefaultRemindersSheet extends ConsumerStatefulWidget {
  const _DefaultRemindersSheet({required this.initial, required this.offsets});

  final List<int> initial;
  final List<int> offsets;

  @override
  ConsumerState<_DefaultRemindersSheet> createState() => _DefaultRemindersSheetState();
}

class _DefaultRemindersSheetState extends ConsumerState<_DefaultRemindersSheet> {
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
              Expanded(child: Text(l10n.defaultReminders, style: Theme.of(context).textTheme.titleLarge)),
              TextButton(
                onPressed: () async {
                  await ref.read(settingsProvider.notifier).setDefaultReminderOffsets(_selected.toList());
                  if (context.mounted) Navigator.of(context).pop();
                },
                child: Text(l10n.save),
              ),
            ],
          ),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final offset in widget.offsets)
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

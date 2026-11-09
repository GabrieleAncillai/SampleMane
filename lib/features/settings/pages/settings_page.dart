import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/i18n/reminder_label.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../models/app_settings.dart';
import '../../../state/providers.dart';
import '../../../state/settings_controller.dart';
import '../../tags/pages/tags_page.dart';
import '../../backup/backup_files.dart';
import '../../backup/backup_service.dart';
import '../../home_inventory/pages/home_inventory_page.dart';
import '../../home_inventory/pages/shopping_list_page.dart';
import '../../import/companion_import.dart';
import '../../import/ics_import_service.dart';
import '../../import/import_dialogs.dart';
import '../../import/import_files.dart';
import '../../mcp/pages/mcp_page.dart';
import '../../shifts/pages/shift_patterns_page.dart';
import '../../sync/pages/devices_page.dart';
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

    return ManePage(
      title: l10n.settings,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          SettingsSection(
            title: l10n.appearanceSection,
            children: [
              SettingsChoiceRow(
                icon: Icons.brightness_6_outlined,
                title: l10n.theme,
                choice: ManeSegmented<ThemeMode>(
                  segments: [
                    ManeSegment(value: ThemeMode.system, label: l10n.themeSystem),
                    ManeSegment(value: ThemeMode.light, label: l10n.themeLight),
                    ManeSegment(value: ThemeMode.dark, label: l10n.themeDark),
                  ],
                  selected: settings.themeMode,
                  onChanged: controller.setThemeMode,
                  compact: true,
                ),
              ),
              SettingsChoiceRow(
                icon: Icons.translate,
                title: l10n.language,
                choice: ManeSegmented<String>(
                  segments: [
                    ManeSegment(value: 'system', label: l10n.languageSystem),
                    ManeSegment(value: 'en', label: l10n.languageEnglish),
                    ManeSegment(value: 'es', label: l10n.languageSpanish),
                  ],
                  selected: settings.locale?.languageCode ?? 'system',
                  onChanged: (value) => controller.setLocale(value == 'system' ? null : Locale(value)),
                  compact: true,
                ),
              ),
              SettingsChoiceRow(
                icon: Icons.calendar_view_week_outlined,
                title: l10n.weekStartsOn,
                choice: ManeSegmented<int>(
                  segments: [
                    ManeSegment(value: DateTime.monday, label: l10n.weekStartMonday),
                    ManeSegment(value: DateTime.saturday, label: l10n.weekStartSaturday),
                    ManeSegment(value: DateTime.sunday, label: l10n.weekStartSunday),
                  ],
                  selected: settings.weekStart,
                  onChanged: controller.setWeekStart,
                  compact: true,
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
            title: l10n.sleepWindow,
            children: [
              SettingsSwitchRow(
                icon: Icons.bedtime_outlined,
                title: l10n.sleepWindow,
                subtitle: l10n.sleepWindowSubtitle,
                value: settings.sleepEnabled,
                onChanged: controller.setSleepEnabled,
              ),
              SettingsNavRow(
                icon: Icons.timer_outlined,
                title: l10n.sleepBuffers,
                subtitle: l10n.sleepBuffersSummary(
                  settings.sleepCommuteMinutes,
                  settings.sleepWindDownMinutes,
                  settings.sleepWakeBufferMinutes,
                ),
                onTap: () => _showSleepBuffers(context, ref),
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
              SettingsNavRow(
                icon: Icons.inventory_2_outlined,
                title: l10n.homeInventory,
                subtitle: l10n.homeInventorySubtitle,
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute<void>(builder: (_) => const HomeInventoryPage())),
              ),
              SettingsNavRow(
                icon: Icons.shopping_cart_outlined,
                title: l10n.shoppingList,
                subtitle: l10n.shoppingListSubtitle,
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute<void>(builder: (_) => const ShoppingListPage())),
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
              SettingsNavRow(
                icon: Icons.event_available_outlined,
                title: l10n.importCalendar,
                subtitle: l10n.importCalendarSubtitle,
                onTap: () => _importCalendar(context, ref),
              ),
              SettingsNavRow(
                icon: Icons.devices_other_outlined,
                title: l10n.importCompanion,
                subtitle: l10n.importCompanionSubtitle,
                onTap: () => _importCompanion(context, ref),
              ),
            ],
          ),
          SettingsSection(
            title: l10n.devices,
            children: [
              SettingsNavRow(
                icon: Icons.devices_other,
                title: l10n.devices,
                subtitle: l10n.devicesSubtitle,
                value: '${ref.watch(pairedDevicesProvider).value?.length ?? 0}',
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const DevicesPage())),
              ),
              SettingsNavRow(
                icon: Icons.terminal,
                title: l10n.mcpEndpoint,
                subtitle: l10n.mcpEndpointSubtitle,
                value: settings.mcpEnabled ? l10n.on : l10n.off,
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const McpPage())),
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
                  await ref.read(serviceCoordinatorProvider).apply(ref.read(settingsProvider));
                  if (value && context.mounted) {
                    final identity = await ref.read(repositoryProvider).readIdentity();
                    if (identity == null && context.mounted) {
                      _showNotice(context, l10n.identityRequired);
                    }
                  }
                },
              ),
              SettingsSwitchRow(
                icon: Icons.terminal,
                title: l10n.mcpEnabled,
                subtitle: l10n.mcpOffInfo,
                value: settings.mcpEnabled,
                onChanged: (value) async {
                  await controller.setMcpEnabled(value);
                  await ref.read(serviceCoordinatorProvider).apply(ref.read(settingsProvider));
                  if (value && context.mounted) {
                    final identity = await ref.read(repositoryProvider).readIdentity();
                    if (identity == null && context.mounted) {
                      _showNotice(context, l10n.identityRequired);
                    }
                  }
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
      await ref.read(serviceCoordinatorProvider).apply(ref.read(settingsProvider));
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupImported)));
    } on BackupVersionException {
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupFuture)));
    } on BackupFormatException {
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupInvalid)));
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.backupFailed('$error'))));
    }
  }

  Future<void> _importCalendar(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final String? source;
    try {
      source = await pickIcsText();
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.importCalendarFailed('$error'))));
      return;
    }
    if (source == null || !context.mounted) return;

    final spaceId = await pickImportSpace(context, ref, title: l10n.importCalendarSpace);
    if (spaceId == null) return;

    try {
      final report = await IcsImportService(ref.read(repositoryProvider)).importText(
        source,
        spaceId: spaceId,
        defaultTimeZone: ref.read(deviceTimeZoneProvider),
        fallbackTitle: l10n.importedEvent,
      );
      final skipped = report.duplicates + report.skipped.length;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            report.imported == 0 && skipped == 0
                ? l10n.importCalendarEmpty
                : l10n.importCalendarDone(report.imported, skipped),
          ),
        ),
      );
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.importCalendarFailed('$error'))));
    }
  }

  Future<void> _importCompanion(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final String? source;
    try {
      source = await pickCompanionText();
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.importCompanionFailed('$error'))));
      return;
    }
    if (source == null || !context.mounted) return;

    final spaceId = await pickImportSpace(context, ref, title: l10n.importCalendarSpace);
    if (spaceId == null) return;

    try {
      final report = await CompanionImportService(
        ref.read(repositoryProvider),
      ).importText(source, spaceId: spaceId, defaultTimeZone: ref.read(deviceTimeZoneProvider));
      final skipped = report.duplicates + report.skipped.length;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            report.imported == 0 && skipped == 0
                ? l10n.importCompanionEmpty
                : l10n.importCompanionDone(report.imported, skipped),
          ),
        ),
      );
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.importCompanionFailed('$error'))));
    }
  }

  Future<void> _showSleepBuffers(BuildContext context, WidgetRef ref) async {
    await showAppSheet<void>(
      context: context,
      builder: (context) => _SleepBuffersSheet(initial: ref.read(settingsProvider)),
    );
  }

  Future<void> _showDefaultReminders(BuildContext context, WidgetRef ref) async {
    await showAppSheet<void>(
      context: context,
      builder: (context) => _DefaultRemindersSheet(
        initial: ref.read(settingsProvider).defaultReminderOffsets,
        offsets: _reminderOffsets,
      ),
    );
  }
}

class _SleepBuffersSheet extends ConsumerStatefulWidget {
  const _SleepBuffersSheet({required this.initial});

  final AppSettings initial;

  @override
  ConsumerState<_SleepBuffersSheet> createState() => _SleepBuffersSheetState();
}

class _SleepBuffersSheetState extends ConsumerState<_SleepBuffersSheet> {
  late final TextEditingController _commute;
  late final TextEditingController _windDown;
  late final TextEditingController _wake;

  @override
  void initState() {
    super.initState();
    _commute = TextEditingController(text: '${widget.initial.sleepCommuteMinutes}');
    _windDown = TextEditingController(text: '${widget.initial.sleepWindDownMinutes}');
    _wake = TextEditingController(text: '${widget.initial.sleepWakeBufferMinutes}');
  }

  @override
  void dispose() {
    _commute.dispose();
    _windDown.dispose();
    _wake.dispose();
    super.dispose();
  }

  int _value(TextEditingController controller, int fallback) {
    final parsed = int.tryParse(controller.text.trim());
    return parsed == null || parsed < 0 ? fallback : parsed.clamp(0, 24 * 60);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppSheet(
      title: l10n.sleepBuffers,
      children: [
        TextField(
          controller: _commute,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: l10n.commute),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _windDown,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: l10n.windDown),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _wake,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: l10n.wakeBuffer),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () async {
            final controller = ref.read(settingsProvider.notifier);
            await controller.setSleepCommuteMinutes(_value(_commute, widget.initial.sleepCommuteMinutes));
            await controller.setSleepWindDownMinutes(_value(_windDown, widget.initial.sleepWindDownMinutes));
            await controller.setSleepWakeBufferMinutes(_value(_wake, widget.initial.sleepWakeBufferMinutes));
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Text(l10n.save),
        ),
      ],
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
    return AppSheet(
      title: l10n.defaultReminders,
      children: [
        for (final offset in widget.offsets)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
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
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () async {
            await ref.read(settingsProvider.notifier).setDefaultReminderOffsets(_selected.toList());
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

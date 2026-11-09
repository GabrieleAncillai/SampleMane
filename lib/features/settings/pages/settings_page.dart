import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/i18n/reminder_label.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../models/app_settings.dart';
import '../../../state/providers.dart';
import '../../../state/settings_controller.dart';
import '../../app_lock/pages/pin_setup_page.dart';
import '../../tags/pages/tags_page.dart';
import '../../backup/backup_files.dart';
import '../../backup/backup_service.dart';
import '../../export/csv_interchange.dart';
import '../../export/export_files.dart';
import '../../export/ics_export_service.dart';
import '../../home_inventory/pages/home_inventory_page.dart';
import '../../home_inventory/pages/maintenance_page.dart';
import '../../home_inventory/pages/shopping_list_page.dart';
import '../../import/companion_import.dart';
import '../../import/gymmane_import.dart';
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
              SettingsNavRow(
                icon: Icons.build_outlined,
                title: l10n.maintenance,
                subtitle: l10n.maintenanceSubtitle,
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute<void>(builder: (_) => const MaintenancePage())),
              ),
            ],
          ),
          SettingsSection(
            title: l10n.dataAndBackup,
            children: [
              SettingsSwitchRow(
                icon: Icons.backup_outlined,
                title: l10n.automaticBackups,
                subtitle: l10n.automaticBackupsSubtitle,
                value: settings.autoBackupEnabled,
                onChanged: controller.setAutoBackupEnabled,
              ),
              if (settings.autoBackupEnabled)
                SettingsNavRow(
                  icon: Icons.history,
                  title: l10n.keepBackups,
                  value: '${settings.autoBackupKeep}',
                  onTap: () => _showKeepBackups(context, ref),
                ),
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
              SettingsNavRow(
                icon: Icons.fitness_center,
                title: l10n.gymmaneImport,
                subtitle: l10n.gymmaneImportSubtitle,
                onTap: () => _importGymMane(context, ref),
              ),
              SettingsNavRow(
                icon: Icons.table_view_outlined,
                title: l10n.exportCsv,
                subtitle: l10n.exportCsvSubtitle,
                onTap: () => _exportCsv(context, ref),
              ),
              SettingsNavRow(
                icon: Icons.table_view,
                title: l10n.importCsv,
                subtitle: l10n.importCsvSubtitle,
                onTap: () => _importCsv(context, ref),
              ),
              SettingsNavRow(
                icon: Icons.ios_share_outlined,
                title: l10n.exportCalendar,
                subtitle: l10n.exportCalendarSubtitle,
                onTap: () => _exportCalendar(context, ref),
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
                icon: Icons.lock_outline,
                title: l10n.appLock,
                subtitle: l10n.appLockSubtitle,
                value: settings.appLockEnabled,
                onChanged: (value) => _setAppLock(context, ref, value),
              ),
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
            report.imported == 0 && report.updated == 0 && skipped == 0
                ? l10n.importCalendarEmpty
                : l10n.importCalendarDone(report.imported, report.updated, skipped),
          ),
        ),
      );
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.importCalendarFailed('$error'))));
    }
  }

  Future<void> _importGymMane(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final String? source;
    try {
      source = await pickGymManeText();
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.gymmaneImportFailed('$error'))));
      return;
    }
    if (source == null) return;

    final spaces = await ref.read(repositoryProvider).watchSpaces().first;
    if (spaces.isEmpty) return;
    var space = spaces.first;
    for (final candidate in spaces) {
      if (candidate.id == 'personal') {
        space = candidate;
        break;
      }
    }
    final timeZone = ref.read(deviceTimeZoneProvider);
    final today = localDateAt(ref.read(nowProvider), timeZone);
    try {
      final report = await GymManeImportService(
        ref.read(repositoryProvider),
      ).importJson(source, spaceId: space.id, today: today, timeZone: timeZone);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            report.imported == 0 && report.duplicates == 0 && report.skipped == 0
                ? l10n.gymmaneImportEmpty
                : l10n.gymmaneImportDone(report.imported, report.timed, report.allDay, report.skipped),
          ),
        ),
      );
    } on GymManeImportException catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.gymmaneImportFailed('$error'))));
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.gymmaneImportFailed('$error'))));
    }
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    await showAppSheet<void>(
      context: context,
      builder: (sheetContext) => AppSheet(
        title: l10n.exportCsv,
        subtitle: l10n.exportCsvSubtitle,
        children: [
          SettingsNavRow(
            icon: Icons.event_note_outlined,
            title: l10n.csvEntries,
            onTap: () {
              Navigator.of(sheetContext).pop();
              _exportCsvEntries(context, ref);
            },
          ),
          SettingsNavRow(
            icon: Icons.shopping_cart_outlined,
            title: l10n.csvShopping,
            onTap: () {
              Navigator.of(sheetContext).pop();
              _exportCsvShopping(context, ref);
            },
          ),
          SettingsNavRow(
            icon: Icons.inventory_2_outlined,
            title: l10n.csvInventory,
            onTap: () {
              Navigator.of(sheetContext).pop();
              _exportCsvInventory(context, ref);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _importCsv(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    await showAppSheet<void>(
      context: context,
      builder: (sheetContext) => AppSheet(
        title: l10n.importCsv,
        subtitle: l10n.importCsvSubtitle,
        children: [
          SettingsNavRow(
            icon: Icons.event_note_outlined,
            title: l10n.csvEntries,
            onTap: () {
              Navigator.of(sheetContext).pop();
              _importCsvEntries(context, ref);
            },
          ),
          SettingsNavRow(
            icon: Icons.shopping_cart_outlined,
            title: l10n.csvShopping,
            onTap: () {
              Navigator.of(sheetContext).pop();
              _importCsvShopping(context, ref);
            },
          ),
          SettingsNavRow(
            icon: Icons.inventory_2_outlined,
            title: l10n.csvInventory,
            onTap: () {
              Navigator.of(sheetContext).pop();
              _importCsvInventory(context, ref);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _exportCsvEntries(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final timeZone = ref.read(deviceTimeZoneProvider);
      final today = localDateAt(ref.read(nowProvider), timeZone);
      final csv = await CsvInterchangeService(
        ref.read(repositoryProvider),
      ).exportEntries(start: today.addDays(-30), end: today.addDays(365), viewerTimeZone: timeZone);
      final path = await saveCsvFile(csv, dialogTitle: l10n.exportCsv, fileName: _csvFileName('entries'));
      if (path == null) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.csvExported(path))));
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.csvExportFailed('$error'))));
    }
  }

  Future<void> _exportCsvShopping(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final csv = await CsvInterchangeService(ref.read(repositoryProvider)).exportShopping();
      final path = await saveCsvFile(csv, dialogTitle: l10n.exportCsv, fileName: _csvFileName('shopping'));
      if (path == null) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.csvExported(path))));
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.csvExportFailed('$error'))));
    }
  }

  Future<void> _exportCsvInventory(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final csv = await CsvInterchangeService(ref.read(repositoryProvider)).exportInventory();
      final path = await saveCsvFile(csv, dialogTitle: l10n.exportCsv, fileName: _csvFileName('inventory'));
      if (path == null) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.csvExported(path))));
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.csvExportFailed('$error'))));
    }
  }

  Future<void> _importCsvEntries(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final String? source;
    try {
      source = await pickCsvText();
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.csvExportFailed('$error'))));
      return;
    }
    if (source == null) return;
    try {
      final report = await CsvInterchangeService(
        ref.read(repositoryProvider),
      ).importEntries(source, defaultTimeZone: ref.read(deviceTimeZoneProvider));
      await ref.read(reminderCoordinatorProvider).reschedule();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            report.imported == 0 && report.duplicates == 0 && report.skipped == 0
                ? l10n.csvImportEmpty
                : l10n.csvImportDone(report.imported, report.duplicates, report.skipped),
          ),
        ),
      );
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.csvExportFailed('$error'))));
    }
  }

  Future<void> _importCsvShopping(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final String? source;
    try {
      source = await pickCsvText();
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.csvExportFailed('$error'))));
      return;
    }
    if (source == null) return;
    try {
      final report = await CsvInterchangeService(ref.read(repositoryProvider)).importShopping(source);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            report.imported == 0 && report.duplicates == 0 && report.skipped == 0
                ? l10n.csvImportEmpty
                : l10n.csvImportDone(report.imported, report.duplicates, report.skipped),
          ),
        ),
      );
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.csvExportFailed('$error'))));
    }
  }

  Future<void> _importCsvInventory(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final String? source;
    try {
      source = await pickCsvText();
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.csvExportFailed('$error'))));
      return;
    }
    if (source == null) return;
    try {
      final report = await CsvInterchangeService(ref.read(repositoryProvider)).importInventory(source);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            report.imported == 0 && report.duplicates == 0 && report.skipped == 0
                ? l10n.csvImportEmpty
                : l10n.csvImportDone(report.imported, report.duplicates, report.skipped),
          ),
        ),
      );
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.csvExportFailed('$error'))));
    }
  }

  Future<void> _setAppLock(BuildContext context, WidgetRef ref, bool value) async {
    final l10n = context.l10n;
    if (value) {
      final result = await Navigator.of(
        context,
      ).push<bool>(MaterialPageRoute<bool>(builder: (_) => const PinSetupPage(), fullscreenDialog: true));
      if (result != true || !context.mounted) return;
      _showNotice(context, l10n.appLockEnabled);
      return;
    }
    await ref.read(appLockServiceProvider).disable();
    await ref.read(settingsProvider.notifier).reload();
    if (context.mounted) _showNotice(context, l10n.appLockDisabled);
  }

  Future<void> _showKeepBackups(BuildContext context, WidgetRef ref) async {
    await showAppSheet<void>(
      context: context,
      builder: (_) => _KeepBackupsSheet(initial: ref.read(settingsProvider).autoBackupKeep),
    );
  }

  static String _csvFileName(String kind) {
    final now = DateTime.now();
    return 'mane-$kind-${now.year.toString().padLeft(4, '0')}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}.csv';
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

  Future<void> _exportCalendar(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final timeZone = ref.read(deviceTimeZoneProvider);
      final today = localDateAt(ref.read(nowProvider), timeZone);
      final content = await IcsExportService(
        ref.read(repositoryProvider),
      ).exportRange(start: today.addDays(-30), end: today.addDays(180), viewerTimeZone: timeZone);
      final path = await saveIcsFile(content, dialogTitle: l10n.exportCalendar);
      if (path == null) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.calendarExported(path))));
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.calendarExportFailed('$error'))));
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

class _KeepBackupsSheet extends ConsumerWidget {
  const _KeepBackupsSheet({required this.initial});

  final int initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return AppSheet(
      title: l10n.keepBackups,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          child: ManeSegmented<int>(
            segments: const [
              ManeSegment(value: 3, label: '3'),
              ManeSegment(value: 5, label: '5'),
              ManeSegment(value: 10, label: '10'),
              ManeSegment(value: 20, label: '20'),
            ],
            selected: initial,
            onChanged: (value) async {
              await ref.read(settingsProvider.notifier).setAutoBackupKeep(value);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}

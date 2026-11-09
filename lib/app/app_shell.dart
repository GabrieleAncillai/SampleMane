import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:mane_core/mane_core.dart';

import '../core/i18n/l10n.dart';
import '../features/calendar/pages/calendar_page.dart';
import '../features/settings/pages/settings_page.dart';
import '../features/tags/widgets/tag_filter_sheet.dart';
import '../screens/entry_editor.dart';
import '../screens/today_screen.dart';
import '../screens/week_screen.dart';
import '../state/providers.dart';
import '../state/settings_controller.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> with WidgetsBindingObserver {
  int _index = 0;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _clockTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) ref.invalidate(nowProvider);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshTimeZoneAndSchedule();
  }

  Future<void> _bootstrap() async {
    if (!mounted) return;
    final notifications = ref.read(notificationServiceProvider);
    notifications.onOpenEntry = _openEntry;
    final pending = notifications.takePendingEntry();
    if (pending != null) await _openEntry(pending);
    if (!mounted) return;
    await ref.read(reminderCoordinatorProvider).reschedule();
    await ref.read(serviceCoordinatorProvider).apply(ref.read(settingsProvider));
  }

  Future<void> _refreshTimeZoneAndSchedule() async {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      if (isKnownTimeZone(info.identifier)) {
        ref.read(deviceTimeZoneProvider.notifier).set(info.identifier);
      }
    } catch (_) {
      // Keep the last known zone when the platform lookup is unavailable.
    }
    if (!mounted) return;
    await ref.read(reminderCoordinatorProvider).reschedule();
    final settings = ref.read(settingsProvider);
    await ref.read(serviceCoordinatorProvider).apply(settings);
    if (settings.syncEnabled) await ref.read(syncServiceProvider).refresh();
  }

  Future<void> _openEntry(String id) async {
    final entry = await ref.read(repositoryProvider).readEntry(id);
    if (entry == null || !mounted) return;
    final spaces = ref.read(spacesProvider).value ?? fallbackSpaces;
    await showEntryEditor(context, entry: entry, initialDate: entry.date, spaces: spaces);
  }

  @override
  Widget build(BuildContext context) {
    final spaces = ref.watch(spacesProvider).value ?? fallbackSpaces;
    final filterCount = ref.watch(tagFilterProvider).length;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => showTagFilterSheet(context),
            tooltip: l10n.filterByTag,
            icon: Badge(
              isLabelVisible: filterCount > 0,
              label: Text('$filterCount'),
              child: Icon(filterCount > 0 ? Icons.filter_alt : Icons.filter_alt_outlined),
            ),
          ),
          IconButton(
            onPressed: () =>
                Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SettingsPage())),
            tooltip: l10n.settings,
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: const [TodayScreen(), WeekScreen(), CalendarPage()]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showEntryEditor(context, spaces: spaces),
        tooltip: l10n.addEntry,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.today_outlined),
            selectedIcon: const Icon(Icons.today),
            label: l10n.today,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_view_week_outlined),
            selectedIcon: const Icon(Icons.calendar_view_week),
            label: l10n.week,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: l10n.calendar,
          ),
        ],
      ),
    );
  }
}

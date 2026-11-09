import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:mane_core/mane_core.dart';

import '../core/i18n/l10n.dart';
import '../core/widgets/ui_kit.dart';
import '../features/calendar/pages/calendar_page.dart';
import '../features/home_widget/home_widget_service.dart';
import '../features/search/pages/search_page.dart';
import '../features/settings/pages/settings_page.dart';
import '../features/tags/widgets/tag_filter_sheet.dart';
import '../screens/entry_editor.dart';
import '../screens/today_screen.dart';
import '../screens/week_screen.dart';
import '../state/providers.dart';
import '../state/settings_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  int _index = 0;
  Timer? _clockTimer;
  late final AnimationController _swap;

  @override
  void initState() {
    super.initState();
    _swap = AnimationController(vsync: this, duration: const Duration(milliseconds: 280), value: 1);
    WidgetsBinding.instance.addObserver(this);
    _clockTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) ref.invalidate(nowProvider);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _swap.dispose();
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
    await _updateHomeWidget();
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
    await _updateHomeWidget();
  }

  Future<void> _updateHomeWidget() async {
    if (!mounted) return;
    final timeZone = ref.read(deviceTimeZoneProvider);
    final now = DateTime.now();
    final today = localDateAt(now, timeZone);
    final repository = ref.read(repositoryProvider);
    final entries = await repository.loadEntries(today, today, timeZone);
    final shifts = await repository.watchShifts(today, today, timeZone).first;
    final upcoming = await repository.watchShifts(today, today.addDays(7), timeZone).first;
    if (!mounted) return;
    await ref
        .read(homeWidgetServiceProvider)
        .update(
          buildHomeWidgetData(
            todayEntries: entries,
            todayShifts: shifts,
            upcomingShifts: upcoming,
            now: now,
            timeZone: timeZone,
            title: context.l10n.today,
            emptyText: context.l10n.noPlanToday,
            nextPrefix: context.l10n.nextShiftPrefix,
          ),
        );
  }

  Future<void> _openEntry(String id) async {
    final entry = await ref.read(repositoryProvider).readEntry(id);
    if (entry == null || !mounted) return;
    final spaces = ref.read(spacesProvider).value ?? fallbackSpaces;
    await showEntryEditor(context, entry: entry, initialDate: entry.date, spaces: spaces);
  }

  void _selectTab(int value) {
    if (value == _index) return;
    setState(() => _index = value);
    if (!MediaQuery.disableAnimationsOf(context)) _swap.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final spaces = ref.watch(spacesProvider).value ?? fallbackSpaces;
    final filterCount = ref.watch(tagFilterProvider).length;
    final l10n = context.l10n;
    final c = context.mc;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyF, control: true): _openSearch,
        const SingleActivator(LogicalKeyboardKey.digit1, control: true): () => _selectTab(0),
        const SingleActivator(LogicalKeyboardKey.digit2, control: true): () => _selectTab(1),
        const SingleActivator(LogicalKeyboardKey.digit3, control: true): () => _selectTab(2),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: AppBackground(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 16, 6),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(color: c.accent, borderRadius: BorderRadius.circular(13)),
                          child: Icon(Icons.event_note, size: 21, color: c.onAccent),
                        ),
                        const SizedBox(width: 10),
                        Text(l10n.appName, style: ManeType.headline(21, color: c.text)),
                        const Spacer(),
                        GlassIconButton(icon: Icons.search, tooltip: l10n.search, onTap: _openSearch),
                        const SizedBox(width: 8),
                        GlassIconButton(
                          icon: filterCount > 0 ? Icons.filter_alt : Icons.filter_alt_outlined,
                          tooltip: l10n.filterByTag,
                          onTap: () => showTagFilterSheet(context),
                          badge: filterCount == 0
                              ? null
                              : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: c.accent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('$filterCount', style: ManeType.label(9, color: c.onAccent)),
                                ),
                        ),
                        const SizedBox(width: 8),
                        GlassIconButton(
                          icon: Icons.settings_outlined,
                          tooltip: l10n.settings,
                          onTap: () => Navigator.of(
                            context,
                          ).push(MaterialPageRoute<void>(builder: (_) => const SettingsPage())),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FadeThrough(
                      animation: _swap,
                      child: IndexedStack(
                        index: _index,
                        children: const [TodayScreen(), WeekScreen(), CalendarPage()],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 12 + MediaQuery.paddingOf(context).bottom),
                    child: Row(
                      children: [
                        Expanded(
                          child: ManeNavBar(
                            index: _index,
                            onSelected: _selectTab,
                            items: [
                              (icon: Icons.today_outlined, selectedIcon: Icons.today, label: l10n.today),
                              (
                                icon: Icons.calendar_view_week_outlined,
                                selectedIcon: Icons.calendar_view_week,
                                label: l10n.week,
                              ),
                              (
                                icon: Icons.calendar_month_outlined,
                                selectedIcon: Icons.calendar_month,
                                label: l10n.calendar,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        ManeAddButton(
                          tooltip: l10n.addEntry,
                          onTap: () => showEntryEditor(context, spaces: spaces),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openSearch() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SearchPage()));
  }
}

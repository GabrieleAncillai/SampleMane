import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/core/i18n/l10n.dart';
import 'package:mane/core/widgets/ui_kit.dart';
import 'package:mane/features/app_lock/pages/pin_setup_page.dart';
import 'package:mane/features/calendar/pages/calendar_page.dart';
import 'package:mane/features/home_inventory/pages/maintenance_page.dart';
import 'package:mane/features/home_inventory/pages/shopping_list_page.dart';
import 'package:mane/features/settings/pages/settings_page.dart';
import 'package:mane/models/app_settings.dart';
import 'package:mane/models/home_item.dart';
import 'package:mane/models/shopping_item.dart';
import 'package:mane/screens/today_screen.dart';
import 'package:mane/state/providers.dart';
import 'package:mane/state/settings_controller.dart';
import 'package:mane/theme/app_colors.dart';
import 'package:mane/theme/app_theme.dart';
import 'package:mane/theme/app_typography.dart';
import 'package:mane_core/mane_core.dart';

void main() {
  setUpAll(() async {
    initializeTimeZones();
    final materialFont = locateMaterialFont();
    if (materialFont != null) {
      final icons = FontLoader('MaterialIcons')
        ..addFont(Future.value(ByteData.sublistView(materialFont.readAsBytesSync())));
      await icons.load();
    }
    final loader = FontLoader('Nunito');
    for (final file in [
      'Nunito-Regular.ttf',
      'Nunito-Italic.ttf',
      'Nunito-Medium.ttf',
      'Nunito-SemiBold.ttf',
      'Nunito-SemiBoldItalic.ttf',
      'Nunito-Bold.ttf',
      'Nunito-ExtraBold.ttf',
      'Nunito-Black.ttf',
    ]) {
      loader.addFont(rootBundle.load('assets/fonts/$file'));
    }
    await loader.load();
  });

  testWidgets('render Today light', (tester) async {
    await render(tester, 'v0.6-today-light.png', ManeTheme.light, shell(const TodayScreen()));
  });

  testWidgets('render Today dark', (tester) async {
    await render(tester, 'v0.6-today-dark.png', ManeTheme.dark, shell(const TodayScreen()));
  });

  testWidgets('render Calendar light', (tester) async {
    await render(tester, 'v0.6-calendar-light.png', ManeTheme.light, shell(const CalendarPage()));
  });

  testWidgets('render Calendar day light', (tester) async {
    await render(
      tester,
      'v0.7-calendar-day-light.png',
      ManeTheme.light,
      shell(const CalendarPage()),
      act: (tester) async {
        await tester.tap(find.text('Day'));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView).first, const Offset(0, -720));
        await tester.pumpAndSettle();
      },
    );
  });

  testWidgets('render Settings light', (tester) async {
    await render(tester, 'v0.6-settings-light.png', ManeTheme.light, const SettingsPage());
  });

  testWidgets('render Shopping light', (tester) async {
    await render(
      tester,
      'v0.8-shopping-light.png',
      ManeTheme.light,
      const ShoppingListPage(),
      homeItems: const [
        HomeItem(id: 'rice', name: 'Rice', category: 'Pantry', location: 'Kitchen', quantity: 1),
        HomeItem(id: 'soap', name: 'Soap', category: 'Bathroom', location: 'Cabinet', quantity: 2),
      ],
      shoppingItems: const [
        ShoppingItem(id: 'rice', name: 'Rice', quantity: 2, homeItemId: 'rice'),
        ShoppingItem(id: 'soap', name: 'Soap', quantity: 3, homeItemId: 'soap'),
        ShoppingItem(id: 'batteries', name: 'Batteries', quantity: 1, note: 'AA'),
      ],
    );
  });

  testWidgets('render Maintenance light', (tester) async {
    final today = LocalDate.parse('2026-11-09');
    final now = DateTime.utc(2026, 11, 1, 8);
    final entry = Entry(
      id: 'pump',
      spaceId: 'home',
      title: 'Service the water pump',
      date: today.addDays(-3),
      allDay: true,
      repeatAfterCompletionDays: 90,
      createdAt: now,
      updatedAt: now,
    );
    await render(
      tester,
      'v0.8-maintenance-light.png',
      ManeTheme.light,
      const MaintenancePage(),
      entryOccurrences: [EntryOccurrence(date: entry.date!, displayDate: entry.date!, entry: entry)],
    );
  });

  testWidgets('render PIN setup light', (tester) async {
    await render(tester, 'v0.8-pin-setup-light.png', ManeTheme.light, const PinSetupPage());
  });
}

Widget shell(Widget page) {
  return Builder(
    builder: (context) {
      final c = context.mc;
      final l10n = context.l10n;
      return AppBackground(
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
                    GlassIconButton(icon: Icons.search, tooltip: l10n.search, onTap: () {}),
                    const SizedBox(width: 8),
                    GlassIconButton(icon: Icons.filter_alt_outlined, tooltip: l10n.filterByTag, onTap: () {}),
                    const SizedBox(width: 8),
                    GlassIconButton(icon: Icons.settings_outlined, tooltip: l10n.settings, onTap: () {}),
                  ],
                ),
              ),
              Expanded(child: page),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: ManeNavBar(
                        index: 0,
                        onSelected: (_) {},
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
                    ManeAddButton(tooltip: l10n.addEntry, onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> render(
  WidgetTester tester,
  String name,
  ThemeData theme,
  Widget home, {
  Future<void> Function(WidgetTester tester)? act,
  List<EntryOccurrence>? entryOccurrences,
  List<HomeItem> homeItems = const [],
  List<ShoppingItem> shoppingItems = const [],
}) async {
  tester.view.physicalSize = const Size(1290, 2796);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final key = GlobalKey();
  final today = LocalDate.parse('2026-11-09');
  final entries = entryOccurrences ?? demoEntries(today);
  final shifts = demoShifts(today);

  await tester.pumpWidget(
    RepaintBoundary(
      key: key,
      child: ProviderScope(
        overrides: [
          initialSettingsProvider.overrideWithValue(const AppSettings()),
          deviceTimeZoneProvider.overrideWith(() => DeviceTimeZoneController(initial: 'Europe/Madrid')),
          nowProvider.overrideWithValue(DateTime.utc(2026, 11, 9, 18)),
          spacesProvider.overrideWith((ref) => Stream.value(fallbackSpaces)),
          tagsProvider.overrideWith((ref) => Stream.value(const <Tag>[])),
          homeItemsProvider.overrideWith((ref) => Stream.value(homeItems)),
          shoppingItemsProvider.overrideWith((ref) => Stream.value(shoppingItems)),
          pairedDevicesProvider.overrideWith((ref) => Stream.value(const [])),
          entriesProvider.overrideWith(
            (ref, range) => Stream.value(
              entries
                  .where(
                    (entry) =>
                        entry.displayDate.key >= range.start.key && entry.displayDate.key <= range.end.key,
                  )
                  .toList(),
            ),
          ),
          shiftsProvider.overrideWith(
            (ref, range) => Stream.value(
              shifts
                  .where(
                    (shift) =>
                        shift.displayDate.key >= range.start.key && shift.displayDate.key <= range.end.key,
                  )
                  .toList(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(backgroundColor: Colors.transparent, body: home),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  if (act != null) await act(tester);
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    final dir = Directory('docs/screenshots')..createSync(recursive: true);
    File('${dir.path}/$name').writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}

File? locateMaterialFont() {
  var dir = File(Platform.resolvedExecutable).parent;
  for (var i = 0; i < 10; i++) {
    for (final candidate in [
      File('${dir.path}/artifacts/material_fonts/MaterialIcons-Regular.otf'),
      File('${dir.path}/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf'),
      File('${dir.path}/cache/artifacts/material_fonts/MaterialIcons-Regular.otf'),
    ]) {
      if (candidate.existsSync()) return candidate;
    }
    if (dir.parent.path == dir.path) break;
    dir = dir.parent;
  }
  return null;
}

List<EntryOccurrence> demoEntries(LocalDate today) {
  final now = DateTime.utc(2026, 11, 1, 8);
  Entry entry(
    String id,
    String space,
    String title,
    LocalDate date, {
    EntryKind kind = EntryKind.task,
    bool allDay = false,
    int? start,
    int? end,
    RecurrenceRule? recurrence,
  }) {
    return Entry(
      id: id,
      spaceId: space,
      title: title,
      kind: kind,
      date: date,
      allDay: allDay,
      startMinute: allDay ? null : start,
      endMinute: allDay ? null : end,
      timeZone: allDay ? null : 'Europe/Madrid',
      recurrence: recurrence,
      createdAt: now,
      updatedAt: now,
    );
  }

  final list = [
    entry('review', 'work', 'Review the release notes', today, start: 10 * 60, end: 11 * 60),
    entry('taxes', 'personal', 'File the quarterly taxes', today, kind: EntryKind.deadline, allDay: true),
    entry('pump', 'home', 'Service the water pump', today, kind: EntryKind.obligation, allDay: true),
    entry('standup', 'work', 'Morning standup', today.addDays(1), start: 9 * 60, end: 9 * 60 + 30),
    entry(
      'anniversary',
      'personal',
      'Anniversary dinner',
      today.addDays(3),
      kind: EntryKind.event,
      start: 20 * 60,
      end: 22 * 60,
      recurrence: const RecurrenceRule(frequency: RecurrenceFrequency.yearly),
    ),
  ];
  return [
    for (final item in list)
      EntryOccurrence(
        date: item.date!,
        displayDate: item.date!,
        entry: item,
        startAt: item.startAt,
        endAt: item.endAt,
      ),
  ];
}

List<ShiftOccurrence> demoShifts(LocalDate today) {
  final pattern = ShiftPattern(
    id: 'pizzeria',
    spaceId: 'work',
    name: 'Pizzeria',
    timeZone: 'Europe/Madrid',
    cycleDays: 7,
    anchorDate: today,
    slots: const [ShiftSlot(dayIndex: 0, startMinute: 15 * 60, endMinute: 23 * 60, label: 'Floor')],
  );
  return pattern.occurrencesBetween(today, today.addDays(6), viewerTimeZone: 'Europe/Madrid');
}

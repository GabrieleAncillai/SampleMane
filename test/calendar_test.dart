import 'dart:ffi' show DynamicLibrary;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/core/i18n/l10n.dart';
import 'package:mane/features/calendar/pages/calendar_page.dart';
import 'package:mane/models/app_settings.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane/state/providers.dart';
import 'package:mane/state/settings_controller.dart';
import 'package:mane/theme/app_theme.dart';
import 'package:mane_core/mane_core.dart';
import 'package:sqlite3/open.dart';

void main() {
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
    initializeTimeZones();
  });

  late AppDatabase database;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    await database.seedDefaults();
  });

  tearDown(() => database.close());

  Widget host() => ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(database),
      deviceTimeZoneProvider.overrideWith(() => DeviceTimeZoneController(initial: 'Europe/Madrid')),
      nowProvider.overrideWithValue(DateTime.utc(2026, 11, 9, 12)),
      initialSettingsProvider.overrideWithValue(const AppSettings()),
    ],
    child: MaterialApp(
      theme: ManeTheme.light,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: CalendarPage()),
    ),
  );

  testWidgets('calendar days expose a descriptive semantics label', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(host());
    await tester.pump();

    expect(find.bySemanticsLabel(RegExp(r'Nov 9, 0 items')), findsOneWidget);
    handle.dispose();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('selecting a day shows its entries and keeps the selected date', (tester) async {
    tester.view.physicalSize = const Size(500, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await database.saveEntry(
      Entry(
        id: 'dentist',
        spaceId: 'personal',
        title: 'Dentist',
        date: LocalDate.parse('2026-11-15'),
        allDay: true,
        createdAt: DateTime.utc(2026, 11, 1),
        updatedAt: DateTime.utc(2026, 11, 1),
      ),
    );

    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    expect(find.text('November 2026'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('calendar-day-2026-11-15')));
    await tester.pumpAndSettle();

    expect(find.text('Dentist'), findsOneWidget);

    await tester.tap(find.byTooltip('Next month'));
    await tester.pumpAndSettle();
    expect(find.text('December 2026'), findsOneWidget);

    await tester.tap(find.byTooltip('Jump to today'));
    await tester.pumpAndSettle();
    expect(find.text('November 2026'), findsOneWidget);
    expect(find.text('Dentist'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('week mode navigates by whole weeks', (tester) async {
    tester.view.physicalSize = const Size(500, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(host());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Week'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('week-day-2026-11-09')), findsOneWidget);

    await tester.tap(find.byTooltip('Next week'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('week-day-2026-11-16')), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('a Sunday week start rotates the month grid', (tester) async {
    tester.view.physicalSize = const Size(500, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          deviceTimeZoneProvider.overrideWith(() => DeviceTimeZoneController(initial: 'Europe/Madrid')),
          nowProvider.overrideWithValue(DateTime.utc(2026, 11, 9, 12)),
          initialSettingsProvider.overrideWithValue(const AppSettings(weekStart: DateTime.sunday)),
        ],
        child: MaterialApp(
          theme: ManeTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: CalendarPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1 November 2026 is a Sunday, so the first cell is the 1st itself.
    final firstCell = find.byKey(const ValueKey('calendar-day-2026-11-01'));
    expect(firstCell, findsOneWidget);
    final firstRect = tester.getRect(firstCell);
    final secondRect = tester.getRect(find.byKey(const ValueKey('calendar-day-2026-11-02')));
    expect(secondRect.left, greaterThan(firstRect.left));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}

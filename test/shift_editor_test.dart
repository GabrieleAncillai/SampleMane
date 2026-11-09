import 'dart:ffi' show DynamicLibrary;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/core/i18n/l10n.dart';
import 'package:mane/features/shifts/pages/shift_pattern_editor_page.dart';
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

  testWidgets('creates a pattern with a slot and saves it', (tester) async {
    tester.view.physicalSize = const Size(500, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final database = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    addTearDown(database.close);
    await database.seedDefaults();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          deviceTimeZoneProvider.overrideWith(() => DeviceTimeZoneController(initial: 'Europe/Madrid')),
          nowProvider.overrideWithValue(DateTime.utc(2026, 11, 9, 8)),
          initialSettingsProvider.overrideWithValue(const AppSettings()),
        ],
        child: MaterialApp(
          theme: ManeTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ShiftPatternEditorPage(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    await tester.enterText(find.byType(TextFormField).first, 'Night rotation');
    await tester.tap(find.text('Add a slot').first);
    await tester.pump();

    await tester.scrollUntilVisible(
      find.text('Save pattern'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Save pattern'));
    await tester.pump(const Duration(milliseconds: 500));

    final rows = await database.customSelect('SELECT name, time_zone FROM shift_pattern_records').get();
    expect(rows, hasLength(1));
    expect(rows.single.data['name'], 'Night rotation');
    expect(rows.single.data['time_zone'], 'Europe/Madrid');

    final slots = await database.customSelect('SELECT * FROM shift_slot_records').get();
    expect(slots, hasLength(1));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}

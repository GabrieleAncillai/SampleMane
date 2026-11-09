import 'dart:ffi';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/core/i18n/l10n.dart';
import 'package:mane/features/sync/identity_service.dart';
import 'package:mane/features/sync/pages/devices_page.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane/services/planner_repository.dart';
import 'package:mane/state/providers.dart';
import 'package:mane/theme/app_theme.dart';
import 'package:sqlite3/open.dart';

void main() {
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
  });

  testWidgets('creates the local pairing identity from the devices page', (tester) async {
    final database = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          deviceTimeZoneProvider.overrideWith(() => DeviceTimeZoneController(initial: 'Europe/Madrid')),
          identityServiceProvider.overrideWithValue(
            IdentityService(PlannerRepository(database), certificateKeySize: 1024),
          ),
        ],
        child: MaterialApp(
          theme: ManeTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const DevicesPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Pairing identity'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'muffin');
    await tester.enterText(find.byType(TextField).at(1), 'Test device');
    await tester.enterText(find.byType(TextField).at(2), '4821');
    await tester.tap(find.text('Create identity'));
    await tester.pump();

    for (var index = 0; index < 30; index++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (await database.readIdentity() != null) break;
    }

    final identity = await database.readIdentity();
    expect(identity, isNotNull);
    expect(identity!.username, 'muffin');
    expect(identity.deviceName, 'Test device');
    expect(identity.pinHash, isNot('4821'));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}

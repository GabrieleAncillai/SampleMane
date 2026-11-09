import 'dart:ffi';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/core/i18n/l10n.dart';
import 'package:mane/features/app_lock/app_lock_service.dart';
import 'package:mane/features/app_lock/widgets/app_lock_gate.dart';
import 'package:mane/models/app_settings.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane/services/planner_repository.dart';
import 'package:mane/state/providers.dart';
import 'package:mane/state/settings_controller.dart';
import 'package:mane/theme/app_theme.dart';
import 'package:sqlite3/open.dart';

class _FakeAppLockService extends AppLockService {
  _FakeAppLockService() : super(PlannerRepository(AppDatabase(NativeDatabase.memory())));

  @override
  Future<bool> verify(String pin) async => pin == '1234';

  @override
  Future<Duration> lockoutRemaining() async => Duration.zero;
}

void main() {
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
  });

  Widget host() => ProviderScope(
    overrides: [
      initialSettingsProvider.overrideWithValue(const AppSettings(appLockEnabled: true, hasAppLockPin: true)),
      appLockServiceProvider.overrideWithValue(_FakeAppLockService()),
    ],
    child: MaterialApp(
      theme: ManeTheme.light,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppLockGate(child: Text('secret plan')),
    ),
  );

  testWidgets('locks the shell until the local PIN is entered', (tester) async {
    await tester.pumpWidget(host());
    await tester.pump();

    expect(find.text('Enter your PIN'), findsOneWidget);
    for (final digit in ['1', '2', '3', '4']) {
      await tester.tap(find.text(digit));
      await tester.pump();
    }
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Enter your PIN'), findsNothing);
  });

  testWidgets('wrong PIN keeps the gate closed', (tester) async {
    await tester.pumpWidget(host());
    await tester.pump();

    for (final digit in ['9', '9', '9', '9']) {
      await tester.tap(find.text(digit).first);
      await tester.pump();
    }
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('Wrong PIN'), findsOneWidget);
    expect(find.text('Enter your PIN'), findsOneWidget);
  });
}

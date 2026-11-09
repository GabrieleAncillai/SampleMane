import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/core/i18n/l10n.dart';
import 'package:mane/features/home_inventory/pages/maintenance_page.dart';
import 'package:mane/features/home_inventory/pages/shopping_list_page.dart';
import 'package:mane/models/app_settings.dart';
import 'package:mane/models/home_item.dart';
import 'package:mane/models/shopping_item.dart';
import 'package:mane/state/providers.dart';
import 'package:mane/state/settings_controller.dart';
import 'package:mane/theme/app_theme.dart';
import 'package:mane_core/mane_core.dart';

void main() {
  testWidgets('shopping groups linked lines by home category', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeItemsProvider.overrideWith(
            (ref) => Stream.value(const [
              HomeItem(id: 'rice', name: 'Rice', category: 'Pantry', location: 'Kitchen'),
            ]),
          ),
          shoppingItemsProvider.overrideWith(
            (ref) => Stream.value(const [
              ShoppingItem(id: 'rice-buy', name: 'Rice', quantity: 2, homeItemId: 'rice'),
              ShoppingItem(id: 'soap-buy', name: 'Soap'),
            ]),
          ),
        ],
        child: MaterialApp(
          theme: ManeTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ShoppingListPage(),
        ),
      ),
    );
    for (var index = 0; index < 10; index++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.text('Pantry · Kitchen'), findsOneWidget);
    expect(find.text('Other'), findsOneWidget);
    expect(find.text('Rice'), findsOneWidget);
    expect(find.text('Clear bought'), findsNothing);
  });

  testWidgets('maintenance shows due tasks', (tester) async {
    final now = DateTime.utc(2026, 11, 9, 12);
    final today = localDateAt(now, 'Europe/Madrid');
    final entry = Entry(
      id: 'water',
      spaceId: 'home',
      title: 'Water tank',
      date: today.addDays(-2),
      allDay: true,
      repeatAfterCompletionDays: 90,
      createdAt: now,
      updatedAt: now,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          initialSettingsProvider.overrideWithValue(const AppSettings()),
          deviceTimeZoneProvider.overrideWith(() => DeviceTimeZoneController(initial: 'Europe/Madrid')),
          nowProvider.overrideWithValue(now),
          entriesProvider.overrideWith(
            (ref, range) =>
                Stream.value([EntryOccurrence(date: entry.date!, displayDate: entry.date!, entry: entry)]),
          ),
        ],
        child: MaterialApp(
          theme: ManeTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const MaintenancePage(),
        ),
      ),
    );
    for (var index = 0; index < 10; index++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.text('Water tank'), findsOneWidget);
    expect(find.text('DUE NOW'), findsOneWidget);
  });
}

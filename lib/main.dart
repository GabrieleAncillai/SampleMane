import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:mane_core/mane_core.dart';

import 'app/mane_app.dart';
import 'models/app_settings.dart';
import 'services/app_database.dart';
import 'services/notification_service.dart';
import 'state/providers.dart';
import 'state/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();
  final timeZone = await _deviceTimeZone();
  final database = AppDatabase.open(defaultTimeZone: timeZone);
  await database.seedDefaults();
  final settings = AppSettings.fromMap(await database.readSettings());
  final notifications = NotificationService();
  await notifications.initialize(deviceTimeZone: timeZone);
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        deviceTimeZoneProvider.overrideWith(() => DeviceTimeZoneController(initial: timeZone)),
        notificationServiceProvider.overrideWithValue(notifications),
        initialSettingsProvider.overrideWithValue(settings),
      ],
      child: const ManeApp(),
    ),
  );
}

/// The device's IANA timezone, or UTC when the platform cannot report one.
///
/// A wrong-but-valid zone is worse than UTC: it would silently move timed
/// plans. The editor still lets the user keep a stored zone on existing items.
Future<String> _deviceTimeZone() async {
  try {
    final zone = await FlutterTimezone.getLocalTimezone();
    if (isKnownTimeZone(zone.identifier)) return zone.identifier;
  } catch (_) {
    // Platform lookup is unavailable on some Linux sessions; UTC is safe.
  }
  return 'UTC';
}

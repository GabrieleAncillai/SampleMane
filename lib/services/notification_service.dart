import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'reminder_planner.dart';

/// Thin wrapper around `flutter_local_notifications`.
///
/// All schedule arithmetic lives in `reminder_planner.dart`; this class only
/// initialises the plugin, asks for permissions and signs the plan.
class NotificationService {
  NotificationService();

  static const channelId = 'mane_reminders';
  static const channelName = 'Mane reminders';
  static const channelDescription = 'Entry and all-day reminders';

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  String _deviceTimeZone = 'UTC';
  String? _pendingEntryId;

  /// Called when a notification is tapped while the app is running.
  void Function(String entryId)? onOpenEntry;

  bool get isReady => _ready;

  String? takePendingEntry() {
    final id = _pendingEntryId;
    _pendingEntryId = null;
    return id;
  }

  Future<void> initialize({required String deviceTimeZone}) async {
    if (_ready) return;
    _deviceTimeZone = deviceTimeZone;
    try {
      const android = AndroidInitializationSettings('ic_stat_mane');
      const linux = LinuxInitializationSettings(defaultActionName: 'Mane');
      await _plugin.initialize(
        settings: const InitializationSettings(android: android, linux: linux),
        onDidReceiveNotificationResponse: _onResponse,
      );

      if (defaultTargetPlatform == TargetPlatform.android) {
        const channel = AndroidNotificationChannel(
          channelId,
          channelName,
          description: channelDescription,
          importance: Importance.high,
        );
        await _plugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
      }

      final launch = await _plugin.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp == true) {
        final payload = launch?.notificationResponse?.payload;
        if (payload != null && payload.isNotEmpty) _pendingEntryId = payload;
      }
      _ready = true;
    } catch (_) {
      // A desktop session without a notification daemon must not break the
      // planner. The app keeps working; reminders are simply unavailable.
      _ready = false;
    }
  }

  /// Requests the Android notification and exact-alarm permissions.
  ///
  /// Returns false only when notification permission is denied. An exact-alarm
  /// denial degrades to inexact scheduling instead of dropping the reminder.
  Future<bool> ensurePermissions() async {
    if (defaultTargetPlatform != TargetPlatform.android) return true;
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return true;

    try {
      final notifications = await android.requestNotificationsPermission() ?? true;
      if (!notifications) return false;
      final exact = await android.canScheduleExactNotifications() ?? true;
      if (!exact) {
        await android.requestExactAlarmsPermission();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Replaces the pending queue with [plans].
  Future<void> reschedule(List<PlannedReminder> plans) async {
    if (!_ready) return;
    try {
      await _plugin.cancelAllPendingNotifications();
      if (plans.isEmpty) return;

      var exact = true;
      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = _plugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        exact = await android?.canScheduleExactNotifications() ?? true;
      }
      final mode = exact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;

      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        linux: LinuxNotificationDetails(),
      );

      for (final plan in plans) {
        try {
          final scheduled = tz.TZDateTime.from(plan.fireAt, tz.getLocation(_deviceTimeZone));
          await _plugin.zonedSchedule(
            id: plan.notificationId,
            title: plan.title,
            body: plan.body.isEmpty ? null : plan.body,
            scheduledDate: scheduled,
            notificationDetails: details,
            androidScheduleMode: mode,
            payload: plan.entryId,
          );
        } catch (_) {
          // One bad row must not take the rest of the queue with it.
        }
      }
    } catch (_) {
      // The plugin is best-effort on platforms without a notification daemon.
    }
  }

  Future<void> cancelAll() async {
    if (!_ready) return;
    try {
      await _plugin.cancelAllPendingNotifications();
    } catch (_) {
      // Keep the planner usable when the platform channel is unavailable.
    }
  }

  void _onResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    final callback = onOpenEntry;
    if (callback != null) {
      callback(payload);
    } else {
      _pendingEntryId = payload;
    }
  }
}

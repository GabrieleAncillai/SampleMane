import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mane_core/mane_core.dart';
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
  (String, String, LocalDate?)? _pendingAction;

  /// Called when a notification is tapped while the app is running.
  void Function(String entryId)? onOpenEntry;

  /// Called for the snooze/complete action buttons where the platform supports
  /// them. The callback runs on the app side, never in the notification helper.
  void Function(String actionId, String entryId, LocalDate? date)? onAction;

  /// Action identifiers used by the Android notification buttons.
  static const snoozeAction = 'snooze';
  static const completeAction = 'complete';

  bool get isReady => _ready;

  String? takePendingEntry() {
    final id = _pendingEntryId;
    _pendingEntryId = null;
    return id;
  }

  (String, String, LocalDate?)? takePendingAction() {
    final action = _pendingAction;
    _pendingAction = null;
    return action;
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
        final response = launch?.notificationResponse;
        final payload = _decodePayload(response?.payload);
        if (payload != null) {
          final actionId = response?.actionId;
          if (actionId == snoozeAction || actionId == completeAction) {
            _pendingAction = (actionId!, payload.$1, payload.$2);
          } else {
            _pendingEntryId = payload.$1;
          }
        }
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
          actions: [
            AndroidNotificationAction(snoozeAction, 'Snooze 10 minutes'),
            AndroidNotificationAction(completeAction, 'Mark complete'),
          ],
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
            payload: _encodePayload(plan.entryId, plan.date),
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

  /// Schedules a one-off reminder. Used by the snooze action; the original
  /// reminder keeps its own id, so this replaces the notification cleanly.
  Future<void> scheduleSnooze({
    required int notificationId,
    required String entryId,
    required LocalDate date,
    required String title,
    required String body,
    required DateTime fireAt,
  }) async {
    if (!_ready) return;
    try {
      final scheduled = tz.TZDateTime.from(fireAt, tz.getLocation(_deviceTimeZone));
      await _plugin.zonedSchedule(
        id: notificationId,
        title: title,
        body: body.isEmpty ? null : body,
        scheduledDate: scheduled,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            importance: Importance.high,
            priority: Priority.high,
            actions: [
              AndroidNotificationAction(snoozeAction, 'Snooze 10 minutes'),
              AndroidNotificationAction(completeAction, 'Mark complete'),
            ],
          ),
          linux: LinuxNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: _encodePayload(entryId, date),
      );
    } catch (_) {
      // A missed snooze is a missed notification, not a broken planner.
    }
  }

  Future<void> cancel(int notificationId) async {
    if (!_ready) return;
    try {
      await _plugin.cancel(id: notificationId);
    } catch (_) {
      // Best effort.
    }
  }

  void _onResponse(NotificationResponse response) {
    final payload = _decodePayload(response.payload);
    if (payload == null) return;
    final actionId = response.actionId;
    if (actionId != null && (actionId == snoozeAction || actionId == completeAction)) {
      final callback = onAction;
      if (callback != null) {
        callback(actionId, payload.$1, payload.$2);
        return;
      }
    }
    final callback = onOpenEntry;
    if (callback != null) {
      callback(payload.$1);
    } else {
      _pendingEntryId = payload.$1;
    }
  }

  static String _encodePayload(String entryId, LocalDate date) =>
      jsonEncode({'entryId': entryId, 'date': date.iso});

  static (String, LocalDate?)? _decodePayload(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (!raw.startsWith('{')) return (raw, null);
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return (raw, null);
      final entryId = decoded['entryId'];
      if (entryId is! String || entryId.isEmpty) return null;
      LocalDate? date;
      final dateRaw = decoded['date'];
      if (dateRaw is String) {
        try {
          date = LocalDate.parse(dateRaw);
        } on FormatException {
          date = null;
        }
      }
      return (entryId, date);
    } on FormatException {
      return (raw, null);
    }
  }
}

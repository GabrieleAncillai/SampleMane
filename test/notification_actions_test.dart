import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/services/notification_service.dart';
import 'package:mane/services/reminder_planner.dart';
import 'package:mane_core/mane_core.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class _FakePlatform extends FlutterLocalNotificationsPlatform {
  final cancelled = <int>[];
  final scheduled = <int>[];
  int cancelAllCalls = 0;

  @override
  Future<void> cancel({required int id}) async {
    cancelled.add(id);
  }

  @override
  Future<void> cancelAllPendingNotifications() async {
    cancelAllCalls++;
  }

  @override
  Future<void> zonedSchedule({
    required int id,
    String? title,
    String? body,
    required tz.TZDateTime scheduledDate,
    String? payload,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    scheduled.add(id);
  }
}

void main() {
  tzdata.initializeTimeZones();

  test('reminder actions use the foreground callback path', () {
    final android = NotificationService.reminderDetails.android;
    expect(android, isNotNull);
    final actions = android!.actions;
    expect(actions, isNotNull);
    expect(
      actions!.map((action) => action.id),
      containsAll([NotificationService.snoozeAction, NotificationService.completeAction]),
    );
    expect(actions.every((action) => action.showsUserInterface), isTrue);
  });

  test('a resume rebuild keeps a scheduled snooze', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    expect(defaultTargetPlatform, TargetPlatform.linux);
    final plugin = _FakePlatform();
    FlutterLocalNotificationsPlatform.instance = plugin;
    final service = NotificationService.withPlugin(FlutterLocalNotificationsPlugin());
    const date = LocalDate(2026, 11, 9);
    final first = PlannedReminder(
      notificationId: 1,
      entryId: 'entry',
      date: date,
      fireAt: DateTime.utc(2026, 11, 9, 23),
      title: 'test',
      body: '',
    );
    final second = PlannedReminder(
      notificationId: 2,
      entryId: 'entry',
      date: date,
      fireAt: DateTime.utc(2026, 11, 10, 23),
      title: 'test',
      body: '',
    );

    await service.reschedule([first]);
    await service.scheduleSnooze(
      notificationId: 99,
      entryId: 'entry',
      date: date,
      title: 'test',
      body: '',
      fireAt: DateTime.utc(2026, 11, 9, 23, 10),
    );
    await service.reschedule([second]);

    expect(plugin.scheduled, [1, 99, 2]);
    expect(plugin.cancelled, [1]);
    expect(plugin.cancelAllCalls, 0);

    await service.cancelAll();
    expect(plugin.cancelAllCalls, 1);
  });
}

import 'package:mane_core/mane_core.dart';

import 'notification_service.dart';
import 'planner_repository.dart';
import 'reminder_planner.dart';

/// Rebuilds the notification queue from the current plan.
///
/// Called on app start, on resume after a timezone change, and after an entry
/// or reminder is edited. Failures are best-effort: the planner must keep
/// working without notifications.
class ReminderCoordinator {
  ReminderCoordinator({
    required this.repository,
    required this.notifications,
    required this.deviceTimeZone,
    required this.clock,
  });

  final PlannerRepository repository;
  final NotificationService notifications;
  final String deviceTimeZone;
  final DateTime Function() clock;

  Future<void> reschedule() async {
    try {
      final now = clock().toUtc();
      final today = localDateAt(now, deviceTimeZone);
      final occurrences = await repository.loadEntries(
        today,
        today.addDays(reminderHorizonDays),
        deviceTimeZone,
      );
      final reminders = await repository.readAllReminders();
      final plans = planReminders(
        occurrences: occurrences,
        remindersByEntry: reminders,
        now: now,
        deviceTimeZone: deviceTimeZone,
      );
      await notifications.reschedule(plans);
    } catch (_) {
      // A missing platform notification channel must not break the planner.
    }
  }

  Future<void> cancelAll() => notifications.cancelAll();
}

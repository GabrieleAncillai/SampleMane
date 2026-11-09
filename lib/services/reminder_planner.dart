import 'package:mane_core/mane_core.dart';

import '../models/reminder.dart';

/// All-day items have no start time, so reminders count from 09:00 local.
const allDayReminderMinute = 9 * 60;

/// How far ahead reminders are scheduled. The coordinator rebuilds on every
/// app start/resume, so this only bounds the plugin queue.
const reminderHorizonDays = 90;

const maxScheduledReminders = 500;

class PlannedReminder {
  const PlannedReminder({
    required this.notificationId,
    required this.entryId,
    required this.fireAt,
    required this.title,
    required this.body,
  });

  final int notificationId;
  final String entryId;
  final DateTime fireAt;
  final String title;
  final String body;
}

/// Builds the notification schedule from expanded occurrences and reminders.
///
/// Pure on purpose: the plugin wrapper only signs and sends this list, so the
/// arithmetic is testable without Android or Linux.
List<PlannedReminder> planReminders({
  required Iterable<EntryOccurrence> occurrences,
  required Map<String, List<Reminder>> remindersByEntry,
  required DateTime now,
  required String deviceTimeZone,
}) {
  final plans = <PlannedReminder>[];
  for (final occurrence in occurrences) {
    if (occurrence.completed) continue;
    final entry = occurrence.entry;
    final reminders = remindersByEntry[entry.id];
    if (reminders == null || reminders.isEmpty) continue;

    final base =
        occurrence.startAt ?? instantAt(occurrence.displayDate, allDayReminderMinute, deviceTimeZone);
    for (final reminder in reminders) {
      if (!reminder.enabled) continue;
      final fireAt = base.subtract(Duration(minutes: reminder.offsetMinutes));
      if (!fireAt.isAfter(now)) continue;
      plans.add(
        PlannedReminder(
          notificationId: notificationIdFor(entry.id, reminder.id, occurrence.date.key),
          entryId: entry.id,
          fireAt: fireAt,
          title: entry.title,
          body: entry.notes,
        ),
      );
    }
  }

  plans.sort((a, b) => a.fireAt.compareTo(b.fireAt));
  return plans.take(maxScheduledReminders).toList();
}

/// Stable 31-bit notification id. FNV-1a avoids `String.hashCode`, which is
/// not guaranteed to survive Dart SDK upgrades.
int notificationIdFor(String entryId, String reminderId, int dateKey) {
  final input = '$entryId|$reminderId|$dateKey';
  var hash = 0x811c9dc5;
  for (final unit in input.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0x7fffffff;
  }
  return hash == 0 ? 1 : hash;
}

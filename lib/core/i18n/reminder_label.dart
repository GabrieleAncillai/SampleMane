import 'package:flutter/widgets.dart';

import 'l10n.dart';

/// A reminder lead time in the current locale.
String reminderOffsetLabel(BuildContext context, int minutes) {
  final l10n = context.l10n;
  if (minutes <= 0) return l10n.reminderAtTime;
  if (minutes % 1440 == 0) return l10n.reminderDaysBefore(minutes ~/ 1440);
  if (minutes % 60 == 0) return l10n.reminderHoursBefore(minutes ~/ 60);
  return l10n.reminderMinutesBefore(minutes);
}

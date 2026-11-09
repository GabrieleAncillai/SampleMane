import 'package:flutter/widgets.dart';
import 'package:mane_core/mane_core.dart';

import '../i18n/date_labels.dart';
import '../i18n/l10n.dart';

/// A localized recurrence description for lists and the entry editor.
String recurrenceLabel(BuildContext context, RecurrenceRule rule, LocalDate anchor) {
  final l10n = context.l10n;
  switch (rule.frequency) {
    case RecurrenceFrequency.daily:
      return rule.interval == 1 ? l10n.recurrenceEveryDay : l10n.recurrenceEveryNDays(rule.interval);
    case RecurrenceFrequency.weekly:
      final days = rule.weekdays.isEmpty ? <int>{anchor.weekday} : rule.weekdays;
      final label = shortWeekdayList(context, days);
      if (rule.interval == 1) return l10n.recurrenceOnDays(label);
      return l10n.recurrenceEveryNWeeksOnDays(rule.interval, label);
    case RecurrenceFrequency.monthly:
      final day = rule.monthDay;
      if (rule.interval == 1) {
        return day == null ? l10n.recurrenceEveryMonth : l10n.recurrenceOnDayOfMonth(day);
      }
      return day == null
          ? l10n.recurrenceEveryNMonths(rule.interval)
          : l10n.recurrenceEveryNMonthsOnDay(rule.interval, day);
    case RecurrenceFrequency.yearly:
      return rule.interval == 1 ? l10n.recurrenceEveryYear : l10n.recurrenceEveryNYears(rule.interval);
  }
}

String entryKindLabel(BuildContext context, EntryKind kind) => switch (kind) {
  EntryKind.task => context.l10n.entryKindTask,
  EntryKind.event => context.l10n.entryKindEvent,
  EntryKind.obligation => context.l10n.entryKindObligation,
  EntryKind.deadline => context.l10n.entryKindDeadline,
};

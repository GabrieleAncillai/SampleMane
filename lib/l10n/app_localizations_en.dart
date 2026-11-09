// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mane';

  @override
  String get today => 'Today';

  @override
  String get week => 'Week';

  @override
  String get calendar => 'Calendar';

  @override
  String get settings => 'Settings';

  @override
  String get tags => 'Tags';

  @override
  String get shifts => 'Shifts';

  @override
  String get about => 'About';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get addEntry => 'Add an entry';

  @override
  String get addSomething => 'Add something';

  @override
  String get addOnThisDay => 'Add on this day';

  @override
  String get noPlanToday => 'Nothing planned for today.';

  @override
  String get noPlanTodayHint => 'That is allowed. If something is missing, add it now.';

  @override
  String get nothingPlanned => 'Nothing planned';

  @override
  String get shiftsSection => 'Shifts';

  @override
  String couldNotLoadDay(String error) {
    return 'Could not load your day: $error';
  }

  @override
  String couldNotLoadShifts(String error) {
    return 'Could not load shifts: $error';
  }

  @override
  String get allDay => 'All day';

  @override
  String get overnightSuffix => '(+1 day)';

  @override
  String get importedEvent => 'Imported calendar event';

  @override
  String get readOnlyNotice => 'This event comes from an imported calendar and is read-only.';

  @override
  String get newEntry => 'New entry';

  @override
  String get editEntry => 'Edit entry';

  @override
  String get titleQuestion => 'What is it?';

  @override
  String get titleRequired => 'Give it a name';

  @override
  String get space => 'Space';

  @override
  String get type => 'Type';

  @override
  String get date => 'Date';

  @override
  String get starts => 'Starts';

  @override
  String get ends => 'Ends';

  @override
  String get repeat => 'Repeat';

  @override
  String get repeatNever => 'Never';

  @override
  String get repeatDaily => 'Every day';

  @override
  String get repeatWeekly => 'Every week';

  @override
  String get repeatMonthly => 'Every month';

  @override
  String get repeatYearly => 'Every year';

  @override
  String get repeatAfterCompletion => 'Repeat after completion';

  @override
  String get repeatAfterCompletionSubtitle => 'Schedule the next one from the day you finish.';

  @override
  String get daysRequired => 'Use a number of days greater than zero.';

  @override
  String daysValue(int count) {
    return '$count days';
  }

  @override
  String get repeatAfterDaysLabel => 'Days between completions';

  @override
  String couldNotComplete(String error) {
    return 'Could not complete: $error';
  }

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get deleteEntryQuestion => 'Delete this entry?';

  @override
  String get deleteEntryBody => 'It will disappear from your plan.';

  @override
  String get endAfterStartError => 'The end time has to be after the start.';

  @override
  String couldNotSave(String error) {
    return 'Could not save: $error';
  }

  @override
  String couldNotDelete(String error) {
    return 'Could not delete: $error';
  }

  @override
  String timesDefinedIn(String timeZone) {
    return 'Times are defined in $timeZone';
  }

  @override
  String markAsDone(String title) {
    return 'Mark $title as done';
  }

  @override
  String get entryKindTask => 'Task';

  @override
  String get entryKindEvent => 'Event';

  @override
  String get entryKindObligation => 'Obligation';

  @override
  String get entryKindDeadline => 'Deadline';

  @override
  String get recurrenceEveryDay => 'Every day';

  @override
  String recurrenceEveryNDays(int count) {
    return 'Every $count days';
  }

  @override
  String get recurrenceEveryWeek => 'Every week';

  @override
  String recurrenceEveryNWeeks(int count) {
    return 'Every $count weeks';
  }

  @override
  String recurrenceOnDays(String days) {
    return 'Every week on $days';
  }

  @override
  String recurrenceEveryNWeeksOnDays(int count, String days) {
    return 'Every $count weeks on $days';
  }

  @override
  String get recurrenceEveryMonth => 'Every month';

  @override
  String recurrenceEveryNMonths(int count) {
    return 'Every $count months';
  }

  @override
  String recurrenceEveryNMonthsOnDay(int count, int day) {
    return 'Every $count months on day $day';
  }

  @override
  String recurrenceOnDayOfMonth(int day) {
    return 'Every month on day $day';
  }

  @override
  String get recurrenceEveryYear => 'Every year';

  @override
  String recurrenceEveryNYears(int count) {
    return 'Every $count years';
  }

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get previousWeek => 'Previous week';

  @override
  String get nextWeek => 'Next week';

  @override
  String get jumpToToday => 'Jump to today';

  @override
  String get monthView => 'Month';

  @override
  String get weekView => 'Week';

  @override
  String get selectedDay => 'Selected day';

  @override
  String get noEntriesOnDay => 'Nothing planned on this day.';

  @override
  String calendarDaySemantics(String date, int count) {
    return '$date, $count items';
  }

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get weekStartsOn => 'Week starts on';

  @override
  String get weekStartMonday => 'Monday';

  @override
  String get weekStartSaturday => 'Saturday';

  @override
  String get weekStartSunday => 'Sunday';

  @override
  String get hideWorkSpace => 'Hide the Work space';

  @override
  String get hideWorkSpaceSubtitle => 'Keep work commitments out of Today, Week and Calendar.';

  @override
  String get defaultReminders => 'Default reminders';

  @override
  String get defaultRemindersSubtitle => 'Pre-selected when you add an entry.';

  @override
  String get reminderAtTime => 'At the start time';

  @override
  String reminderMinutesBefore(int count) {
    return '$count minutes before';
  }

  @override
  String reminderHoursBefore(int count) {
    return '$count hours before';
  }

  @override
  String reminderDaysBefore(int count) {
    return '$count days before';
  }

  @override
  String get reminders => 'Reminders';

  @override
  String get addReminder => 'Add a reminder';

  @override
  String get removeReminder => 'Remove reminder';

  @override
  String get remindersOff => 'No reminders';

  @override
  String get notificationPermissionDenied =>
      'Notifications are off. Enable them in system settings so reminders can reach you.';

  @override
  String couldNotLoadReminders(String error) {
    return 'Could not load reminders: $error';
  }

  @override
  String get dataAndBackup => 'Data and backup';

  @override
  String get exportBackup => 'Export a backup';

  @override
  String get exportBackupSubtitle => 'Write a versioned JSON file of all your data.';

  @override
  String get importBackup => 'Import a backup';

  @override
  String get importBackupSubtitle => 'Replace your data with a validated backup file.';

  @override
  String get importCalendar => 'Import a calendar';

  @override
  String get importCalendarSubtitle => 'Read a local .ics file. Imported events are read-only.';

  @override
  String get importCalendarSpace => 'Import into';

  @override
  String importCalendarDone(int imported, int skipped) {
    return 'Imported $imported events. Skipped $skipped duplicates or unsupported events.';
  }

  @override
  String get importCalendarEmpty => 'No events were found in this file.';

  @override
  String importCalendarFailed(String error) {
    return 'Calendar import failed: $error';
  }

  @override
  String backupExported(String path) {
    return 'Backup written to $path';
  }

  @override
  String get backupImported => 'Backup restored.';

  @override
  String backupFailed(String error) {
    return 'Backup failed: $error';
  }

  @override
  String get backupInvalid => 'This file is not a valid Mane backup.';

  @override
  String get backupFuture => 'This backup comes from a newer version of Mane.';

  @override
  String get importConfirmTitle => 'Replace your data?';

  @override
  String get importConfirmBody => 'The backup replaces every entry, shift, tag and setting on this device.';

  @override
  String get syncAndAgent => 'Sync and local agent';

  @override
  String get syncEnabled => 'LAN sync';

  @override
  String get syncOffInfo => 'Off by default. Automatic only between paired devices on the same network.';

  @override
  String get mcpEnabled => 'Local MCP endpoint';

  @override
  String get mcpOffInfo => 'Off by default. Lets a desktop agent read the plan over loopback.';

  @override
  String get aboutSubtitle => 'License, credits and version';

  @override
  String get appearanceSection => 'Appearance';

  @override
  String get plannerSection => 'Planner';

  @override
  String get librarySection => 'Library';

  @override
  String get privacySection => 'Privacy';

  @override
  String get notSet => 'None';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get syncNotActive =>
      'LAN sync is not active in this build. The switch is stored for the pairing update.';

  @override
  String get mcpNotActive =>
      'The local MCP endpoint is not active in this build. The switch is stored for the agent update.';

  @override
  String get basedOnGymMane => 'Based on GymMane by InlitX';

  @override
  String get basedOnStreak => 'Based on Streak by InlitX';

  @override
  String get basedOnMane => 'Based on Mane by the Mane contributors';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get license => 'License';

  @override
  String get licenseBody =>
      'Mane is free software under GPL-3.0-only. It comes with no warranty. See LICENSE and ADDITIONAL_TERMS.md in the repository.';

  @override
  String get credits => 'Credits';

  @override
  String get creditsBody =>
      'Built with reference to GymMane and Streak by InlitX. Based on Mane by the Mane contributors.';

  @override
  String get tagsManager => 'Tags';

  @override
  String get homeInventory => 'Home inventory';

  @override
  String get homeInventorySubtitle => 'Quantities, locations and reorder levels.';

  @override
  String get shoppingList => 'Shopping list';

  @override
  String get shoppingListSubtitle => 'Groceries and household items to buy.';

  @override
  String get addHomeItem => 'Add an item';

  @override
  String get editHomeItem => 'Edit item';

  @override
  String get itemName => 'Item';

  @override
  String get category => 'Category';

  @override
  String get location => 'Location';

  @override
  String get quantity => 'Quantity';

  @override
  String get unit => 'Unit';

  @override
  String get reorderLevel => 'Reorder at';

  @override
  String get lowStock => 'Low stock';

  @override
  String get inStock => 'In stock';

  @override
  String get addToShoppingList => 'Add to shopping list';

  @override
  String get addLowStockItems => 'Add low-stock items';

  @override
  String get noLowStock => 'Nothing is below its reorder level.';

  @override
  String get homeInventoryEmpty => 'No household items yet.';

  @override
  String get shoppingListEmpty => 'The shopping list is empty.';

  @override
  String get addShoppingItem => 'Add to the list';

  @override
  String get editShoppingItem => 'Edit list item';

  @override
  String get linkedItem => 'Linked inventory item';

  @override
  String get noLink => 'None';

  @override
  String get note => 'Note';

  @override
  String get archiveItemQuestion => 'Archive this item?';

  @override
  String get archiveItemBody => 'It disappears from the inventory but stays in backups.';

  @override
  String shoppingProgress(int done, int total) {
    return '$done of $total bought';
  }

  @override
  String get sleepWindow => 'Sleep window';

  @override
  String get sleepWindowSubtitle => 'A soft block from the last commitment today to the first tomorrow.';

  @override
  String get sleepBuffers => 'Sleep buffers';

  @override
  String sleepBuffersSummary(int commute, int windDown, int wake) {
    return '$commute commute · $windDown wind-down · $wake wake';
  }

  @override
  String get commute => 'Commute (minutes)';

  @override
  String get windDown => 'Wind-down (minutes)';

  @override
  String get wakeBuffer => 'Wake buffer (minutes)';

  @override
  String sleepBedtime(String time) {
    return 'Bedtime around $time';
  }

  @override
  String sleepWake(String time) {
    return 'Wake around $time';
  }

  @override
  String get sleepWarning => 'This plan leaves little room to sleep.';

  @override
  String get sleepNoEarlyStart => 'No early start tomorrow.';

  @override
  String minutesValue(int count) {
    return '$count min';
  }

  @override
  String get tagsManagerSubtitle => 'Separate jobs in Work and people or groups in Personal.';

  @override
  String get shiftPatterns => 'Shift patterns';

  @override
  String get shiftPatternsSubtitle => 'Cycles, per-day slots and date exceptions.';

  @override
  String get addTag => 'Add a tag';

  @override
  String get editTag => 'Edit tag';

  @override
  String get tagName => 'Name';

  @override
  String get tagColor => 'Color';

  @override
  String get tagSpace => 'Space';

  @override
  String get tagSpaceAny => 'Any space';

  @override
  String get noTags => 'No tags yet.';

  @override
  String get deleteTagQuestion => 'Delete this tag?';

  @override
  String get deleteTagBody => 'It will be removed from every entry that uses it.';

  @override
  String get tagNameRequired => 'Give the tag a name.';

  @override
  String get manageTags => 'Manage tags';

  @override
  String get filterByTag => 'Filter by tag';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get newShiftPattern => 'New shift pattern';

  @override
  String get editShiftPattern => 'Edit shift pattern';

  @override
  String get patternName => 'Pattern name';

  @override
  String get cycleLength => 'Cycle length';

  @override
  String cycleLengthValue(int count) {
    return '$count days';
  }

  @override
  String get anchorDate => 'Anchor date';

  @override
  String get timeZone => 'Time zone';

  @override
  String cycleDay(int index) {
    return 'Day $index';
  }

  @override
  String get addSlot => 'Add a slot';

  @override
  String get removeSlot => 'Remove slot';

  @override
  String get slotLabel => 'Label';

  @override
  String get startTime => 'Start';

  @override
  String get endTime => 'End';

  @override
  String get exceptions => 'Date exceptions';

  @override
  String get addException => 'Add exception';

  @override
  String get exceptionFree => 'Free day';

  @override
  String get exceptionOverride => 'Replace shifts';

  @override
  String get exceptionExtra => 'Extra shift';

  @override
  String get exceptionNote => 'Note';

  @override
  String get exceptionDate => 'Date';

  @override
  String get preview => 'Next 28 days';

  @override
  String get conflictsFound => 'Some shifts overlap. Fix them before saving.';

  @override
  String get noConflicts => 'No overlapping shifts.';

  @override
  String get savePattern => 'Save pattern';

  @override
  String get deletePatternQuestion => 'Delete this shift pattern?';

  @override
  String get deletePatternBody => 'Its shifts will disappear from the calendar.';

  @override
  String get invalidTimeZone => 'Use an IANA time zone such as Europe/Madrid.';

  @override
  String get patternNameRequired => 'Give the pattern a name.';

  @override
  String get noShiftPatterns => 'No shift patterns yet.';

  @override
  String get noSlots => 'No slots on this day.';

  @override
  String get noExceptions => 'No exceptions.';

  @override
  String get shiftChecklist => 'Shift checklist';

  @override
  String get shiftChecklistSubtitle => 'Items to tick off on each shift of this pattern.';

  @override
  String get addChecklistItem => 'Add item';

  @override
  String get checklistItemLabel => 'Checklist item';

  @override
  String get noChecklistItems => 'No checklist items yet.';

  @override
  String checklistDone(int done, int total) {
    return '$done of $total done';
  }

  @override
  String get backupRestoredReminders => 'Reminders have been rescheduled.';
}

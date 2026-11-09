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
  String importCalendarDone(int imported, int updated, int skipped) {
    return 'Imported $imported, updated $updated, skipped $skipped duplicates or unsupported events.';
  }

  @override
  String get importCalendarEmpty => 'No events were found in this file.';

  @override
  String importCalendarFailed(String error) {
    return 'Calendar import failed: $error';
  }

  @override
  String get importCompanion => 'Import a companion export';

  @override
  String get importCompanionSubtitle => 'Read a local JSON schedule exported by another app.';

  @override
  String importCompanionDone(int imported, int skipped) {
    return 'Imported $imported events. Skipped $skipped duplicates or invalid rows.';
  }

  @override
  String get importCompanionEmpty => 'No events were found in this file.';

  @override
  String importCompanionFailed(String error) {
    return 'Companion import failed: $error';
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
  String get on => 'On';

  @override
  String get off => 'Off';

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
  String get devices => 'Devices';

  @override
  String get devicesSubtitle => 'Pair your own devices over the local network.';

  @override
  String get thisDevice => 'This device';

  @override
  String get pairingIdentity => 'Pairing identity';

  @override
  String get pairingIdentitySubtitle => 'A local username and PIN. Never sent anywhere.';

  @override
  String get username => 'Username';

  @override
  String get deviceName => 'Device name';

  @override
  String get pin => 'PIN';

  @override
  String get pinHint => 'At least four digits.';

  @override
  String get createIdentity => 'Create identity';

  @override
  String get identityCreated => 'Pairing identity created.';

  @override
  String get editIdentity => 'Edit identity';

  @override
  String get changePin => 'Change PIN';

  @override
  String get currentPin => 'Current PIN';

  @override
  String get newPin => 'New PIN';

  @override
  String get identityRequired => 'Set a username and PIN before pairing.';

  @override
  String get pairDevice => 'Pair a device';

  @override
  String get showPairingCode => 'Show a code on this device';

  @override
  String get enterPairingCode => 'Enter a code from another device';

  @override
  String get pairingCode => 'Pairing code';

  @override
  String get pairingCodeHint => 'On the other device, choose “Enter a code” and type this code.';

  @override
  String get pairingExpires => 'Valid for five minutes.';

  @override
  String get newCode => 'New code';

  @override
  String pairingSucceeded(String name) {
    return 'Paired with $name.';
  }

  @override
  String pairingFailed(String error) {
    return 'Pairing failed: $error';
  }

  @override
  String get discoveredOnNetwork => 'Found on this network';

  @override
  String get noDiscoveredDevices => 'No other Mane devices found yet.';

  @override
  String get address => 'Address';

  @override
  String get port => 'Port';

  @override
  String get code => 'Code';

  @override
  String get pair => 'Pair';

  @override
  String get pairedDevices => 'Paired devices';

  @override
  String get noPairedDevices => 'No devices paired yet.';

  @override
  String get unpair => 'Unpair';

  @override
  String get unpairQuestion => 'Unpair this device?';

  @override
  String get unpairBody => 'It disappears from this device. The other device keeps its own copy.';

  @override
  String lastSeen(String time) {
    return 'Last seen $time';
  }

  @override
  String get neverReached => 'Not reached yet';

  @override
  String get refreshDevices => 'Refresh';

  @override
  String remoteToday(int entries, int shifts) {
    return '$entries entries, $shifts shifts today';
  }

  @override
  String remoteNextShift(String label) {
    return 'Next shift: $label';
  }

  @override
  String remoteShopping(int count) {
    return '$count shopping items open';
  }

  @override
  String serverOnPort(int port) {
    return 'Server on port $port';
  }

  @override
  String get serverOff => 'Server off';

  @override
  String get discoveryUnavailable => 'Network discovery is unavailable. Use the address manually.';

  @override
  String get identityFingerprint => 'Certificate fingerprint';

  @override
  String get manualAddress => 'Device address';

  @override
  String get hostHint => '192.168.1.20';

  @override
  String get mcpEndpoint => 'Local MCP endpoint';

  @override
  String get mcpEndpointSubtitle => 'Read-only by default, loopback only, off unless enabled.';

  @override
  String get mcpWriteTools => 'Allow write tools';

  @override
  String get mcpWriteToolsSubtitle => 'Lets the local agent create and complete entries.';

  @override
  String get mcpToken => 'Access token';

  @override
  String get mcpTokenHint => 'Use it as a Bearer token. Rotating it disconnects existing agents.';

  @override
  String get rotateToken => 'Rotate token';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied.';

  @override
  String get mcpLoopbackHint => 'Bound to 127.0.0.1 only. The agent must run on this machine.';

  @override
  String mcpRunning(int port) {
    return 'Listening on 127.0.0.1:$port';
  }

  @override
  String get mcpStopped => 'MCP endpoint is off.';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search entries, tags and home items';

  @override
  String get searchPrompt => 'Type a title, a note, a tag or a household item.';

  @override
  String searchNoResults(String query) {
    return 'Nothing matches “$query”.';
  }

  @override
  String get searchEntries => 'Entries';

  @override
  String get searchHomeItems => 'Home items';

  @override
  String get nextShiftPrefix => 'Next: ';

  @override
  String get backupRestoredReminders => 'Reminders have been rescheduled.';

  @override
  String get dayView => 'Day';

  @override
  String get shiftTags => 'Job tags';

  @override
  String get commuteOverride => 'Commute override';

  @override
  String get windDownOverride => 'Wind-down override';

  @override
  String get inheritSleepBuffers => 'Leave empty to use the sleep settings.';

  @override
  String get endDate => 'Ends on';

  @override
  String get multiDayHint => 'Leave the end date empty for a single day.';

  @override
  String get skipThisOccurrence => 'Skip this occurrence';

  @override
  String get skippedOccurrences => 'Skipped dates';

  @override
  String get recurrenceExceptions => 'Exceptions';

  @override
  String get exportCalendar => 'Export calendar (.ics)';

  @override
  String get exportCalendarSubtitle => 'Share a read-only calendar file. No account or network is used.';

  @override
  String calendarExported(String path) {
    return 'Calendar exported to $path';
  }

  @override
  String calendarExportFailed(String error) {
    return 'Could not export the calendar: $error';
  }

  @override
  String icsUpdated(int count) {
    return '$count updated';
  }

  @override
  String get onlyThisOccurrence => 'Only this occurrence';

  @override
  String get onlyThisOccurrenceSubtitle => 'Keep the series and change just this date.';

  @override
  String get singleDay => 'Single day';

  @override
  String get automaticBackups => 'Automatic local backups';

  @override
  String get automaticBackupsSubtitle => 'A daily JSON copy in the app folder. Older copies rotate out.';

  @override
  String get keepBackups => 'Copies to keep';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get exportCsvSubtitle => 'Entries, shopping or inventory.';

  @override
  String get importCsv => 'Import CSV';

  @override
  String get importCsvSubtitle => 'Entries, shopping or inventory.';

  @override
  String get csvEntries => 'Entries';

  @override
  String get csvShopping => 'Shopping';

  @override
  String get csvInventory => 'Inventory';

  @override
  String csvExported(String path) {
    return 'CSV exported to $path';
  }

  @override
  String csvExportFailed(String error) {
    return 'Could not export the CSV: $error';
  }

  @override
  String csvImportDone(int imported, int duplicates, int skipped) {
    return '$imported imported, $duplicates duplicates, $skipped skipped';
  }

  @override
  String get csvImportEmpty => 'No rows to import.';

  @override
  String get gymmaneImport => 'GymMane schedule';

  @override
  String get gymmaneImportSubtitle => 'Read-only weekly gym blocks from a GymMane JSON backup.';

  @override
  String gymmaneImportDone(int imported, int timed, int allDay, int skipped) {
    return '$imported blocks imported ($timed timed, $allDay all-day), $skipped skipped.';
  }

  @override
  String gymmaneImportFailed(String error) {
    return 'Could not import GymMane: $error';
  }

  @override
  String get gymmaneImportEmpty => 'The backup has no weekly plan.';

  @override
  String get appLock => 'App lock';

  @override
  String get appLockSubtitle => 'Ask for a PIN when the app opens.';

  @override
  String get appLockPinTitle => 'Choose a PIN';

  @override
  String get appLockPinRepeat => 'Repeat the PIN';

  @override
  String get appLockPinMismatch => 'The PINs do not match.';

  @override
  String get appLockUnlockTitle => 'Enter your PIN';

  @override
  String get appLockUnlockSubtitle => 'Unlock Mane';

  @override
  String get appLockWrong => 'Wrong PIN. Try again.';

  @override
  String appLockLockedOut(int seconds) {
    return 'Too many attempts. Wait ${seconds}s.';
  }

  @override
  String get appLockEnabled => 'App lock is on.';

  @override
  String get appLockDisabled => 'App lock is off.';

  @override
  String get appLockPinLength => 'Use four to eight digits.';

  @override
  String get purchaseHistory => 'Purchase history';

  @override
  String get purchaseHistoryEmpty => 'No purchases recorded yet.';

  @override
  String get increaseQuantity => 'Increase quantity';

  @override
  String get decreaseQuantity => 'Decrease quantity';

  @override
  String lowStockCount(int count) {
    return '$count items below their reorder level';
  }

  @override
  String get maintenance => 'Maintenance';

  @override
  String get maintenanceSubtitle => 'Tasks due after their last service.';

  @override
  String get maintenanceDue => 'Due now';

  @override
  String get maintenanceUpcoming => 'Upcoming';

  @override
  String get maintenanceNone => 'No maintenance tasks yet.';

  @override
  String maintenanceDone(String date) {
    return 'Done. Next due $date.';
  }

  @override
  String get clearChecked => 'Clear bought';

  @override
  String get clearCheckedBody => 'Remove every bought line? This cannot be undone.';

  @override
  String get shoppingToBuy => 'To buy';

  @override
  String get shoppingBought => 'Bought';

  @override
  String get shoppingOther => 'Other';

  @override
  String get moveUp => 'Move up';

  @override
  String get moveDown => 'Move down';

  @override
  String get complete => 'Complete';
}

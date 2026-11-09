import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('es')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Mane'**
  String get appName;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @shifts.
  ///
  /// In en, this message translates to:
  /// **'Shifts'**
  String get shifts;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @addEntry.
  ///
  /// In en, this message translates to:
  /// **'Add an entry'**
  String get addEntry;

  /// No description provided for @addSomething.
  ///
  /// In en, this message translates to:
  /// **'Add something'**
  String get addSomething;

  /// No description provided for @addOnThisDay.
  ///
  /// In en, this message translates to:
  /// **'Add on this day'**
  String get addOnThisDay;

  /// No description provided for @noPlanToday.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned for today.'**
  String get noPlanToday;

  /// No description provided for @noPlanTodayHint.
  ///
  /// In en, this message translates to:
  /// **'That is allowed. If something is missing, add it now.'**
  String get noPlanTodayHint;

  /// No description provided for @nothingPlanned.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned'**
  String get nothingPlanned;

  /// No description provided for @shiftsSection.
  ///
  /// In en, this message translates to:
  /// **'Shifts'**
  String get shiftsSection;

  /// No description provided for @couldNotLoadDay.
  ///
  /// In en, this message translates to:
  /// **'Could not load your day: {error}'**
  String couldNotLoadDay(String error);

  /// No description provided for @couldNotLoadShifts.
  ///
  /// In en, this message translates to:
  /// **'Could not load shifts: {error}'**
  String couldNotLoadShifts(String error);

  /// No description provided for @allDay.
  ///
  /// In en, this message translates to:
  /// **'All day'**
  String get allDay;

  /// No description provided for @overnightSuffix.
  ///
  /// In en, this message translates to:
  /// **'(+1 day)'**
  String get overnightSuffix;

  /// No description provided for @importedEvent.
  ///
  /// In en, this message translates to:
  /// **'Imported calendar event'**
  String get importedEvent;

  /// No description provided for @readOnlyNotice.
  ///
  /// In en, this message translates to:
  /// **'This event comes from an imported calendar and is read-only.'**
  String get readOnlyNotice;

  /// No description provided for @newEntry.
  ///
  /// In en, this message translates to:
  /// **'New entry'**
  String get newEntry;

  /// No description provided for @editEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get editEntry;

  /// No description provided for @titleQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is it?'**
  String get titleQuestion;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Give it a name'**
  String get titleRequired;

  /// No description provided for @space.
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get space;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @starts.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get starts;

  /// No description provided for @ends.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get ends;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @repeatNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get repeatNever;

  /// No description provided for @repeatDaily.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get repeatDaily;

  /// No description provided for @repeatWeekly.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get repeatWeekly;

  /// No description provided for @repeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get repeatMonthly;

  /// No description provided for @repeatYearly.
  ///
  /// In en, this message translates to:
  /// **'Every year'**
  String get repeatYearly;

  /// No description provided for @repeatAfterCompletion.
  ///
  /// In en, this message translates to:
  /// **'Repeat after completion'**
  String get repeatAfterCompletion;

  /// No description provided for @repeatAfterCompletionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule the next one from the day you finish.'**
  String get repeatAfterCompletionSubtitle;

  /// No description provided for @daysRequired.
  ///
  /// In en, this message translates to:
  /// **'Use a number of days greater than zero.'**
  String get daysRequired;

  /// No description provided for @daysValue.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysValue(int count);

  /// No description provided for @repeatAfterDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Days between completions'**
  String get repeatAfterDaysLabel;

  /// No description provided for @couldNotComplete.
  ///
  /// In en, this message translates to:
  /// **'Could not complete: {error}'**
  String couldNotComplete(String error);

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @deleteEntryQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this entry?'**
  String get deleteEntryQuestion;

  /// No description provided for @deleteEntryBody.
  ///
  /// In en, this message translates to:
  /// **'It will disappear from your plan.'**
  String get deleteEntryBody;

  /// No description provided for @endAfterStartError.
  ///
  /// In en, this message translates to:
  /// **'The end time has to be after the start.'**
  String get endAfterStartError;

  /// No description provided for @couldNotSave.
  ///
  /// In en, this message translates to:
  /// **'Could not save: {error}'**
  String couldNotSave(String error);

  /// No description provided for @couldNotDelete.
  ///
  /// In en, this message translates to:
  /// **'Could not delete: {error}'**
  String couldNotDelete(String error);

  /// No description provided for @timesDefinedIn.
  ///
  /// In en, this message translates to:
  /// **'Times are defined in {timeZone}'**
  String timesDefinedIn(String timeZone);

  /// No description provided for @markAsDone.
  ///
  /// In en, this message translates to:
  /// **'Mark {title} as done'**
  String markAsDone(String title);

  /// No description provided for @entryKindTask.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get entryKindTask;

  /// No description provided for @entryKindEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get entryKindEvent;

  /// No description provided for @entryKindObligation.
  ///
  /// In en, this message translates to:
  /// **'Obligation'**
  String get entryKindObligation;

  /// No description provided for @entryKindDeadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get entryKindDeadline;

  /// No description provided for @recurrenceEveryDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get recurrenceEveryDay;

  /// No description provided for @recurrenceEveryNDays.
  ///
  /// In en, this message translates to:
  /// **'Every {count} days'**
  String recurrenceEveryNDays(int count);

  /// No description provided for @recurrenceEveryWeek.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get recurrenceEveryWeek;

  /// No description provided for @recurrenceEveryNWeeks.
  ///
  /// In en, this message translates to:
  /// **'Every {count} weeks'**
  String recurrenceEveryNWeeks(int count);

  /// No description provided for @recurrenceOnDays.
  ///
  /// In en, this message translates to:
  /// **'Every week on {days}'**
  String recurrenceOnDays(String days);

  /// No description provided for @recurrenceEveryNWeeksOnDays.
  ///
  /// In en, this message translates to:
  /// **'Every {count} weeks on {days}'**
  String recurrenceEveryNWeeksOnDays(int count, String days);

  /// No description provided for @recurrenceEveryMonth.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get recurrenceEveryMonth;

  /// No description provided for @recurrenceEveryNMonths.
  ///
  /// In en, this message translates to:
  /// **'Every {count} months'**
  String recurrenceEveryNMonths(int count);

  /// No description provided for @recurrenceEveryNMonthsOnDay.
  ///
  /// In en, this message translates to:
  /// **'Every {count} months on day {day}'**
  String recurrenceEveryNMonthsOnDay(int count, int day);

  /// No description provided for @recurrenceOnDayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Every month on day {day}'**
  String recurrenceOnDayOfMonth(int day);

  /// No description provided for @recurrenceEveryYear.
  ///
  /// In en, this message translates to:
  /// **'Every year'**
  String get recurrenceEveryYear;

  /// No description provided for @recurrenceEveryNYears.
  ///
  /// In en, this message translates to:
  /// **'Every {count} years'**
  String recurrenceEveryNYears(int count);

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @previousWeek.
  ///
  /// In en, this message translates to:
  /// **'Previous week'**
  String get previousWeek;

  /// No description provided for @nextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get nextWeek;

  /// No description provided for @jumpToToday.
  ///
  /// In en, this message translates to:
  /// **'Jump to today'**
  String get jumpToToday;

  /// No description provided for @monthView.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthView;

  /// No description provided for @weekView.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get weekView;

  /// No description provided for @selectedDay.
  ///
  /// In en, this message translates to:
  /// **'Selected day'**
  String get selectedDay;

  /// No description provided for @noEntriesOnDay.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned on this day.'**
  String get noEntriesOnDay;

  /// No description provided for @calendarDaySemantics.
  ///
  /// In en, this message translates to:
  /// **'{date}, {count} items'**
  String calendarDaySemantics(String date, int count);

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @weekStartsOn.
  ///
  /// In en, this message translates to:
  /// **'Week starts on'**
  String get weekStartsOn;

  /// No description provided for @weekStartMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekStartMonday;

  /// No description provided for @weekStartSaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekStartSaturday;

  /// No description provided for @weekStartSunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekStartSunday;

  /// No description provided for @hideWorkSpace.
  ///
  /// In en, this message translates to:
  /// **'Hide the Work space'**
  String get hideWorkSpace;

  /// No description provided for @hideWorkSpaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep work commitments out of Today, Week and Calendar.'**
  String get hideWorkSpaceSubtitle;

  /// No description provided for @defaultReminders.
  ///
  /// In en, this message translates to:
  /// **'Default reminders'**
  String get defaultReminders;

  /// No description provided for @defaultRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-selected when you add an entry.'**
  String get defaultRemindersSubtitle;

  /// No description provided for @reminderAtTime.
  ///
  /// In en, this message translates to:
  /// **'At the start time'**
  String get reminderAtTime;

  /// No description provided for @reminderMinutesBefore.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes before'**
  String reminderMinutesBefore(int count);

  /// No description provided for @reminderHoursBefore.
  ///
  /// In en, this message translates to:
  /// **'{count} hours before'**
  String reminderHoursBefore(int count);

  /// No description provided for @reminderDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'{count} days before'**
  String reminderDaysBefore(int count);

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @addReminder.
  ///
  /// In en, this message translates to:
  /// **'Add a reminder'**
  String get addReminder;

  /// No description provided for @removeReminder.
  ///
  /// In en, this message translates to:
  /// **'Remove reminder'**
  String get removeReminder;

  /// No description provided for @remindersOff.
  ///
  /// In en, this message translates to:
  /// **'No reminders'**
  String get remindersOff;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off. Enable them in system settings so reminders can reach you.'**
  String get notificationPermissionDenied;

  /// No description provided for @couldNotLoadReminders.
  ///
  /// In en, this message translates to:
  /// **'Could not load reminders: {error}'**
  String couldNotLoadReminders(String error);

  /// No description provided for @dataAndBackup.
  ///
  /// In en, this message translates to:
  /// **'Data and backup'**
  String get dataAndBackup;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export a backup'**
  String get exportBackup;

  /// No description provided for @exportBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write a versioned JSON file of all your data.'**
  String get exportBackupSubtitle;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Import a backup'**
  String get importBackup;

  /// No description provided for @importBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Replace your data with a validated backup file.'**
  String get importBackupSubtitle;

  /// No description provided for @importCalendar.
  ///
  /// In en, this message translates to:
  /// **'Import a calendar'**
  String get importCalendar;

  /// No description provided for @importCalendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read a local .ics file. Imported events are read-only.'**
  String get importCalendarSubtitle;

  /// No description provided for @importCalendarSpace.
  ///
  /// In en, this message translates to:
  /// **'Import into'**
  String get importCalendarSpace;

  /// No description provided for @importCalendarDone.
  ///
  /// In en, this message translates to:
  /// **'Imported {imported}, updated {updated}, skipped {skipped} duplicates or unsupported events.'**
  String importCalendarDone(int imported, int updated, int skipped);

  /// No description provided for @importCalendarEmpty.
  ///
  /// In en, this message translates to:
  /// **'No events were found in this file.'**
  String get importCalendarEmpty;

  /// No description provided for @importCalendarFailed.
  ///
  /// In en, this message translates to:
  /// **'Calendar import failed: {error}'**
  String importCalendarFailed(String error);

  /// No description provided for @importCompanion.
  ///
  /// In en, this message translates to:
  /// **'Import a companion export'**
  String get importCompanion;

  /// No description provided for @importCompanionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read a local JSON schedule exported by another app.'**
  String get importCompanionSubtitle;

  /// No description provided for @importCompanionDone.
  ///
  /// In en, this message translates to:
  /// **'Imported {imported} events. Skipped {skipped} duplicates or invalid rows.'**
  String importCompanionDone(int imported, int skipped);

  /// No description provided for @importCompanionEmpty.
  ///
  /// In en, this message translates to:
  /// **'No events were found in this file.'**
  String get importCompanionEmpty;

  /// No description provided for @importCompanionFailed.
  ///
  /// In en, this message translates to:
  /// **'Companion import failed: {error}'**
  String importCompanionFailed(String error);

  /// No description provided for @backupExported.
  ///
  /// In en, this message translates to:
  /// **'Backup written to {path}'**
  String backupExported(String path);

  /// No description provided for @backupImported.
  ///
  /// In en, this message translates to:
  /// **'Backup restored.'**
  String get backupImported;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: {error}'**
  String backupFailed(String error);

  /// No description provided for @backupInvalid.
  ///
  /// In en, this message translates to:
  /// **'This file is not a valid Mane backup.'**
  String get backupInvalid;

  /// No description provided for @backupFuture.
  ///
  /// In en, this message translates to:
  /// **'This backup comes from a newer version of Mane.'**
  String get backupFuture;

  /// No description provided for @importConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace your data?'**
  String get importConfirmTitle;

  /// No description provided for @importConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The backup replaces every entry, shift, tag and setting on this device.'**
  String get importConfirmBody;

  /// No description provided for @syncAndAgent.
  ///
  /// In en, this message translates to:
  /// **'Sync and local agent'**
  String get syncAndAgent;

  /// No description provided for @syncEnabled.
  ///
  /// In en, this message translates to:
  /// **'LAN sync'**
  String get syncEnabled;

  /// No description provided for @syncOffInfo.
  ///
  /// In en, this message translates to:
  /// **'Off by default. Automatic only between paired devices on the same network.'**
  String get syncOffInfo;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @mcpEnabled.
  ///
  /// In en, this message translates to:
  /// **'Local MCP endpoint'**
  String get mcpEnabled;

  /// No description provided for @mcpOffInfo.
  ///
  /// In en, this message translates to:
  /// **'Off by default. Lets a desktop agent read the plan over loopback.'**
  String get mcpOffInfo;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'License, credits and version'**
  String get aboutSubtitle;

  /// No description provided for @appearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSection;

  /// No description provided for @plannerSection.
  ///
  /// In en, this message translates to:
  /// **'Planner'**
  String get plannerSection;

  /// No description provided for @librarySection.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get librarySection;

  /// No description provided for @privacySection.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacySection;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get notSet;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @basedOnGymMane.
  ///
  /// In en, this message translates to:
  /// **'Based on GymMane by InlitX'**
  String get basedOnGymMane;

  /// No description provided for @basedOnStreak.
  ///
  /// In en, this message translates to:
  /// **'Based on Streak by InlitX'**
  String get basedOnStreak;

  /// No description provided for @basedOnMane.
  ///
  /// In en, this message translates to:
  /// **'Based on Mane by the Mane contributors'**
  String get basedOnMane;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @licenseBody.
  ///
  /// In en, this message translates to:
  /// **'Mane is free software under GPL-3.0-only. It comes with no warranty. See LICENSE and ADDITIONAL_TERMS.md in the repository.'**
  String get licenseBody;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get credits;

  /// No description provided for @creditsBody.
  ///
  /// In en, this message translates to:
  /// **'Built with reference to GymMane and Streak by InlitX. Based on Mane by the Mane contributors.'**
  String get creditsBody;

  /// No description provided for @tagsManager.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagsManager;

  /// No description provided for @homeInventory.
  ///
  /// In en, this message translates to:
  /// **'Home inventory'**
  String get homeInventory;

  /// No description provided for @homeInventorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quantities, locations and reorder levels.'**
  String get homeInventorySubtitle;

  /// No description provided for @shoppingList.
  ///
  /// In en, this message translates to:
  /// **'Shopping list'**
  String get shoppingList;

  /// No description provided for @shoppingListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Groceries and household items to buy.'**
  String get shoppingListSubtitle;

  /// No description provided for @addHomeItem.
  ///
  /// In en, this message translates to:
  /// **'Add an item'**
  String get addHomeItem;

  /// No description provided for @editHomeItem.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get editHomeItem;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get itemName;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @reorderLevel.
  ///
  /// In en, this message translates to:
  /// **'Reorder at'**
  String get reorderLevel;

  /// No description provided for @lowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get lowStock;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get inStock;

  /// No description provided for @addToShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Add to shopping list'**
  String get addToShoppingList;

  /// No description provided for @addLowStockItems.
  ///
  /// In en, this message translates to:
  /// **'Add low-stock items'**
  String get addLowStockItems;

  /// No description provided for @noLowStock.
  ///
  /// In en, this message translates to:
  /// **'Nothing is below its reorder level.'**
  String get noLowStock;

  /// No description provided for @homeInventoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No household items yet.'**
  String get homeInventoryEmpty;

  /// No description provided for @shoppingListEmpty.
  ///
  /// In en, this message translates to:
  /// **'The shopping list is empty.'**
  String get shoppingListEmpty;

  /// No description provided for @addShoppingItem.
  ///
  /// In en, this message translates to:
  /// **'Add to the list'**
  String get addShoppingItem;

  /// No description provided for @editShoppingItem.
  ///
  /// In en, this message translates to:
  /// **'Edit list item'**
  String get editShoppingItem;

  /// No description provided for @linkedItem.
  ///
  /// In en, this message translates to:
  /// **'Linked inventory item'**
  String get linkedItem;

  /// No description provided for @noLink.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noLink;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @archiveItemQuestion.
  ///
  /// In en, this message translates to:
  /// **'Archive this item?'**
  String get archiveItemQuestion;

  /// No description provided for @archiveItemBody.
  ///
  /// In en, this message translates to:
  /// **'It disappears from the inventory but stays in backups.'**
  String get archiveItemBody;

  /// No description provided for @shoppingProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} bought'**
  String shoppingProgress(int done, int total);

  /// No description provided for @sleepWindow.
  ///
  /// In en, this message translates to:
  /// **'Sleep window'**
  String get sleepWindow;

  /// No description provided for @sleepWindowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A soft block from the last commitment today to the first tomorrow.'**
  String get sleepWindowSubtitle;

  /// No description provided for @sleepBuffers.
  ///
  /// In en, this message translates to:
  /// **'Sleep buffers'**
  String get sleepBuffers;

  /// No description provided for @sleepBuffersSummary.
  ///
  /// In en, this message translates to:
  /// **'{commute} commute · {windDown} wind-down · {wake} wake'**
  String sleepBuffersSummary(int commute, int windDown, int wake);

  /// No description provided for @commute.
  ///
  /// In en, this message translates to:
  /// **'Commute (minutes)'**
  String get commute;

  /// No description provided for @windDown.
  ///
  /// In en, this message translates to:
  /// **'Wind-down (minutes)'**
  String get windDown;

  /// No description provided for @wakeBuffer.
  ///
  /// In en, this message translates to:
  /// **'Wake buffer (minutes)'**
  String get wakeBuffer;

  /// No description provided for @sleepBedtime.
  ///
  /// In en, this message translates to:
  /// **'Bedtime around {time}'**
  String sleepBedtime(String time);

  /// No description provided for @sleepWake.
  ///
  /// In en, this message translates to:
  /// **'Wake around {time}'**
  String sleepWake(String time);

  /// No description provided for @sleepWarning.
  ///
  /// In en, this message translates to:
  /// **'This plan leaves little room to sleep.'**
  String get sleepWarning;

  /// No description provided for @sleepNoEarlyStart.
  ///
  /// In en, this message translates to:
  /// **'No early start tomorrow.'**
  String get sleepNoEarlyStart;

  /// No description provided for @minutesValue.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutesValue(int count);

  /// No description provided for @tagsManagerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Separate jobs in Work and people or groups in Personal.'**
  String get tagsManagerSubtitle;

  /// No description provided for @shiftPatterns.
  ///
  /// In en, this message translates to:
  /// **'Shift patterns'**
  String get shiftPatterns;

  /// No description provided for @shiftPatternsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cycles, per-day slots and date exceptions.'**
  String get shiftPatternsSubtitle;

  /// No description provided for @addTag.
  ///
  /// In en, this message translates to:
  /// **'Add a tag'**
  String get addTag;

  /// No description provided for @editTag.
  ///
  /// In en, this message translates to:
  /// **'Edit tag'**
  String get editTag;

  /// No description provided for @tagName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get tagName;

  /// No description provided for @tagColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get tagColor;

  /// No description provided for @tagSpace.
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get tagSpace;

  /// No description provided for @tagSpaceAny.
  ///
  /// In en, this message translates to:
  /// **'Any space'**
  String get tagSpaceAny;

  /// No description provided for @noTags.
  ///
  /// In en, this message translates to:
  /// **'No tags yet.'**
  String get noTags;

  /// No description provided for @deleteTagQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this tag?'**
  String get deleteTagQuestion;

  /// No description provided for @deleteTagBody.
  ///
  /// In en, this message translates to:
  /// **'It will be removed from every entry that uses it.'**
  String get deleteTagBody;

  /// No description provided for @tagNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Give the tag a name.'**
  String get tagNameRequired;

  /// No description provided for @manageTags.
  ///
  /// In en, this message translates to:
  /// **'Manage tags'**
  String get manageTags;

  /// No description provided for @filterByTag.
  ///
  /// In en, this message translates to:
  /// **'Filter by tag'**
  String get filterByTag;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @newShiftPattern.
  ///
  /// In en, this message translates to:
  /// **'New shift pattern'**
  String get newShiftPattern;

  /// No description provided for @editShiftPattern.
  ///
  /// In en, this message translates to:
  /// **'Edit shift pattern'**
  String get editShiftPattern;

  /// No description provided for @patternName.
  ///
  /// In en, this message translates to:
  /// **'Pattern name'**
  String get patternName;

  /// No description provided for @cycleLength.
  ///
  /// In en, this message translates to:
  /// **'Cycle length'**
  String get cycleLength;

  /// No description provided for @cycleLengthValue.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String cycleLengthValue(int count);

  /// No description provided for @anchorDate.
  ///
  /// In en, this message translates to:
  /// **'Anchor date'**
  String get anchorDate;

  /// No description provided for @timeZone.
  ///
  /// In en, this message translates to:
  /// **'Time zone'**
  String get timeZone;

  /// No description provided for @cycleDay.
  ///
  /// In en, this message translates to:
  /// **'Day {index}'**
  String cycleDay(int index);

  /// No description provided for @addSlot.
  ///
  /// In en, this message translates to:
  /// **'Add a slot'**
  String get addSlot;

  /// No description provided for @removeSlot.
  ///
  /// In en, this message translates to:
  /// **'Remove slot'**
  String get removeSlot;

  /// No description provided for @slotLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get slotLabel;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endTime;

  /// No description provided for @exceptions.
  ///
  /// In en, this message translates to:
  /// **'Date exceptions'**
  String get exceptions;

  /// No description provided for @addException.
  ///
  /// In en, this message translates to:
  /// **'Add exception'**
  String get addException;

  /// No description provided for @exceptionFree.
  ///
  /// In en, this message translates to:
  /// **'Free day'**
  String get exceptionFree;

  /// No description provided for @exceptionOverride.
  ///
  /// In en, this message translates to:
  /// **'Replace shifts'**
  String get exceptionOverride;

  /// No description provided for @exceptionExtra.
  ///
  /// In en, this message translates to:
  /// **'Extra shift'**
  String get exceptionExtra;

  /// No description provided for @exceptionNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get exceptionNote;

  /// No description provided for @exceptionDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get exceptionDate;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Next 28 days'**
  String get preview;

  /// No description provided for @conflictsFound.
  ///
  /// In en, this message translates to:
  /// **'Some shifts overlap. Fix them before saving.'**
  String get conflictsFound;

  /// No description provided for @noConflicts.
  ///
  /// In en, this message translates to:
  /// **'No overlapping shifts.'**
  String get noConflicts;

  /// No description provided for @savePattern.
  ///
  /// In en, this message translates to:
  /// **'Save pattern'**
  String get savePattern;

  /// No description provided for @deletePatternQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this shift pattern?'**
  String get deletePatternQuestion;

  /// No description provided for @deletePatternBody.
  ///
  /// In en, this message translates to:
  /// **'Its shifts will disappear from the calendar.'**
  String get deletePatternBody;

  /// No description provided for @invalidTimeZone.
  ///
  /// In en, this message translates to:
  /// **'Use an IANA time zone such as Europe/Madrid.'**
  String get invalidTimeZone;

  /// No description provided for @patternNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Give the pattern a name.'**
  String get patternNameRequired;

  /// No description provided for @noShiftPatterns.
  ///
  /// In en, this message translates to:
  /// **'No shift patterns yet.'**
  String get noShiftPatterns;

  /// No description provided for @noSlots.
  ///
  /// In en, this message translates to:
  /// **'No slots on this day.'**
  String get noSlots;

  /// No description provided for @noExceptions.
  ///
  /// In en, this message translates to:
  /// **'No exceptions.'**
  String get noExceptions;

  /// No description provided for @shiftChecklist.
  ///
  /// In en, this message translates to:
  /// **'Shift checklist'**
  String get shiftChecklist;

  /// No description provided for @shiftChecklistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Items to tick off on each shift of this pattern.'**
  String get shiftChecklistSubtitle;

  /// No description provided for @addChecklistItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addChecklistItem;

  /// No description provided for @checklistItemLabel.
  ///
  /// In en, this message translates to:
  /// **'Checklist item'**
  String get checklistItemLabel;

  /// No description provided for @noChecklistItems.
  ///
  /// In en, this message translates to:
  /// **'No checklist items yet.'**
  String get noChecklistItems;

  /// No description provided for @checklistDone.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} done'**
  String checklistDone(int done, int total);

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// No description provided for @devicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pair your own devices over the local network.'**
  String get devicesSubtitle;

  /// No description provided for @thisDevice.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get thisDevice;

  /// No description provided for @pairingIdentity.
  ///
  /// In en, this message translates to:
  /// **'Pairing identity'**
  String get pairingIdentity;

  /// No description provided for @pairingIdentitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'A local username and PIN. Never sent anywhere.'**
  String get pairingIdentitySubtitle;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @deviceName.
  ///
  /// In en, this message translates to:
  /// **'Device name'**
  String get deviceName;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @pinHint.
  ///
  /// In en, this message translates to:
  /// **'At least four digits.'**
  String get pinHint;

  /// No description provided for @createIdentity.
  ///
  /// In en, this message translates to:
  /// **'Create identity'**
  String get createIdentity;

  /// No description provided for @identityCreated.
  ///
  /// In en, this message translates to:
  /// **'Pairing identity created.'**
  String get identityCreated;

  /// No description provided for @editIdentity.
  ///
  /// In en, this message translates to:
  /// **'Edit identity'**
  String get editIdentity;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @currentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPin;

  /// No description provided for @newPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get newPin;

  /// No description provided for @identityRequired.
  ///
  /// In en, this message translates to:
  /// **'Set a username and PIN before pairing.'**
  String get identityRequired;

  /// No description provided for @pairDevice.
  ///
  /// In en, this message translates to:
  /// **'Pair a device'**
  String get pairDevice;

  /// No description provided for @showPairingCode.
  ///
  /// In en, this message translates to:
  /// **'Show a code on this device'**
  String get showPairingCode;

  /// No description provided for @enterPairingCode.
  ///
  /// In en, this message translates to:
  /// **'Enter a code from another device'**
  String get enterPairingCode;

  /// No description provided for @pairingCode.
  ///
  /// In en, this message translates to:
  /// **'Pairing code'**
  String get pairingCode;

  /// No description provided for @pairingCodeHint.
  ///
  /// In en, this message translates to:
  /// **'On the other device, choose “Enter a code” and type this code.'**
  String get pairingCodeHint;

  /// No description provided for @pairingExpires.
  ///
  /// In en, this message translates to:
  /// **'Valid for five minutes.'**
  String get pairingExpires;

  /// No description provided for @newCode.
  ///
  /// In en, this message translates to:
  /// **'New code'**
  String get newCode;

  /// No description provided for @pairingSucceeded.
  ///
  /// In en, this message translates to:
  /// **'Paired with {name}.'**
  String pairingSucceeded(String name);

  /// No description provided for @pairingFailed.
  ///
  /// In en, this message translates to:
  /// **'Pairing failed: {error}'**
  String pairingFailed(String error);

  /// No description provided for @discoveredOnNetwork.
  ///
  /// In en, this message translates to:
  /// **'Found on this network'**
  String get discoveredOnNetwork;

  /// No description provided for @noDiscoveredDevices.
  ///
  /// In en, this message translates to:
  /// **'No other Mane devices found yet.'**
  String get noDiscoveredDevices;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @pair.
  ///
  /// In en, this message translates to:
  /// **'Pair'**
  String get pair;

  /// No description provided for @pairedDevices.
  ///
  /// In en, this message translates to:
  /// **'Paired devices'**
  String get pairedDevices;

  /// No description provided for @noPairedDevices.
  ///
  /// In en, this message translates to:
  /// **'No devices paired yet.'**
  String get noPairedDevices;

  /// No description provided for @unpair.
  ///
  /// In en, this message translates to:
  /// **'Unpair'**
  String get unpair;

  /// No description provided for @unpairQuestion.
  ///
  /// In en, this message translates to:
  /// **'Unpair this device?'**
  String get unpairQuestion;

  /// No description provided for @unpairBody.
  ///
  /// In en, this message translates to:
  /// **'It disappears from this device. The other device keeps its own copy.'**
  String get unpairBody;

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen {time}'**
  String lastSeen(String time);

  /// No description provided for @neverReached.
  ///
  /// In en, this message translates to:
  /// **'Not reached yet'**
  String get neverReached;

  /// No description provided for @refreshDevices.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshDevices;

  /// No description provided for @remoteToday.
  ///
  /// In en, this message translates to:
  /// **'{entries} entries, {shifts} shifts today'**
  String remoteToday(int entries, int shifts);

  /// No description provided for @remoteNextShift.
  ///
  /// In en, this message translates to:
  /// **'Next shift: {label}'**
  String remoteNextShift(String label);

  /// No description provided for @remoteShopping.
  ///
  /// In en, this message translates to:
  /// **'{count} shopping items open'**
  String remoteShopping(int count);

  /// No description provided for @serverOnPort.
  ///
  /// In en, this message translates to:
  /// **'Server on port {port}'**
  String serverOnPort(int port);

  /// No description provided for @serverOff.
  ///
  /// In en, this message translates to:
  /// **'Server off'**
  String get serverOff;

  /// No description provided for @discoveryUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Network discovery is unavailable. Use the address manually.'**
  String get discoveryUnavailable;

  /// No description provided for @identityFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Certificate fingerprint'**
  String get identityFingerprint;

  /// No description provided for @manualAddress.
  ///
  /// In en, this message translates to:
  /// **'Device address'**
  String get manualAddress;

  /// No description provided for @hostHint.
  ///
  /// In en, this message translates to:
  /// **'192.168.1.20'**
  String get hostHint;

  /// No description provided for @mcpEndpoint.
  ///
  /// In en, this message translates to:
  /// **'Local MCP endpoint'**
  String get mcpEndpoint;

  /// No description provided for @mcpEndpointSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read-only by default, loopback only, off unless enabled.'**
  String get mcpEndpointSubtitle;

  /// No description provided for @mcpWriteTools.
  ///
  /// In en, this message translates to:
  /// **'Allow write tools'**
  String get mcpWriteTools;

  /// No description provided for @mcpWriteToolsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Lets the local agent create and complete entries.'**
  String get mcpWriteToolsSubtitle;

  /// No description provided for @mcpToken.
  ///
  /// In en, this message translates to:
  /// **'Access token'**
  String get mcpToken;

  /// No description provided for @mcpTokenHint.
  ///
  /// In en, this message translates to:
  /// **'Use it as a Bearer token. Rotating it disconnects existing agents.'**
  String get mcpTokenHint;

  /// No description provided for @rotateToken.
  ///
  /// In en, this message translates to:
  /// **'Rotate token'**
  String get rotateToken;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied.'**
  String get copied;

  /// No description provided for @mcpLoopbackHint.
  ///
  /// In en, this message translates to:
  /// **'Bound to 127.0.0.1 only. The agent must run on this machine.'**
  String get mcpLoopbackHint;

  /// No description provided for @mcpRunning.
  ///
  /// In en, this message translates to:
  /// **'Listening on 127.0.0.1:{port}'**
  String mcpRunning(int port);

  /// No description provided for @mcpStopped.
  ///
  /// In en, this message translates to:
  /// **'MCP endpoint is off.'**
  String get mcpStopped;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search entries, tags and home items'**
  String get searchHint;

  /// No description provided for @searchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Type a title, a note, a tag or a household item.'**
  String get searchPrompt;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches “{query}”.'**
  String searchNoResults(String query);

  /// No description provided for @searchEntries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get searchEntries;

  /// No description provided for @searchHomeItems.
  ///
  /// In en, this message translates to:
  /// **'Home items'**
  String get searchHomeItems;

  /// No description provided for @nextShiftPrefix.
  ///
  /// In en, this message translates to:
  /// **'Next: '**
  String get nextShiftPrefix;

  /// No description provided for @backupRestoredReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders have been rescheduled.'**
  String get backupRestoredReminders;

  /// No description provided for @dayView.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayView;

  /// No description provided for @shiftTags.
  ///
  /// In en, this message translates to:
  /// **'Job tags'**
  String get shiftTags;

  /// No description provided for @commuteOverride.
  ///
  /// In en, this message translates to:
  /// **'Commute override'**
  String get commuteOverride;

  /// No description provided for @windDownOverride.
  ///
  /// In en, this message translates to:
  /// **'Wind-down override'**
  String get windDownOverride;

  /// No description provided for @inheritSleepBuffers.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to use the sleep settings.'**
  String get inheritSleepBuffers;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'Ends on'**
  String get endDate;

  /// No description provided for @multiDayHint.
  ///
  /// In en, this message translates to:
  /// **'Leave the end date empty for a single day.'**
  String get multiDayHint;

  /// No description provided for @skipThisOccurrence.
  ///
  /// In en, this message translates to:
  /// **'Skip this occurrence'**
  String get skipThisOccurrence;

  /// No description provided for @skippedOccurrences.
  ///
  /// In en, this message translates to:
  /// **'Skipped dates'**
  String get skippedOccurrences;

  /// No description provided for @recurrenceExceptions.
  ///
  /// In en, this message translates to:
  /// **'Exceptions'**
  String get recurrenceExceptions;

  /// No description provided for @exportCalendar.
  ///
  /// In en, this message translates to:
  /// **'Export calendar (.ics)'**
  String get exportCalendar;

  /// No description provided for @exportCalendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share a read-only calendar file. No account or network is used.'**
  String get exportCalendarSubtitle;

  /// No description provided for @calendarExported.
  ///
  /// In en, this message translates to:
  /// **'Calendar exported to {path}'**
  String calendarExported(String path);

  /// No description provided for @calendarExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not export the calendar: {error}'**
  String calendarExportFailed(String error);

  /// No description provided for @icsUpdated.
  ///
  /// In en, this message translates to:
  /// **'{count} updated'**
  String icsUpdated(int count);

  /// No description provided for @onlyThisOccurrence.
  ///
  /// In en, this message translates to:
  /// **'Only this occurrence'**
  String get onlyThisOccurrence;

  /// No description provided for @onlyThisOccurrenceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the series and change just this date.'**
  String get onlyThisOccurrenceSubtitle;

  /// No description provided for @singleDay.
  ///
  /// In en, this message translates to:
  /// **'Single day'**
  String get singleDay;

  /// No description provided for @automaticBackups.
  ///
  /// In en, this message translates to:
  /// **'Automatic local backups'**
  String get automaticBackups;

  /// No description provided for @automaticBackupsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A daily JSON copy in the app folder. Older copies rotate out.'**
  String get automaticBackupsSubtitle;

  /// No description provided for @keepBackups.
  ///
  /// In en, this message translates to:
  /// **'Copies to keep'**
  String get keepBackups;

  /// No description provided for @exportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCsv;

  /// No description provided for @exportCsvSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Entries, shopping or inventory.'**
  String get exportCsvSubtitle;

  /// No description provided for @importCsv.
  ///
  /// In en, this message translates to:
  /// **'Import CSV'**
  String get importCsv;

  /// No description provided for @importCsvSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Entries, shopping or inventory.'**
  String get importCsvSubtitle;

  /// No description provided for @csvEntries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get csvEntries;

  /// No description provided for @csvShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get csvShopping;

  /// No description provided for @csvInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get csvInventory;

  /// No description provided for @csvExported.
  ///
  /// In en, this message translates to:
  /// **'CSV exported to {path}'**
  String csvExported(String path);

  /// No description provided for @csvExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not export the CSV: {error}'**
  String csvExportFailed(String error);

  /// No description provided for @csvImportDone.
  ///
  /// In en, this message translates to:
  /// **'{imported} imported, {duplicates} duplicates, {skipped} skipped'**
  String csvImportDone(int imported, int duplicates, int skipped);

  /// No description provided for @csvImportEmpty.
  ///
  /// In en, this message translates to:
  /// **'No rows to import.'**
  String get csvImportEmpty;

  /// No description provided for @gymmaneImport.
  ///
  /// In en, this message translates to:
  /// **'GymMane schedule'**
  String get gymmaneImport;

  /// No description provided for @gymmaneImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read-only weekly gym blocks from a GymMane JSON backup.'**
  String get gymmaneImportSubtitle;

  /// No description provided for @gymmaneImportDone.
  ///
  /// In en, this message translates to:
  /// **'{imported} blocks imported ({timed} timed, {allDay} all-day), {skipped} skipped.'**
  String gymmaneImportDone(int imported, int timed, int allDay, int skipped);

  /// No description provided for @gymmaneImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not import GymMane: {error}'**
  String gymmaneImportFailed(String error);

  /// No description provided for @gymmaneImportEmpty.
  ///
  /// In en, this message translates to:
  /// **'The backup has no weekly plan.'**
  String get gymmaneImportEmpty;

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get appLock;

  /// No description provided for @appLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask for a PIN when the app opens.'**
  String get appLockSubtitle;

  /// No description provided for @appLockPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a PIN'**
  String get appLockPinTitle;

  /// No description provided for @appLockPinRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat the PIN'**
  String get appLockPinRepeat;

  /// No description provided for @appLockPinMismatch.
  ///
  /// In en, this message translates to:
  /// **'The PINs do not match.'**
  String get appLockPinMismatch;

  /// No description provided for @appLockUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get appLockUnlockTitle;

  /// No description provided for @appLockUnlockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Mane'**
  String get appLockUnlockSubtitle;

  /// No description provided for @appLockWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN. Try again.'**
  String get appLockWrong;

  /// No description provided for @appLockLockedOut.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait {seconds}s.'**
  String appLockLockedOut(int seconds);

  /// No description provided for @appLockEnabled.
  ///
  /// In en, this message translates to:
  /// **'App lock is on.'**
  String get appLockEnabled;

  /// No description provided for @appLockDisabled.
  ///
  /// In en, this message translates to:
  /// **'App lock is off.'**
  String get appLockDisabled;

  /// No description provided for @appLockPinLength.
  ///
  /// In en, this message translates to:
  /// **'Use four to eight digits.'**
  String get appLockPinLength;

  /// No description provided for @purchaseHistory.
  ///
  /// In en, this message translates to:
  /// **'Purchase history'**
  String get purchaseHistory;

  /// No description provided for @purchaseHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No purchases recorded yet.'**
  String get purchaseHistoryEmpty;

  /// No description provided for @increaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Increase quantity'**
  String get increaseQuantity;

  /// No description provided for @decreaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Decrease quantity'**
  String get decreaseQuantity;

  /// No description provided for @lowStockCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items below their reorder level'**
  String lowStockCount(int count);

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @maintenanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks due after their last service.'**
  String get maintenanceSubtitle;

  /// No description provided for @maintenanceDue.
  ///
  /// In en, this message translates to:
  /// **'Due now'**
  String get maintenanceDue;

  /// No description provided for @maintenanceUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get maintenanceUpcoming;

  /// No description provided for @maintenanceNone.
  ///
  /// In en, this message translates to:
  /// **'No maintenance tasks yet.'**
  String get maintenanceNone;

  /// No description provided for @maintenanceDone.
  ///
  /// In en, this message translates to:
  /// **'Done. Next due {date}.'**
  String maintenanceDone(String date);

  /// No description provided for @clearChecked.
  ///
  /// In en, this message translates to:
  /// **'Clear bought'**
  String get clearChecked;

  /// No description provided for @clearCheckedBody.
  ///
  /// In en, this message translates to:
  /// **'Remove every bought line? This cannot be undone.'**
  String get clearCheckedBody;

  /// No description provided for @shoppingToBuy.
  ///
  /// In en, this message translates to:
  /// **'To buy'**
  String get shoppingToBuy;

  /// No description provided for @shoppingBought.
  ///
  /// In en, this message translates to:
  /// **'Bought'**
  String get shoppingBought;

  /// No description provided for @shoppingOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get shoppingOther;

  /// No description provided for @moveUp.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get moveUp;

  /// No description provided for @moveDown.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get moveDown;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @beforeStart.
  ///
  /// In en, this message translates to:
  /// **'Before the start'**
  String get beforeStart;

  /// No description provided for @atTimeSection.
  ///
  /// In en, this message translates to:
  /// **'At a time'**
  String get atTimeSection;

  /// No description provided for @addTime.
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get addTime;

  /// No description provided for @customReminderHint.
  ///
  /// In en, this message translates to:
  /// **'A custom time fires on the occurrence day in the device timezone.'**
  String get customReminderHint;

  /// No description provided for @workHours.
  ///
  /// In en, this message translates to:
  /// **'Work hours'**
  String get workHours;

  /// No description provided for @workHoursSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide Work tasks outside these hours. Work deadlines stay visible.'**
  String get workHoursSubtitle;

  /// No description provided for @quietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet hours'**
  String get quietHours;

  /// No description provided for @quietHoursSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pause notifications during this window.'**
  String get quietHoursSubtitle;

  /// No description provided for @mcpTools.
  ///
  /// In en, this message translates to:
  /// **'MCP tools'**
  String get mcpTools;

  /// No description provided for @mcpToolsHint.
  ///
  /// In en, this message translates to:
  /// **'Loopback only. Initialize returns an Mcp-Session-Id header; clients that accept text/event-stream receive one SSE message per call. Writes stay gated by the switch above.'**
  String get mcpToolsHint;

  /// No description provided for @hoursWindow.
  ///
  /// In en, this message translates to:
  /// **'Set window'**
  String get hoursWindow;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

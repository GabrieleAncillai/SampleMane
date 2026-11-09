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

  /// No description provided for @syncNotActive.
  ///
  /// In en, this message translates to:
  /// **'LAN sync is not active in this build. The switch is stored for the pairing update.'**
  String get syncNotActive;

  /// No description provided for @mcpNotActive.
  ///
  /// In en, this message translates to:
  /// **'The local MCP endpoint is not active in this build. The switch is stored for the agent update.'**
  String get mcpNotActive;

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

  /// No description provided for @backupRestoredReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders have been rescheduled.'**
  String get backupRestoredReminders;
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

# Reference map

GymMane and Streak by InlitX are the primary references for Mane. Before
building a feature, open the equivalent in both projects and reuse or adapt it.
This map points at the files worth reading first.

Clone the references next to this repository:

```bash
git clone https://github.com/InlitX/GymMane.git ../GymMane
git clone https://github.com/InlitX/streak.git ../Streak
```

| Area | GymMane | Streak | Notes |
|---|---|---|---|
| App shell, tabs, navigation | `lib/app/gymmane_app.dart`, `lib/app/app_shell.dart` | `lib/app/streak_app.dart`, `lib/app/home_shell.dart`, `lib/app/classic_nav_bar.dart`, `lib/core/minimal/minimal_nav.dart`, `lib/core/express/express_nav.dart` | Streak has several complete nav designs; GymMane has the simpler shell. |
| Theme, colors, typography | `lib/theme/app_colors.dart`, `lib/theme/app_theme.dart` | `lib/app/theme/app_palette.dart`, `lib/app/theme/app_theme.dart`, `lib/app/theme/app_tokens.dart`, `lib/app/theme/color_themes.dart` | Use theme extensions, never scattered raw colors. |
| State and app architecture | `lib/state/fit_state.dart` and its `part` files | `lib/features/*/state/*_controller.dart` | GymMane is one `ChangeNotifier`; Streak is feature-first with `provider`. |
| Local storage | `lib/services/local_store.dart` | `lib/core/database/local_store.dart`, `lib/core/database/data_location.dart` | Compare with Mane's Drift layer before adding more schema. |
| Entry / habit editing | `lib/screens/exercise_detail_screen.dart`, `lib/screens/routine_edit_screen.dart`, `lib/screens/settings_screen.dart` | `lib/features/habits/pages/habit_details_page.dart`, `lib/features/habits/widgets/habit_form_schedule.dart`, `lib/features/habits/widgets/habit_form_kind.dart` | Sheets, validation, segmented controls, date/time picking. |
| Calendar / month / week | `lib/screens/history_screen.dart`, `lib/screens/timeline_screen.dart` | `lib/features/habits/widgets/activity_calendar.dart`, `lib/core/express/express_month.dart`, `lib/features/habits/pages/day_timeline_page.dart`, `lib/features/habits/widgets/grid_habit_cards.dart` | Streak is the primary calendar reference. |
| Notifications and reminders | `lib/services/alarm_store.dart`, `lib/services/rest_alarm.dart`, `lib/services/train_reminder.dart`, `lib/services/supplement_reminder.dart` | `lib/services/notification_service.dart`, `lib/services/reminder_schedule.dart`, `lib/services/reminder_sounds.dart` | Streak is the primary reminder reference. |
| Backup and import | `lib/services/auto_backup.dart`, `lib/services/backup_zip.dart`, `lib/services/fitnotes_backup.dart`, `lib/services/workout_import.dart` | `lib/services/backup_service.dart`, `lib/services/backup_archive.dart`, `lib/services/import_service.dart`, `lib/services/auto_sync.dart` | Versioned files, validation, test coverage. |
| Settings | `lib/screens/settings_screen.dart`, `lib/state/settings_state.dart` | `lib/features/settings/pages/settings_page.dart`, `lib/features/settings/state/settings_controller.dart` | Theme, locale, week start, reminders, data folder, privacy. |
| Localization | `l10n.yaml`, `lib/l10n/l10n.dart`, `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb` | `l10n.yaml`, `lib/core/i18n/l10n.dart`, `lib/core/i18n/app_locale.dart`, `lib/l10n/app_en.arb`, `lib/l10n/app_es.arb` | English source, Spanish first translation. |
| Motion and polish | `lib/widgets/ui_kit.dart`, `lib/widgets/glass.dart`, `lib/widgets/dialogs.dart` | `lib/core/widgets/page_motion.dart`, `lib/core/widgets/glass.dart`, `lib/core/widgets/celebration_overlay.dart`, `lib/core/express/express_motion.dart` | Use the same motion language and timing. |
| Empty and error states | `lib/widgets/ui_kit.dart` | `lib/core/widgets/app_empty_state.dart`, `lib/core/widgets/startup_failure.dart` | Calm, useful, never an error-looking dead end. |
| Accessibility | `lib/screens/settings_screen.dart` | `lib/core/widgets/*`, `lib/core/shortcuts/*` | Semantics, text scaling, keyboard shortcuts on desktop. |
| Home widgets | `lib/services/home_widget_bridge.dart`, `lib/services/nutrition_widgets.dart` | `lib/services/home_widget_service.dart`, `lib/services/todos_widget_service.dart`, `lib/services/widget_action_service.dart` | Follow the working Android widget pattern. |
| Device / desktop behavior | `lib/services/device_kind.dart` | `lib/services/desktop_window.dart`, `lib/core/utils/responsive.dart` | Phone-first, desktop-aware. |
| Build and release | `.github/workflows/build-apk.yml` | `.github/workflows/build-apk.yml`, `.github/workflows/linux.yml`, `fdroid/com.streak.app.yml`, `fastlane/` | Split APKs, GitHub Releases, F-Droid metadata, signing docs. |
| Tests | `test/` | `test/` | Copy the test style and coverage areas. |

## How to use this map

1. Read the GymMane file first when the task is about the small-app shell,
   settings, theme, l10n, backup or a simple screen.
2. Read the Streak file first when the task is about calendar, notifications,
   sync, motion, feature modules or a larger state tree.
3. If both have an implementation, choose the one closest to the task and keep
   the difference small.
4. If neither has an equivalent, it is a new domain problem. Design it, test it,
   and document the deviation in `docs/full-docs.md`.
5. If code is copied or closely adapted, keep GPL-3.0-only and update
   `CREDITS.md` plus the About screen attribution.

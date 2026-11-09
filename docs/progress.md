# Progress log

Keep this file current. A fresh context window should be able to resume from it.

## Current milestone

v0.2 complete. Next: v0.3 (home inventory, shopping, ICS, interval maintenance,
sleep window, shift checklists).

## Reference notes

- Timezone resolution: Streak `lib/services/notification_service.dart`.
- Notifications, channels, exact alarms, boot receiver: Streak
  `lib/services/notification_service.dart`, `lib/services/reminder_schedule.dart`
  and `android/app/src/main/AndroidManifest.xml`.
- Backup shape and validation: Streak `lib/services/backup_service.dart`,
  GymMane `lib/services/backup_zip.dart` and `lib/state/fit_state.dart` for the
  validate-then-rollback idea.
- Settings shell and row kit: Streak
  `features/settings/pages/settings_page.dart`,
  `features/settings/widgets/settings_rows.dart`, `features/settings/pages/about_page.dart`.
- Localization: both projects use the same `l10n.yaml`; Mane follows Streak's
  `context.l10n` extension and explicit `en`/`es` supported locales.
- Calendar: Streak `timeline_week_strip.dart`, `activity_calendar.dart`,
  `express_month.dart`. Mane keeps the month maths and selection model, but
  replaces habit cells with per-space markers and shift bars, and taps navigate
  to a day detail instead of toggling completion.
- Shift editor, tags, reminders and backup are Mane-specific domain work; the
  reference projects do not have equivalents.

## Decisions

- Keep Drift + Riverpod. The reason is in `docs/full-docs.md`.
- Settings live in the existing `setting_records` table. Keys:
  `themeMode`, `locale`, `weekStart`, `hideWorkSpace`,
  `defaultReminderOffsets`, `syncEnabled`, `mcpEnabled`.
- Default week start is Monday. Default reminder offsets are 10 and 60 minutes.
  All-day reminders count from 09:00 in the device timezone.
- Calendar month grid is six weeks from the week containing the 1st. Week start
  comes from settings. Tapping a day selects it; a second tap is not needed.
- Tags are rows with an optional space. Deleting a tag removes its entry links
  in one transaction. Entry tag links are saved with the entry in a transaction.
- Reminders are offsets stored per entry, with deterministic ids
  (`entryId:offsetMinutes`). The notification queue is rebuilt on start,
  resume, timezone change, and after entry/reminder edits. The horizon is 90
  days with a 500-notification cap.
- Backup is a versioned JSON document (`app: mane`, `schemaVersion: 3`) with
  every table, timestamps, IANA zones, recurrence JSON and soft deletes. Import
  validates the envelope before the transaction and rolls back on any bad row.
- Localization uses `lib/l10n/app_en.arb` and `app_es.arb`, generated into
  `lib/l10n/app_localizations*.dart`.

## Work completed

### v0.1.5

- Timezone-aware entries and shifts, Personal/Work/Home, flexible slots and
  exceptions, v1→v2 migration, DST/travel tests.

### v0.2

- Month/week calendar with markers, shift bars, month/week navigation, jump to
  today, selected-day detail and a selected date that survives edits.
- Week navigation and the week-start setting.
- Tags: schema v3, entry links, manager, editor chips and an app-wide tag
  filter.
- Shift-pattern editor: cycles, multiple slots per day, overnight slots,
  free/override/extra exceptions, conflict validation and a 28-day preview.
- Settings: theme, language (system/en/es), week start, hide Work, default
  reminders, tags, shift patterns, backup, sync/MCP switches and About.
- Reminders: multiple per entry, editor chips, Android notification permission
  and exact-alarm handling, stable IDs, a pure schedule planner, rescheduling on
  start/resume/timezone change, and notification taps that open the entry.
- Backup: versioned JSON export, validated transactional import, file picker,
  round-trip test and rejection tests.
- Localization foundation and English/Spanish strings for all shipped screens.

## Known limitations

- Real-device notification delivery, reboot rescheduling, battery optimization
  and timezone changes still need the user's Android device checklist.
- The Android manifest has the plugin boot receiver. A separate
  `TIMEZONE_CHANGED` receiver is not implemented; the app rebuilds the queue on
  resume and after the device zone is re-read.
- The notification channel name is English at the OS level; in-app strings are
  localized.
- Backup import accepts schema version 3 only. A future schema will need an
  explicit upgrade path.
- Linux file export depends on zenity/kdialog through `file_picker`.
- Shift patterns have no per-shift checklist yet; that is v0.3.
- Multi-day recurring entries remain unsupported; multi-day all-day events are
  shown per day.

## Next three steps

1. v0.3 schema: `home_items`, `shopping_items`, maintenance fields and shift
   checklist tables, with a v3→v4 migration test.
2. v0.3 UI: home inventory, shopping list, low-stock view, interval
   maintenance, sleep window and shift checklists.
3. v0.3 import: read-only ICS with `TZID`, all-day events and a documented
   RRULE subset, plus deduplication and fixtures.

## Commands and results

- `flutter pub get` — ok.
- `dart run build_runner build --force-jit` — ok.
- `flutter gen-l10n` — ok.
- `flutter analyze --no-fatal-infos` — no issues.
- `flutter test` — 33 passed (calendar, tags, reminders, backup, migrations,
  shift editor, timezone widgets).
- `(cd packages/mane_core && dart test)` — 64 passed.
- `flutter build linux --debug` — ok.
- `flutter build apk --debug` — ok after enabling core library desugaring.
- Linux app launch with an isolated `XDG_DATA_HOME` — starts without errors.

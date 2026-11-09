# Progress log

Keep this file current. A fresh context window should be able to resume from it.

## Current milestone

v0.3 complete. Next: v0.4 (pairing, mDNS, LAN query, companion integration and
MCP).

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
- Home inventory, shopping, ICS import, interval maintenance, sleep window and
  shift checklists have no equivalent in GymMane or Streak. They are
  planner-specific, implemented in `mane_core` and the `home_inventory`,
  `import`, `shifts` and `sleep` feature folders. The settings rows, theme and
  localization still follow the reference patterns.

## Decisions

- Keep Drift + Riverpod. The reason is in `docs/full-docs.md`.
- Settings live in the existing `setting_records` table. Keys:
  `themeMode`, `locale`, `weekStart`, `hideWorkSpace`,
  `defaultReminderOffsets`, `syncEnabled`, `mcpEnabled`, `sleepEnabled`,
  `sleepCommuteMinutes`, `sleepWindDownMinutes`, `sleepWakeBufferMinutes`.
- Default week start is Monday. Default reminder offsets are 10 and 60 minutes.
  All-day reminders count from 09:00 in the device timezone.
- Default sleep buffers are 30 minutes commute, 60 minutes wind-down and
  30 minutes wake buffer. The sleep window follows the visible plan and is off
  only when the user turns it off.
- Calendar month grid is six weeks from the week containing the 1st. Week start
  comes from settings. Tapping a day selects it; a second tap is not needed.
- Tags are rows with an optional space. Deleting a tag removes its entry links
  in one transaction. Entry tag links are saved with the entry in a transaction.
- Reminders are offsets stored per entry, with deterministic ids
  (`entryId:offsetMinutes`). The notification queue is rebuilt on start,
  resume, timezone change, and after entry/reminder edits. The horizon is 90
  days with a 500-notification cap.
- Backup is a versioned JSON document (`app: mane`, `schemaVersion: 4`) with
  every table, timestamps, IANA zones, recurrence JSON and soft deletes. Import
  validates the envelope before the transaction and rolls back on any bad row.
- Localization uses `lib/l10n/app_en.arb` and `app_es.arb`, generated into
  `lib/l10n/app_localizations*.dart`.
- ICS import stores read-only entries with `source = 'ics'`. The external id is
  `uid:<UID>` when present, otherwise a stable
  `fallback:<date>:<startMinute>:<summary>` string. Re-import deduplicates but
  does not update changed events.
- Shift checklist items belong to a pattern and keep their ids across edits.
  Completions are keyed by item id and the shift date in the pattern's timezone.
  Removing an item deletes its completions; renaming it preserves them.

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

### v0.3

- Schema v4: `home_item_records`, `shopping_item_records`,
  `shift_checklist_item_records`, `shift_checklist_completion_records`; entry
  columns `source`, `external_id`, `read_only`, `last_completed_at` and
  `repeat_after_completion_days`. A v3 fixture and migration test cover real
  prior rows.
- Entry domain: read-only and imported sources, interval maintenance, and the
  rule that a recurrence and a completion interval cannot coexist.
- Home inventory: add/edit/archive, quantity, unit, location, reorder level,
  low-stock view and "add all low stock to the shopping list".
- Shopping list: add/edit/check off. Checking a linked line adds its quantity to
  the inventory and stamps last-purchased; unchecking reverses it.
- Maintenance: completing a task advances its date from the actual completion
  date, records history and keeps a timed entry's wall time.
- Sleep window: pure `computeSleepWindow` in `mane_core`, a soft card on Today
  and settings for the toggle, commute, wind-down and wake buffer.
- Shift checklists: editor section, per-date checklist in the day detail, and
  tests proving independence across dates and preservation across renames.
- ICS import: pure parser for the documented subset, a local file picker, an
  import dialog with a space choice, read-only entries and re-import dedupe.
- Backup now covers schema v4 and the new tables and columns.
- Tests: 50 app/database/widget tests and 68 core tests.

## Known limitations

- Real-device notification delivery, reboot rescheduling, battery optimization
  and timezone changes still need the user's Android device checklist.
- The Android manifest has the plugin boot receiver. A separate
  `TIMEZONE_CHANGED` receiver is not implemented; the app rebuilds the queue on
  resume and after the device zone is re-read.
- The notification channel name is English at the OS level; in-app strings are
  localized.
- Backup import accepts schema version 4 only. A future schema will need an
  explicit upgrade path.
- Linux file export depends on zenity/kdialog through `file_picker`.
- ICS import does not support `EXDATE`, `RECURRENCE-ID`, ordinal `BYDAY`,
  `BYSETPOS`, `BYHOUR`/`BYMINUTE`, multi-day timed events or non-IANA zones.
  Unsupported events are reported as skipped. Re-import deduplicates but does
  not update changed events.
- Shift checklist completions are shared by two slots of the same pattern on
  the same date; the roadmap keys completion by pattern, date and item.
- Multi-day recurring entries remain unsupported; multi-day all-day events are
  shown per day.
- No LAN pairing, discovery, query endpoint or MCP server.
- No search, widgets or full accessibility pass.

## Next three steps

1. v0.4 pairing: local username + PIN hashing, short-code pairing, tests.
2. v0.4 LAN query: mDNS discovery, pinned transport, automatic refresh with a
   manual fallback, offline behavior tests.
3. v0.4 MCP: thin repository adapter, loopback/LAN binding, read-only by
   default and write tools behind a setting.

## Commands and results

- `flutter pub get` — ok.
- `dart run build_runner build --force-jit` — ok.
- `flutter gen-l10n` — ok.
- `flutter analyze --no-fatal-infos` — no issues.
- `flutter test` — 50 passed (database, migrations, timezone, calendar, tags,
  reminders, backup, shift editor and checklists, home inventory, ICS, widgets).
- `(cd packages/mane_core && dart test)` — 68 passed (recurrence, expansion,
  shifts, timezones, sleep).
- `flutter build linux --debug` — ok.
- `flutter build apk --debug` — ok with Java 21 and core library desugaring.

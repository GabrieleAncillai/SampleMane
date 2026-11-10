# Progress log

Keep this file current. A fresh context window should be able to resume from it.

## Current milestone

v0.9 is complete. The v1.0 program is real-device verification, the
accessibility/contrast audit, final docs and a signed release. The 2026-11-09
Huawei run fixed the app-lock bypass, notification actions/snooze and CSV
import duplication; see `docs/device-run-2026-11-09.md`. The widget and OEM
battery checks still need the user, and reboot is blocked by EMUI. The
constraint audit is in `docs/compliance-audit.md`.

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
- LAN pairing, query and MCP have no equivalent. Streak's `auto_sync.dart` and
  `folder_sync.dart` exchange backup files through a shared folder; they do not
  discover peers, pin TLS certificates or expose tools. Mane implements the
  v0.4 transport in `lib/features/sync` and `lib/features/mcp` with standard
  PBKDF2, HMAC, AES-GCM and TLS pinning.

## Decisions

- Keep Drift + Riverpod. The reason is in `docs/full-docs.md`.
- Settings live in the existing `setting_records` table. Keys:
  `themeMode`, `locale`, `weekStart`, `hideWorkSpace`,
  `defaultReminderOffsets`, `syncEnabled`, `mcpEnabled`, `mcpWritesEnabled`,
  `sleepEnabled`, `sleepCommuteMinutes`, `sleepWindDownMinutes`,
  `sleepWakeBufferMinutes`.
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
- Backup is a versioned JSON document (`app: mane`, `schemaVersion: 5`) with
  every user table, timestamps, IANA zones, recurrence JSON and soft deletes.
  Import validates the envelope before the transaction and rolls back on any bad
  row. `identity_records` and `paired_device_records` are deliberately excluded.
- Localization uses `lib/l10n/app_en.arb` and `app_es.arb`, generated into
  `lib/l10n/app_localizations*.dart`.
- ICS import stores read-only entries with `source = 'ics'`. The external id is
  `uid:<UID>` when present, otherwise a stable
  `fallback:<date>:<startMinute>:<summary>` string. Re-import deduplicates but
  does not update changed events.
- Companion import stores read-only entries with `source = 'companion'` and a
  documented JSON export shape. It also deduplicates but does not update.
- Shift checklist items belong to a pattern and keep their ids across edits.
  Completions are keyed by item id and the shift date in the pattern's timezone.
  Removing an item deletes its completions; renaming it preserves them.
- Pairing identity is one local row: device id/name, username, PBKDF2-SHA256
  PIN hash (210k iterations, 16-byte salt), self-signed RSA-2048 certificate and
  private key, and the MCP token. It is device-local security material.
- Pairing uses a six-digit code valid for five minutes with at most five
  attempts. The code plus both certificate fingerprints derive a PBKDF2 key
  (150k iterations). A random 32-byte shared key is wrapped in AES-256-GCM and
  acknowledged with an HMAC. Queries are signed over method, path, timestamp,
  nonce and body hash; the server keeps a five-minute nonce cache.
- MCP is loopback-only (`127.0.0.1:8765/mcp`), off by default, and requires the
  device bearer token. `initialize`, `ping`, `tools/list` and `tools/call` are
  implemented. Write tools appear only when `mcpWritesEnabled` is on.
- Snapshots from paired devices are display-only and stay in memory. Mane never
  merges a remote plan into the local one.
- Search reads only non-deleted entries and home items. It matches titles,
  notes, tag names, and home name/category/location/notes; results are grouped
  in the UI.
- The Android home widget uses `home_widget` plus a Kotlin provider. It is
  updated when the app starts or resumes; Android's own minimum refresh period
  is 30 minutes, and the widget is Android-only.
- Accessibility is a first pass: semantics, text scaling in the calendar,
  tooltips and desktop shortcuts. It is not a certified screen-reader audit.
- Release signing is user-provided. The workflow refuses to publish without
  keystore secrets; a local release build without them uses the debug key.

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

- Schema v4: home items, shopping items, shift checklist items and completions,
  plus entry source/read-only/maintenance columns.
- Home inventory, shopping list, low-stock flow and linked quantity updates.
- Interval maintenance that advances from the actual completion date.
- Sleep window on Today with configurable buffers.
- Per-shift checklists in the editor and day detail, independent per date.
- Local-only ICS import with a documented RRULE subset and dedupe.
- Backup schema v4 and real v3 migration test.

### v0.4

- Schema v5: `identity_records` and `paired_device_records`, with a real v4
  fixture and migration test. Both tables are excluded from backups.
- Local identity setup: username, device name, PIN with PBKDF2 hashing,
  self-signed certificate, MCP token, profile edit and PIN change.
- Pairing: host code sheet with PIN unlock and five-minute expiry; guest sheet
  with discovered peers and manual host/port; fingerprint-bound HMAC, AES-GCM
  key wrapping and an HMAC acknowledgement.
- LAN server: pinned HTTPS; `info`, `pair` and `query` endpoints; signed
  requests with timestamp window and nonce replay cache; read-only resources for
  summary, entries, shifts, spaces, tags, home and shopping.
- LAN client: certificate capture and pinning, pairing, signed queries and
  friendly errors for stale pairing, offline peers and wrong certificates.
- Bonsoir mDNS advertisement and browsing with manual fallback.
- Sync service: start/stop, discovery updates, presence, snapshots, automatic
  refresh on launch, resume, discovery and a five-minute timer, manual refresh
  and per-device errors. Local plan untouched when a peer is offline.
- Devices page: identity setup, identity card, paired devices with snapshots,
  refresh, unpair and pair flows. MCP page: endpoint, token, copy, rotate and
  write-tool switch.
- MCP server: loopback HTTP, bearer token, JSON-RPC initialize/ping/tools,
  `personal.today`, `work.next_shifts`, `home.shopping`, and gated `plan.create`
  and `plan.complete`.
- Companion JSON export import with fixtures, dedupe, read-only rows and a space
  choice.
- Android permissions for LAN and multicast; MCP remains loopback-only.

### v0.5

- Global search over entry titles/notes, tag names and home name, category,
  location and notes, with grouped results and a debounced screen.
- Android home-screen widget: `home_widget` bridge, Kotlin provider, layout,
  widget info and manifest receiver. It shows today's plan, the next shift and
  the update time.
- Error banners on Calendar and Week; the search screen has prompt, loading,
  error and no-results states.
- Semantics for shift tiles and week days, scaled calendar cell heights,
  Ctrl+F search and Ctrl+1..3 tab shortcuts.
- English/Spanish ARB parity and a scanner that rejects new user-facing string
  literals in widgets.
- Recurrence count ordinals are constant-time; a year of a long-running daily
  rule expands under a regression threshold.
- Release workflow and `docs/release.md`: keystore secrets, split-per-ABI APKs,
  Linux bundle, checksums and GitHub release.
- Tests: 85 app/database/widget tests and 71 core tests.

### v0.6

- Completion program and compliance audit added: `docs/completion-plan.md`,
  `docs/compliance-audit.md`.
- Android cloud backup and device transfer disabled for the app's data, with a
  data-extraction rule. User-exported JSON remains the only backup path.
- CI now checks formatting and builds a Linux debug bundle; Zed has a
  `verify: all` task and a format-check task.
- Documentation truth pass: v1.0 scope, known gaps and reference-map claims now
  match the code.
- Bundled Nunito (the GymMane face) with a display/headline/title/body/label
  scale in `lib/theme/app_typography.dart`.
- Rewrote `ManeColors` as the single palette (space, state, glass, nav and
  shadow tokens) and rebuilt `ManeTheme` with app bar, card, sheet, dialog,
  snack bar, navigation bar, button, input, chip, switch, date and time picker
  themes. Screens read `context.mc`, not generated Material roles.
- Added the shared UI kit under `lib/core/widgets`: `SoftCard`, `AppSheet`,
  `SectionLabel`, `Pressable`, `GlassIconButton`, `GlassPill`, `TinySwitch`,
  `GlassSurface`, `AppEmptyState`, `ManeNotice`, `FadeThrough`, `ManePage`,
  `ManeAddButton`, `ManeNavBar`, `ManeSegmented`, `ManeSearchField` and the
  dotted `AppBackground`.
- Replaced the stock shell with a transparent scaffold, paper background, custom
  header, floating nav and companion add button. Ctrl+1..3 and the tag filter
  still work.
- Swept Today, Week, Calendar, Settings, Tags, Shift patterns, Home inventory,
  Shopping, Devices, pairing, MCP, Search and About onto the kit. Entry, shift,
  tag, reminder and household sheets use `showAppSheet`.
- Added `test/visual_kit_test.dart` (theme tokens, kit behaviour, nav selection,
  custom page header, sheet handle) and rendered reference screenshots to
  `docs/screenshots/`.
- Validation: format clean, analyze clean, 90 app tests and 71 core tests pass,
  Linux debug and Android debug APK build.

### v0.7

- Day timeline: 24-hour view in Calendar's Day mode, shifts drawn behind
  entries, all-day chips above it, a now line and per-shift checklists. The
  screenshot is `docs/screenshots/v0.7-calendar-day-light.png`.
- Multi-day timed entries: `endDate` is now valid for timed rows, end instants
  resolve on the end date, and the expander emits each displayed day (including
  overnight tails).
- Recurrence: `skipDates`, `RecurrenceOverride` (moved or time-changed
  occurrences), ordinal weekdays (`1MO`, `-1FR`), negative `BYMONTHDAY` and
  `BYSETPOS`, with JSON round-trip and DST-safe expansion.
- Entry editor: optional end date, skip-this-occurrence toggle and an
  only-this-occurrence mode that writes a recurrence override.
- Shift patterns carry tags and optional commute/wind-down minutes. The global
  tag filter now filters shifts as well as entries. The editor exposes both.
- Per-slot checklists: schema v6 adds `slot_key` to completions, the real v5
  fixture is migrated by assigning legacy ticks to the first slot, and two slots
  on one date keep independent ticks.
- ICS export in `features/export`: read-only VCALENDAR for entries (with RRULE,
  EXDATE and RECURRENCE-ID), multi-day dates and concrete shift blocks.
- ICS import hardening: `EXDATE`, `RECURRENCE-ID` cancellations and moves,
  Windows TZID aliases, vendor-prefixed TZIDs, multi-day timed events and
  update-on-reimport.
- Schema v6 adds `shift_pattern_tag_records`, `commute_minutes`,
  `wind_down_minutes` and the per-slot key. Backup schema 6 exports the new
  fields and table.
- Tests: 98 app/database/widget tests and 82 core tests.
- Validation: format clean, analyze clean, both suites pass, Linux debug and
  Android debug APK build.

### v0.8

- Schema v7 adds `shopping_item_records.position` and `home_purchase_records`,
  with a real v6 fixture (`test/fixtures/schema_v6.sql`) migrated to the current
  schema. Purchase history is written by linked shopping check-offs and manual
  stock increases; unchecking reverses the quantity and removes that history
  row.
- GymMane import in `features/import/gymmane_import.dart`: reads `weeklyPlan`,
  `routines` and `trainAt`, writes read-only weekly Personal blocks, skips
  archived and unknown routines, deduplicates by routine/weekday, and falls back
  to all-day blocks when `trainAt` is missing. The documented input is the JSON
  payload (`gymmane.json`).
- Automatic backups in `features/backup/auto_backup_service.dart`: one JSON copy
  per local day under the app support `backups` folder, rotation to the
  configured count, and manual export unchanged as the canonical path. Wired to
  app start and resume.
- Backup import accepts schema versions 3–8. Missing tables and fields in older
  payloads become empty defaults. App-lock settings (salt, hash, misses,
  blocked-until) are excluded from export, so a restored install starts
  unlocked.
- CSV in `features/export/csv_interchange.dart`: entry export/import with space,
  kind, all-day or timed values, end date, timezone, status, recurrence JSON,
  tags and notes; shopping and inventory export/import with dedupe. Shopping
  groups by the linked home item's category/location, clears bought lines and
  supports move up/down.
- Home tracking: inventory quick ±1 adjustment and a purchase-history sheet;
  a dedicated maintenance page with due/upcoming groups and one-tap completion;
  the low-stock card now states the count as well as the names.
- App lock in `features/app_lock`: PBKDF2 salt/hash in device settings, a PIN pad
  adapted from Streak's `pin_pad.dart`, a two-step setup page, a 30-second
  resume grace and a 30-second lockout after five misses. The About/data
  section documents that the lock is optional and has no recovery code.
- Screenshots: `docs/screenshots/v0.8-shopping-light.png`,
  `v0.8-maintenance-light.png` and `v0.8-pin-setup-light.png`.
- Tests: 121 app/database/widget tests and 82 core tests.
- Validation: format check clean, analyze clean, both suites pass, Linux debug
  and Android debug APK build.

### v0.9

- Schema v8 adds `reminder_records.time_minute` and `remote_snapshot_records`,
  with a real v7 fixture (`test/fixtures/schema_v7.sql`) migrated to the current
  schema. LAN snapshots store the raw read-only payload, are restored on start
  and are pruned for unpaired devices.
- MCP adapter: `plan.range`, `plan.search`, `plan.get`, `work.shifts`,
  `home.inventory`, `tags.list`, `sleep.window`, plus gated `plan.update`,
  `plan.uncomplete`, `plan.delete`, `home.shopping_add` and
  `home.shopping_check`. `initialize` returns `Mcp-Session-Id`; sessions expire
  after an hour, `DELETE /mcp` closes one, and `text/event-stream` clients get
  one SSE message per call. The MCP page lists the surface.
- LAN: the `snapshot` resource returns the compact summary plus spaces, tags,
  the next week of entries and shifts, inventory and shopping. The Devices page
  keeps the last snapshot after a restart and while the peer is offline.
- Work hours and quiet hours: settings, time pickers, aggregate-screen Work
  filtering (deadlines stay visible), and reminder-planner suppression at each
  notification's local fire time. Custom reminder times are stored as
  `time_minute`; the editor and reminder sheet support offsets and times.
- Android notification actions: snooze (10 minutes) and complete. The payload
  carries the occurrence date, so completing one recurring occurrence is
  correct; cold-start actions are handled at bootstrap.
- Screenshots: `docs/screenshots/v0.9-settings-hours-light.png` and
  `v0.9-reminders-light.png`.
- Tests: 131 app/database/widget tests and 85 core tests.
- Validation: format check clean, analyze clean, both suites pass, Linux debug
  and Android debug APK build.

### v1.0 device verification (in progress)

- 2026-11-09: HUAWEI MAR-LX3A, Android 10 / API 29, debug 0.9.0+9. Full log in
  `docs/device-run-2026-11-09.md`.
- Fixed: the app-lock gate moved into `MaterialApp.builder`, above the Navigator,
  so Settings and other pushed routes cannot cover the PIN pad. A regression
  test locks, pushes a route, resumes and asserts the gate still covers it.
- Fixed: notification actions use the foreground path (`showsUserInterface`),
  and a resume rebuild cancels only planner-owned IDs so a one-off snooze
  survives. Timezone lookup uses `timeZoneLocation()` and scheduling errors are
  logged.
- Fixed: CSV entry import now uses `hasEntryLike(...)`, matching any live entry
  by title, space, date, all-day flag and minutes, not only earlier CSV rows.
  The same CSV re-imported on the phone reported 0 imported, 7 duplicates and
  left 7 entries.
- Passed on the device: first launch/About, notifications on API 29 (delivery,
  grouping, taps, edit time, custom time, quiet/work suppression, snooze,
  complete), timezone travel, LAN pairing with manual host/port, MCP including
  session `DELETE` and linked inventory, JSON backup/import, and app lock.
- Blocked or failed: the widget needs the user's launcher; OEM battery needs the
  EMUI path; reboot fails because EMUI does not deliver `BOOT_COMPLETED` even
  with the app whitelisted and auto-launch enabled. Opening Mane rebuilt the
  queue without duplicates.
- Tests: 135 app/database/widget tests and 85 core tests.
- Validation: format check clean (144 files), analyze clean, both suites pass,
  Linux debug and Android debug APK build.

## Known limitations

- The 2026-11-09 real-device run passed install, notifications on API 29,
  timezone, LAN, MCP, backup/CSV and app lock. The Android 13 permission and
  Android 12 exact-alarm paths are N/A on that API 29 phone and are covered by
  the Pixel 9 emulator baseline. The widget and OEM battery checks still need
  the user.
- Reboot rescheduling fails on EMUI 10: the queued alarms are persisted in
  `scheduled_notifications.xml`, but `BOOT_COMPLETED` does not reach the plugin
  receiver after a reboot. A manual launch rebuilds the queue without
  duplicates. This is documented as an OEM limitation, not a pass.
- Automatic backup rotation is implemented and unit-tested; pruning older copies
  was not forced on the device by changing the clock.
- The Android manifest has the plugin boot receiver. A separate
  `TIMEZONE_CHANGED` receiver is not implemented; the app rebuilds the queue on
  resume and after the device zone is re-read.
- The notification channel name is English at the OS level; in-app strings are
  localized.
- Backup import accepts schema versions 3 through 8. Versions 1–2 are rejected
  because they predate timezone-aware entries. Import still replaces the local
  plan rather than merging it.
- Automatic backups run on app start/resume, once per local day. A long-running
  foreground session without a resume does not trigger a new copy.
- GymMane import reads the JSON payload, not the zip container; `planMoves`
  per-date overrides are ignored, and a timed block is one hour because GymMane
  stores no duration.
- Linux file export depends on zenity/kdialog through `file_picker`.
- ICS import still does not support `BYHOUR`/`BYMINUTE`, multiple
  `BYMONTHDAY` values, `EXRULE`, floating time without a TZID default that the
  user can control, or non-IANA zones outside the built-in Windows alias table.
  Unsupported events are reported as skipped.
- Multi-day recurring timed entries have a single end offset; moving one
  occurrence with `RECURRENCE-ID` carries the moved date but not a changed end
  date.
- Shift checklist completions are now keyed by pattern, date and slot. Legacy
  pre-v6 ticks are assigned to the first slot of that date.
- The visual layer follows the references: Nunito, tokens, component themes,
  the shared kit and the floating shell.
- ICS export is shipped. GymMane schedule import is shipped as a read-only
  JSON adapter in v0.8.
- MCP is loopback-only and exposes the full v0.9 tool set behind the write
  switch. Streamable HTTP is one SSE message per call; sessions are in memory
  and `GET /mcp` is rejected.
- LAN snapshots are persisted read-only and restored after a restart; they are
  never merged into the local plan. A companion app's ContentProvider is not
  integrated because no app and authority were specified; the documented JSON
  export is the v0.4 path and the GymMane JSON import is the v0.8 path.
- mDNS depends on the platform daemon (Avahi on Linux, NSD on Android). The
  phone reports "Network discovery is unavailable", so manual host/port is the
  verified fallback. Pairing sessions live in memory and are cancelled by an app
  restart.
- The Android home-screen widget refreshes when the app starts or resumes; it
  is Android-only and has no configuration screen.
- Accessibility is a first pass, not a certified screen-reader or contrast
  audit.
- The app lock has no recovery code; clearing app data is the only reset. The
  lock hash is deliberately absent from backups.
- Work-hours hiding applies to Today, Week and Calendar outside the window.
  Work deadlines stay visible; search and opened entries are never filtered.
- Quiet hours and work hours suppress notifications when the queue is rebuilt;
  Settings rebuilds it immediately. A reminder scheduled before an external
  change can still fire until the next launch/resume rebuild.
- MCP sessions live in memory and expire after one hour. Streamable HTTP is one
  SSE message per call, not a long-lived bidirectional stream; `GET /mcp` is
  rejected.
- Android notification action labels are English at the OS level; buttons are
  Android-only.
- Remote snapshots are display data only and are never merged into the local
  plan. They are pruned when a device is unpaired.
- Release signing is a user-provided keystore step; local release builds fall
  back to the debug key and are not production releases.

## Next three steps

1. Add the Mane widget on the phone and finish the OEM battery path, then record
   both in `docs/device-run-2026-11-09.md`.
2. Run the accessibility/contrast pass and fix what is fixable.
3. Tag v1.0 only when every scenario in `docs/completion-plan.md` passes and a
   signed release succeeds.

## Commands and results

- `flutter pub get` — ok.
- `dart run build_runner build --force-jit` — ok.
- `flutter gen-l10n` — ok.
- `dart format --line-length 110 --output=none --set-exit-if-changed` — clean
  (143 hand-written Dart files; generated `.g.dart` and ARB outputs excluded,
  matching CI).
- `flutter analyze --no-fatal-infos` — no issues.
- `flutter test` — 135 passed (database, migrations v1→v8, timezone, calendar,
  tags, reminders and custom times, backup and pairing-secret exclusion, shift
  editor and checklists, home inventory and purchase history, shopping grouping,
  app lock and the pushed-route regression, ICS, CSV including same-plan
  dedupe, GymMane import, companion import, pairing crypto, certificates, TLS
  pinning, replay rejection, MCP tools/sessions/SSE, sync orchestration and
  snapshot persistence, search, widget data, notification actions, l10n
  enforcement and widget flows).
- `(cd packages/mane_core && dart test)` — 85 passed (recurrence including
  constant-time ordinals, expansion, shifts, timezones, local windows, sleep).
- `flutter build linux --debug` — ok, including the Bonsoir plugin.
- `flutter build linux --release` — ok.
- `flutter build apk --debug` — ok with Java 21 and core library desugaring.
- `flutter build apk --release --split-per-abi` — ok for armeabi-v7a, arm64-v8a
  and x86_64 with the local debug-key fallback; CI requires the real keystore.
- Linux launch with isolated `XDG_DATA_HOME` — starts and stays up.
- Pixel 9 emulator (debug 0.5.0): app launch, entry creation, notification
  permission, exact-alarm access, two grouped reminders delivered, timezone
  travel moved 9:00 AM Bogota to 3:00 PM Madrid, reboot kept the entry and
  rescheduled both reminders; the 10-minute reminder fired after advancing the
  clock. `dumpsys alarm` showed exact alarms after reboot.
- Huawei MAR-LX3A (debug 0.9.0+9, Android 10): the full result table, fixed
  defects, reboot limitation and screenshot list are in
  `docs/device-run-2026-11-09.md`. The final APK was rebuilt and reinstalled; the
  preserved plan launched normally.

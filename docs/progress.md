# Progress log

Keep this file current. A fresh context window should be able to resume from it.

## Current milestone

v0.5 complete. v1.0 is waiting only on the user's real-device notification,
reboot, battery-optimization and timezone checklist.

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

## Known limitations

- Real-device notification delivery, reboot rescheduling, battery optimization
  and timezone changes still need the user's Android device checklist.
- The Android manifest has the plugin boot receiver. A separate
  `TIMEZONE_CHANGED` receiver is not implemented; the app rebuilds the queue on
  resume and after the device zone is re-read.
- The notification channel name is English at the OS level; in-app strings are
  localized.
- Backup import accepts schema version 5 only. A future schema will need an
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
- MCP is loopback-only and implements the core tools JSON-RPC surface, not
  SSE/streamable sessions. LAN-bound MCP is not implemented.
- mDNS depends on the platform daemon (Avahi on Linux, NSD on Android) and still
  needs the user's real-device check. Pairing sessions live in memory and are
  cancelled by an app restart.
- LAN snapshots are in memory and are not persisted or merged. A companion
  app's ContentProvider is not integrated because no app and authority were
  specified; the documented JSON export is the v0.4 path.
- The Android home-screen widget refreshes when the app starts or resumes; it
  is Android-only and has no configuration screen.
- Accessibility is a first pass, not a certified screen-reader or contrast
  audit.
- Release signing is a user-provided keystore step; local release builds fall
  back to the debug key and are not production releases.

## Next three steps

1. Run the real-device checklist on the user's Android device: notification
   permission, delivery, reboot, battery optimization and timezone change.
2. Fix anything the device checklist finds, with a regression test where the
   behavior is testable off-device.
3. Tag v1.0 only after the device checklist passes; keep the release keystore
   as a user-provided step.

## Commands and results

- `flutter pub get` — ok.
- `dart run build_runner build --force-jit` — ok.
- `flutter gen-l10n` — ok.
- `flutter analyze --no-fatal-infos` — no issues.
- `flutter test` — 85 passed (database, migrations v1→v5, timezone, calendar,
  tags, reminders, backup and pairing-secret exclusion, shift editor and
  checklists, home inventory, ICS, companion import, pairing crypto,
  certificates, TLS pinning, replay rejection, MCP, sync orchestration, search,
  widget data, l10n enforcement and widget flows).
- `(cd packages/mane_core && dart test)` — 71 passed (recurrence including
  constant-time ordinals, expansion, shifts, timezones, sleep).
- `flutter build linux --debug` — ok, including the Bonsoir plugin.
- `flutter build linux --release` — ok.
- `flutter build apk --debug` — ok with Java 21 and core library desugaring.
- `flutter build apk --release --split-per-abi` — ok for armeabi-v7a, arm64-v8a
  and x86_64 with the local debug-key fallback; CI requires the real keystore.
- Linux launch with isolated `XDG_DATA_HOME` — starts and stays up.

# Compliance audit

Status: v0.9, audited 2026-11-09. This audit covers the project rules in
`AGENTS.md`, `CONTRIBUTING.md`, the public docs and the private scenario brief.
The private brief is reviewed locally; its details are not copied here.

## Verdict

The core promises are intact: offline-first storage, no accounts, no telemetry,
GPL-3.0-only, optional LAN/MCP, tested migrations and green builds. v0.6 through
v0.9 closed the visual and feature gaps: the reference kit, calendar day
timeline, multi-day entries, recurrence exceptions, per-slot checklists,
GymMane import, backup automation, CSV, home tracking, app lock, full MCP tools
and sessions, persistent read-only LAN snapshots, work/quiet hours, custom
reminder times and notification actions. The project is **not** v1.0-ready only
because the real-device checklist, accessibility/contrast audit and signed
release are still pending.

The completion work is in `docs/completion-plan.md`. The v0.6 M0 slice already
fixed Android cloud backup, the CI gap and the documentation claims; the
product/visual and feature work is the active program.

## Constraint status

| Constraint | Status | Evidence | Action |
|---|---|---|---|
| Offline core, no internet dependency | Pass | No cloud/HTTP client dependency in `pubspec.yaml`; core uses local SQLite; LAN/MCP services are behind settings | Keep |
| No accounts, email, password reset or cloud identity | Pass | Only local `identity_records`; PIN hash stored locally; no auth provider | Keep |
| Data ownership in SQLite, export first-class | Pass | Drift schema, JSON export/import, rotating automatic local backups, older-schema upgrade, CSV and ICS export; Android cloud backup disabled | Keep |
| Optional network only | Pass | `syncEnabled` and `mcpEnabled` default false; local plan works without peers | Keep, add tests for both-switch-off startup |
| GPL-3.0-only and attribution | Pass | `LICENSE`, `ADDITIONAL_TERMS.md`, `CREDITS.md`, About screen | Keep |
| Android + Linux both build | Pass at v0.9 | Debug APK and Linux debug pass locally; release workflow builds both | Add Linux build to the normal CI |
| No new dependency without reason | Pass | Existing stack only; no analytics/ads/Firebase/Supabase | Keep |
| Do not weaken tests or security | Pass | 131 app + 85 core tests; pairing/TLS/replay, app-lock hashing, MCP auth/session and snapshot tests | Keep |
| Reference-first for components, styles, motion | Pass (v0.6) | Nunito, expanded `ManeColors`, `ManeType`, component themes, `lib/core/widgets` kit, floating shell and screen sweep; `test/visual_kit_test.dart` and `docs/screenshots/` | Keep |
| Reference map describes shipped state | Pass (v0.6) | `docs/reference-map.md` now names the shipped kit and the visual deviation | Keep |
| Every schema change has migration + real-row test | Pass | v1→v8 migration tests, including real v5, v6 and v7 fixtures | Keep |
| Timezone behavior has DST/travel tests | Pass | Core time tests and widget/reminder tests | Keep for new features |
| Localization: English source, Spanish first | Pass for shipped screens | ARB parity and literal scanner tests, including the v0.8 and v0.9 surfaces | Keep |
| Accessibility basics | Partial | Semantics, text scaling, shortcuts; no certified screen-reader/contrast audit | v1.0 audit |
| Release signing is user-provided | Pass | Release workflow refuses without keystore secrets | Keep |
| Private brief stays private | Pass | `doc-personal/` is gitignored; no private details in public docs | Keep |

## Findings

Severity: P0 blocks all use; P1 blocks v1.0 or can lose/leak data; P2 degrades a
real scenario; P3 polish.

### P1 — Android auto-backup could copy pairing secrets to the cloud (fixed v0.6)

**Evidence:** `android/app/src/main/AndroidManifest.xml` had no
`android:allowBackup` or data-extraction rule. The app's JSON backup deliberately
excludes `identity_records` and `paired_device_records`, but Android Auto Backup
does not use that code and could copy the SQLite database to Google's cloud
backup.

**Impact:** violated the offline/data-ownership promise and could move the local
PIN hash, private key, shared pairing keys and MCP token off-device.

**Remediation (done):** `android:allowBackup="false"`,
`android:fullBackupContent="false"` and
`res/xml/data_extraction_rules.xml` exclude every data domain from cloud backup
and device transfer. Verified in the merged debug manifest and the debug APK
build.

### P1 — The visual layer did not follow the references (fixed v0.6)

**Evidence:** `lib/theme/app_theme.dart` only wrapped `ColorScheme.fromSeed` and
set four roles. `ManeColors` was referenced only by the theme file. The shell used
stock `AppBar`, `NavigationBar` and `FloatingActionButton`. There was no shared
UI kit, font asset or animation code.

**Impact:** the app looked like a default Material prototype, the opposite of the
reference-first rule and the documented visual direction.

**Remediation (done):** Nunito plus `ManeType`; expanded tokens and component
themes; `lib/core/widgets` kit; floating shell and background; screen sweep;
widget tests and `docs/screenshots/`. The deviation is recorded in
`docs/full-docs.md` and `docs/reference-map.md`.

### P1 — Real calendar files exceeded the ICS subset (fixed v0.7)

**Evidence:** `lib/features/import/ics_parser.dart` rejected `EXDATE`,
`RECURRENCE-ID`, ordinal `BYDAY`, `BYSETPOS`, negative `BYMONTHDAY`, timed events
over 24 hours and non-IANA `TZID` values. Re-import only deduplicated.

**Remediation (done):** skip dates, cancelled and moved occurrences, ordinal
weekdays, `BYSETPOS`, negative month days, Windows/vendor TZID aliases, multi-day
timed events and update-on-reimport are implemented and tested. Unsupported
parts are still reported, not guessed.

### P1 — GymMane read-only schedule integration was not shipped (fixed v0.8)

**Evidence:** `features/import/companion_import.dart` accepts a generic JSON
shape. GymMane's actual backup format (`weeklyPlan`, `routines`, `trainAt`) was
not read. The private brief explicitly accepts a read-only export/provider.

**Remediation (done):** `features/import/gymmane_import.dart` reads the JSON
payload, writes read-only weekly Personal blocks, dedupes by routine/weekday,
skips archived/unknown routines and falls back to all-day blocks when `trainAt`
is missing. `planMoves` and per-routine durations remain documented limits.

### P2 — Per-shift checklist was keyed by pattern + date, not slot (fixed v0.7)

**Evidence:** `ShiftChecklistCompletionRecords` primary key was
`{itemId, dateKey}`.

**Remediation (done):** schema v6 keys completions by item, date and stable slot
key, migrates real v5 rows to the first slot and tests two-slot independence.

### P2 — Work-hours visibility is only "hide the whole Work space" (fixed v0.9)

**Evidence:** `AppSettings.hideWorkSpace` filtered Work from screens. There was
no work-hours window, quiet-hours notification suppression or per-space rule.

**Remediation (done):** `workHoursEnabled`/`workHoursStart`/`workHoursEnd` hide
Work tasks from Today, Week and Calendar outside the window while Work deadlines
remain visible and search still finds them. `quietHoursEnabled` with start/end
and the work window are applied to each notification's local fire time in the
reminder planner. Settings expose switches and time pickers.

### P2 — LAN snapshots are in memory and disappear on restart (fixed v0.9)

**Evidence:** `SyncService` kept `_snapshots` in a map; no table or file stored
them.

**Remediation (done):** schema v8 adds `remote_snapshot_records`; the client
stores the raw read-only payload, restores it on start, prunes unpaired devices
and still never merges it. A restart test keeps the last snapshot while the peer
is offline.

### P2 — MCP covered only four tools and the core JSON-RPC surface (fixed v0.9)

**Evidence:** `McpServer` exposed the four core tools and no session handling.

**Remediation (done):** the v0.9 tool set adds range, search, get, shifts,
inventory, tags, sleep, update, uncomplete, delete and shopping add/check;
writes stay behind the setting. `initialize` returns `Mcp-Session-Id`, explicit
sessions expire, `DELETE /mcp` closes one, and `text/event-stream` clients get
one SSE message per call. The MCP page lists the surface.

### P2 — Reminders were offset-only with no notification actions (fixed v0.9)

**Remediation (done):** `reminder_records.time_minute` stores an absolute local
time; the editor and sheet support both forms. Android notifications carry
snooze and complete actions, and the payload includes the occurrence date so a
recurring completion does not complete the whole series.

### P2 — Multi-day entries and recurrence exceptions were incomplete (fixed v0.7)

**Evidence:** the editor created single-day items; the recurrence model had no
skip dates.

**Remediation (done):** multi-day all-day and timed entries, end dates in the
editor, skip dates, moved/time-changed occurrences, and an only-this-occurrence
save path.

### P2 — No read-only calendar export (fixed v0.7)

**Remediation (done):** `features/export` writes a read-only VCALENDAR with
entries, recurrence, `EXDATE`, `RECURRENCE-ID`, multi-day dates and concrete
shift blocks. Settings exposes it.

### P2 — Backup was manual and accepted only schema version 5 (fixed v0.8)

**Evidence:** `BackupService` validated `schemaVersion: 5`; there was no
automatic backup or rotation.

**Remediation (done):** `features/backup/auto_backup_service.dart` writes one
local JSON copy per day with rotation, wired to app start/resume. Backup import
accepts schemas 3–8 by defaulting missing fields, and rejects 1–2 and future
versions. App-lock secrets are excluded from export. Tests cover v3/v4 upgrades,
round-trip, rejection and rotation.

### P2 — No optional app lock or home-tracking views (fixed v0.8)

**Evidence:** the planner opened straight into the plan, shopping had no
grouping/clear/reorder, inventory had no quick adjustment or purchase history,
and maintenance had no dedicated due view.

**Remediation (done):** `features/app_lock` adds an optional PBKDF2 PIN lock
with a two-step setup, resume grace and lockout; shopping groups by linked
category/location and supports clear/reorder; inventory has quick adjustments
and purchase history (schema v7); maintenance has a due/upcoming page with
one-tap completion. The lock hash is device-local and absent from backups, and
no recovery code ships, which is documented as a deliberate limitation.

### P2 — CI did not check formatting or build Linux (fixed v0.6)

**Evidence:** `.github/workflows/build.yml` ran analyze, tests and a debug APK.
Only `release.yml` built Linux.

**Impact:** a Linux regression could reach `main` unnoticed. Format drift was
only caught by hand.

**Remediation (done):** `build.yml` now runs the format check, installs the Linux
build dependencies and builds a Linux debug bundle before the APK. Zed has a
matching `verify: all` task.

### P3 — Accessibility and documentation accuracy

**Evidence:** accessibility is a first pass, not a screen-reader/contrast audit.
Several docs stated that v1.0 waits only on the device checklist, and the
reference map claimed the visual language followed the references.

**Impact:** misleading project state and unknown accessibility quality.

**Remediation:** the v0.6 truth pass fixed the roadmap, status, reference-map and
visual claims. The accessibility audit remains a v1.0 gate.

## Security and data-boundary review

- Pairing uses PBKDF2-HMAC-SHA256 for the PIN, a short-lived code bound to both
  certificate fingerprints, AES-256-GCM key wrapping, HMAC acknowledgement,
  pinned TLS, signed requests, a timestamp window and a nonce replay cache.
- `identity_records` and `paired_device_records` are excluded from the app's JSON
  backup on purpose. Their presence in the Android database is why cloud backup
  must be off.
- MCP is loopback-only, off by default, bearer-token authenticated and write
  tools are behind a second switch. It has no direct SQL access and calls
  `PlannerRepository`.
- LAN sync is query-only. The local plan is never merged with a remote one.
- No analytics, ads, telemetry, Firebase, Supabase or remote config dependency is
  present. The `INTERNET` permission exists for opt-in LAN sockets, not cloud
  calls.

## Required gates for every future change

1. Reference audit for the equivalent GymMane/Streak file.
2. Schema change → Drift migration and a real prior-row test.
3. Timezone change → DST/travel test.
4. Visual change → screenshot or golden test.
5. Backup/import change → round-trip and rejection test.
6. Security/transport change → auth, pinning and replay test.
7. Localization → English/Spanish ARB parity and no widget literals.
8. Analyze, both test suites, format check and both platform builds.
9. Documentation and roadmap checkboxes updated.

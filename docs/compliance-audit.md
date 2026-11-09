# Compliance audit

Status: v0.5 baseline, audited 2026-11-09. This audit covers the project rules in
`AGENTS.md`, `CONTRIBUTING.md`, the public docs and the private scenario brief.
The private brief is reviewed locally; its details are not copied here.

## Verdict

The core promises are intact: offline-first storage, no accounts, no telemetry,
GPL-3.0-only, optional LAN/MCP, tested migrations and green builds. The project
is **not** v1.0-ready. The visual gap is closed in v0.6. The remaining gap is
feature completeness: the original v1.0 gate only covered the v0.5 surface. Real
scenario gaps remain in ICS, GymMane import, MCP tool coverage, work-hours
behavior, per-shift checklists, multi-day entries, persisted snapshots and
backup automation.

The completion work is in `docs/completion-plan.md`. The v0.6 M0 slice already
fixed Android cloud backup, the CI gap and the documentation claims; the
product/visual and feature work is the active program.

## Constraint status

| Constraint | Status | Evidence | Action |
|---|---|---|---|
| Offline core, no internet dependency | Pass | No cloud/HTTP client dependency in `pubspec.yaml`; core uses local SQLite; LAN/MCP services are behind settings | Keep |
| No accounts, email, password reset or cloud identity | Pass | Only local `identity_records`; PIN hash stored locally; no auth provider | Keep |
| Data ownership in SQLite, export first-class | Pass for core; auto backup pending | Drift schema, JSON export/import, file picker; Android cloud backup disabled in v0.6 | Add auto backup and older-schema import in v0.8 |
| Optional network only | Pass | `syncEnabled` and `mcpEnabled` default false; local plan works without peers | Keep, add tests for both-switch-off startup |
| GPL-3.0-only and attribution | Pass | `LICENSE`, `ADDITIONAL_TERMS.md`, `CREDITS.md`, About screen | Keep |
| Android + Linux both build | Pass at v0.5 | Debug APK and Linux debug pass locally; release workflow builds both | Add Linux build to the normal CI |
| No new dependency without reason | Pass | Existing stack only; no analytics/ads/Firebase/Supabase | Keep |
| Do not weaken tests or security | Pass | 85 app + 71 core tests; pairing/TLS/replay tests | Keep |
| Reference-first for components, styles, motion | Pass (v0.6) | Nunito, expanded `ManeColors`, `ManeType`, component themes, `lib/core/widgets` kit, floating shell and screen sweep; `test/visual_kit_test.dart` and `docs/screenshots/` | Keep |
| Reference map describes shipped state | Pass (v0.6) | `docs/reference-map.md` now names the shipped kit and the visual deviation | Keep |
| Every schema change has migration + real-row test | Pass | v1→v5 migration tests | Required again for v0.7/v0.9 schema work |
| Timezone behavior has DST/travel tests | Pass | Core time tests and widget/reminder tests | Keep for new features |
| Localization: English source, Spanish first | Pass for shipped screens | ARB parity and literal scanner tests | Extend for new surfaces |
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

### P1 — Real calendar files exceed the ICS subset

**Evidence:** `lib/features/import/ics_parser.dart` rejects `EXDATE`,
`RECURRENCE-ID`, ordinal `BYDAY`, `BYSETPOS`, negative `BYMONTHDAY`, timed events
over 24 hours and non-IANA `TZID` values. Re-import only deduplicates; it does not
update changed events.

**Impact:** Google/Microsoft calendar exports commonly use cancelled occurrences,
moved occurrences and Windows timezone identifiers. The user can lose the exact
events the planner exists to catch.

**Remediation (v0.7):** support exceptions, ordinal rules, alias mapping,
multi-day timed events and update-on-reimport; keep a documented subset and
report skips.

### P1 — GymMane read-only schedule integration is not shipped

**Evidence:** `features/import/companion_import.dart` accepts a generic JSON
shape. GymMane's actual backup format (`weeklyPlan`, `routines`, `trainAt`) is not
read. The private brief explicitly accepts a read-only export/provider.

**Impact:** the gym blocks the scenario needs are still manual entries, and the
companion-import promise is only partially met.

**Remediation (v0.8):** add a GymMane backup JSON adapter with dedupe, read-only
entries and documented behavior when the backup has no time of day.

### P2 — Per-shift checklist is keyed by pattern + date, not slot

**Evidence:** `ShiftChecklistCompletionRecords` primary key is
`{itemId, dateKey}`. Two slots of the same pattern on one date share completions.

**Impact:** a double shift cannot track two independent checklist runs. This
contradicts the scenario's "per shift, not per day" requirement.

**Remediation (v0.7):** add a slot/occurrence key, migrate existing rows as the
single-slot default, and add a two-slot independence test.

### P2 — Work-hours visibility is only "hide the whole Work space"

**Evidence:** `AppSettings.hideWorkSpace` filters Work from screens. There is no
work-hours window, quiet-hours notification suppression or per-space rule.

**Impact:** users either see all work all the time or hide Work entirely. Work
notifications can interrupt outside work hours.

**Remediation (v0.9):** work-hours visibility and quiet hours with notification
suppression, while explicit Work views remain available.

### P2 — LAN snapshots are in memory and disappear on restart

**Evidence:** `SyncService` keeps `_snapshots` in a map; no table or file stores
them. `SyncState` is rebuilt empty after launch.

**Impact:** the Devices page is empty until a peer is reachable again. The
"read-only snapshot" is not durable.

**Remediation (v0.9):** persist snapshots read-only, with schema migration,
retention and a test that a restart keeps the last snapshot.

### P2 — MCP covers only four tools and the core JSON-RPC surface

**Evidence:** `McpServer` exposes `personal.today`, `work.next_shifts`,
`home.shopping`, `plan.create`, `plan.complete`; no search, range listing, update,
delete, home inventory, tags or sleep. No streamable/session handling.

**Impact:** a desktop agent cannot use the planner as its full local data source,
which is one of the stated product goals.

**Remediation (v0.9):** full tool set, gated writes, streamable HTTP session
handling and tests.

### P2 — Multi-day entries and recurrence exceptions are incomplete

**Evidence:** the editor creates single-day items. The recurrence model has no
skip dates. The database has `endDateKey`, but the UI does not expose it
consistently.

**Impact:** holidays, trips, multi-day events and "skip this occurrence" are
awkward or impossible.

**Remediation (v0.7):** multi-day all-day/timed entries and recurrence
exceptions.

### P2 — No read-only calendar export

**Evidence:** ICS is import-only. The private brief prefers a read-only export
over a shared account when another person needs visibility.

**Impact:** sharing the calendar requires screenshots or access to the app.

**Remediation (v0.7):** export entries and shifts as a documented ICS file.

### P2 — Backup is manual and accepts only schema version 5

**Evidence:** `BackupService` validates `schemaVersion: 5`; no automatic backup
or rotation.

**Impact:** a lost phone loses everything unless the user remembers to export;
future schema changes will strand old files.

**Remediation (v0.8):** automatic local backups with rotation and an explicit
upgrade path for older versions.

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

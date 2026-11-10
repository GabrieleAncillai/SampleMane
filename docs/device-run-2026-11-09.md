# Mane device run — 2026-11-09

Real-device verification of the v1.0 checklist. This run found and fixed two
defects in the app-lock and notification paths, then found and fixed a CSV import
duplication bug. It did not finish the widget or OEM battery checks; those still
need the user's hands on the device.

## Device and build

| Item | Value |
|---|---|
| Device | HUAWEI MAR-LX3A (Huawei), EMUI 10.0.0.265 |
| Android | 10 / API 29 |
| Build | `0.9.0+9`, debug APK, application id `io.github.gabrieleancillai.mane` |
| Base commit | `68cbde8` (`docs: correct final test count`) |
| Fix commits | `fix: keep app lock above pushed routes`, `fix: deliver notification actions and keep snoozes`, `fix: dedupe CSV imports against existing entries` |
| Timezone | `America/Caracas`, `auto_time_zone=1` |
| Test data | Test-only entries, a test birthday, GymMane fixtures and a test PIN. No personal data is included in this log or the screenshots. |

The APK was rebuilt after the app-lock and notification fixes and again after the
CSV fix. The final APK passed the full validation listed at the end of this file
and was reinstalled before the final launch check.

## Results

| Checklist section | Result | Notes |
|---|---|---|
| 1. Install and first launch | PASS | Offline start, Personal/Work/Home, no sample rows, About shows 0.9.0, GPL-3.0-only and InlitX. |
| 2. Notifications | PASS (Android 13/12 paths N/A) | Delivery, grouping, tap closed/open, edit time, custom time, quiet-hours and work-hours suppression, snooze and complete all observed. Android 13 notification permission and Android 12 exact-alarm access do not exist on API 29. |
| 3. Reboot | FAIL — OEM limitation | The app's alarms survived in `scheduled_notifications.xml` but the app process did not start after reboot and no reminder fired. Opening Mane rebuilt exactly the two upcoming alarms with no duplicates. |
| 4. Battery optimization | BLOCKED | The app is whitelisted and in the active bucket, but the boot receiver still did not run. The exact EMUI App launch path and a restricted-bucket 30-minute test still need the user. |
| 5. Timezone | PASS | Madrid 10:00 became New York 4:00; the all-day birthday stayed on the same date; returning restored 10:00. The reminder epoch was unchanged and work/quiet windows used the new zone. |
| 6. LAN pairing and query | PASS (manual host/port) | mDNS is unavailable on this phone, so the documented host/port fallback was used. Pairing, read-only snapshot, offline persistence, airplane mode and unpair all behaved as specified. |
| 7. MCP | PASS | No-token 401; `initialize` returned a session; 17 tools; SSE one message; `DELETE /mcp` invalidated the session; read tools and all gated write tools exercised; linked shopping check increased inventory quantity. |
| 8. Widget | BLOCKED | Requires the user to long-press the home screen, add the Mane widget, tap it and check the resume refresh. |
| 9. Backup | PASS for JSON; CSV fixed | Schema 8 export/import restored the plan and excluded identity, pairing, app-lock and MCP secrets. Automatic backup created a daily copy. GymMane timed and all-day imports were read-only. CSV export worked; the first re-import exposed the duplication bug, which was fixed and re-tested (0 imported, 7 duplicates, 7 entries remained). |
| 10. App lock | PASS after fix | Enable, background, lockout, cold start, disable and backup-import leaving the lock off all verified. |

## Defects found and fixed

### App lock was bypassed by pushed routes

`AppLockGate` wrapped only `AppShell` in `MaterialApp.home`, so a route pushed
above the shell rendered above the PIN overlay. Backgrounding 35–45 seconds
while Settings was open resumed straight to Settings with no PIN prompt.

Fix: the gate is now in `MaterialApp.builder`, above the Navigator, and
`home: const AppShell()`. `AppLockGate` takes a `graceSeconds` parameter for
tests. A regression test unlocks, pushes a route, simulates pause/resume with
`graceSeconds: 0`, and asserts the PIN screen covers the pushed route.

Evidence: `36-cold-start-lock-fixed.png`, `40-lock-over-settings-fixed.png`,
`48-lockout-captured.png` ("Too many attempts. Wait 9s."). The normal two-Back
dismissal of the editor sheet was control-tested and is not a duplicate stack.

### Notification actions did nothing and snooze was wiped

`AndroidNotificationAction` defaulted to `showsUserInterface: false`, so the
buttons sent a broadcast to a receiver Mane does not declare. Both actions now
use `showsUserInterface: true`; the plugin's foreground path delivers the action
to `onAction` and cancels the notification.

The resume queue rebuild called `cancelAllPendingNotifications()`, which also
removed one-off snoozes. `NotificationService` now tracks `_scheduledIds` and
cancels only planner-owned IDs; `cancelAll()` still clears everything. The
timezone lookup was switched to the documented `timeZoneLocation()` helper, and
scheduling errors are logged instead of silently swallowed.

Regression test: `test/notification_actions_test.dart` asserts the foreground
path and that a resume rebuild keeps a scheduled snooze. Device evidence:
reminders fired at 20:05 and 20:10 and grouped (`31`, `32`, `34`, `35`); tap
while closed opened the editor (`52`); tap while open opened one editor (`58`);
editing the time replaced the old alarms; Snooze queued a new alarm about ten
minutes later; Mark complete checked the entry and cleared its alarms (`60`).

### CSV re-import duplicated the plan

Exporting entries to CSV and importing the same file into the same database
doubled the rows: 7 entries became 14, all duplicates with `source='csv'`. The
importer only checked `hasImportedEntry('csv', externalId)`, which searches
CSV-sourced rows and ignored ordinary and GymMane entries.

Fix: `AppDatabase.hasEntryLike(...)` matches a live entry by title, space, date,
all-day flag and both minute fields (null for all-day). `CsvInterchangeService`
uses it before inserting, so ordinary entries are covered as well as earlier
imports. A regression test exports two entries from a repository, imports the
same CSV into that repository, and asserts `imported == 0`,
`duplicates == row count` and an unchanged entry count.

Device re-test: the same 7-row CSV now reports **0 imported, 7 duplicates,
0 skipped**, and the database still has 7 live entries (0 CSV-sourced rows).
Evidence: `85-csv-settings.png`, `86-csv-import-sheet.png`,
`87-csv-import-report.png`. `83-csv-import.png` is the pre-fix reproduction
("7 imported, 0 duplicates").

## Reboot failure detail

Steps: schedule reminders 21:15 and 21:20; confirm they are queued; confirm the
boot receiver is declared; whitelist the app from battery optimization; enable
EMUI auto-launch; reboot. After boot the app process was absent, no alarm for
Mane existed and no notification fired. Opening Mane rebuilt exactly the two
upcoming alarms, with no duplicates.

Expected: the plugin's boot receiver restores the queued alarms and the reminder
fires while the app is closed. Actual: EMUI does not deliver `BOOT_COMPLETED` to
the app, so the receiver never runs. This is recorded as an OEM limitation, not
a pass. A dedicated `TIMEZONE_CHANGED` receiver is still not implemented; the
queue rebuilds on resume.

## MCP evidence

Loopback endpoint on `127.0.0.1:8765`, temporary harness against the Linux test
database, writes enabled.

- `initialize` returned `Mcp-Session-Id`; `tools/list` returned 17 tools.
- `DELETE /mcp` returned 204; a later call with that session returned
  `404 {"error":"unknown_session"}`.
- `plan.range` returned the seeded entry; `plan.search` returned the entry and
  the inventory item; `work.shifts`, `tags.list` and `sleep.window` returned
  valid empty/calculated results.
- `home.shopping_add` created a 3 L line linked to an inventory item with
  quantity 2; `home.shopping_check` changed the inventory quantity to 5 and set
  `lastPurchasedAt`.
- `plan.create/get/update/complete/uncomplete/delete` and
  `home.shopping_add/check` were exercised in the same session. SSE returned one
  JSON-RPC message per call. A request without the bearer token returned 401.

## Not run in this pass

- **Widget:** needs the user's launcher interaction.
- **OEM battery:** needs the exact EMUI path and a restricted-bucket reminder at
  least 30 minutes ahead.
- **Backup rotation:** the daily copy was observed; pruning older copies was not
  forced by changing the clock.
- **Shopping and inventory CSV on device:** covered by the unit round-trip test;
  the entry CSV path was re-tested on the device.
- **Android 13 notification permission and Android 12 exact-alarm access:** N/A
  on API 29. The Pixel 9 emulator baseline in `docs/device-checklist.md` covers
  those paths separately.
- **Accessibility/contrast:** separate v1.0 gate, not part of this run.

## Validation after the fixes

```
dart format --line-length 110 --output=none --set-exit-if-changed  # 144 files, 0 changed
flutter analyze --no-fatal-infos                                   # no issues
flutter test                                                       # 135 passed
(cd packages/mane_core && dart test)                               # 85 passed
flutter build linux --debug                                        # ok
JAVA_HOME=/usr/lib/jvm/java-21-openjdk flutter build apk --debug  # ok
```

The APK was reinstalled and launched; the final state shows the preserved plan
(`88-final-launch.png`).

## Screenshots

All files are in `docs/screenshots/device-run-2026-11-09/`. The numbers are the
capture order, not a claim that every frame is unique evidence.

- App lock: `36-cold-start-lock-fixed.png`, `40-lock-over-settings-fixed.png`,
  `47-lock-before-lockout.png`, `48-lockout-captured.png`,
  `49-unlocked-after-lockout.png`.
- Notifications: `31-notification-2005.png`,
  `32-notification-expanded.png`, `34-notification-2010.png`,
  `35-notification-group-expanded.png`, `43-after-snooze-fixed.png`,
  `50-notification-closed-app.png`, `52-tap-while-closed-opened.png`,
  `58-tap-while-open.png`, `60-mark-complete-rendered.png`.
- Reboot: `53-after-reboot.png`, `54-current-state.png`,
  `56-after-autolaunch-change.png`.
- Timezone: `63-madrid.png`, `64-madrid-entry-created.png`,
  `65-new-york.png`, `66-new-york-week.png`, `67-madrid-return.png`.
- LAN and pairing: `68-phone-identity.png` through `79-unpaired.png`.
- Backup: `80-backup-export.png`, `81-after-clear.png`,
  `82-backup-imported.png`, `83-csv-import.png` (pre-fix).
- CSV fix: `84-post-fix-launch.png`, `85-csv-settings.png`,
  `86-csv-import-sheet.png`, `87-csv-import-report.png`.
- Final launch: `88-final-launch.png`.
- Raw notification evidence: `alarms-before-delivery.txt`,
  `notification-channel.txt`.

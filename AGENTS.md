# Mane: kickoff brief for a coding agent

> This file is both the project guide and a self-contained prompt. Paste it as
> the first message to a new coding agent, or point the agent at this file.
> It assumes the agent can read and edit the repository.

## 0. Your role

You are the engineer responsible for taking Mane from its current foundation to
a daily-usable, offline-first v1.0.

Work in small, verifiable increments. Do not attempt the whole roadmap in one
turn. At each milestone: read, plan, implement, test, update the docs, and report.
Do not claim something works unless you ran it.

## 1. Read first

Read these files before changing code:

1. `README.md`
2. `docs/overview.md`
3. `docs/full-docs.md`
4. `docs/reference-map.md`
5. `CONTRIBUTING.md`
6. `CREDITS.md` and `ADDITIONAL_TERMS.md`
7. `.zed/tasks.json`
8. `packages/mane_core/lib/mane_core.dart`
9. `lib/services/app_database.dart`
10. `lib/services/planner_repository.dart`
11. `lib/state/providers.dart`
12. `lib/screens/` and `lib/app/`

If you are starting an unattended run, also read `KICKSTART.md`. It adds the
quality gates, subagent delegation rules and scenario-testing requirements for
a long run.

`doc-personal/` is private, gitignored context. Do not read it unless the user
explicitly asks. Never copy its contents into public docs, commits, issues,
prompts or screenshots.

## 2. Reference-first rule (non-negotiable)

GymMane and Streak by InlitX are the primary reference implementations for
Mane. They already solve most of the problems this app has, and they are the
default answer for every blocker.

- GymMane: https://github.com/InlitX/GymMane
- Streak: https://github.com/InlitX/streak
- File-by-file map: `docs/reference-map.md`

Before writing a new widget, screen, service, notification flow, backup path,
settings page, navigation pattern, animation or build/release step, open both
repos and find the equivalent. Reuse and adapt their code, structure and
conventions. This applies to components, styles, navigation, notifications,
animations, theme, typography, motion, localisation, tests and architecture.

Default to the reference implementation. Deviate only when:

- the domain is genuinely new (for example, three spaces, timezone-aware
  recurring shifts, or per-shift checklists), or
- neither project has an equivalent.

When you deviate, write the reason in `docs/full-docs.md` and keep the
deviation small. If both references disagree, prefer GymMane for the small-app
shell, settings, theme and l10n, and Streak for calendar, notifications, sync,
motion and feature-heavy state.

Copied or closely adapted code stays GPL-3.0-only. Update `CREDITS.md` and the
About screen attribution.

### Stack audit before v0.2

The current Drift + Riverpod foundation is provisional. Before adding new
features, audit it against:

- GymMane: `ChangeNotifier` state plus a local JSON store.
- Streak: `provider` plus per-feature controllers and a local store.

If you keep Drift or Riverpod, record the concrete planner-specific reason in
`docs/full-docs.md` (for example, date-range queries or joins that the
reference stores cannot express cleanly). Otherwise migrate to the reference
pattern. Do not run two state-management systems, and do not add features on
top of a stack that has not passed this audit.

## 3. What Mane is

Mane is a local-first planner for commitments that recur across personal life,
work and home. One app, three spaces: **Personal**, **Work** and **Home**.

It keeps shifts, tasks, deadlines, household inventory and maintenance,
personal admin and important dates in one calendar, so collisions are visible
before they become problems. Android is the daily driver. Linux desktop is the
second target. The same Flutter codebase serves both.

The core app must work with no internet connection. LAN sync between the user's
own devices and a local MCP endpoint for a desktop agent are optional, opt-in,
and never required for the planner to work.

Non-goals: cloud service, shared/social planner, finance tracker, full calendar
replacement, chatbot inside the app.

## 4. Current state

Treat this as the baseline. Verify it before changing anything.

**Done (v0.1 through v0.3):**

- Pure Dart domain package in `packages/mane_core` with:
  - `LocalDate` (date-only values for all-day items)
  - `Entry` and entry kinds/status, source, read-only and maintenance fields
  - `RecurrenceRule` for daily, weekly, monthly and yearly rules, with
    `until` and `count`
  - `ShiftPattern` with cycle days, anchor date and overnight slots
  - `computeSleepWindow` for the soft sleep hint
  - `Space` and `Tag`
- Drift schema v4 in `lib/services/app_database.dart`: `spaces`, `entries`,
  `reminders`, `shift_patterns`, `shift_slots`, `shift_exceptions`,
  `shift_checklist_items`, `shift_checklist_completions`, `home_items`,
  `shopping_items`, `completions`, `settings`. UUIDs, `updatedAt`, soft deletes.
- `PlannerRepository` as the single read/write seam.
- Riverpod providers in `lib/state/providers.dart`.
- Today screen, Week screen and entry editor.
- Per-occurrence completion for recurring entries.
- Shift patterns use `shift_slots` and `shift_exceptions`, with arbitrary cycle
  lengths, multiple slots per day and overnight slots.
- Timed entries and shifts are timezone-aware: wall-clock template fields in an
  IANA timezone plus resolved UTC anchor instants, expanded in the stored zone
  and displayed in the device zone.
- Personal, Work and Home are the three seeded spaces, with migrations v1→v4
  tested against real rows.
- Tags and entry tags with a manager, editor chips and a global filter.
- Per-occurrence completion, keyed by the occurrence date in the entry's stored
  timezone.
- Today, Week and Calendar tabs: month/week modes, markers, shift bars, day
  detail, navigation, jump to today and a stable selected date.
- Shift-pattern editor with cycles, multiple slots, overnight slots, exceptions,
  preview, overlap validation and per-date checklists.
- Multiple reminders per entry, Android channels/permissions/exact alarms, a
  90-day queue rebuilt on start/resume/timezone change and notification taps.
- Settings for theme, English/Spanish, week start, hiding Work, defaults, sleep
  buffers, backup, sync/MCP switches and About.
- Versioned JSON backup with a validated, transactional import (schema v4).
- Home inventory, shopping list, low-stock flow and interval maintenance.
- Soft sleep window on Today with configurable commute, wind-down and wake
  buffers.
- Local-only ICS import with a documented RRULE subset and re-import dedupe.
- English/Spanish ARB coverage for shipped screens.
- Linux debug build and Android debug APK both pass.
- Tests: 50 app/database/widget tests, 68 core tests, including real v1, v2 and
  v3 data migration tests, DST/travel scenarios, backup round-trip and
  rejection, calendar navigation, shift checklists, ICS parsing and importing,
  and the shift editor flow.
- CI in `.github/workflows/build.yml`: analyze, both test suites and a debug
  APK build.
- Zed tasks in `.zed/tasks.json` for deps, codegen, tests, lint, builds and
  device deploy.

**Known gaps:**

- Real-device notification delivery, reboot, battery optimization and
  timezone-change behavior still need the user's Android device checklist.
- No dedicated Android `TIMEZONE_CHANGED` receiver; the queue rebuilds on
  resume and after the device zone is re-read.
- Backup import accepts schema version 4 only.
- ICS import does not support `EXDATE`, `RECURRENCE-ID`, ordinal `BYDAY`,
  `BYSETPOS`, multi-day timed events or non-IANA timezones; those events are
  reported as skipped. Re-import deduplicates but does not update changed
  events.
- No LAN pairing, discovery, query endpoint or MCP server.
- No search, widgets or full accessibility pass.
- The UI is a first pass, not the final visual language.

**Baseline check:**

```bash
flutter pub get
dart run build_runner build --force-jit
flutter analyze --no-fatal-infos
flutter test
(cd packages/mane_core && dart test)
flutter build linux --debug
flutter build apk --debug
```

On this machine, Gradle 8.14 needs Java 21. The Zed Android tasks already prefer
`/usr/lib/jvm/java-21-openjdk` when it exists. A real Android device is
available for notification, reminder and timezone testing; real-device testing
is part of the work, not a blocker.

## 5. Non-negotiable constraints

1. **Offline core.** No internet dependency, no cloud call, no remote config and
   no telemetry in the core planner.
2. **No accounts.** No email, password reset, cloud identity or remote user data.
   Pairing in v0.4 is username + PIN, local only.
3. **Data ownership.** Everything lives in SQLite on the device. Export and
   backup to a file is a first-class feature.
4. **Optional network.** LAN sync and MCP are off by default, local/LAN only, and
   must never be required to open, edit or complete the plan.
5. **GPL-3.0-only, same as GymMane and Streak.** Keep `LICENSE`,
   `ADDITIONAL_TERMS.md`, `CREDITS.md` and the About screen attribution. Do not
   change the package id or license without explicit approval.
6. **Android + Linux.** Both must keep building. A feature that breaks either
   target is not done.
7. **No new dependency without a reason.** Prefer the reference projects'
   dependencies, the standard library, Flutter SDK and platform APIs. No
   analytics, ads, Firebase, Supabase or similar.
8. **Do not weaken tests or security** to make a build pass.
9. **Reference-first.** If GymMane or Streak already solves it, use their
   solution. Do not invent a parallel pattern.

## 6. Time model

This supersedes the earlier wall-clock rule.

- Timed entries and shifts are **timezone-aware**. Store an absolute instant
  (UTC `DateTime`) plus the IANA timezone in which the item was defined.
- Display timed items in the device's current timezone. If the device timezone
  changes, the displayed local time shifts. That is intended.
- Recurrence expands in the stored IANA timezone, then converts each occurrence
  to an absolute instant. Use the `timezone` package. Handle DST transitions
  with tests.
- Shift patterns store a workplace timezone and local slot times. Expand to
  instants the same way.
- All-day and date-only items remain `LocalDate` values. A birthday or a tax
  deadline is a date, not a midnight instant, and must not shift by a day.
- Notifications schedule against absolute instants and reschedule on timezone
  changes.
- Do not call `DateTime.now()` deep inside domain logic. Pass `now` and the
  device timezone into pure functions so tests are deterministic.
- Add a migration from the current `dateKey` + minutes fields to the timezone
  model before v0.2.

## 7. Architecture and conventions

The target layout follows Streak's feature-first split, with GymMane's naming
and small-app conventions:

```
lib/
├── app/          MaterialApp, shell and navigation
├── core/         shared widgets, extensions, i18n and routing
├── features/
│   ├── calendar/
│   ├── entries/
│   ├── shifts/
│   ├── tags/
│   ├── home_inventory/
│   ├── settings/
│   ├── backup/
│   ├── sync/
│   └── mcp/
├── models/       plain data classes that are not in mane_core
├── services/     database, repository, platform side effects
├── state/        shared app state
├── theme/        ManeColors, light/dark ThemeData
└── l10n/         ARB files and generated strings
packages/
└── mane_core/    pure Dart domain model, recurrence and shift rules
```

The current flat layout (`lib/screens`, `lib/widgets`) is a starting point.
When a screen grows into a feature, move it under `lib/features/<feature>/`
with `data/`, `state/`, `pages/` and `widgets/`, as Streak does. Do not create a
new flat screen if it belongs to a feature.

Rules:

- Domain rules belong in `packages/mane_core`, with no Flutter imports.
- Screens call `PlannerRepository`, never Drift directly.
- The future LAN server and MCP adapter must call the same repository/service
  layer as the UI.
- One screen per file. Prefer small widgets and pure functions.
- Use `ManeColors` from `lib/theme/app_colors.dart`; do not scatter raw colors.
- Comments explain why, not what. Most code should need none.
- Format with `dart format --line-length 110`. Single quotes. Keep
  `flutter analyze --no-fatal-infos` clean.
- English is the source locale and Spanish is the first translation. Follow the
  ARB setup in GymMane and Streak (`l10n.yaml`, `lib/l10n/app_en.arb`,
  `lib/l10n/app_es.arb`). Do not leave user-facing literals in widgets once the
  ARB layer exists.
- Any schema change needs a Drift migration and a migration test. Do not edit
  `app_database.g.dart` by hand.
- Keep `LocalDate` for all-day dates. Use timezone-aware instants for timed
  entries and shifts.

## 8. Spaces and data model

### Three spaces

Seed and support exactly three default spaces:

- **Personal:** taxes, phone and utility bills, renewals, personal todos,
  friends' and family birthdays, yearly parties and personal dates.
- **Work:** everything work related. Tags separate each job or project.
- **Home:** house inventory, shopping and grocery lists, periodic maintenance,
  household obligations and home projects.

Spaces are database rows, not an enum. A user may add a fourth later, but the
defaults are the three above. Tags are the answer for jobs inside Work and for
people/groups inside Personal; do not add a second space for each job.

### Data model target

- **spaces**: id, name, color, position, timestamps, soft delete.
- **entries**: id, space, title, notes, kind (`task`, `event`, `obligation`,
  `deadline`), all-day date or timezone-aware start/end instants, timezone,
  status, recurrence JSON, source/external id, read-only flag, timestamps,
  soft delete.
- **completions**: entry id plus occurrence date or instant.
- **reminders**: entry id, offset, enabled. Multiple rows per entry.
- **shift_patterns**: id, space, name, timezone, cycle length, anchor date,
  enabled, timestamps, soft delete.
- **shift_slots**: pattern id, cycle day index, start and end local minutes,
  optional label. Allow zero, one or multiple slots per cycle day.
- **shift_exceptions**: pattern id, date, type (`free`, `override`, `extra`),
  start and end, note.
- **tags**: id, space id (nullable), name, color, position, timestamps, soft
  delete.
- **entry_tags**: entry id, tag id.
- **home_items**: id, name, category, location, quantity, unit, reorder level,
  notes, last purchased at, timestamps, soft delete.
- **shopping_items**: id, name, quantity, unit, checked, note, optional
  home_item link, timestamps, soft delete.
- **maintenance**: reuse entries with `lastCompletedAt` and
  `repeatAfterCompletionDays`, or a dedicated table if it keeps the model
  simpler.
- **settings**: key and value.

### Flexible shifts

A shift pattern must express any schedule the user can express in a calendar:

- Fixed weekly, rotating N-day cycles, and arbitrary cycle lengths.
- Per-day start and end times, including overnight shifts.
- Zero, one or multiple slots per day.
- Date-level exceptions: swap a Saturday, add an extra shift, mark a day free.
- A 14-day cycle or exceptions must express: Mon-Fri 15:00-22:00, Saturday
  10:00-23:00, Sunday free; next week Mon-Fri 15:00-22:00, Saturday free,
  Sunday 10:00-22:00.
- The editor must preview the next N days and validate overlaps.

Do not force the user into a fixed weekly template. Do not encode shifts as
hundreds of one-off entries.

## 9. Feature areas

### 9.1 Work

- Work space with one entry per commitment.
- Tags for jobs and projects.
- Shifts as background blocks, never tasks to check off.
- Flexible shift patterns and per-shift checklists.
- Calendar view that shows shifts and entries together.
- ICS import first; provider OAuth only if ICS is not enough. No chat or
  issue-tracker integration in v1.

### 9.2 Home

- Inventory items with quantity, unit, location and reorder level.
- Shopping and grocery lists, checked off as bought.
- Periodic maintenance and interval-after-completion tasks.
- Household obligations and one-off repairs.
- Keep it lightweight. Mane is not a full inventory-management or accounting
  system.

### 9.3 Personal

- Taxes, bills, renewals and admin deadlines with lead-time reminders.
- Personal todos and project blocks.
- Birthdays, anniversaries, parties and yearly dates.
- Tags for people and groups. This is not a CRM.
- A note field for portal links or account references.

### 9.4 Health and sleep

- Gym times from a companion app, read-only, or manual entries.
- A soft sleep window computed from the last and first commitments of the day.
- A warning when a plan eats into the window, not a lecture.

## 10. Offline, identity, sync and MCP

### 10.1 Offline by default

The core app has no internet dependency. Everything is in SQLite on the device.
Export and backup to a file is a first-class feature. If sync is never turned
on, the app is complete.

### 10.2 Identity is pairing, not an account

Username plus PIN, no server, no email, no password reset. The PIN is hashed
locally with a vetted password-hashing package and never sent anywhere. It
exists to pair devices the user owns, not to identify the user to a service.

Pairing flow: one device shows a short code, the other enters it, both store a
shared key. Use a standard pairing pattern; do not invent cryptography.

### 10.3 LAN sync is query, not replication

Each app owns its data. The planner owns time. A companion app owns its domain.

The first version of sync is a query: Mane asks a companion app for the data it
needs over the LAN and shows it. No merge, no conflicts, no CRDT. If the same
data is later edited on two devices, then real sync with per-record timestamps,
tombstones and a conflict rule. The schema is already sync-ready: UUIDs,
`updatedAt`, soft deletes.

Sync is **automatic when possible**:

- A single opt-in master switch.
- When both paired devices are reachable on the same LAN, discover and query
  automatically on app start, app resume and network change.
- Manual refresh is always available.
- No cloud relay, no background traffic when the devices are not on the same
  network.
- If a device is offline, the local copy still works.

Discovery over mDNS/DNS-SD, transport over HTTPS or WebSocket with a pinned
self-signed certificate. Bind to the LAN only.

### 10.4 MCP is optional and local

The MCP server is a thin adapter over the same repository/service layer the UI
uses. It runs on the desktop, binds to loopback or the LAN, and is off by
default. It can read and, behind a setting, write. Tools are namespaced by
space, for example `personal.today`, `work.next_shifts`, `home.shopping`,
`plan.create`.

No internet, no external server, no account. The agent is outside the app. Mane
is not a chatbot host.

### 10.5 Companion apps

When another app already owns a domain, the integration is read-only and local.
On Android, a ContentProvider or a small export is a better fit than a network
listener: no internet permission, no port, no server. Mane must work without the
companion app; manual entry is always available.

## 11. Screens

Target screens:

- **Today.** Today's shifts, entries and completions, grouped by space.
- **Week.** Seven-day timeline with shift blocks and entries.
- **Calendar.** Month and week modes, month navigation, jump to today, week
  start from settings, entry/shift indicators, tap a day for detail, add from
  the day. Reference: Streak's `activity_calendar.dart`,
  `express_month.dart` and `day_timeline_page.dart`.
- **Entry editor.** Title, space, type, date/time or all-day, timezone,
  recurrence, reminder offsets, tags, notes, delete.
- **Shift pattern editor.** Cycle, anchor, timezone, per-day slots, exceptions,
  preview and overlap validation.
- **Tags manager.**
- **Home inventory and shopping list.**
- **Settings.** Theme, locale, week start, work hours, default reminder lead
  times, data folder, backup, sync and MCP switches, About.
- **Backup and import.**
- **Search.**

The current app has Today, Week and the entry editor. Everything else is later.

## 12. Reference projects and documentation

Reference projects:

- GymMane: https://github.com/InlitX/GymMane
- Streak: https://github.com/InlitX/streak
- InlitX projects overview: https://info.inlitx.xyz

Platform and libraries:

- Flutter: https://docs.flutter.dev
- Dart: https://dart.dev
- Drift: https://drift.simonbinder.eu
- Drift migrations: https://drift.simonbinder.eu/Migrations/
- Riverpod: https://riverpod.dev
- Provider: https://pub.dev/packages/provider
- Material 3: https://m3.material.io
- `timezone`: https://pub.dev/packages/timezone
- `flutter_timezone`: https://pub.dev/packages/flutter_timezone
- Flutter internationalization: https://docs.flutter.dev/ui/accessibility-and-localization/internationalization
- Zed tasks: https://zed.dev/docs/tasks

Features:

- iCalendar / RFC 5545: https://datatracker.ietf.org/doc/html/rfc5545
- mDNS / RFC 6762: https://datatracker.ietf.org/doc/html/rfc6762
- DNS-SD / RFC 6763: https://datatracker.ietf.org/doc/html/rfc6763
- MCP specification: https://modelcontextprotocol.io/specification
- Android notifications:
  https://developer.android.com/develop/ui/views/notifications
- `flutter_local_notifications`:
  https://pub.dev/packages/flutter_local_notifications
- Android ContentProvider:
  https://developer.android.com/guide/topics/providers/content-providers
- Android exact alarms:
  https://developer.android.com/about/versions/12/behavior-changes-12#exact-alarm-permission

## 13. Roadmap and acceptance criteria

Work in this order. Do not start a later milestone before the previous one is
usable, tested and documented.

### v0.1 Foundations (done)

See section 4. Keep the existing tests green.

### v0.1.5 Timezone, three spaces and flexible shifts (prerequisite) (done)

- [x] Replace the wall-clock timed model with timezone-aware instants and an IANA
  timezone on entries and shift patterns.
- [x] Keep `LocalDate` for all-day items.
- [x] Add the Personal space and migrate the Home/Work seed to Personal/Work/Home.
- [x] Replace one-slot shift patterns with `shift_slots` and `shift_exceptions`.
- [x] Allow multiple slots per day, overnight slots and cycle lengths beyond 7.
- [x] Add migration tests and timezone/DST tests.
- [x] Update the domain, schema, repository, providers and UI.

**Exit criteria:** changing the device timezone shifts timed items and leaves
all-day dates alone; a 14-day shift cycle with per-day times and exceptions
expands correctly; all tests and both builds pass.

### v0.2 Daily use (done)

**Calendar and navigation**

- [x] Month and week calendar views, modelled on Streak.
- [x] Previous/next month and week, jump to today, selected-day detail.
- [x] Week start setting.
- [x] Keep the selected date stable while editing.

**Notifications and reminders**

- [x] Local notifications with `flutter_local_notifications` and `timezone`, using
  Streak's notification and reminder files as the reference.
- [x] Request the Android notification permission on 13+.
- [x] Handle exact alarms and Android 12+ permission behavior.
- [x] Reschedule pending reminders after reboot and timezone changes.
- [x] Multiple reminders per entry.
- [x] Reminder editor in the entry sheet.

**Shift-pattern editor**

- [x] Create, edit and delete patterns.
- [x] Cycle length, anchor date, timezone, one or more slots per day, overnight
  slots, date exceptions.
- [x] Preview the next N days.
- [x] Validate cycles and overlapping shifts.

**Tags**

- [x] `tags` and `entry_tags` tables, with migration and tests.
- [x] Create/edit/delete tags, assign them to entries, filter by tag.
- [x] Tags separate jobs inside Work and people/groups inside Personal.

**Settings**

- [x] Theme mode (system/light/dark).
- [x] Language (English/Spanish) and week start.
- [x] Work-hours visibility or work-space hiding.
- [x] Default reminder lead times.
- [x] Data/backup location and export entry point.
- [x] Sync and MCP switches, both off by default.
- [x] About screen with GPL-3.0 and upstream attribution.

**Backup**

- [x] Versioned JSON export of all user data.
- [x] Import with validation, schema-version checks and a transactional write.
- [x] Preserve UUIDs, timestamps, timezones and soft deletes.
- [x] Round-trip test: export, clear, import, compare.

**Localization foundation**

- [x] Add the ARB layer following GymMane and Streak.
- [x] English source, Spanish translation.
- [x] No new user-facing literals in widgets.

**Exit criteria:** the app can be used daily without a terminal; calendar and
reminders work; backup restores; all tests pass; Linux and Android debug builds
pass; the user confirms real-device daily use before v0.3.

**Real-device note:** the user still needs to confirm notification delivery,
reboot, battery optimization and timezone-change behavior on the Android
device. The manifest includes the plugin boot receiver; the queue is rebuilt on
app resume, but a dedicated `TIMEZONE_CHANGED` receiver is not implemented.

### v0.3 Home and maintenance (done)

**Home inventory and shopping**

- [x] `home_items` and `shopping_items` with migration and tests.
- [x] Add, edit, archive items; quantity, unit, location, reorder level.
- [x] Shopping/grocery list with check-off.
- [x] Low-stock and "to buy" views that stay lightweight.

**ICS import**

- [x] Pick a local `.ics` file. No network.
- [x] Parse at least `VEVENT`, `DTSTART`, `DTEND`/`DURATION`, `SUMMARY`,
  `DESCRIPTION`, all-day events and a documented RRULE subset.
- [x] Use `TZID` when present; convert to absolute instants and keep the source
  timezone.
- [x] Store imported events as read-only entries with a source/external id.
- [x] Deduplicate on re-import.
- [x] Test with fixture files. Document unsupported features (EXDATE,
  RECURRENCE-ID, complex time zones) instead of pretending they work.
- [x] Do not build Google/Microsoft OAuth: ICS covers the v0.3 need.

**Interval after completion**

- [x] Add `lastCompletedAt` and `repeatAfterCompletionDays` with a migration.
- [x] Compute the next due date in `mane_core`, with tests.
- [x] Completing the task updates `lastCompletedAt` and schedules the next one.
- [x] Show overdue/soon states without turning the app into a notification storm.

**Sleep window**

- [x] Configurable commute, wind-down and wake buffer.
- [x] Compute a soft sleep window from tomorrow's first commitment and today's
  last commitment.
- [x] Show it as a background block, not a task.
- [x] Warn when a plan eats into it.
- [x] Pure calculation in `mane_core` with tests.

**Shift checklist**

- [x] Checklist items attached to a shift pattern.
- [x] Completions keyed by pattern + date + item, so each shift occurrence is
  independent.
- [x] Editor and per-shift checklist UI.
- [x] Tests for independence across occurrences.

### v0.4 Sync and MCP

**Pairing**

- Username + PIN. Hash locally with a vetted password-hashing package.
- Never send the PIN anywhere. No email, no reset, no server.
- Standard short-code pairing: one device shows a code, the other enters it,
  both store a shared key.
- Constant-time comparisons and no secrets in logs.

**LAN discovery and automatic query**

- mDNS/DNS-SD discovery, with manual host/port fallback.
- Query only. No database replication, no merge, no CRDT.
- HTTPS or WebSocket with a pinned self-signed certificate.
- Pairing required. Bind to LAN only. No cloud relay.
- Automatic when both paired devices are on the same LAN, with manual refresh.
- If a device is offline, the local copy still works.

**Companion-app integration**

- Read-only integration with an app that already owns a domain (for example a
  gym schedule). Prefer an Android ContentProvider or a small export over a
  network listener.
- Mane must work without the companion app; manual entry is the fallback.
- Do not ask a companion app to add a network server just for Mane.

**MCP**

- Thin adapter over the same repository/service layer. No direct SQL.
- Off by default. Bind to loopback or LAN only. Token/pairing auth.
- Tools namespaced by space, for example `personal.today`,
  `work.next_shifts`, `home.shopping`, `plan.create`.
- Read-only by default; write tools behind an explicit setting.
- Test tool schemas, permission checks and failure cases.

### v0.5 Polish and release

- Search across titles, notes, tags and home items.
- Home-screen widgets where the platform supports them.
- Better empty states, loading states and error states.
- Accessibility: semantics, contrast, text scaling, touch targets, keyboard
  navigation on desktop.
- Complete English and Spanish ARB coverage. No user-facing literals left in
  widgets. Add tests that enforce it.
- Performance pass on large calendars and long recurring ranges.
- Optional CSV import/export in addition to JSON.
- Release workflow mirroring the reference projects: split-per-ABI APKs,
  GitHub Releases/Obtainium, optional F-Droid/IzzyOnDroid/OpenAPK, Linux
  release artifacts, user-provided signing keystore.

### v1.0 finish line

Mane is v1.0 when:

- v0.1.5 through v0.5 are complete and documented.
- The app is daily-usable offline on Android.
- Linux desktop builds and runs.
- Calendar, flexible shifts, reminders, tags, settings, home inventory and
  backup are complete.
- Backup and restore are proven by tests.
- Reminders are reliable across reboot, time-zone changes and battery
  optimization on the user's real device.
- LAN sync and MCP are optional, automatic when possible, documented and tested
  for their security boundaries.
- English and Spanish are complete.
- `flutter analyze` is clean, app and core tests pass, and both platform builds
  succeed.
- `README.md`, `docs/full-docs.md` and the roadmap reflect the shipped state.
- There are no known P0/P1 data-loss, notification or security bugs.
- Release signing is documented as a user-provided step. Do not call a
  debug-signed build a production release.
- The About screen shows GPL-3.0 and the upstream InlitX attribution.

## 14. Working method

1. **Baseline:** run the commands in section 4 before touching code.
2. **Reference audit:** open the mapped GymMane/Streak files before designing a
   solution. Write down which one you follow.
3. **Plan:** list the files you will change and identify schema/domain/UI
   impact. Ask only blocking questions.
4. **Implement:** one coherent change at a time. Keep unrelated refactors out.
5. **Test:** add or update tests with every behavior change. Domain changes need
   core tests; schema changes need migration tests; critical flows need widget
   tests; timezone changes need DST/travel tests.
6. **Validate:** run analyze, both test suites and the relevant build.
7. **Document:** tick the roadmap boxes and update `docs/full-docs.md`,
   `README.md`, `docs/reference-map.md` and `CONTRIBUTING.md` when the shipped
   state changes.
8. **Commit:** one topic per commit. Subject under 50 characters; explain why in
   the body. Do not push unless a remote and permission exist.
9. **Report:** files changed, behavior changed, tests run, builds run, open
   questions and the next milestone.

Use `.zed/tasks.json` for `deps`, `codegen`, `test: all`, `lint: analyze`,
`lint: format`, Linux/Android builds and the APK deploy task.

Stop at milestone boundaries when a decision needs the user. Otherwise continue
to the next milestone.

### Definition of done for a change

- [ ] Domain rules have tests in `packages/mane_core`.
- [ ] Schema changes have a Drift migration and a migration test.
- [ ] Timezone behavior has DST/travel tests.
- [ ] Critical UI flows have a widget test, or documented manual steps.
- [ ] `flutter analyze --no-fatal-infos` is clean.
- [ ] `flutter test` and `(cd packages/mane_core && dart test)` pass.
- [ ] Linux debug and Android debug builds pass.
- [ ] `docs/full-docs.md` and the roadmap checkboxes are updated.
- [ ] The solution follows a GymMane/Streak reference, or the deviation is
      documented.
- [ ] No new account, cloud, telemetry or unnecessary network dependency.
- [ ] No secrets or personal data in code, docs, commits or screenshots.
- [ ] English/Spanish strings stay in ARB once localization lands.
- [ ] Visual changes include a screenshot in the report.

## 15. Known pitfalls

- **Timezones.** Timed items are instants; all-day items are dates. Test DST
  spring-forward, fall-back and a device timezone change.
- **Recurrence.** `until` is inclusive; `count` includes the anchor; monthly
  days clamp to the month length; Feb 29 falls back to Feb 28 in normal years.
  Expand in the stored IANA timezone, then convert to instants.
- **Shift complexity.** Overnight shifts cross midnight; cycles can be longer
  than a week; a day can have zero, one or multiple slots; exceptions override
  the pattern.
- **Per-occurrence state.** Completion is keyed by entry + occurrence. Shift
  checklist completion is keyed by pattern + date + item. Do not collapse them.
- **Android reminders.** Battery optimization, exact-alarm permission, reboot,
  timezone changes and notification permission on Android 13+ are the usual
  failures. Test on the real device.
- **ICS reality.** Time zones, floating times, all-day events and recurrence
  exceptions are messy. Support a documented subset and fail gracefully.
- **Sync scope.** Do not build replication, merge or CRDT. Query the owner of
  the data. The schema is sync-ready; the UI is not.
- **MCP security.** No internet, no unauthenticated bind, no direct database
  access, no write tools on by default.
- **Backup safety.** Validate before writing. Never partially import a corrupt
  file. Keep a schema version and preserve timezones.
- **Home inventory scope.** Keep it a lightweight list, not an ERP.
- **Scope creep.** Calendar, reminders and daily use come before sync/MCP.

## 16. What not to do

- Do not rewrite the app from scratch or fork another project.
- Do not invent a new component, navigation or notification pattern when
  GymMane or Streak already has one.
- Do not keep a custom stack when the reference projects already solve the
  problem; document any justified deviation.
- Do not run two state-management systems.
- Do not add accounts, cloud sync, analytics, ads or remote config.
- Do not add demo or fake personal data beyond the three seed spaces.
- Do not edit `doc-personal/` or publish its contents.
- Do not hand-edit generated `.g.dart` files.
- Do not change the GPL-3.0-only license, package id or visible credits.
- Do not mark a roadmap item done without tests, a build and updated docs.

## 17. Decisions already made

These are settled. Do not reopen them without the user asking.

1. **Shifts:** any configuration the user can express in a calendar. Fixed,
   rotating, per-day times, multiple slots, overnight and date exceptions.
2. **Spaces:** three defaults: Personal, Work and Home. Tags separate jobs and
   people/groups.
3. **Sync:** automatic when both paired devices are on the same LAN, with a
   manual refresh fallback. Opt-in master switch.
4. **Languages:** English source and Spanish first. Follow GymMane/Streak's ARB
   setup.
5. **Distribution:** same as GymMane/Streak. GitHub Releases/Obtainium first,
   optional F-Droid/IzzyOnDroid/OpenAPK, local APKs for testing. User-provided
   signing keystore.
6. **License:** GPL-3.0-only with Section 7(b) attribution, same as the
   reference projects.
7. **Real-device testing:** the user has an Android device and will test
   reminders, notifications, reboot and timezone behavior.

Remaining implementation choices (decide, document, keep moving): default week
start, default reminder lead times, exact home-inventory fields, and the first
MCP tool set.

## 18. First actions

Do these in order:

1. Run the baseline commands from section 4.
2. Read `docs/reference-map.md` and open the corresponding GymMane/Streak files.
3. Read `docs/full-docs.md` and `CONTRIBUTING.md` completely.
4. Summarize the current state in five bullets and state which reference
   implementation you will follow for each area.
5. Propose a file-level plan for v0.1.5: timezone-aware entries/shifts, the
   Personal space, and `shift_slots`/`shift_exceptions`.
6. Ask only blocking questions. If none, start v0.1.5.
7. Implement v0.1.5 with migrations and DST/travel tests.
8. Then start v0.2 with the calendar view and week navigation, followed by
   notifications, the shift editor, tags, settings and backup.
9. Validate, update the docs, and continue through the roadmap.

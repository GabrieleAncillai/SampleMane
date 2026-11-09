# Mane: full docs

Status: v0.8, data interchange, home tracking and privacy. Last updated
2026-11-09. The active completion program is in
[completion-plan.md](completion-plan.md); the constraint audit is in
[compliance-audit.md](compliance-audit.md).

This is the long version. The short version is in [overview.md](overview.md).
The file-by-file map of the reference projects is in
[reference-map.md](reference-map.md). Nothing in this document is more important
than the app being useful.

## 1. What Mane is

A personal planner for the week and month as they actually happen. One app,
three spaces: Personal, Work and Home.

It has to hold work shifts, house inventory and maintenance, personal admin,
relationship and family dates, health commitments, project deadlines and sleep,
without turning into a project management tool. It works offline. It syncs only
on the user's own LAN, automatically when both devices are reachable, and only
if that is turned on. It can expose a local MCP endpoint for a desktop agent,
also optional.

The design target is not "a better todo list". It is a calendar that can show
two domains at once: *the late shift is on Thursday, and the anniversary dinner
is the same evening*.

## 2. One app, three spaces

An earlier version of this plan had HomeMane and WorkMane as two apps, and then
one app with Home and Work spaces. The current decision is one app with three
spaces:

- **Personal:** taxes, phone and utility bills, renewals, personal todos,
  friends' and family birthdays, yearly parties and personal dates.
- **Work:** everything work related. Tags separate each job or project.
- **Home:** house inventory, shopping and grocery lists, periodic maintenance,
  household obligations and home projects.

The reason is the collision. The useful moment is not "show me work tasks" or
"show me home tasks". It is the overlap between them. Separate apps cannot show
that, and separate apps would recreate the same fragmentation the planner is
meant to fix, only with nicer icons.

The maintenance reason is just as important. One app means one repository, one
release pipeline and one set of shared rules. Spaces are database rows, not an
enum, so a fourth space is a data change rather than a migration.

Tags are the answer for jobs inside Work and for people/groups inside Personal.
Do not add a second space for each job.

## 3. The week it has to survive

The app is built around load, not around an ideal week. It has to handle:

- **Shift work.** Fixed weekly shifts or a rotation, including overnight shifts.
  A shift is a block, not a task. Times can differ by day and by week, and a
  date can be swapped or given as an exception.
- **Flexible work.** Deadlines, meetings and focus blocks that move. Consistency
  matters more than a fixed schedule.
- **Home.** Bills, groceries, cleaning, inventory and maintenance that is due
  "N months after the last service" rather than on a calendar date.
- **Personal.** Taxes, renewals, appointments, personal todos, birthdays,
  anniversaries and yearly events. Planning often has to start weeks before the
  date.
- **Health.** Gym times, appointments and a sleep window that survives late
  shifts.
- **Projects.** Time reserved for work that only moves when it is given time.
- **Admin.** Renewals, taxes, insurance and other deadlines that do not announce
  themselves.

Anything described as "when I remember" is what the app is for.

## 4. Problems and features, area by area

### 4.1 Work: shifts, jobs and checklists

**Problem.** Work life is split across calendars, chat, issue trackers and
memory. Flexible work blurs into home time. Shift work repeats a checklist every
shift, with no way to see whether it was actually done. A user with several jobs
needs to separate them without creating a new app.

**What the app should do.**

- A Work space with one entry per commitment.
- Tags for jobs or projects, so the week can be filtered by context.
- Shifts as background blocks. A shift is not a task and is not checked off.
- A shift pattern that can express any schedule the user can put in a calendar:
  fixed weekly, rotating N-day cycles, arbitrary cycle lengths, per-day start
  and end times, multiple slots per day, overnight shifts, and date exceptions.
- A checklist template per shift. Completion is per shift occurrence, not per
  template item, so today's checks do not mark tomorrow's as done.
- Calendar read, ICS first. Provider OAuth later, only if ICS is not enough.
  No chat or issue-tracker integration in v1.

**Current state.** Manual entries, today and week views, per-occurrence
completion for recurring things. The shift-pattern engine and editor are built
and tested, including cycles, multiple slots per day, overnight slots and date
exceptions. A pattern can carry a checklist, and each shift date stores its own
completions. Read-only ICS import is shipped with a documented RRULE subset.

**Shift example.** A 14-day cycle or per-date exceptions must express:

- Week 1: Mon-Fri 15:00-22:00, Saturday 10:00-23:00, Sunday free.
- Week 2: Mon-Fri 15:00-22:00, Saturday free, Sunday 10:00-22:00.

Do not force the user into a fixed weekly template. Do not encode shifts as
hundreds of one-off entries. The editor must preview the next N days and
validate overlaps.

**Open.** None for v1. Checklist items live in `shift_checklist_item_records`,
and completions are keyed by item and shift date in
`shift_checklist_completion_records`.

### 4.2 Home: inventory, shopping and maintenance

**Problem.** Some obligations are monthly, some are weekly, and some are due
relative to the last time they were done. A fixed date drifts the moment the
work happens early or late. Household items, groceries and spare parts are
usually tracked in a separate list or not at all.

**What the app should do.**

- Household inventory: item name, category, location, quantity, unit, reorder
  level and notes.
- Shopping and grocery lists: check items off as bought, optionally link to an
  inventory item.
- Low-stock and "to buy" views that stay lightweight.
- Periodic maintenance and repairs.
- Three shapes of obligation:
  1. Fixed calendar recurrence: rent, utility bills, subscriptions.
  2. Interval after completion: service the boiler every 6 months after the
     last service.
  3. One-off with a date: an inspection, a repair, a delivery.

The current model handles all three. `home_item_records` and
`shopping_item_records` cover inventory and the shopping list; checking a
linked line updates the household quantity and last-purchased time, and
unchecking reverses it. `lastCompletedAt` plus `repeatAfterCompletionDays` on an
entry covers interval maintenance, and completing the task advances its date
from the day it was actually done.

**Not this.** A full inventory-management or accounting system. A lightweight
list that answers "what do we have, what is missing, what needs service" is the
target.

### 4.3 Personal: admin, dates and people

**Problem.** Taxes, bills, renewals and important dates do not announce
themselves. People remember the date and forget the planning around it. A
birthday, anniversary or visit usually needs a booking, a gift or a free
evening, and all of that has to start earlier than the day itself.

**What the app should do.**

- Recurring obligations and annual deadlines with lead-time reminders.
- A note field for the portal link or account reference.
- Yearly recurring dates with more than one reminder: 30 days before, 7 days
  before, 1 day before. The point is time to act.
- A way to mark a small group of dates as "partner", "family" or "friends". A
  tag is enough; this is not a CRM.
- An optional daily reminder to reach out, not a task to check off.
- Personal todos and project blocks.

**Current state.** Multiple reminders per entry, yearly dates, tags and a
global tag filter are shipped. The Personal space carries admin and people
dates.

**Not this.** A shared account or a couples planning app. If another person
needs visibility, a read-only calendar export is a better answer than shared
editing.

### 4.4 Health and sleep

**Problem.** Gym time is the first thing dropped when a shift runs late, and
sleep is the first thing cut.

**What the app should do.**

- Gym times from a companion app, read-only. Not workout logs, just schedule
  blocks.
- A sleep window per day: latest bedtime from tomorrow's first commitment,
  earliest wake time from today's last commitment plus commute and wind-down.
  Shown as a soft block, not a task.
- A warning when a plan eats into the window, not a lecture.

**Current state.** The Today screen shows a soft sleep window computed from
today's last timed end and tomorrow's first timed start, with configurable
commute, wind-down and wake buffers. It warns when the plan leaves no gap. It is
a background hint, never a task or a notification. Manual gym entries work;
companion-app integration is still later and read-only.

### 4.5 Personal projects and startups

**Problem.** Consistency. The boards already exist; another board is not the
answer. What is missing is reserved time and deadlines that show up before they
are urgent.

**What the app should do.**

- Deadlines and a weekly review block.
- A project tag, so the amount of the week spent on self-directed work is
  visible.
- No issue-tracker integration in v1. If it happens, read-only deadlines, not
  two-way sync.

## 5. Time, offline, identity, sync and MCP

### 5.1 Timezone-aware by default

This supersedes the earlier wall-clock model and is implemented in v0.1.5.

- Timed entries and shift patterns store the wall-clock template (`dateKey`,
  `startMinute`, `endMinute` or slot minutes) in an IANA `time_zone`, plus the
  resolved UTC anchor instants (`start_at`, `end_at`) for range work and sync.
- Display timed items in the device's current timezone. If the device timezone
  changes, the displayed local time and possibly the displayed date shift. That
  is intended.
- Recurrence expands in the stored IANA timezone, then converts each occurrence
  to an absolute instant. `packages/mane_core` owns that rule; the database only
  supplies rows and completions.
- Shift patterns store a workplace timezone and local slot times, then expand
  to instants the same way. Exceptions are applied before expansion.
- All-day and date-only items remain `LocalDate` values. A birthday or a tax
  deadline is a date, not a midnight instant, and must not shift by a day.
- The viewer timezone is passed into every expansion and display function. A
  list of occurrences carries both `date` (stored zone) and `displayDate`
  (viewer zone), so travel never loses per-occurrence completion.
- Notifications schedule against absolute instants and reschedule on app
  start, resume and timezone change.
- Do not call `DateTime.now()` deep inside domain logic. The app reads
  `nowProvider` and `deviceTimeZoneProvider`; pure functions take both.

The v0.1.5 migration reads the device IANA zone at open time, interprets legacy
wall-clock rows and one-slot shift patterns in that zone, and backfills the
instants. Migration tests use a fixed zone so they stay deterministic.

Known limitation: the device timezone is re-read on resume, but a dedicated
Android `TIMEZONE_CHANGED` receiver is not implemented. A zone change while the
app is not running is picked up the next time it starts or resumes.

### 5.2 Offline by default

The core app has no internet dependency. Everything is in SQLite on the device.
Export and backup to a file is a first-class feature, not an afterthought. If
sync is never turned on, the app is complete.

### 5.3 Identity is pairing, not an account

Username plus PIN, no server, no email, no password reset. The PIN is hashed
locally with PBKDF2-HMAC-SHA256 (210,000 iterations, 16-byte random salt) and is
never sent anywhere. It exists to unlock pairing on the device, not to identify
the user to a service.

Each device also generates a self-signed RSA-2048 TLS certificate on first use.
Peers pin its SHA-256 fingerprint. The private key, PIN hash and pairing secrets
live in `identity_records` and `paired_device_records`, which are deliberately
excluded from JSON backups.

Pairing flow:

1. One device opens a five-minute pairing session and shows a six-digit code.
   Five failed attempts close the session.
2. The other device fetches the host's certificate fingerprint and derives a
   short-lived key from the code and **both** fingerprints with PBKDF2
   (150,000 iterations). A man-in-the-middle with a different certificate
   cannot produce the matching HMAC.
3. The guest sends a random 32-byte shared key inside AES-256-GCM under that
   pairing key, plus an HMAC over the binding message. The host verifies the
   MAC, stores the key, and returns an HMAC acknowledgement under the new key.
4. Every later request is signed with HMAC-SHA256 over method, path, timestamp,
   nonce and body hash. The server accepts a five-minute clock window and keeps
   a per-device nonce cache to reject replays.

Unpairing removes the row locally; the other device keeps its own copy. There
is no account to delete and no password-reset channel. The PIN is a local
gate, not a defense against someone holding the unlocked device.

### 5.4 LAN sync is query, not replication

Each app owns its data. The planner owns time. A companion app owns its own
domain.

Sync is a query: Mane asks a paired device for the data it needs over the LAN
and shows a read-only snapshot. It never merges rows, resolves conflicts or
writes into the remote database. The schema stays sync-ready (UUIDs,
`updatedAt`, soft deletes), but replication and CRDTs are not part of v0.4.

Shipped transport and discovery:

- mDNS/DNS-SD advertisement and browsing through Bonsoir (`_mane._tcp`), with a
  manual host and port fallback when the platform daemon is unavailable.
- HTTPS with the device's pinned self-signed certificate. The server binds to
  the LAN and uses an ephemeral port; only paired devices with a valid HMAC
  signature can query.
- Read-only resources: `summary` (today's plan and next shifts), `entries`,
  `shifts`, `spaces`, `tags`, `home` and `shopping`. Date ranges are capped at
  366 days.
- A single opt-in master switch. When it is on, the app starts the server and
  discovery on launch, refreshes on resume, refreshes when mDNS reports a peer,
  and polls every five minutes. Manual refresh is always available.
- Snapshots are kept in memory and shown on the Devices page. If a device is
  offline, the local plan keeps working and the device shows its last error.
- No cloud relay, no background traffic when the devices are not on the same
  network, and no write path from one device to the other.

### 5.5 MCP is optional and local

The MCP endpoint is a thin adapter over `PlannerRepository`, never over SQL. It
is off by default, binds to `127.0.0.1:8765` only, and requires a random bearer
token stored with the local identity.

It speaks JSON-RPC 2.0 over `POST /mcp` and implements `initialize`, `ping`,
`tools/list`, `tools/call` and the client `notifications/*` messages. Read tools
are always available; write tools appear only when the setting is on:

- `personal.today`, `work.next_shifts`, `home.shopping` (read).
- `plan.create`, `plan.complete` (write, gated).

No internet, no external server, no account. The agent runs on the same
machine. SSE/streamable sessions and a LAN-bound MCP listener are not part of
this version; this is the core tools JSON-RPC surface, documented as such.

### 5.6 Companion apps

When another app already owns a domain, the integration is read-only and
local. Mane ships a small JSON export import for that case: the user picks a
file, chooses a space, and the rows become read-only entries with
`source = 'companion'`. The format is documented in
[companion import](#companion-export-format) below and tested with fixtures.
There is no network listener, no permission request and no background service.

Mane works without the companion app; manual entry and ICS import remain
available. A ContentProvider client is not shipped because no specific
companion app and authority were named; the export path is the v0.4 answer.

#### Companion export format

The companion export format is deliberately small:

```json
{
  "app": "companion",
  "events": [
    {
      "id": "gym-1",
      "title": "Gym",
      "date": "2026-11-09",
      "startMinute": 1080,
      "endMinute": 1140,
      "timeZone": "Europe/Madrid",
      "notes": "Leg day"
    },
    {"id": "off", "title": "Day off", "date": "2026-11-11", "allDay": true}
  ]
}
```

`id` is optional; without it the importer derives a stable fallback key. Invalid
rows are counted as skipped. Re-importing the same file deduplicates by id and
does not update changed rows.

## 6. Data model (target)

The migration path is v1 → v2 → v3 → v4 → v5 → v6. The shipped schema has the
shape below, including tags, home items, shopping items, per-slot shift
checklists, shift tags, per-pattern sleep buffers and the local pairing identity.

- **spaces**: id, name, color, position, timestamps, soft delete. Seeded with
  Personal, Work and Home. Spaces are rows, not an enum.
- **entries**: id, space, title, notes, kind (`task`, `event`, `obligation`,
  `deadline`), all-day `LocalDate` or timezone-aware start/end instants,
  timezone, status, recurrence JSON, source/external id, read-only flag,
  `last_completed_at`, `repeat_after_completion_days`, timestamps, soft delete.
  The wall-clock `dateKey`, `startMinute` and `endMinute` are the recurrence
  template; `start_at` and `end_at` are the resolved UTC anchor instants.
  An entry uses either a recurrence rule or a completion interval, never both.
- **completions**: entry id plus occurrence date in the entry's stored
  timezone. This is what makes a recurring chore checkable per occurrence.
  Checking this week's bins does not check next week's, and travel does not
  lose the check.
- **reminders**: entry id, offset in minutes, enabled. Multiple rows per entry.
- **shift_patterns**: id, space, name, timezone, cycle length in days, anchor
  date, enabled, timestamps, soft delete.
- **shift_slots**: id, pattern id, cycle day index, start and end local
  minutes, optional label. Zero, one or multiple slots per cycle day are
  allowed; an end past 1440 crosses midnight.
- **shift_exceptions**: id, pattern id, date, type (`free`, `override`,
  `extra`), start and end, note. A free day wins over other exceptions for the
  same date; override replaces the cycle slots; extra adds to them.
- **tags**: id, space id (nullable), name, color, position, timestamps, soft
  delete.
- **entry_tags**: entry id, tag id.
- **home_items**: id, name, category, location, quantity, unit, reorder level,
  notes, last purchased at, timestamps, soft delete.
- **shopping_items**: id, name, quantity, unit, checked, note, optional
  home_item link, timestamps, soft delete. Checking a linked item adds its
  quantity to the inventory and stamps `lastPurchasedAt`; unchecking reverses
  the change.
- **shift_checklist_items**: id, pattern id, label, position. They belong to a
  pattern, not to an entry.
- **shift_checklist_completions**: checklist item id, the shift date in the
  pattern's timezone and a stable slot key. Two slots on one date keep
  independent ticks; legacy v5 rows are migrated to the first slot of the date.
- **shift_pattern_tags**: pattern id plus tag id, the same join shape as entry
  tags. The global tag filter applies to shifts as well as entries.
- **maintenance**: reuse entries with `lastCompletedAt` and
  `repeatAfterCompletionDays`. Completing one records a completion row and
  advances the date from the day it was actually completed.
- **settings**: key and value.
- **identity_records**: one local row with the device id and name, username,
  PBKDF2 salt and hash, self-signed certificate PEM, private key PEM and MCP
  token. Never included in a backup.
- **paired_device_records**: remote device id, name, username, pinned
  certificate fingerprint, shared key, last host and port, last seen. Never
  included in a backup.

Recurrence rules support daily with an interval, weekly by ISO weekday with an
interval, monthly on a day (clamped to the month length), and yearly (February 29
falls on February 28 in normal years). `until` is inclusive. `count` counts the
anchor as the first occurrence. Expand in the stored timezone, then convert to
instants. The pure functions live in `packages/mane_core`; the database calls
them instead of reimplementing them.

This is not a full RFC 5545 implementation. It is the subset the app can explain
and test. Ordinal rules ("last Friday of the month") can be added later without
migrating existing data.

## 7. Screens (target)

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
- **Search.** Global search over entry titles and notes, tag names and household
  items, with grouped results.
- **Android home-screen widget.** Today's plan and the next shift at a glance.

The app now has Today, Week and Calendar tabs, the entry editor, the tags
manager, the shift-pattern editor with checklists, settings, About,
backup/import, ICS and companion import, home inventory, the shopping list, the
Devices and pairing pages, the local MCP page and global search. An Android
home-screen widget shows today's plan.

## 8. Platform, stack, architecture and references

Flutter 3.38 and Dart 3.10, one codebase for Android and Linux desktop. Drift
over SQLite for storage, Riverpod for state, Material 3 for the UI.

GymMane and Streak by InlitX are the primary references for this project. They
already solve most of the problems Mane has, and they are the default answer for
every blocker. Before writing a new widget, screen, service, notification,
backup path, settings page, animation or build step, open the equivalent in
both repos and reuse or adapt it. The mapping is in
[reference-map.md](reference-map.md).

This applies to architecture and conventions too:

- GymMane is the reference for the small-app shell, settings, theme, l10n and
  simple screens.
- Streak is the reference for calendar, notifications, sync, motion and
  feature-first state.
- If both disagree, pick the one closer to the task and document the choice.
- If neither has an equivalent, the domain is new. Design it, test it, and
  record the deviation here.

**Stack audit (before v0.2): keep Drift and Riverpod.** GymMane's single
`ChangeNotifier` plus local JSON store and Streak's `provider` plus Hive boxes
are a good fit for their domains, but the planner needs date-range queries,
a join between entries and per-occurrence completions, and a transactional
backup import. Drift gives those directly, and the generated schema is what
makes the v1 to v2 migration test possible. Riverpod's provider overrides keep
`now`, the device timezone and the database injectable in tests. Mane will not
run a second state-management system; feature state stays in Riverpod
providers, and the repository seam stays the only read/write path. The feature
folder split from Streak is still the target layout; files move there when a
screen grows, not as a rewrite.

The target layout follows Streak's feature-first split, with GymMane's naming:

```
lib/
├── app/          MaterialApp, shell and navigation
├── core/         shared widgets, extensions, i18n and routing
├── features/     calendar, entries, shifts, tags, home_inventory, settings,
│                 backup, sync, mcp
├── models/       plain data classes that are not in mane_core
├── services/     database, repository, platform side effects
├── state/        shared app state
├── theme/        ManeColors, light/dark ThemeData
└── l10n/         ARB files and generated strings
packages/
└── mane_core/    pure Dart domain model, recurrence and shift rules
```

The current flat `lib/screens` and `lib/widgets` layout is a starting point.
When a screen grows into a feature, move it under `lib/features/<feature>/` with
`data/`, `state/`, `pages/` and `widgets/`, as Streak does.

English is the source locale and Spanish is the first translation. Follow the
ARB setup in GymMane and Streak: `l10n.yaml`, `lib/l10n/app_en.arb`,
`lib/l10n/app_es.arb` and a generated `AppLocalizations`. Do not leave
user-facing literals in widgets once the ARB layer exists.

Mane is GPL-3.0-only, the same as GymMane and Streak. Keep the license, the
additional attribution terms and the About screen credit. If code is copied or
closely adapted, add the upstream attribution to `CREDITS.md` and the About
screen.

Release distribution follows the references: GitHub Releases and Obtainium
first, optional F-Droid/IzzyOnDroid/OpenAPK, local APKs for testing. Split the
APK per ABI. Release signing is a user-provided keystore step; a debug-signed
build is not a production release.

## 9. Roadmap and checklists

These are not promises with dates. They are the order of work.

### v0.1 Foundations (done)

- [x] Pure Dart domain model: spaces, entries, recurrence, shift patterns.
- [x] Recurrence engine with tests: daily, weekly, monthly, yearly, until, count.
- [x] Shift pattern engine with tests, including overnight shifts.
- [x] Drift schema: spaces, entries, completions, reminders, shift patterns,
      settings.
- [x] Seed Home and Work.
- [x] Today and Week screens.
- [x] Add, edit, soft-delete entries.
- [x] Per-occurrence completion for recurring entries.
- [x] Linux desktop build.
- [x] Android debug build.

### v0.1.5 Timezone, three spaces and flexible shifts (prerequisite) (done)

- [x] Replaced the wall-clock timed model with timezone-aware instants and an
      IANA timezone on entries and shift patterns.
- [x] Kept `LocalDate` for all-day items.
- [x] Added the Personal space and migrated the seed to Personal/Work/Home.
- [x] Replaced one-slot shift patterns with `shift_slots` and
      `shift_exceptions`.
- [x] Allowed multiple slots per day, overnight slots and cycle lengths beyond
      7.
- [x] Added migration tests and timezone/DST tests.
- [x] Updated the domain, schema, repository, providers and UI.

**Exit criteria met:** changing the viewer timezone shifts timed items and
leaves all-day dates alone; a 14-day shift cycle with per-day times and
exceptions expands correctly; all tests and both builds pass.

**Deviation from the references:** GymMane and Streak both use wall-clock
`DateTime` values for schedules and reminders. Neither has timezone-aware
recurrence, flexible shift cycles, multiple slots per day or shift exceptions.
Mane implements those rules in `mane_core` (`src/time.dart`, `src/entry.dart`,
`src/entry_expander.dart`, `src/shift_pattern.dart`) because the planner is the
product's core domain. The references remain the source for the app shell,
theme, settings, notifications and release work.

### v0.2 Daily use (done)

**Calendar and navigation**

- [x] Month and week calendar views, modelled on Streak.
- [x] Previous/next month and week, jump to today, selected-day detail.
- [x] Week start setting.
- [x] Keep the selected date stable while editing.

**Notifications and reminders**

- [x] Local notifications with `flutter_local_notifications` and `timezone`.
- [x] Android notification permission on 13+.
- [x] Exact alarms and Android 12+ permission behavior.
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

- [x] ARB layer following GymMane and Streak.
- [x] English source, Spanish translation.
- [x] No new user-facing literals in widgets.

**Exit criteria:** the app can be used daily without a terminal; calendar and
reminders work; backup restores; all tests pass; Linux and Android debug builds
pass; the user confirms real-device daily use before v0.3.

**Shipped in v0.2:** Today, Week and Calendar tabs; month/week calendar with
per-space markers and shift bars; selected-day detail; week-start setting;
tags with links, manager, chips and a global filter; shift-pattern editor with
preview and overlap validation; multiple reminders per entry; Android channels,
permissions, exact/inexact fallback, boot receiver and a 90-day queue rebuilt on
start, resume and timezone change; theme, language, hiding Work, default
reminders, backup, sync/MCP switches and the About screen; versioned JSON
backup with a transactional import; English/Spanish ARB coverage. Tests cover
calendar navigation, week start, tag links, reminder arithmetic and DST,
backup round-trip and rejection, schema v1→v3 and v2→v3 migrations, and the
shift editor flow.

**Remaining v0.2 limitation:** real-device notification delivery, reboot,
battery optimization and timezone-change behavior need the user's Android
device checklist. The app rebuilds the queue on resume; a dedicated Android
`TIMEZONE_CHANGED` receiver is not implemented.

### v0.3 Home and maintenance (done)

- [x] `home_items` and `shopping_items` with migration and tests.
- [x] Add, edit and archive items; quantity, unit, location, reorder level.
- [x] Shopping/grocery list with check-off.
- [x] Low-stock and "to buy" views.
- [x] Read-only ICS import.
- [x] Interval-after-completion maintenance tasks.
- [x] Sleep window calculation.
- [x] Shift checklist.
- [x] Calendar provider OAuth: not built, because the documented ICS subset
      covers the v0.3 need. Revisit only if real files prove insufficient.

**Shipped in v0.3:** schema v4 with `home_item_records`,
`shopping_item_records`, `shift_checklist_item_records` and
`shift_checklist_completion_records`, plus `source`, `external_id`,
`read_only`, `last_completed_at` and `repeat_after_completion_days` on entries;
a v3→v4 migration tested against real rows; home inventory, shopping list and
low-stock-to-shopping flow; interval maintenance that advances from the actual
completion date; a configurable sleep window on Today; per-date shift
checklists in the pattern editor and day detail; and a local-only ICS importer
for multiple `VEVENT`s with `UID`, `SUMMARY`, `DESCRIPTION`, `DTSTART`,
`DTEND`, `DURATION`, `TZID`, UTC/floating times, all-day dates and an RRULE
subset (daily, weekly, monthly, yearly with `INTERVAL`, `COUNT`, `UNTIL` and
weekly `BYDAY`). Unsupported events are reported, not guessed.

**ICS limitations:** `EXDATE`, `RECURRENCE-ID`, ordinal `BYDAY` (for example
`1MO`), `BYSETPOS`, `BYHOUR`, `BYMINUTE`, events longer than 24 hours and
non-IANA `TZID`s are not supported; such events are counted as skipped. A
re-import deduplicates by UID, or by date/time/summary when UID is missing, but
does not update an event that changed in the source file.

**Deviation from the references:** neither GymMane nor Streak has home
inventory, ICS import, interval maintenance, a sleep window or shift checklists.
These are planner-specific domains and are implemented in `mane_core`
(`src/sleep.dart`), the repository and the `home_inventory`, `import` and
`shifts` feature folders. The app shell, settings rows and localization still
follow the reference patterns.

### v0.4 Sync and MCP (done)

- [x] Username and PIN pairing.
- [x] mDNS discovery.
- [x] LAN query endpoint.
- [x] Automatic query when both paired devices are on the same LAN.
- [x] Read-only companion-app integration through a documented local export.
- [x] MCP read-only tools.
- [x] MCP write tools behind a setting.

**Shipped in v0.4:** schema v5 with `identity_records` and
`paired_device_records` (both excluded from backups); PBKDF2 PIN hashing;
self-signed pinned TLS; a six-digit, five-minute, five-attempt pairing session
bound to both certificate fingerprints with AES-GCM key wrapping; signed HTTP
queries with a five-minute clock window and a nonce replay cache; Bonsoir mDNS
advertisement and browsing with a manual address fallback; automatic refresh on
launch, resume, discovery and a five-minute timer; a Devices page with identity
setup, host/guest pairing and read-only snapshots; a local MCP endpoint with a
bearer token, JSON-RPC `initialize`/`tools/list`/`tools/call`, read tools and
gated write tools; and a read-only companion JSON export import.

**Limitations:** the MCP endpoint is loopback-only and implements the core
tools JSON-RPC surface, not SSE/streamable sessions. mDNS depends on the
platform daemon (Avahi on Linux, NSD on Android) and still needs the user's real
device check. Pairing sessions live in memory, so an app restart cancels them.
Snapshots are not persisted and are never merged into the local plan. The
export importer does not update a companion row that changed after the first
import. A ContentProvider client is not shipped because no companion app and
authority were specified.

**Deviation from the references:** neither GymMane nor Streak has LAN pairing,
mDNS query, MCP or a companion export import. Their only sync is a shared-folder
backup exchange. Mane implements the v0.4 transport in `lib/features/sync` and
`lib/features/mcp` using standard TLS pinning, HMAC and PBKDF2 rather than a
new cryptographic protocol. The settings shell and page structure still follow
the reference projects.

### v0.5 Polish and release (done)

- [x] Search across entry titles and notes, tags and home items.
- [x] Home-screen widget on Android, with today's plan and the next shift.
- [x] Better empty, loading and error states on Today, Week, Calendar and
  search.
- [x] Accessibility: calendar and shift semantics, text scaling in the
  calendar, tooltips on icon actions and keyboard shortcuts for search and tab
  switching on desktop.
- [x] Complete English and Spanish ARB coverage, enforced by a test that rejects
  new user-facing literals in widgets.
- [x] Performance: count-limited recurrence now computes its ordinal in constant
  time, with a long-range regression test.
- [x] Release workflow: split-per-ABI APKs, a Linux bundle, checksums, a signed
  GitHub release and documented keystore secrets.

**Shipped in v0.5:** global search in `features/search`; an Android widget with
`home_widget`, a Kotlin `ManeTodayWidgetProvider` and a static layout; error
banners on the calendar and week; localized semantics for calendar days and
shifts; `Ctrl+F` and `Ctrl+1..3` shortcuts; ARB parity plus a literal-scanner
test; an O(1) recurrence ordinal; `.github/workflows/release.yml` and
`docs/release.md` for signing and distribution.

**Remaining v0.5 items:** real-device notification delivery, reboot, battery
optimization and timezone changes still need the user's Android checklist.
Everything shipped in v0.5 is tested and documented, but v1.0 has a wider scope.

### v0.6 Visual foundation and truth pass (done)

- [x] Bundle the reference font family and a real type scale.
- [x] Apply `ManeColors` through `context.mc` and add component themes.
- [x] Port the shared UI kit and the reference-style shell.
- [x] Sweep every shipped screen to use the kit.
- [x] Add shell/component smoke or golden tests.
- [x] Correct the reference map and screenshots.

**Shipped in v0.6:** Nunito and the `ManeType` scale; a hand-authored palette
with space, state, glass, nav and shadow tokens; component themes for app bar,
cards, sheets, dialogs, snack bars, navigation, buttons, inputs, chips, switches,
date and time pickers; the `lib/core/widgets` kit (`SoftCard`, `AppSheet`,
`SectionLabel`, `Pressable`, `TinySwitch`, `GlassSurface`, `AppEmptyState`,
`ManeNotice`, `FadeThrough`, `ManePage`, `ManeNavBar`, `ManeSegmented`,
`ManeSearchField`); the dotted paper background; the floating shell; the screen
sweep; `test/visual_kit_test.dart`; and `docs/screenshots/`.

**Deviation from the references:** Mane keeps GymMane's Nunito, warm palette,
round cards and settings rows, and Streak's floating nav, sheet motion and type
hierarchy. It does not copy GymMane's photo/dot background picker or Streak's
three selectable nav designs; those are product options Mane does not ship. The
result is the adapted reference language, not a new visual identity.

### v0.7 Calendar, recurrence and shift completeness (done)

- [x] Day timeline with shift background blocks.
- [x] Multi-day entries and recurrence exceptions.
- [x] Tagged shifts and per-slot checklist keys.
- [x] Read-only ICS export, per-pattern sleep buffers and real-file ICS hardening.

**Shipped in v0.7:** a 24-hour Day mode in Calendar (shifts behind entries,
all-day chips, now line, per-shift checklists); multi-day all-day and timed
entries including overnight tails; `skipDates`, moved/time-changed occurrences,
ordinal weekdays, negative month days and `BYSETPOS`; an editor for end dates,
skip and only-this-occurrence; tagged shift patterns with a shift-aware global
filter; schema v6 with per-slot checklist keys and real v5 row migration;
per-pattern commute/wind-down sleep overrides; read-only ICS export; and ICS
import support for `EXDATE`, `RECURRENCE-ID`, Windows TZIDs, multi-day timed
events and update-on-reimport.

### v0.8 Data interchange, home tracking and privacy

- [ ] GymMane schedule import, automatic local backups and CSV.
- [ ] Inventory adjustments, shopping grouping and a maintenance view.
- [ ] Optional local PIN app lock.

### v0.8 Data interchange, home tracking and privacy (done)

- [x] GymMane schedule import, automatic local backups and CSV.
- [x] Inventory adjustments, shopping grouping and a maintenance view.
- [x] Optional local PIN app lock.

**Shipped in v0.8:** schema v7 adds manual shopping order
(`shopping_item_records.position`) and a lightweight `home_purchase_records`
table, with a real v6-row migration. `features/import/gymmane_import.dart` reads
GymMane's `weeklyPlan` / `routines` / `trainAt`, writes read-only weekly blocks
to Personal, deduplicates by routine and weekday, and falls back to all-day
blocks when GymMane has no time. `features/backup/auto_backup_service.dart`
writes one JSON copy per day into the app support folder, rotates to the
configured count and leaves manual export as the canonical path. Backup import
now upgrades schemas 3 through 7 by treating missing lists and fields as empty
defaults; schema 1–2 are rejected. App-lock secrets are device-local and never
exported. `features/export/csv_interchange.dart` exports and imports entries,
shopping and inventory with quoting, dedupe and explicit reports. Shopping is
grouped by the linked item's category/location with clear-bought and manual
reorder; inventory has ±1 adjustment, the existing low-stock card and a
purchase-history sheet; maintenance has a due/upcoming page with one-tap
completion. `features/app_lock` adapts Streak's PIN pad to the Mane kit and
reuses the PBKDF2 PIN primitive, with a 30-second resume grace and a 30-second
lockout after five misses.

**Limitations:** GymMane import accepts the JSON payload (`gymmane.json`) rather
than reading the backup zip directly, ignores GymMane's `planMoves` per-date
overrides, and uses a one-hour block because GymMane stores no duration.
Automatic backups run on app start/resume, so a device that never leaves a
foreground session may wait; manual export still exists. A forgotten app-lock
PIN has no recovery code: clearing app data is the only reset, and the lock is
therefore opt-in. CSV import deduplicates by title/date/start for entries and
by name for shopping/inventory; it does not merge changed rows.

**Deviation from the references:** Streak's lock includes biometrics and a
recovery code; Mane ships only the local PIN, because the planner must stay
account-free and portable. GymMane has no import consumer for another app's
weekly plan, so the read-only adapter is planner-specific. The backup rotation
follows GymMane's `auto_backup.dart`, but writes a plain JSON document because
Mane's backup is already canonical and readable.

### v0.9 MCP, LAN sync and notification reliability

- [ ] Full MCP tool set and streamable HTTP sessions.
- [ ] Persistent read-only LAN snapshots and a richer query payload.
- [ ] Work-hours visibility, quiet hours, custom reminder times and actions.

### v1.0 finish line

Mane is v1.0 when v0.1.5 through v0.9 are complete, every generalized scenario in
[completion-plan.md](completion-plan.md) passes, the visual layer follows the
references or documents a deviation, the real-device checklist passes, and
`flutter analyze`, both test suites, the format check and both platform builds
succeed. v0.5 is shipped; v0.6 through v1.0 are the active program.

## 10. Contributing

Mane is open source under GPL-3.0-only. Pull requests are welcome. Read
[CONTRIBUTING.md](../CONTRIBUTING.md) before starting. If you are a coding agent,
start from [AGENTS.md](../AGENTS.md), the self-contained project brief. Before
building anything, check [reference-map.md](reference-map.md) for the equivalent
GymMane or Streak implementation.

Two rules never bend:

1. No accounts, logins or remote user data.
2. No network in the core. LAN sync and MCP are opt-in and local.

Anything that keeps working in flight mode is fair game.

## 11. Decisions

These are settled. Do not reopen them without the user asking.

1. **Calendar:** a month/week calendar is a first-class screen, modelled on
   Streak.
2. **Spaces:** three defaults: Personal, Work and Home. Tags separate jobs and
   people/groups.
3. **Time:** timed entries and shifts are timezone-aware instants. All-day items
   remain date-only.
4. **Shifts:** any configuration expressible in a calendar: fixed, rotating,
   per-day times, multiple slots, overnight and date exceptions.
5. **Sync:** automatic when both paired devices are on the same LAN, with a
   manual refresh fallback. Opt-in master switch.
6. **Languages:** English source and Spanish first, following GymMane/Streak's
   ARB setup.
7. **Distribution:** GitHub Releases/Obtainium first, optional
   F-Droid/IzzyOnDroid/OpenAPK, local APKs for testing. User-provided signing
   keystore.
8. **License:** GPL-3.0-only with Section 7(b) attribution, same as the
   reference projects.
9. **Real-device testing:** the user has an Android device and tests reminders,
   notifications, reboot and timezone behavior.

Remaining implementation choices: default week start, default reminder lead
times, exact home-inventory fields and the first MCP tool set. Decide, document
and keep moving.

## 12. Credits

GymMane and Streak by InlitX are the primary references for this project and the
reason the app follows its structure. They are GPL-3.0-only. If code is copied
or closely adapted, the license stays GPL-3.0-only and the attribution stays
visible. See [CREDITS.md](../CREDITS.md) and
[ADDITIONAL_TERMS.md](../ADDITIONAL_TERMS.md).

Built with Flutter, Drift, Riverpod and Material 3.

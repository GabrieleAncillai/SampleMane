# Mane: full docs

Status: v0.1, foundations. Last updated 2026-11-08.

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
completion for recurring things. Fixed weekly shifts can be entered as recurring
events. The shift-pattern engine is built and tested; its editor is a later
screen.

**Shift example.** A 14-day cycle or per-date exceptions must express:

- Week 1: Mon-Fri 15:00-22:00, Saturday 10:00-23:00, Sunday free.
- Week 2: Mon-Fri 15:00-22:00, Saturday free, Sunday 10:00-22:00.

Do not force the user into a fixed weekly template. Do not encode shifts as
hundreds of one-off entries. The editor must preview the next N days and
validate overlaps.

**Open.** How to model a shift checklist without making the data model ugly.
The working idea is checklist items attached to a shift pattern, with
completions keyed by pattern, date and item.

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

The current model handles 1 and 3. Shape 2 needs `lastCompletedAt` plus
`repeatAfterCompletionDays` on the entry, or a separate maintenance task type.
It should not be faked with a fixed date.

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

**Current state.** Yearly dates with one reminder. Multiple reminders are
already in the schema; the UI is later. Tags are later.

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

**Current state.** Manual gym entries. Companion-app integration is later and
does not block anything.

**Later.** Sleep windows need configurable commute and wind-down per job. Ship
the simple planner first.

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
- Notifications schedule against absolute instants and reschedule when the
  timezone changes. That lands with notifications in v0.2.
- Do not call `DateTime.now()` deep inside domain logic. The app reads
  `nowProvider` and `deviceTimeZoneProvider`; pure functions take both.

The v0.1.5 migration reads the device IANA zone at open time, interprets legacy
wall-clock rows and one-slot shift patterns in that zone, and backfills the
instants. Migration tests use a fixed zone so they stay deterministic.

Known limitation: the device timezone is read at app start. Changing it while
the app is open takes effect on the next start until v0.2 adds resume-time
refresh and notification rescheduling.

### 5.2 Offline by default

The core app has no internet dependency. Everything is in SQLite on the device.
Export and backup to a file is a first-class feature, not an afterthought. If
sync is never turned on, the app is complete.

### 5.3 Identity is pairing, not an account

Username plus PIN, no server, no email, no password reset. The PIN is hashed
locally with a vetted password-hashing package and never sent anywhere. It
exists to pair devices the user owns, not to identify the user to a service.

Pairing flow, when it exists: one device shows a short code, the other enters it,
both store a shared key. Use a standard pairing pattern; do not invent
cryptography.

### 5.4 LAN sync is query, not replication

Each app owns its data. The planner owns time. A companion app owns its own
domain.

The first version of sync is a query: Mane asks a companion app for the data it
needs over the LAN and shows it. No merge, no conflicts, no CRDT. If the same
data is later edited on two devices, then real sync with per-record timestamps,
tombstones and a conflict rule. The schema is already sync-ready: UUIDs,
`updatedAt`, soft deletes. The UI is not.

Sync is automatic when possible:

- A single opt-in master switch.
- When both paired devices are reachable on the same LAN, discover and query
  automatically on app start, app resume and network change.
- Manual refresh is always available.
- No cloud relay, no background traffic when the devices are not on the same
  network.
- If a device is offline, the local copy still works.

Discovery over mDNS/DNS-SD, transport over HTTPS or WebSocket with a pinned
self-signed certificate. Bind to the LAN only.

### 5.5 MCP is optional and local

The MCP server is a thin adapter over the same service layer the UI uses. It
runs on the desktop, binds to the LAN or loopback, and is off by default. It can
read and, behind a setting, write. Tools are namespaced by space, for example
`personal.today`, `work.next_shifts`, `home.shopping`, `plan.create`.

No internet, no external server, no account. The agent is outside the app. Mane
is not a chatbot host.

### 5.6 Companion apps

When another app already owns a domain, the integration should be read-only and
local. On Android, a ContentProvider or a small export is a better fit than a
network listener: no internet permission, no port, no server. It keeps the
companion app's zero-internet identity intact.

Mane must work without the companion app. Manual entry is always available.

## 6. Data model (target)

The v0.1.5 migration brought the shipped schema to the shape below. Later
milestones add tags, home items, reminders and sync metadata.

- **spaces**: id, name, color, position, timestamps, soft delete. Seeded with
  Personal, Work and Home. Spaces are rows, not an enum.
- **entries**: id, space, title, notes, kind (`task`, `event`, `obligation`,
  `deadline`), all-day `LocalDate` or timezone-aware start/end instants,
  timezone, status, recurrence JSON, source/external id, read-only flag,
  timestamps, soft delete. The wall-clock `dateKey`, `startMinute` and
  `endMinute` are the recurrence template; `start_at` and `end_at` are the
  resolved UTC anchor instants.
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
  home_item link, timestamps, soft delete.
- **maintenance**: reuse entries with `lastCompletedAt` and
  `repeatAfterCompletionDays`, or a dedicated table if it keeps the model
  simpler.
- **settings**: key and value.

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
- **Search.**

The app now has Today, Week and Calendar tabs, the entry editor, the tags
manager, the shift-pattern editor, settings, About, backup/import and the
tag-filter sheet. Search, home inventory and the remaining v0.3 screens are
later.

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

### v0.3 Home and maintenance

- [ ] `home_items` and `shopping_items` with migration and tests.
- [ ] Add, edit and archive items; quantity, unit, location, reorder level.
- [ ] Shopping/grocery list with check-off.
- [ ] Low-stock and "to buy" views.
- [ ] Read-only ICS import.
- [ ] Interval-after-completion maintenance tasks.
- [ ] Sleep window calculation.
- [ ] Shift checklist.
- [ ] Calendar provider OAuth, only if ICS is not enough.

### v0.4 Sync and MCP

- [ ] Username and PIN pairing.
- [ ] mDNS discovery.
- [ ] LAN query endpoint.
- [ ] Automatic query when both paired devices are on the same LAN.
- [ ] Read-only companion-app integration.
- [ ] MCP read-only tools.
- [ ] MCP write tools behind a setting.

### v0.5 Polish and release

- [ ] Search.
- [ ] Home screen widgets.
- [ ] Better empty states.
- [ ] Accessibility pass.
- [ ] Complete English and Spanish ARB coverage.
- [ ] Performance pass.
- [ ] Release workflow mirroring the references: split-per-ABI APKs, GitHub
      Releases/Obtainium, optional F-Droid/IzzyOnDroid/OpenAPK, Linux release
      artifacts, user-provided signing keystore.

### v1.0 finish line

Mane is v1.0 when v0.1.5 through v0.5 are complete, the app is daily-usable
offline on Android, Linux builds and runs, backup and restore are proven by
tests, reminders survive reboot and timezone changes, LAN sync and MCP are
optional and documented, English and Spanish are complete, and `flutter
analyze`, both test suites and both platform builds pass.

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

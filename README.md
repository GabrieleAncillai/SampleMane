# Mane

A local-first planner for the week and month as they actually happen. One app,
three spaces: **Personal**, **Work** and **Home**.

Work shifts, house inventory and maintenance, personal admin and the dates that
matter sit in one calendar, so collisions are visible before they become
problems. Android is the daily driver. Linux desktop is where planning and the
local agent run.

No account, no cloud, no telemetry. LAN sync and a local MCP endpoint are
planned, optional, automatic when possible, and never required for the core to
work.

**Status:** v0.5 release candidate. Today, Week and Calendar tabs, tags,
flexible shifts, reminders, settings, backup/restore, home inventory, shopping,
maintenance, sleep, ICS and companion import, optional LAN pairing, a local MCP
endpoint, global search, an Android home-screen widget and English/Spanish
coverage are in place. v1.0 waits on the user's real-device notification,
reboot, battery and timezone checklist.

## Docs

- [Overview](docs/overview.md): the short version.
- [Full docs](docs/full-docs.md): architecture, data model, feature areas,
  roadmap and decisions.
- [Reference map](docs/reference-map.md): the exact GymMane and Streak files to
  use for each area.
- [Contributing](CONTRIBUTING.md): setup, layout, house style and tests.
- [Release](docs/release.md): signing, split APKs and GitHub Releases.
- [Android device checklist](docs/device-checklist.md): the v1.0 real-device
  notification, reboot, battery, timezone, LAN, MCP and widget checks.
- [Agent brief](AGENTS.md): self-contained kickoff prompt for a coding agent.
- [Unattended kickoff](KICKSTART.md): quality-first prompt for a long,
  unattended implementation run.
- [Inspiration](inspiration/): screenshots and references for the visual
  direction.

## Working now

- Today, Week and Calendar tabs, with month/week modes, per-space markers,
  shift bars, day detail, month/week navigation and jump-to-today.
- Personal, Work and Home spaces, add/edit/soft-delete entries.
- Timezone-aware timed entries and shift patterns. Device travel moves the
  displayed local time; all-day dates never shift.
- Flexible shifts: cycles longer than a week, several slots per day, overnight
  slots, and free/override/extra date exceptions. A pattern editor previews the
  next 28 days and blocks overlapping shifts.
- Daily, weekly, monthly and yearly recurrence with `until` and `count`,
  expanded in the entry's stored IANA timezone.
- Per-occurrence completion that survives travel and a database restart.
- Tags with a manager, entry chips and a global tag filter.
- Multiple reminders per entry, Android notification permission and exact-alarm
  handling, a 90-day queue rebuilt on start/resume/timezone change, and taps
  that open the entry.
- Settings for theme, English/Spanish, week start, hiding Work, default
  reminders, sleep buffers, data backup, sync/MCP switches and About.
- Versioned JSON backup and a validated, transactional restore.
- Home inventory with quantity, unit, location and reorder levels; a shopping
  list whose checked lines update linked inventory.
- Interval-after-completion maintenance that advances from the actual
  completion date.
- A soft sleep window on Today, with configurable commute, wind-down and wake
  buffers.
- Shift checklists whose completions stay independent for each shift date.
- Read-only ICS import for local files, with TZID, all-day events, a documented
  RRULE subset and re-import deduplication.
- Read-only companion JSON export import with a documented schema.
- Optional LAN pairing: username + PBKDF2-hashed PIN, a six-digit short code,
  pinned self-signed TLS, signed queries and replay rejection. The switch is
  off by default.
- mDNS discovery with a manual host/port fallback, automatic refresh on launch,
  resume and discovery, a five-minute timer and manual refresh.
- A Devices page with read-only snapshots from paired devices. The local plan is
  never merged with a remote one and keeps working when a peer is offline.
- Optional local MCP endpoint on loopback with a bearer token, read tools and
  write tools behind a second setting.
- Global search across entry titles and notes, tag names and household items.
- An Android home-screen widget with today's plan and the next shift.
- Accessibility basics: semantics on calendar days and shifts, text scaling in
  the calendar, keyboard shortcuts for search and tab switching.
- A schema v1/v2/v3/v4 to v5 migration tested against real prior rows.
- A pure Dart domain package with the timezone, recurrence, shift and sleep
  rules.
- Android debug APK, Linux debug build and a tagged release workflow for split
  APKs and a Linux bundle.

## Planned after v1.0

- A ContentProvider client for a specific companion app.
- MCP over LAN with the same pinned transport.
- Home-screen widget variants for other platforms.

## Stack

- Flutter 3.38 / Dart 3.10
- Drift + SQLite
- Riverpod
- Material 3
- `cryptography` for PBKDF2/AES-GCM, `basic_utils` for the self-signed
  certificate, `bonsoir` for mDNS
- Android and Linux desktop from one codebase

The stack audit is done: Mane keeps Drift + Riverpod. The planner needs
date-range queries, entry/completion joins and a transactional backup import,
which the reference projects' local JSON stores do not provide directly.
Riverpod's overrides keep the clock, timezone and database injectable in tests.
There is no second state-management system. See
[docs/full-docs.md](docs/full-docs.md).

## Layout

```
lib/
  app/         MaterialApp and the shell
  features/    calendar, shifts, home inventory, settings, backup, sync, mcp
  models/      plain data classes that are not in mane_core
  screens/     one file per screen
  services/    database, repository, platform side effects
  state/       providers and app state
  theme/       colors and text styles
  widgets/     shared UI pieces
packages/
  mane_core/   pure Dart domain model, recurrence and shift rules
docs/
inspiration/
```

The core package has no Flutter imports on purpose. The UI, a future LAN server
and the MCP adapter share the same rules. The target is Streak's feature-first
layout as Mane grows; see [docs/full-docs.md](docs/full-docs.md).

## Run

```bash
flutter pub get
dart run build_runner build --force-jit
flutter run -d linux
```

`--force-jit` is needed on this Flutter version: build_runner 2.15 tries to
AOT-compile the build script, and one transitive dependency ships a native build
hook. JIT mode avoids that.

## Test

```bash
flutter test
(cd packages/mane_core && dart test)
```

## License

GPL-3.0-only, the same license as the primary references. See [LICENSE](LICENSE)
and [ADDITIONAL_TERMS.md](ADDITIONAL_TERMS.md).

## Credits

[GymMane](https://github.com/InlitX/GymMane) and
[Streak](https://github.com/InlitX/streak) by [InlitX](https://github.com/InlitX)
are the primary references for this project's structure, components, styles,
navigation, notifications, motion and architecture. See [CREDITS.md](CREDITS.md).

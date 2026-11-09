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

**Status:** foundations. The domain model, recurrence and shift engines with
tests, the SQLite schema, and a first Today/Week UI are in place. The calendar,
timezone-aware storage, three-space migration, notifications, LAN sync and MCP
come next.

## Docs

- [Overview](docs/overview.md): the short version.
- [Full docs](docs/full-docs.md): architecture, data model, feature areas,
  roadmap and decisions.
- [Reference map](docs/reference-map.md): the exact GymMane and Streak files to
  use for each area.
- [Contributing](CONTRIBUTING.md): setup, layout, house style and tests.
- [Agent brief](AGENTS.md): self-contained kickoff prompt for a coding agent.
- [Unattended kickoff](KICKSTART.md): quality-first prompt for a long,
  unattended implementation run.
- [Inspiration](inspiration/): screenshots and references for the visual
  direction.

## Working now

- Today and Week screens with entries and shift blocks.
- Home and Work spaces, add/edit/soft-delete entries.
- Daily, weekly, monthly and yearly recurrence with `until` and `count`.
- Per-occurrence completion, so a recurring chore is checked per occurrence.
- A pure Dart domain package with the recurrence and shift rules.
- Android debug APK and Linux debug build.

## Planned

- Three spaces: Personal, Work and Home.
- Month and week calendar, modelled on Streak.
- Flexible shifts: fixed, rotating, per-day times, overnight, multiple slots and
  date exceptions.
- Timezone-aware timed items: change the device timezone and timed entries and
  shifts move with it. All-day dates stay dates.
- Local notifications and multiple reminders.
- Tags for jobs and people/groups.
- Home inventory, shopping and grocery lists.
- Interval-after-completion maintenance and a sleep window.
- Read-only ICS import.
- Settings and versioned backup/restore.
- Optional LAN sync between the user's own devices, automatic on the same
  network.
- Optional local MCP endpoint for a desktop agent, off by default.
- English and Spanish localization.

## Stack

- Flutter 3.38 / Dart 3.10
- Drift + SQLite
- Riverpod
- Material 3
- Android and Linux desktop from one codebase

The Drift + Riverpod foundation is provisional. It is being audited against
GymMane's `ChangeNotifier` + local store and Streak's `provider` + per-feature
controllers before v0.2. See [docs/full-docs.md](docs/full-docs.md).

## Layout

```
lib/
  app/         MaterialApp and the shell
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

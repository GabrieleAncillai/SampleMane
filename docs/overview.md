# Overview

Mane is a local-first planner for commitments that recur across personal life,
work and home. One app, three spaces: **Personal**, **Work** and **Home**.

Most people keep their obligations in too many places: work calendars, chat,
task boards, notes apps, messages and their own head. Mane puts the day, week
and month back into one calendar, so collisions are visible before they become
problems.

## What Mane does

- **One calendar** for the day, week and month. Work shifts are background
  blocks; home and personal obligations sit in front of them.
- **Three spaces:** Personal for taxes, bills, renewals and important dates;
  Work for jobs, projects and shifts; Home for inventory, shopping, groceries
  and maintenance.
- **Flexible shifts** that can express fixed weekly schedules, rotating cycles,
  per-day times, overnight shifts and date exceptions.
- **Recurring commitments** handled properly: daily, weekly, every N days,
  monthly, yearly, and interval after completion for maintenance.
- **Timezone-aware timed items.** Change the device timezone and timed entries
  and shifts move with it. All-day dates stay dates.
- **Reminders with lead time**, early enough to act rather than at the moment
  something is already late.
- **Per-occurrence completion**, so checking off this week's chore does not
  check next week's.
- **Read-only companion-app integrations** for data another app already owns.
- **Optional LAN sync** between the user's own devices, automatic when both are
  on the same network. No cloud, no account, no telemetry.
- **Optional local MCP endpoint** for a desktop agent, off by default.

## Platforms

Android is the daily driver because reminders have to reach the user away from
the desk. Linux desktop is the second target because that is where planning and
the local agent run. Both come from the same Flutter codebase; Windows and macOS
should follow with little extra work.

## Not in scope

- A cloud service or hosted account.
- A shared or social planner.
- A finance tracker.
- A full replacement for a calendar provider.
- A chatbot inside the app.

## Status

v0.1.5. The domain model, recurrence and flexible shift engines, the v2 SQLite
schema and migration, and a first Today/Week UI exist. Timed entries and shifts
are timezone-aware; all-day items stay date-only. Calendar view, notifications,
tags, settings and backup are next.

- [Full docs](full-docs.md): architecture, data model, feature areas and roadmap.
- [Reference map](reference-map.md): where to look in GymMane and Streak.
- [Contributing](../CONTRIBUTING.md): setup, layout, house style and tests.
- [Agent brief](../AGENTS.md): self-contained kickoff prompt for a coding agent.

Mane is GPL-3.0-only, the same license as its primary references. See
[LICENSE](../LICENSE), [ADDITIONAL_TERMS.md](../ADDITIONAL_TERMS.md) and
[CREDITS.md](../CREDITS.md).

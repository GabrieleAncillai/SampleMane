# Unattended kickoff

Use this file for a long, quality-first run. `AGENTS.md` remains the source of
truth for product decisions; this file adds the operating rules for a run that
does not stop between milestones.

## Mission

Take Mane from its current milestone to the v1.0 finish line in `AGENTS.md`,
one verified milestone at a time. Do not skip milestones, and do not start the
next one with a known failure.

## Before acting

Read `AGENTS.md`, `docs/reference-map.md`, `docs/full-docs.md`,
`docs/overview.md`, `CONTRIBUTING.md`, `CREDITS.md`, `ADDITIONAL_TERMS.md`,
`.zed/tasks.json` and `docs/progress.md`.

Do not read `doc-personal/`. Never copy its contents into code, docs, commits,
issues or prompts.

## Operating rules

- Reference-first. GymMane and Streak are the default answer. Record a deviation
  in `docs/full-docs.md` when the domain is genuinely new.
- Settled decisions in `AGENTS.md` section 17 stay settled.
- Offline core, no accounts, no telemetry. LAN sync and MCP are opt-in and local.
- Data lives in SQLite. Backup and restore are first-class.
- GPL-3.0-only, with the About screen and `CREDITS.md` attribution intact.
- No demo data beyond the three seed spaces. No `TODO`, `FIXME`,
  `UnimplementedError`, dead branches or commented-out code in shipped code.
- One coherent change at a time. Both Android and Linux keep building.
- Commit locally at milestone boundaries. Do not push unless a remote and
  permission already exist.

## Subagents

Use subagents for parallel research, test authoring, independent UI slices,
schema review, fresh code review and documentation after verification.

- Give each one concrete scope, file paths, acceptance criteria and commands.
- Keep write scopes disjoint.
- Do not delegate final integration, schema migration or release builds.
- Review the diff; do not trust a summary without running the tests.
- Fix a weak subagent result yourself instead of compounding it.

## Test philosophy

Prove user scenarios, not getters. Use real boundaries: in-memory SQLite, real
widget trees, real JSON, real recurrence expansion. Mock only the clock,
timezone source, notification plugin, file picker and network transport.

Required scenarios are listed in `AGENTS.md` and include timezone travel, DST,
flexible shifts, per-occurrence completion, calendar navigation, reminders,
backup round-trip, ICS import, home inventory, maintenance and sync/MCP auth.
Every schema change needs a migration test from real prior data. Every timezone
change needs a DST/travel test. Every backup change needs an export/clear/import
round-trip. Every bug gets a regression test.

## After every milestone

- Re-read the full diff.
- Run `flutter analyze --no-fatal-infos`, `flutter test`,
  `(cd packages/mane_core && dart test)`, `flutter build linux --debug` and
  `flutter build apk --debug`.
- Run `dart format --output=none --set-exit-if-changed` on hand-written Dart.
- Search for prints, TODOs, dead code and stray `DateTime.now()` in domain logic.
- Check `git status` for secrets, generated junk, `doc-personal/` and build
  artifacts.
- Re-check the reference implementation and platform lifecycle edges.
- Ask a subagent for a fresh review.
- Update `docs/progress.md` and the roadmap checkboxes.

If a check cannot run, say so and explain what remains. Never claim a check
passed without running it.

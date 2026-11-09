# Mane completion plan

Status: active. Baseline v0.5. Last updated 2026-11-09.

This is the working plan that takes Mane from the v0.5 release candidate to a
daily-usable v1.0. It is deliberately broader than the original v1.0 gate: the
private brief and the reference projects expose gaps that the v0.5 roadmap did
not treat as deliverables. Those gaps are tracked here, not hidden in prose.

The private brief is not copied into this repository. It was reviewed to build
the generalized scenarios in section 7; only those generalized scenarios belong
in public documentation.

## 1. Goal

Mane v1.0 is a daily planner for a real week:

- several concurrent jobs and shift patterns in one Work space;
- home inventory, shopping and maintenance that is due after the last service;
- personal, family and relationship dates with lead-time reminders;
- sleep protected around the last and first commitment;
- one calendar that shows collisions instead of separate silos;
- offline first, with optional LAN query and a local MCP endpoint;
- data that can be exported and restored without a cloud account;
- a UI that follows the GymMane/Streak component language instead of stock
  Material defaults.

"Feature-complete" means every scenario in section 7 works end to end, not that
every idea in the reference projects is copied.

## 2. Definition of v1.0

Mane is v1.0 when all of the following are true:

- [ ] Every scenario in section 7 passes on Android and Linux, or has a
      documented platform limitation.
- [ ] The visual foundation in v0.6 is applied to every shipped screen.
- [ ] The planner, imports, exports, backup, sync and MCP cover the documented
      feature matrix in section 6.
- [ ] There are no known P0/P1 data-loss, notification, pairing or security bugs.
- [ ] Schema migrations from every real prior version pass in tests.
- [ ] `flutter analyze --no-fatal-infos`, `flutter test`,
      `(cd packages/mane_core && dart test)` and the format check pass.
- [ ] Linux debug/release and Android debug/release split-per-ABI builds pass.
- [ ] The real-device checklist passes, including reboot, battery, timezone,
      widget, LAN and MCP smoke tests.
- [ ] English and Spanish are complete, with ARB parity and literal scanners.
- [ ] GPL-3.0-only, `CREDITS.md`, `ADDITIONAL_TERMS.md` and the About screen
      attribution are intact.
- [ ] `README.md`, `docs/overview.md`, `docs/full-docs.md`, this plan and
      `docs/progress.md` describe the shipped state truthfully.
- [ ] Release signing is documented as a user-provided keystore step.

## 3. Principles

1. **Reference-first.** Before adding a widget, screen, motion, setting, import
   or platform behavior, open the mapped GymMane/Streak file. Record a deviation
   in `docs/full-docs.md` when the domain is genuinely new.
2. **Offline core.** No cloud, account, telemetry or remote config. LAN sync and
   MCP stay opt-in and local.
3. **Data ownership.** SQLite on the device, plus first-class export. Android
   cloud auto-backup is disabled so pairing secrets never leave the device.
4. **One stack.** Drift + Riverpod stays. Feature folders follow Streak.
5. **One milestone at a time.** Do not start a later milestone with a known
   failure in the current one.
6. **Proof, not prose.** A behavior change needs a test. A schema change needs a
   migration test from real prior rows. A timezone change needs a DST/travel
   test. A visual change needs a screenshot or golden test.

## 4. Current baseline

Verified 2026-11-09:

- `flutter analyze --no-fatal-infos`: clean.
- `flutter test`: 85 passed.
- `(cd packages/mane_core && dart test)`: 71 passed.
- `dart format --line-length 110 --output=none --set-exit-if-changed`: clean.
- v0.1.5 through v0.5 features are implemented as described in
  `docs/full-docs.md`.
- Known functional gaps are listed in `docs/compliance-audit.md` and section 6.

## 5. Milestones

Each milestone ends with analyze, both test suites, a format check, the relevant
builds, a documentation update and a report. Later milestones may be reordered
only when a dependency forces it.

### v0.6 Visual foundation and truth pass (done)

The single biggest product gap. The app used stock Material 3 widgets even
though the reference-first rule requires the GymMane/Streak visual language.

- [x] Bundle the reference font family and apply a real type scale.
- [x] Apply `ManeColors` through `context.mc`; stop reading generated Material
      roles directly in screens where a token exists.
- [x] Add component themes for app bar, card, sheet, dialog, snack bar,
      navigation bar, buttons and time picker.
- [x] Port a small shared UI kit from the references: `SoftCard`, `AppSheet`,
      `SectionLabel`, `Pressable`, `TinySwitch`, glass surface, empty state and
      page motion.
- [x] Replace the shell's stock `AppBar` + `NavigationBar` + FAB with the
      reference-style floating shell and background.
- [x] Sweep Today, Week, Calendar, Settings, Tags, Shifts, Home inventory,
      Shopping, Devices, MCP and About to use the kit.
- [x] Add a widget/golden smoke test for the shell and the shared components.
- [x] Correct `docs/reference-map.md` so it describes the visual layer that
      actually ships.

Acceptance met: the screenshots in `docs/screenshots/` show the reference
component language on Today, Calendar and Settings; the shipped shell has no
stock app bar, navigation bar or floating action button; all tests pass.

### v0.7 Calendar, recurrence and shift completeness

- [ ] Add a day timeline view with shifts as background blocks and entries in
      front, modelled on Streak's `day_timeline_page.dart`.
- [ ] Support multi-day all-day entries and multi-day timed entries end to end.
- [ ] Add recurrence exception dates (skip one occurrence) and modified
      occurrences.
- [ ] Add ordinal weekday rules (`1MO`, `-1FR`), `BYSETPOS` and negative
      `BYMONTHDAY`; keep the documented subset honest.
- [ ] Add tag links to shift patterns and make the global tag filter filter
      shifts as well as entries.
- [ ] Key shift checklist completion by pattern + date + slot, not just
      pattern + date. Schema migration and real-row test required.
- [ ] Add a read-only ICS export for sharing a calendar without an account.
- [ ] Add per-pattern commute/wind-down overrides for the sleep window.
- [ ] Hardening pass on ICS import: `EXDATE`, `RECURRENCE-ID`, Windows `TZID`
      aliases, multi-day timed events and re-import updates.

Acceptance: a real Google/Microsoft ICS export with cancelled and moved
occurrences imports without duplicates or skipped rows that Matter; an exported
ICS opens in a standard calendar; a two-slot day keeps independent checklists.

### v0.8 Data interchange, home tracking and privacy

- [ ] Add a read-only GymMane schedule import using GymMane's JSON backup
      (`weeklyPlan`, `routines`, `trainAt`), with dedupe and a documented
      fallback when no time is present.
- [ ] Add automatic local backups with rotation while keeping manual export as
      the canonical path.
- [ ] Accept older backup schema versions through an explicit upgrade path.
- [ ] Add CSV export/import for entries, shopping and inventory.
- [ ] Shopping: group by category/location, clear checked lines, reorder.
- [ ] Inventory: quick quantity adjustment, low-stock dashboard and purchase
      history that stays lightweight.
- [ ] Maintenance: a dedicated due/overdue view and one-tap completion.
- [ ] Optional app lock using the existing local PIN hash, with a PIN pad
      adapted from Streak.

Acceptance: a fresh install can import a GymMane schedule and a real ICS file,
export a backup and an ICS, restore the backup, and unlock with the local PIN.

### v0.9 MCP, LAN sync and notification reliability

- [ ] Extend MCP beyond the four core tools: search, list by range, update,
      uncomplete, delete, shifts by range, home inventory, shopping add/check,
      tags and sleep window.
- [ ] Add MCP session handling for streamable HTTP clients and document the
      supported protocol surface.
- [ ] Persist read-only LAN snapshots so the Devices page survives restarts;
      never merge them into the local plan.
- [ ] Extend the LAN query payload beyond the compact summary while keeping it
      read-only.
- [ ] Add work-hours visibility and quiet hours, including notification
      suppression, without hiding work deadlines the user explicitly opens.
- [ ] Support custom reminder times in addition to offsets, and notification
      actions for snooze and complete where the platform allows.
- [ ] Document why absolute-instant scheduling is timezone-change safe and
      rebuild the queue on every resume, timezone change and boot.

Acceptance: an MCP client can read and write a full plan within the gated
permission; a paired device shows the last snapshot offline; a Work reminder
outside quiet hours is suppressed; a snooze action works on a real device.

### v1.0 Device verification, polish and release

- [ ] Run the full Android device checklist, including the new v0.7-v0.9 flows.
- [ ] Record OEM battery behavior and fix what is fixable; document the rest.
- [ ] Accessibility pass: screen reader walkthrough, contrast against the final
      palette and touch-target audit.
- [ ] Performance pass on long recurring ranges and large calendars.
- [ ] Final English/Spanish ARB pass, including new surfaces.
- [ ] Update all docs, roadmap checkboxes and screenshots.
- [ ] Tag `v1.0.0` only after the device checklist and signed CI release pass.

## 6. Feature matrix

| Area | v0.5 state | v1.0 target | Milestone |
|---|---|---|---|
| Shell, theme, typography, motion | Stock Material 3 | Reference-style shell and UI kit | v0.6 |
| Today / Week / Calendar | List and month/week views | Add day timeline and shift background | v0.7 |
| Entry editor | Single day, one time range | Multi-day, recurrence exceptions, richer fields | v0.7 |
| Recurrence | Daily/weekly/monthly/yearly subset | Add ordinal rules, skip dates and overrides | v0.7 |
| Shift patterns | Cycles, slots, exceptions, preview | Add job tags and per-slot checklist keys | v0.7 |
| ICS import | Narrow subset, dedupe only | EXDATE, RECURRENCE-ID, TZID aliases, updates | v0.7 |
| ICS export | None | Read-only sharing export | v0.7 |
| Sleep | Soft window with global buffers | Per-pattern commute/wind-down overrides | v0.7 |
| GymMane | Manual entries only | Read-only weekly schedule import | v0.8 |
| Backup | Manual JSON, schema 5 only | Auto backup, rotation, older-schema upgrade | v0.8 |
| CSV | Not shipped | Entries, shopping and inventory | v0.8 |
| Home inventory | Core list and low stock | Adjustments, dashboard and history | v0.8 |
| Shopping | Core list | Grouping, clear checked and reorder | v0.8 |
| Maintenance | Interval after completion | Dedicated due/overdue view | v0.8 |
| App lock | None | Optional local PIN lock | v0.8 |
| MCP | Four tools, loopback JSON-RPC | Full tool set and streamable sessions | v0.9 |
| LAN sync | In-memory summary snapshots | Persistent read-only snapshots and richer query | v0.9 |
| Work visibility | Hide the whole Work space | Work-hours visibility and quiet hours | v0.9 |
| Reminders | Offsets only | Custom times, snooze/complete actions | v0.9 |
| Android widget | Today + next shift, app resume update | Config/deep-link polish | v0.9 |
| Localization | English/Spanish | Complete, including new surfaces | v1.0 |
| Accessibility | First pass | Screen-reader and contrast audit | v1.0 |

## 7. Scenario matrix

These are the generalized scenarios the private brief requires. They are the
acceptance tests for "the app is useful for a real week".

1. **Multi-job week.** Three to five concurrent jobs, some fixed and some
   rotating, with per-job tags, overnight shifts, shift checklists and personal
   commitments on the same days. The calendar must show the collision.
2. **Shift checklist independence.** Two shifts of the same pattern on the same
   date must keep independent checklist completions; checking one must not check
   the other.
3. **Dates that cannot be missed.** Yearly and monthly personal/family dates with
   30-day, 7-day and 1-day reminders, visible before they become urgent.
4. **Maintenance after completion.** Water tank, AC and pump tasks due N days or
   months after the last service, not on a drifting fixed date.
5. **Imported work calendars.** A real ICS file with recurring events, cancelled
   occurrences, moved occurrences and multiple timezones imports without
   duplicates; a read-only export can be shared.
6. **Gym schedule.** Weekly gym blocks from GymMane appear read-only next to
   shifts without manual re-entry.
7. **Sleep protection.** The soft sleep window reacts to the last and first
   commitment, the configured commute/wind-down buffers and per-pattern
   overrides when a job has a different commute.
8. **Offline and LAN.** The local plan works in airplane mode; a paired device's
   read-only snapshot returns when the LAN is back.
9. **Local agent.** An MCP client can read today's plan, next shifts, shopping,
   home inventory and search, and can create/update/complete a plan when writes
   are enabled.
10. **Travel and reboot.** A timed commitment moves with the device timezone; an
    all-day date does not; reminders survive reboot and timezone changes.
11. **Data ownership.** Export, clear, import restores the same plan; pairing
    secrets and certificates are never in the backup; Android cloud backup is
    off.
12. **Quiet work.** Work reminders stay quiet outside configured hours, while
    the user can still open Work explicitly.

## 8. Risks and mitigations

| Risk | Mitigation |
|---|---|
| Visual sweep breaks flows or tests | Incremental screens, golden/widget smoke tests, screenshot each milestone |
| Schema v6/v7 migration loses checklist or snapshot data | Real previous-version fixtures, transactional migration, rollback test |
| ICS edge cases are unbounded | Keep a documented subset, report skips, test real Google/Outlook exports |
| MCP protocol drift | Pin the supported surface, test with a real client, document limitations |
| LAN security regression | Keep pinned TLS, signature and nonce tests; never merge remote data |
| Work-hours hiding hides a deadline | Hiding is visual and reversible; reminders are suppressed only by explicit quiet hours |
| Real-device OEM battery behavior | Device checklist; document OEM paths; keep inexact fallback |
| Scope creep from the references | Only ship scenarios in section 7 plus the feature matrix |

## 9. Verification gates

Run before reporting any milestone:

```bash
flutter pub get
dart run build_runner build --force-jit
find lib test packages/mane_core/lib packages/mane_core/test -type f -name '*.dart' \
  -not -name '*.g.dart' -not -name 'app_localizations*.dart' -print0 \
  | xargs -0 dart format --line-length 110 --output=none --set-exit-if-changed
flutter analyze --no-fatal-infos
flutter test
(cd packages/mane_core && dart test)
flutter build linux --debug
flutter build apk --debug
```

Visual milestones also need screenshots or golden files. Device milestones also
need `docs/device-checklist.md` results.

## 10. Out of scope

- Cloud service, hosted account, remote sync or telemetry.
- Shared/social planner, couples account or CRM.
- Finance tracking, bank connections or budgets.
- Chatbot inside the app.
- Google/Microsoft OAuth while ICS covers the need.
- Linear/Plane/Mattermost integrations.
- Workout logging in Mane; GymMane owns that domain.
- Full RFC 5545 or full MCP beyond the documented surface.

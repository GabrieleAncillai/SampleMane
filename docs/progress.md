# Progress log

Keep this file current. A fresh context window should be able to resume from it.

## Current milestone

v0.1.5 complete. Next: v0.2 (calendar, notifications, shift editor, tags,
settings, backup, localization).

## Reference notes

- Timezone resolution and notification-time zone handling: Streak
  `lib/services/notification_service.dart` (`tz.initializeTimeZones`,
  `FlutterTimezone.getLocalTimezone`, tolerant `getLocation` fallback).
- Local storage shape: GymMane `lib/services/local_store.dart` (small local
  store). Mane keeps Drift because the planner needs date-range queries,
  completion joins and transactional backup import; recorded in
  `docs/full-docs.md`.
- Shift and entry models are Mane-specific. Neither reference has flexible
  cycles, multiple slots per day, timezone-aware recurrence or shift
  exceptions, so this milestone is a documented domain deviation.

## Decisions

- Keep Drift + Riverpod for v0.2. The stack audit reason is in
  `docs/full-docs.md`.
- Timed entries and shift patterns store wall-clock template fields
  (`dateKey`, `startMinute`, `endMinute`, IANA `time_zone`) plus resolved UTC
  anchor instants (`start_at`, `end_at`) for range work and sync. Recurrence
  expands in the stored IANA zone, then converts each occurrence to an instant.
- All-day items keep `LocalDate` and never carry a timezone or instants.
- Shift patterns are normalized into `shift_slots` and `shift_exceptions`.
  Multiple slots per cycle day are allowed. Overnight slots use end minutes
  greater than 1440. Exception precedence: `free` wins, then `override`
  replaces the cycle slots for that date, then `extra` adds to them.
- Migration uses the device IANA timezone as the default for legacy timed rows
  and shift patterns. It is passed into `AppDatabase` by `main()` so migration
  tests are deterministic.
- Default spaces are Personal (position 0), Work (1) and Home (2).

## Work completed

- Baseline verified on 2026-11-08: analyze clean, 5 app tests, 31 core tests,
  Linux debug build, Android debug APK.
- Captured the v1 schema DDL for a real migration test
  (`test/fixtures/schema_v1.sql`).
- v0.1.5 domain: `time.dart` instant/local helpers, timezone-aware `Entry` and
  `EntryOccurrence`, `expandEntries`, flexible `ShiftPattern` with multiple
  slots, overnight slots, free/override/extra exceptions and conflict
  detection.
- Schema v2: entry `time_zone`/`start_at`/`end_at`, normalized `shift_slots`
  and `shift_exceptions`, Personal space, migration from v1 with real data.
- Repository, providers, Today/Week screens, entry editor and shared widgets
  now expand and display in the viewer timezone.
- Tests: 64 core, 12 app (including migration and widget timezone rendering),
  both suites green.

## Known limitations

- The device IANA timezone is read at app start. A mid-session timezone change
  is picked up on the next start. v0.2 adds resume-time refresh and
  notification rescheduling.
- Multi-day recurring entries remain unsupported; multi-day all-day events are
  displayed per day.
- The shift-pattern editor is not built yet; patterns are domain and database
  ready.

## Commands and results

- `flutter pub get` — ok.
- `dart run build_runner build --force-jit` — ok.
- `flutter analyze --no-fatal-infos` — no issues.
- `flutter test` — 12 passed (includes migration and timezone widget tests).
- `(cd packages/mane_core && dart test)` — 64 passed.
- `dart format --line-length 110` — clean after formatting.
- `flutter build linux --debug` — pending re-run after v0.1.5.
- `flutter build apk --debug` — pending re-run after v0.1.5.

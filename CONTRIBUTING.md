# Contributing to Mane

## Before you start

If you are a coding agent or starting from a blank session, read
[AGENTS.md](AGENTS.md) first. It is the self-contained project brief.

- **Bugs and small fixes:** open a pull request straight away.
- **Anything bigger:** open an issue first so we can agree on the direction
  before you spend an evening on it.
- **Translations:** English is the source and Spanish is the first translation.
  Follow the ARB setup described below.

## Reference-first rule

GymMane and Streak by InlitX are the primary references for Mane. They already
solve most of the problems this project has. Before building a widget, screen,
service, notification flow, backup path, settings page, animation or build step,
open the equivalent in both projects and reuse or adapt it.

- GymMane: https://github.com/InlitX/GymMane
- Streak: https://github.com/InlitX/streak
- File-by-file map: [docs/reference-map.md](docs/reference-map.md)

Default to the reference implementation. Deviate only when the domain is
genuinely new or neither project has an equivalent. Record the reason in
`docs/full-docs.md` and keep the deviation small.

If code is copied or closely adapted, the license stays GPL-3.0-only and the
attribution goes in `CREDITS.md` and the About screen.

## Two rules that never bend

1. **No accounts, no logins, no remote user data.** Ever.
2. **No network in the core.** Mane works in flight mode. LAN sync and the MCP
   endpoint are opt-in, local, and never required for the planner to work.

Anything that keeps working on a phone with no connection is fair game.

## Getting set up

```bash
flutter pub get
dart run build_runner build --force-jit
flutter run -d linux
```

`--force-jit` is needed on this Flutter version: build_runner 2.15 tries to
AOT-compile the build script, and one transitive dependency ships a native build
hook. JIT mode avoids that.

Requires Flutter 3.38+ (Dart 3.10+). Android is the primary target; Linux desktop
is the second.

## Where things live

```
lib/
├── app/          the MaterialApp and the shell
├── models/       plain data classes that are not in mane_core
├── screens/      one file per screen
├── services/     database, repository, platform side effects
├── state/        providers and app state
├── theme/        colours and text styles
└── widgets/      shared UI pieces
packages/
└── mane_core/    pure Dart domain model, recurrence and shift rules
```

This is the current starting layout. As a feature grows, move it under
`lib/features/<feature>/` with `data/`, `state/`, `pages/` and `widgets/`, as
Streak does. Do not create a new flat screen if it belongs to a feature.

`packages/mane_core` has no Flutter imports on purpose. The UI, a future LAN
server and the MCP adapter call the same rules instead of reimplementing them.

`PlannerRepository` is the single read/write seam. Screens and the future
agent-facing adapter call it instead of touching Drift directly.

## Time rules

- Timed entries and shifts are timezone-aware instants. Store a UTC `DateTime`
  plus the IANA timezone in which the item was defined.
- Display them in the device's current timezone. If the device timezone
  changes, the displayed local time shifts.
- Recurrence expands in the stored timezone, then converts to instants. Test
  DST spring-forward, fall-back and a device timezone change.
- All-day and date-only items stay `LocalDate`. A birthday is a date, not a
  midnight instant.
- Pass `now` and the timezone into pure functions. Do not call `DateTime.now()`
  deep inside domain logic.

## House style

The project follows the conventions used by InlitX projects (Streak and GymMane).

- **One screen per file.** Prefer small widgets and pure functions.
- **Comments explain why, not what.** Most code should need none.
- **No literal business rules in the UI.** Recurrence, shift and time rules live
  in `mane_core`.
- Use `ManeColors` from `lib/theme/app_colors.dart`; do not scatter raw colors.
- Run `dart format` before pushing, keep `flutter analyze` clean.
- English is the source locale and Spanish is the first translation. Follow the
  ARB setup in GymMane and Streak: `l10n.yaml`, `lib/l10n/app_en.arb`,
  `lib/l10n/app_es.arb` and a generated `AppLocalizations`. Do not leave
  user-facing literals in widgets once the ARB layer exists.

## Tests

Add a test with your change. The suite is plain `flutter_test` and fast:

```bash
flutter test                        # app and database
(cd packages/mane_core && dart test) # domain rules
```

Domain tests do not need Flutter. Keep them that way. Schema changes need a
Drift migration and a migration test. Timezone changes need DST/travel tests.

## Release

Distribution follows the reference projects: GitHub Releases and Obtainium
first, optional F-Droid/IzzyOnDroid/OpenAPK, local APKs for testing. Release
signing uses a user-provided keystore. Do not call a debug-signed build a
production release.

## Pull requests

- One topic per pull request.
- Say what changed and why, and add a screenshot for anything visual.
- By contributing you agree your work ships under the project's
  [GPL-3.0-only license](LICENSE) and the terms in
  [ADDITIONAL_TERMS.md](ADDITIONAL_TERMS.md).

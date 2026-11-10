# Android device checklist

This is the last v1.0 gate. Run it on the real Android device with a debug or
release build. Record the build version and the device model next to each item.

## Latest run

2026-11-09, HUAWEI MAR-LX3A, Android 10 / API 29, debug 0.9.0+9. The full log
is in [device-run-2026-11-09.md](device-run-2026-11-09.md). Summary: install,
notifications (except the Android 13/12 paths, N/A on API 29), timezone, LAN,
MCP, backup/CSV after the fix, and app lock pass. Reboot fails because EMUI does
not deliver `BOOT_COMPLETED` to the app. The widget and OEM battery checks still
need the user. Checkboxes below reflect that run; unchecked boxes are not
passes.

## Emulator baseline (already verified)

On 2026-11-09, on a Pixel 9 emulator (Google Play image) with a debug build of
0.5.0:

- The app launched and persisted Personal/Work/Home data.
- Creating an entry requested the Android 13+ notification permission and then
  opened the exact-alarm special access screen. Enabling it made the reminders
  exact.
- Two default reminders (1 hour and 10 minutes before) were delivered as a
  grouped notification at the scheduled minute.
- Changing the device timezone from America/Bogota to Europe/Madrid moved the
  timed entry from 9:00 AM to 3:00 PM. All-day dates are covered by the widget
  and unit tests; the emulator run had no all-day entry.
- Rebooting the emulator kept the entry, and the app rebuilt the reminder queue:
  both reminders were present in `dumpsys alarm` after boot, and the 10-minute
  reminder fired after the clock was advanced.
- The release APK also builds split per ABI and the Linux release bundle builds.

The Pixel 9 baseline above is historical and still covers the Android 13/12
paths. On the physical Huawei device, notifications, timezone, real-reboot
recovery (manual launch only) and LAN with the manual host/port fallback are now
recorded in the 2026-11-09 run. Still open there: OEM battery optimization and
the home-screen widget.

## Install and first launch

- [x] Install the arm64 APK (or `flutter install` for a debug build).
- [x] The app opens offline, with Personal, Work and Home and no sample entries.
- [x] The About screen shows v0.9.0, GPL-3.0-only and the InlitX attribution.

## Notifications

- [x] N/A on the 2026-11-09 run: Android 10 does not have the Android 13 runtime
      notification permission. The emulator baseline below covers it.
- [x] N/A on the 2026-11-09 run: Android 10 does not have Android 12 exact-alarm
      special access. The emulator baseline below covers it.
- [x] Create an entry 10 minutes in the future with a 5-minute reminder.
      Lock the screen. The reminder arrives on time.
- [x] Create a second reminder on the same entry and verify both arrive.
- [x] Tap the notification while the app is closed; the entry editor opens.
- [x] Tap the notification while the app is open; no duplicate screen stack.
- [x] Edit the entry time, then verify the old notification is gone and the new
      time is scheduled.
- [x] Add an "at a time" reminder (for example 08:00) and verify it fires on the
      occurrence day at that local time.
- [x] Enable quiet hours around the reminder time and verify it is suppressed
      after the next queue rebuild.
- [x] Enable work hours and create a Work reminder outside them; verify it is
      suppressed while the task remains visible as a deadline if it is.
- [x] On Android, use the notification's Snooze action; it fires again in about
      ten minutes. Use Complete and verify the entry (or one occurrence) is
      marked done.

## Reboot

- [ ] **FAIL on EMUI 10.** With reminders queued, reboot without opening the app.
      The queued alarms remain in `scheduled_notifications.xml`, but the process
      does not start, no alarm is registered and no reminder fires. EMUI does
      not deliver `BOOT_COMPLETED` to the app. The queue only returns after a
      manual launch; this is not a pass.
- [x] Open the app after reboot and confirm the queue rebuilds without
      duplicates. Exactly the two upcoming alarms were rebuilt.

## Battery optimization

- [ ] **BLOCKED.** The app is whitelisted and in the active bucket, but the boot
      receiver still did not run. The exact EMUI App launch path and a
      restricted-bucket 30-minute reminder test still need the user.
- [ ] If it is delayed, exclude Mane from optimization and repeat the test.
      Record the exact OEM setting path.

## Timezone change

- [x] Create a timed entry anchored in `Europe/Madrid`, and an all-day birthday
      on the same date.
- [x] Change the device timezone to `America/New_York`. Open or resume Mane.
- [x] The timed entry moves by the expected offset; the all-day birthday stays
      on the same date.
- [x] Change the timezone back and verify the timed entry returns.
- [x] Schedule a reminder, change the timezone, resume the app, and confirm the
      reminder is still scheduled for the same absolute moment.
- [x] Enable work and quiet hours, then repeat the timezone change. The windows
      are evaluated in the new device zone after the resume rebuild.

## LAN pairing and query

Manual host/port is the supported fallback here; the phone reports "Network
discovery is unavailable" and mDNS could not be used.

- [x] Set a username and PIN on both devices. The PIN is at least four digits.
- [x] On device A, open Devices, show a code, and unlock with the PIN.
- [x] Device B finds A over mDNS, or connects with A's address and port.
- [x] Enter the code on B; both devices show the pairing.
- [x] A's today view and next shift appear on B's Devices page after refresh.
- [x] Kill and reopen B while A is offline; B still shows A's last read-only
      snapshot and never merges it into B's plan.
- [x] Turn on airplane mode, open B, and verify B's own plan still works. Turn
      airplane mode off and refresh; A's snapshot returns.
- [x] Unpair on one device and verify queries are rejected and the cached
      snapshot is removed.

## MCP

- [x] Enable the MCP endpoint and allow write tools.
- [x] From the same machine, call `initialize`, `tools/list` and
      `home.shopping` with the bearer token. Use `curl` or an MCP client.
- [x] Check that `initialize` returns an `Mcp-Session-Id`; send it on a later
      call and confirm it is accepted, then `DELETE /mcp` it and confirm the
      next explicit-session call is rejected.
- [x] Send `Accept: text/event-stream` on a `tools/call` and confirm one SSE
      message containing the JSON-RPC result.
- [x] A request without the token is rejected.
- [x] Exercise `plan.range`, `plan.search`, `work.shifts`, `home.inventory`,
      `tags.list` and `sleep.window`.
- [x] `plan.create` creates an entry visible in the app; `plan.update`,
      `plan.complete`, `plan.uncomplete` and `plan.delete` behave as expected.
- [x] `home.shopping_add` then `home.shopping_check` updates the linked
      inventory quantity.
- [x] Disable the endpoint and verify the port is closed.

## Widget

- [ ] **BLOCKED.** Long-press the home screen, add the Mane widget, and confirm
      it shows today's plan and the next shift. This needs the user's launcher.
- [ ] Tap the widget; Mane opens.
- [ ] Change today's plan in the app, resume, and confirm the widget updates.

## Backup

- [x] Export a backup, change or delete an entry, import the backup, and verify
      the original state returns.
- [x] Pair the devices, export a backup, and import it into a fresh install.
      The pairing is not restored and both devices still open normally.
- [x] Enable automatic local backups, background and resume Mane, and confirm a
      `mane-auto-*.json` file exists in the app support `backups` folder (use
      `adb shell run-as` on a debug build).
- [ ] Change the copy count, let several days pass or adjust the clock, and
      confirm older copies are removed. Not forced in this run.
- [x] Import a GymMane `gymmane.json` backup and confirm the weekly blocks are
      read-only. A backup without `trainAt` must produce all-day blocks.
- [x] Export and re-import entries CSV without duplicating rows. Shopping and
      inventory CSV are covered by the unit round-trip test; they were not
      re-run on the device.

## App lock

All items pass after the 2026-11-09 fix that moved the gate above the Navigator.

- [x] Enable the lock, set a four-digit PIN, background the app for more than
      30 seconds, and confirm the PIN pad covers the plan on resume.
- [x] Enter the wrong PIN five times; confirm the 30-second lockout, then
      unlock with the correct PIN.
- [x] Kill and relaunch the app; the lock must appear before the plan.
- [x] Disable the lock and confirm the app opens directly again.
- [x] Import a backup into a fresh install; the lock must stay off, because its
      hash is device-local.

## Report

Record for each failure:

- device model and Android version,
- build version and whether it is debug or signed release,
- exact steps,
- expected and actual behavior,
- whether the failure reproduces after a cold start.

Do not tag v1.0 until every notification, reboot, battery and timezone item has
a result, even if the result is "not reliable in this OEM's battery saver".

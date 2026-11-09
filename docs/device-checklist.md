# Android device checklist

This is the last v1.0 gate. Run it on the real Android device with a debug or
release build. Record the build version and the device model next to each item.

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

Still required on the physical device: OEM battery optimization, the real
notification shade, a real reboot, the widget, and real LAN pairing with a
second device.

## Install and first launch

- [ ] Install the arm64 APK (or `flutter install` for a debug build).
- [ ] The app opens offline, with Personal, Work and Home and no sample entries.
- [ ] The About screen shows v0.5.0, GPL-3.0-only and the InlitX attribution.

## Notifications

- [ ] On Android 13+, the notification permission is requested and can be
      granted. Denying it leaves the planner usable and does not crash.
- [ ] On Android 12+, the exact-alarm permission state is handled. If it is
      denied, reminders still use the inexact fallback and do not throw.
- [ ] Create an entry 10 minutes in the future with a 5-minute reminder.
      Lock the screen. The reminder arrives on time.
- [ ] Create a second reminder on the same entry and verify both arrive.
- [ ] Tap the notification while the app is closed; the entry editor opens.
- [ ] Tap the notification while the app is open; no duplicate screen stack.
- [ ] Edit the entry time, then verify the old notification is gone and the new
      time is scheduled.

## Reboot

- [ ] With a future reminder scheduled, reboot the device without opening the
      app. The reminder still arrives.
- [ ] Open the app after reboot and confirm the queue rebuilds without
      duplicates.

## Battery optimization

- [ ] Put the app in the device's restricted/optimized battery bucket. Schedule
      a reminder at least 30 minutes ahead; note whether it arrives.
- [ ] If it is delayed, exclude Mane from optimization and repeat the test.
      Record the exact OEM setting path.

## Timezone change

- [ ] Create a timed entry anchored in `Europe/Madrid`, and an all-day birthday
      on the same date.
- [ ] Change the device timezone to `America/New_York`. Open or resume Mane.
- [ ] The timed entry moves by the expected offset; the all-day birthday stays
      on the same date.
- [ ] Change the timezone back and verify the timed entry returns.
- [ ] Schedule a reminder, change the timezone, resume the app, and confirm the
      reminder is still scheduled for the same absolute moment.

## LAN pairing and query

- [ ] Set a username and PIN on both devices. The PIN is at least four digits.
- [ ] On device A, open Devices, show a code, and unlock with the PIN.
- [ ] Device B finds A over mDNS, or connects with A's address and port.
- [ ] Enter the code on B; both devices show the pairing.
- [ ] A's today view and next shift appear on B's Devices page after refresh.
- [ ] Turn on airplane mode, open B, and verify B's own plan still works. Turn
      airplane mode off and refresh; A's snapshot returns.
- [ ] Unpair on one device and verify queries are rejected.

## MCP

- [ ] Enable the MCP endpoint and allow write tools.
- [ ] From the same machine, call `initialize`, `tools/list` and
      `home.shopping` with the bearer token. Use `curl` or an MCP client.
- [ ] A request without the token is rejected.
- [ ] `plan.create` creates an entry visible in the app; `plan.complete` marks
      it done.
- [ ] Disable the endpoint and verify the port is closed.

## Widget

- [ ] Long-press the home screen, add the Mane widget, and confirm it shows
      today's plan and the next shift.
- [ ] Tap the widget; Mane opens.
- [ ] Change today's plan in the app, resume, and confirm the widget updates.

## Backup

- [ ] Export a backup, change or delete an entry, import the backup, and verify
      the original state returns.
- [ ] Pair the devices, export a backup, and import it into a fresh install.
      The pairing is not restored and both devices still open normally.

## Report

Record for each failure:

- device model and Android version,
- build version and whether it is debug or signed release,
- exact steps,
- expected and actual behavior,
- whether the failure reproduces after a cold start.

Do not tag v1.0 until every notification, reboot, battery and timezone item has
a result, even if the result is "not reliable in this OEM's battery saver".

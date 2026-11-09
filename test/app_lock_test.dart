import 'dart:ffi';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/app_lock/app_lock_service.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane/services/planner_repository.dart';
import 'package:sqlite3/open.dart';

void main() {
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
  });

  late AppDatabase database;
  late PlannerRepository repository;
  late DateTime now;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    await database.seedDefaults();
    repository = PlannerRepository(database);
    now = DateTime(2026, 11, 9, 8);
  });

  tearDown(() => database.close());

  test('sets, verifies and disables the local PIN', () async {
    final service = AppLockService(repository, clock: () => now);
    expect(await service.isEnabled(), isFalse);
    await service.setPin('1234');
    expect(await service.isEnabled(), isTrue);
    expect(await service.verify('1234'), isTrue);
    expect(await service.verify('9999'), isFalse);

    await service.disable();
    expect(await service.isEnabled(), isFalse);
    expect(await service.verify('1234'), isFalse);
    final settings = await database.readSettings();
    expect(settings['appLockPinHash'], '');
  });

  test('rejects a PIN outside four to eight digits', () async {
    final service = AppLockService(repository, clock: () => now);
    await expectLater(service.setPin('123'), throwsA(isA<AppLockException>()));
    await expectLater(service.setPin('123456789'), throwsA(isA<AppLockException>()));
  });

  test('locks after five misses and clears when the time passes', () async {
    final service = AppLockService(repository, clock: () => now);
    await service.setPin('1234');
    for (var attempt = 0; attempt < AppLockService.maxTries; attempt++) {
      await service.verify('0000');
    }
    expect(await service.lockoutRemaining(), greaterThan(Duration.zero));
    expect(await service.verify('1234'), isFalse);

    now = now.add(AppLockService.lockout + const Duration(seconds: 1));
    expect(await service.verify('1234'), isTrue);
    expect(await service.lockoutRemaining(), Duration.zero);
  });

  test('grace period decision is explicit', () {
    final leftAt = DateTime(2026, 11, 9, 8);
    expect(appLockNeedsAuth(leftAt: null, graceSeconds: 30, now: leftAt), isTrue);
    expect(
      appLockNeedsAuth(leftAt: leftAt, graceSeconds: 30, now: leftAt.add(const Duration(seconds: 10))),
      isFalse,
    );
    expect(
      appLockNeedsAuth(leftAt: leftAt, graceSeconds: 30, now: leftAt.add(const Duration(seconds: 31))),
      isTrue,
    );
    expect(
      appLockNeedsAuth(leftAt: leftAt, graceSeconds: 0, now: leftAt.add(const Duration(seconds: 1))),
      isTrue,
    );
  });
}

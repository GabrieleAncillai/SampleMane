import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/backup/auto_backup_service.dart';
import 'package:mane/features/backup/backup_service.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane_core/mane_core.dart';
import 'package:sqlite3/open.dart';

void main() {
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
    initializeTimeZones();
  });

  late AppDatabase database;
  late Directory directory;
  late DateTime now;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    await database.seedDefaults();
    directory = await Directory.systemTemp.createTemp('mane-auto-backup');
    now = DateTime(2026, 11, 9, 8);
  });

  tearDown(() async {
    await database.close();
    await directory.delete(recursive: true);
  });

  test('writes one copy per day and keeps the configured number', () async {
    final service = AutoBackupService(BackupService(database), directory: directory, clock: () => now);

    expect(await service.runIfDue(enabled: false, keep: 5), isFalse);
    expect(await service.runIfDue(enabled: true, keep: 5), isTrue);
    expect(await service.runIfDue(enabled: true, keep: 5), isFalse);

    for (var day = 10; day <= 13; day++) {
      now = DateTime(2026, 11, day, 8);
      await service.runIfDue(enabled: true, keep: 2);
    }

    final files = await service.listBackups();
    expect(files, hasLength(2));
    final payload = jsonDecode(await files.first.readAsString()) as Map<String, Object?>;
    expect(payload['app'], 'mane');
    expect(payload['schemaVersion'], 8);
    final entries = payload['entries']! as List<Object?>;
    expect(entries, isEmpty);
  });

  test('runNow writes a valid backup even when the folder does not exist', () async {
    final nested = Directory('${directory.path}/nested/backups');
    final service = AutoBackupService(BackupService(database), directory: nested, clock: () => now);
    final file = await service.runNow(keep: 5);
    expect(file.existsSync(), isTrue);
    expect(file.path, endsWith('.json'));
    final payload = jsonDecode(await file.readAsString()) as Map<String, Object?>;
    expect(payload['spaces'], isNotEmpty);
    expect(payload['homePurchases'], isEmpty);
  });
}

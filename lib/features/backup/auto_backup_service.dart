import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'backup_service.dart';

/// Daily local JSON copies with rotation. Manual export stays the canonical
/// path; this only reduces the cost of forgetting to export.
class AutoBackupService {
  AutoBackupService(this._backupService, {Directory? directory, DateTime Function()? clock})
    : _directoryOverride = directory,
      _clock = clock ?? DateTime.now;

  static const prefix = 'mane-auto-';
  static const extension = '.json';

  final BackupService _backupService;
  final Directory? _directoryOverride;
  final DateTime Function() _clock;

  Future<Directory> _directory() async {
    final override = _directoryOverride;
    if (override != null) return override;
    final support = await getApplicationSupportDirectory();
    return Directory(p.join(support.path, 'backups'));
  }

  Future<List<File>> listBackups() async {
    final dir = await _directory();
    if (!dir.existsSync()) return const [];
    final files = await dir
        .list()
        .where((entry) => entry is File && _isBackup(entry.path))
        .cast<File>()
        .toList();
    files.sort((a, b) => b.path.compareTo(a.path));
    return files;
  }

  /// Writes once per local calendar day. Returns true when a copy was written.
  Future<bool> runIfDue({required bool enabled, required int keep}) async {
    if (!enabled) return false;
    final files = await listBackups();
    final now = _clock();
    if (files.isNotEmpty) {
      final newest = files.first.statSync().modified;
      if (newest.year == now.year && newest.month == now.month && newest.day == now.day) {
        return false;
      }
    }
    await runNow(keep: keep);
    return true;
  }

  Future<File> runNow({int keep = 5}) async {
    final dir = await _directory();
    if (!dir.existsSync()) await dir.create(recursive: true);
    final now = _clock();
    final stamp =
        '${now.year.toString().padLeft(4, '0')}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}-'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
    final target = File(p.join(dir.path, '$prefix$stamp$extension'));
    final part = File('${target.path}.part');
    final json = await _backupService.exportJson();
    await part.writeAsString(json, flush: true);
    await part.rename(target.path);

    final files = await listBackups();
    for (var index = keep; index < files.length; index++) {
      await files[index].delete();
    }
    return target;
  }

  static bool _isBackup(String path) {
    final name = p.basename(path);
    return name.startsWith(prefix) && name.endsWith(extension);
  }
}

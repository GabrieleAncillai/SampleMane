import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Writes [json] through the platform save dialog.
///
/// Returns the chosen path, or null when the user cancelled or no file picker
/// is available (a bare Linux session without zenity/kdialog, for example).
Future<String?> saveBackupFile(String json, {required String dialogTitle}) async {
  final now = DateTime.now().toUtc();
  final name =
      'mane-backup-${now.year.toString().padLeft(4, '0')}'
      '${now.month.toString().padLeft(2, '0')}'
      '${now.day.toString().padLeft(2, '0')}.json';
  try {
    return await FilePicker.platform.saveFile(
      dialogTitle: dialogTitle,
      fileName: name,
      type: FileType.custom,
      allowedExtensions: ['json'],
      bytes: Uint8List.fromList(utf8.encode(json)),
    );
  } catch (_) {
    return null;
  }
}

/// Reads a JSON backup chosen by the user, or null when cancelled.
Future<String?> pickBackupText() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
    withData: true,
  );
  final file = result?.files.single;
  if (file == null) return null;
  final bytes = file.bytes;
  if (bytes != null) return utf8.decode(bytes);
  final path = file.path;
  if (path == null) return null;
  return File(path).readAsString();
}

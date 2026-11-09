import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Writes an iCalendar file through the platform save dialog.
Future<String?> saveIcsFile(String content, {required String dialogTitle}) async {
  final now = DateTime.now().toUtc();
  final name =
      'mane-calendar-${now.year.toString().padLeft(4, '0')}'
      '${now.month.toString().padLeft(2, '0')}'
      '${now.day.toString().padLeft(2, '0')}.ics';
  try {
    return await FilePicker.platform.saveFile(
      dialogTitle: dialogTitle,
      fileName: name,
      type: FileType.custom,
      allowedExtensions: ['ics'],
      bytes: Uint8List.fromList(utf8.encode(content)),
    );
  } catch (_) {
    return null;
  }
}

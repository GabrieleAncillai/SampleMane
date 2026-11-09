import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

/// Reads a local `.ics` file chosen by the user, or null when cancelled.
///
/// No network access is involved: the file picker returns bytes or a path.
Future<String?> pickIcsText() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['ics', 'ical'],
    withData: true,
  );
  final file = result?.files.single;
  if (file == null) return null;
  final bytes = file.bytes;
  if (bytes != null) return utf8.decode(bytes, allowMalformed: true);
  final path = file.path;
  if (path == null) return null;
  return File(path).readAsString();
}

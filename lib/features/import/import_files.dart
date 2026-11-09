import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

/// Reads a local text file chosen by the user, or null when cancelled.
///
/// No network access is involved: the file picker returns bytes or a path.
Future<String?> pickTextFile(List<String> extensions) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: extensions,
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

Future<String?> pickIcsText() => pickTextFile(const ['ics', 'ical']);

Future<String?> pickCompanionText() => pickTextFile(const ['json']);

Future<String?> pickGymManeText() => pickTextFile(const ['json']);

Future<String?> pickCsvText() => pickTextFile(const ['csv']);

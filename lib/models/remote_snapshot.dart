import 'package:mane_core/mane_core.dart';

/// A read-only snapshot returned by a paired device.
///
/// It is display data, not a merged copy: Mane keeps every device's plan
/// separate and asks the owner over the LAN.
class RemoteSnapshot {
  const RemoteSnapshot({
    required this.deviceId,
    required this.deviceName,
    required this.fetchedAt,
    required this.date,
    required this.todayEntries,
    required this.todayShifts,
    this.nextShiftLabel,
    this.nextShiftStart,
    required this.openShopping,
  });

  final String deviceId;
  final String deviceName;
  final DateTime fetchedAt;
  final LocalDate date;
  final List<String> todayEntries;
  final List<String> todayShifts;
  final String? nextShiftLabel;
  final DateTime? nextShiftStart;
  final int openShopping;

  factory RemoteSnapshot.fromPayload({
    required String deviceId,
    required String deviceName,
    required DateTime fetchedAt,
    required Map<String, Object?> data,
  }) {
    final today = data['today'] is Map ? Map<String, Object?>.from(data['today'] as Map) : const {};
    final entries = <String>[];
    for (final raw in (today['entries'] as List?) ?? const []) {
      if (raw is! Map) continue;
      final entry = raw['entry'];
      if (entry is Map && entry['title'] is String) entries.add(entry['title'] as String);
    }
    final shifts = <String>[];
    for (final raw in (today['shifts'] as List?) ?? const []) {
      if (raw is! Map) continue;
      final name = raw['patternName'] is String ? raw['patternName'] as String : 'Shift';
      final label = raw['label'] is String && (raw['label'] as String).isNotEmpty ? ' · ${raw['label']}' : '';
      shifts.add('$name$label');
    }

    String? nextShiftLabel;
    DateTime? nextShiftStart;
    final nextShifts = (data['nextShifts'] as List?) ?? const [];
    if (nextShifts.isNotEmpty && nextShifts.first is Map) {
      final first = Map<String, Object?>.from(nextShifts.first as Map);
      final name = first['patternName'] is String ? first['patternName'] as String : 'Shift';
      final label = first['label'] is String && (first['label'] as String).isNotEmpty
          ? ' · ${first['label']}'
          : '';
      nextShiftLabel = '$name$label';
      nextShiftStart = DateTime.tryParse('${first['startAt']}');
    }

    return RemoteSnapshot(
      deviceId: deviceId,
      deviceName: deviceName,
      fetchedAt: fetchedAt,
      date: LocalDate.parse('${data['date']}'),
      todayEntries: entries,
      todayShifts: shifts,
      nextShiftLabel: nextShiftLabel,
      nextShiftStart: nextShiftStart,
      openShopping: data['openShopping'] is int ? data['openShopping'] as int : 0,
    );
  }
}

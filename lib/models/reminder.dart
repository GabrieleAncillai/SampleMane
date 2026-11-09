/// A reminder for one entry.
///
/// The id is deterministic so rescheduling the same reminder does not create a
/// second notification. A reminder either uses [offsetMinutes] before the
/// occurrence or an absolute local [timeMinute] on the occurrence day.
class Reminder {
  const Reminder({
    required this.id,
    required this.entryId,
    required this.offsetMinutes,
    this.timeMinute,
    this.enabled = true,
  });

  final String id;
  final String entryId;

  /// Minutes before the occurrence starts. Zero means at the start.
  final int offsetMinutes;

  /// Local time of day in the device timezone. When set, the reminder fires at
  /// this time on the occurrence's display date instead of using the offset.
  final int? timeMinute;
  final bool enabled;

  bool get isAtTime => timeMinute != null;

  static String idFor(String entryId, int offsetMinutes) => '$entryId:$offsetMinutes';

  static String timeIdFor(String entryId, int timeMinute) => '$entryId:at:$timeMinute';

  Reminder copyWith({int? offsetMinutes, int? timeMinute, bool clearTime = false, bool? enabled}) => Reminder(
    id: id,
    entryId: entryId,
    offsetMinutes: offsetMinutes ?? this.offsetMinutes,
    timeMinute: clearTime ? null : (timeMinute ?? this.timeMinute),
    enabled: enabled ?? this.enabled,
  );
}

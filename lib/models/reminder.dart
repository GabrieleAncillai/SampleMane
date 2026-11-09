/// A reminder offset for one entry.
///
/// The id is deterministic (`entryId:offsetMinutes`) so rescheduling the same
/// reminder does not create a second notification.
class Reminder {
  const Reminder({required this.id, required this.entryId, required this.offsetMinutes, this.enabled = true});

  final String id;
  final String entryId;

  /// Minutes before the occurrence starts. Zero means at the start.
  final int offsetMinutes;
  final bool enabled;

  static String idFor(String entryId, int offsetMinutes) => '$entryId:$offsetMinutes';
}

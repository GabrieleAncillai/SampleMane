/// A soft sleep window derived from the last commitment today and the first
/// one tomorrow. It is a hint, never a task or a hard rule.
class SleepWindow {
  const SleepWindow({this.bedtime, this.wakeTime, this.warning = false});

  final DateTime? bedtime;
  final DateTime? wakeTime;

  /// True when the plan leaves no positive gap between bedtime and wake time.
  final bool warning;

  bool get hasWindow => bedtime != null && wakeTime != null;

  Duration? get duration {
    final sleep = bedtime;
    final wake = wakeTime;
    if (sleep == null || wake == null) return null;
    final value = wake.difference(sleep);
    return value.isNegative ? Duration.zero : value;
  }
}

SleepWindow computeSleepWindow({
  required Iterable<DateTime> lastEndsToday,
  required Iterable<DateTime> firstStartsTomorrow,
  Duration commute = Duration.zero,
  Duration windDown = Duration.zero,
  Duration wakeBuffer = Duration.zero,
}) {
  DateTime? lastEnd;
  for (final end in lastEndsToday) {
    if (lastEnd == null || end.isAfter(lastEnd)) lastEnd = end;
  }
  DateTime? firstStart;
  for (final start in firstStartsTomorrow) {
    if (firstStart == null || start.isBefore(firstStart)) firstStart = start;
  }

  final bedtime = lastEnd?.add(commute).add(windDown);
  final wakeTime = firstStart?.subtract(commute).subtract(wakeBuffer);
  final warning = bedtime != null && wakeTime != null && !bedtime.isBefore(wakeTime);
  return SleepWindow(bedtime: bedtime, wakeTime: wakeTime, warning: warning);
}

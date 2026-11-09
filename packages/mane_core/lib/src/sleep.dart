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

/// A commitment with its own commute and wind-down buffers.
class SleepCommitment {
  const SleepCommitment({required this.at, this.commute = Duration.zero, this.windDown = Duration.zero});

  final DateTime at;
  final Duration commute;
  final Duration windDown;
}

/// Computes the window using per-commitment buffers.
///
/// For the last commitment of today, the latest `at + commute + windDown` wins.
/// For the first commitment tomorrow, the earliest `at - commute - wakeBuffer`
/// wins. This is how a job with a longer commute moves the soft bedtime without
/// changing another job's buffer.
SleepWindow computeSleepWindowFromCommitments({
  required Iterable<SleepCommitment> lastEndsToday,
  required Iterable<SleepCommitment> firstStartsTomorrow,
  Duration wakeBuffer = Duration.zero,
}) {
  DateTime? bedtime;
  for (final commitment in lastEndsToday) {
    final candidate = commitment.at.add(commitment.commute).add(commitment.windDown);
    if (bedtime == null || candidate.isAfter(bedtime)) bedtime = candidate;
  }
  DateTime? wakeTime;
  for (final commitment in firstStartsTomorrow) {
    final candidate = commitment.at.subtract(commitment.commute).subtract(wakeBuffer);
    if (wakeTime == null || candidate.isBefore(wakeTime)) wakeTime = candidate;
  }
  final warning = bedtime != null && wakeTime != null && !bedtime.isBefore(wakeTime);
  return SleepWindow(bedtime: bedtime, wakeTime: wakeTime, warning: warning);
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

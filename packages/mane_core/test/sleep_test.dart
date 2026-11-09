import 'package:mane_core/mane_core.dart';
import 'package:test/test.dart';

void main() {
  test('computes bedtime from the last end and wake time from the first start', () {
    final window = computeSleepWindow(
      lastEndsToday: [DateTime.utc(2026, 11, 9, 21), DateTime.utc(2026, 11, 9, 22)],
      firstStartsTomorrow: [DateTime.utc(2026, 11, 10, 8), DateTime.utc(2026, 11, 10, 9)],
      commute: const Duration(minutes: 30),
      windDown: const Duration(minutes: 60),
      wakeBuffer: const Duration(minutes: 30),
    );

    expect(window.bedtime, DateTime.utc(2026, 11, 9, 23, 30));
    expect(window.wakeTime, DateTime.utc(2026, 11, 10, 7));
    expect(window.warning, isFalse);
    expect(window.duration, const Duration(hours: 7, minutes: 30));
  });

  test('warns when the plan leaves no sleep gap', () {
    final window = computeSleepWindow(
      lastEndsToday: [DateTime.utc(2026, 11, 9, 23)],
      firstStartsTomorrow: [DateTime.utc(2026, 11, 10, 1)],
      commute: const Duration(minutes: 30),
      windDown: const Duration(minutes: 60),
      wakeBuffer: const Duration(minutes: 30),
    );

    expect(window.bedtime, DateTime.utc(2026, 11, 10, 0, 30));
    expect(window.wakeTime, DateTime.utc(2026, 11, 10, 0));
    expect(window.warning, isTrue);
    expect(window.duration, Duration.zero);
  });

  test('handles a missing commitment on either side', () {
    final onlyBedtime = computeSleepWindow(
      lastEndsToday: [DateTime.utc(2026, 11, 9, 20)],
      firstStartsTomorrow: const [],
    );
    expect(onlyBedtime.bedtime, DateTime.utc(2026, 11, 9, 20));
    expect(onlyBedtime.wakeTime, isNull);
    expect(onlyBedtime.hasWindow, isFalse);

    final empty = computeSleepWindow(lastEndsToday: const [], firstStartsTomorrow: const []);
    expect(empty.bedtime, isNull);
    expect(empty.wakeTime, isNull);
    expect(empty.warning, isFalse);
  });

  test('per-commitment buffers use the last end and first start', () {
    final window = computeSleepWindowFromCommitments(
      lastEndsToday: [
        SleepCommitment(
          at: DateTime.utc(2026, 11, 9, 20),
          commute: const Duration(minutes: 60),
          windDown: const Duration(minutes: 30),
        ),
        SleepCommitment(
          at: DateTime.utc(2026, 11, 9, 22),
          commute: const Duration(minutes: 15),
          windDown: const Duration(minutes: 45),
        ),
      ],
      firstStartsTomorrow: [
        SleepCommitment(at: DateTime.utc(2026, 11, 10, 9), commute: const Duration(minutes: 60)),
        SleepCommitment(at: DateTime.utc(2026, 11, 10, 8), commute: const Duration(minutes: 10)),
      ],
      wakeBuffer: const Duration(minutes: 30),
    );

    expect(window.bedtime, DateTime.utc(2026, 11, 9, 23));
    expect(window.wakeTime, DateTime.utc(2026, 11, 10, 7, 20));
    expect(window.warning, isFalse);
  });
}

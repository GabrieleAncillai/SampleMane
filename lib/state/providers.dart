import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../models/date_range.dart';
import '../services/app_database.dart';
import '../services/planner_repository.dart';

/// Overridden in `main()` with the opened database.
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProvider must be overridden');
});

/// The device's IANA timezone. Overridden in `main()` from the platform.
final deviceTimeZoneProvider = Provider<String>((ref) => 'UTC');

/// Wall clock for screens and tests. Override in tests to keep dates stable.
final nowProvider = Provider<DateTime>((ref) => DateTime.now());

final repositoryProvider = Provider<PlannerRepository>(
  (ref) => PlannerRepository(ref.watch(databaseProvider)),
);

final spacesProvider = StreamProvider<List<Space>>((ref) => ref.watch(repositoryProvider).watchSpaces());

/// Used only if a screen is built before the first space stream arrives.
/// The app seeds these rows on first launch.
const fallbackSpaces = <Space>[
  Space(id: 'personal', name: 'Personal', colorValue: 0xFFB07D5C, position: 0),
  Space(id: 'work', name: 'Work', colorValue: 0xFF4A6FA5, position: 1),
  Space(id: 'home', name: 'Home', colorValue: 0xFF5B7F6B, position: 2),
];

final entriesProvider = StreamProvider.family<List<EntryOccurrence>, DateRange>((ref, range) {
  final timeZone = ref.watch(deviceTimeZoneProvider);
  return ref.watch(repositoryProvider).watchEntries(range.start, range.end, timeZone);
});

final shiftsProvider = StreamProvider.family<List<ShiftOccurrence>, DateRange>((ref, range) {
  final timeZone = ref.watch(deviceTimeZoneProvider);
  return ref.watch(repositoryProvider).watchShifts(range.start, range.end, timeZone);
});

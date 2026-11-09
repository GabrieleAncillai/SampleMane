import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../models/date_range.dart';
import '../services/app_database.dart';
import '../services/planner_repository.dart';

/// Overridden in `main()` with the opened database.
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProvider must be overridden');
});

final repositoryProvider = Provider<PlannerRepository>(
  (ref) => PlannerRepository(ref.watch(databaseProvider)),
);

final spacesProvider = StreamProvider<List<Space>>((ref) => ref.watch(repositoryProvider).watchSpaces());

/// Used only if a screen is built before the first space stream arrives.
/// The app seeds these two rows on first launch.
const fallbackSpaces = <Space>[
  Space(id: 'home', name: 'Home', colorValue: 0xFF5B7F6B),
  Space(id: 'work', name: 'Work', colorValue: 0xFF4A6FA5),
];

final entriesProvider = StreamProvider.family<List<EntryOccurrence>, DateRange>(
  (ref, range) => ref.watch(repositoryProvider).watchEntries(range.start, range.end),
);

final shiftsProvider = StreamProvider.family<List<ShiftOccurrence>, DateRange>(
  (ref, range) => ref.watch(repositoryProvider).watchShifts(range.start, range.end),
);

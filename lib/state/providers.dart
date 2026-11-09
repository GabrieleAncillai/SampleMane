import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../features/app_lock/app_lock_service.dart';
import '../features/backup/auto_backup_service.dart';
import '../features/backup/backup_service.dart';
import '../features/home_widget/home_widget_service.dart';
import '../features/mcp/mcp_server.dart';
import '../features/sync/identity_service.dart';
import '../features/sync/lan_client.dart';
import '../features/sync/lan_server.dart';
import '../features/sync/peer_discovery.dart';
import '../features/sync/sync_service.dart';
import '../models/date_range.dart';
import '../models/home_item.dart';
import '../models/local_identity.dart';
import '../models/paired_device.dart';
import '../models/shopping_item.dart';
import '../models/app_settings.dart';
import '../services/app_database.dart';
import '../services/notification_service.dart';
import '../services/planner_repository.dart';
import '../services/reminder_coordinator.dart';

/// Overridden in `main()` with the opened database.
final databaseProvider = Provider<AppDatabase>((ref) {
  throw StateError('databaseProvider must be overridden');
});

/// The device's IANA timezone. Overridden in `main()` from the platform and
/// refreshed on app resume when the system zone changes.
class DeviceTimeZoneController extends Notifier<String> {
  DeviceTimeZoneController({this.initial = 'UTC'});

  final String initial;

  @override
  String build() => initial;

  void set(String value) {
    if (isKnownTimeZone(value) && value != state) state = value;
  }
}

final deviceTimeZoneProvider = NotifierProvider<DeviceTimeZoneController, String>(
  DeviceTimeZoneController.new,
);

/// Wall clock for screens and tests. Override in tests to keep dates stable.
final nowProvider = Provider<DateTime>((ref) => DateTime.now());

/// A clock for services that need the current instant when they run.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Overridden in `main()` with the initialised notification plugin.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw StateError('notificationServiceProvider must be overridden');
});

final reminderCoordinatorProvider = Provider<ReminderCoordinator>(
  (ref) => ReminderCoordinator(
    repository: ref.watch(repositoryProvider),
    notifications: ref.watch(notificationServiceProvider),
    deviceTimeZone: ref.watch(deviceTimeZoneProvider),
    clock: ref.watch(clockProvider),
  ),
);

final repositoryProvider = Provider<PlannerRepository>(
  (ref) => PlannerRepository(ref.watch(databaseProvider)),
);

final spacesProvider = StreamProvider<List<Space>>((ref) => ref.watch(repositoryProvider).watchSpaces());

final tagsProvider = StreamProvider<List<Tag>>((ref) => ref.watch(repositoryProvider).watchTags());

final homeItemsProvider = StreamProvider<List<HomeItem>>(
  (ref) => ref.watch(repositoryProvider).watchHomeItems(),
);

final shoppingItemsProvider = StreamProvider<List<ShoppingItem>>(
  (ref) => ref.watch(repositoryProvider).watchShoppingItems(),
);

final backupServiceProvider = Provider<BackupService>((ref) => BackupService(ref.watch(databaseProvider)));

final autoBackupServiceProvider = Provider<AutoBackupService>(
  (ref) => AutoBackupService(ref.watch(backupServiceProvider)),
);

final appLockServiceProvider = Provider<AppLockService>(
  (ref) => AppLockService(ref.watch(repositoryProvider)),
);

final homeWidgetServiceProvider = Provider<HomeWidgetService>((ref) => HomeWidgetService());

class TagFilterController extends Notifier<Set<String>> {
  @override
  Set<String> build() => const <String>{};

  void toggle(String tagId) {
    state = state.contains(tagId) ? (state.toSet()..remove(tagId)) : (state.toSet()..add(tagId));
  }

  void clear() => state = const <String>{};
}

final tagFilterProvider = NotifierProvider<TagFilterController, Set<String>>(TagFilterController.new);

/// Used only if a screen is built before the first space stream arrives.
/// The app seeds these rows on first launch.
const fallbackSpaces = <Space>[
  Space(id: 'personal', name: 'Personal', colorValue: 0xFFB07D5C, position: 0),
  Space(id: 'work', name: 'Work', colorValue: 0xFF4A6FA5, position: 1),
  Space(id: 'home', name: 'Home', colorValue: 0xFF5B7F6B, position: 2),
];

final entriesProvider = StreamProvider.family<List<EntryOccurrence>, DateRange>((ref, range) {
  final timeZone = ref.watch(deviceTimeZoneProvider);
  final filter = ref.watch(tagFilterProvider);
  final knownTags = ref.watch(tagsProvider).value;
  return ref.watch(repositoryProvider).watchEntries(range.start, range.end, timeZone).map((items) {
    final active = knownTags == null ? filter : filter.intersection(knownTags.map((tag) => tag.id).toSet());
    if (active.isEmpty) return items;
    return items.where((item) => item.entry.tagIds.any(active.contains)).toList();
  });
});

final shiftsProvider = StreamProvider.family<List<ShiftOccurrence>, DateRange>((ref, range) {
  final timeZone = ref.watch(deviceTimeZoneProvider);
  final filter = ref.watch(tagFilterProvider);
  final knownTags = ref.watch(tagsProvider).value;
  return ref.watch(repositoryProvider).watchShifts(range.start, range.end, timeZone).map((items) {
    final active = knownTags == null ? filter : filter.intersection(knownTags.map((tag) => tag.id).toSet());
    if (active.isEmpty) return items;
    return items.where((item) => item.pattern.tagIds.any(active.contains)).toList();
  });
});

final shiftPatternsProvider = StreamProvider<List<ShiftPattern>>(
  (ref) => ref.watch(repositoryProvider).watchShiftPatterns(),
);

final identityServiceProvider = Provider<IdentityService>(
  (ref) => IdentityService(ref.watch(repositoryProvider)),
);

final identityProvider = FutureProvider<LocalIdentity?>(
  (ref) => ref.watch(repositoryProvider).readIdentity(),
);

final pairedDevicesProvider = StreamProvider<List<PairedDevice>>(
  (ref) => ref.watch(repositoryProvider).watchPairedDevices(),
);

final lanClientProvider = Provider<LanClient>(
  (ref) => LanClient(ref.read(repositoryProvider), clock: ref.read(clockProvider)),
);

final lanServerProvider = Provider<LanServer>(
  (ref) => LanServer(
    repository: ref.read(repositoryProvider),
    deviceTimeZone: () => ref.read(deviceTimeZoneProvider),
    clock: ref.read(clockProvider),
  ),
);

final peerDiscoveryProvider = Provider<PeerDiscovery>((ref) => BonsoirPeerDiscovery());

final syncServiceProvider = Provider<SyncService>((ref) {
  final service = SyncService(
    repository: ref.read(repositoryProvider),
    identityService: ref.read(identityServiceProvider),
    client: ref.read(lanClientProvider),
    server: ref.read(lanServerProvider),
    discovery: ref.read(peerDiscoveryProvider),
    clock: ref.read(clockProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

final mcpServerProvider = Provider<McpServer>((ref) {
  final server = McpServer(
    repository: ref.read(repositoryProvider),
    deviceTimeZone: () => ref.read(deviceTimeZoneProvider),
    clock: ref.read(clockProvider),
  );
  ref.onDispose(server.stop);
  return server;
});

final serviceCoordinatorProvider = Provider<ServiceCoordinator>(
  (ref) => ServiceCoordinator(
    repository: ref.read(repositoryProvider),
    sync: ref.read(syncServiceProvider),
    mcp: ref.read(mcpServerProvider),
  ),
);

class ServiceCoordinator {
  ServiceCoordinator({required this.repository, required this.sync, required this.mcp});

  final PlannerRepository repository;
  final SyncService sync;
  final McpServer mcp;

  /// Applies the opt-in switches. Failures are surfaced through each service's
  /// own state; the planner keeps working either way.
  Future<void> apply(AppSettings settings) async {
    if (settings.syncEnabled) {
      await sync.start();
    } else {
      await sync.stop();
    }
    final identity = await repository.readIdentity();
    if (settings.mcpEnabled && identity != null) {
      await mcp.start(identity: identity, writesEnabled: settings.mcpWritesEnabled, port: McpServer.port);
    } else {
      await mcp.stop();
    }
  }
}

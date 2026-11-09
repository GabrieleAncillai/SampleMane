import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mane_core/mane_core.dart';
import 'package:uuid/uuid.dart';

import '../../app_version.dart';
import '../../models/app_settings.dart';
import '../../models/local_identity.dart';
import '../../models/shopping_item.dart';
import '../../services/planner_repository.dart';
import '../sync/pairing_crypto.dart';
import '../sync/remote_payload.dart';

/// A minimal MCP endpoint over loopback HTTP.
///
/// It speaks JSON-RPC 2.0 for `initialize`, `tools/list` and `tools/call`.
/// Read tools are always available; write tools only when the user enables
/// them. Every request needs the device's bearer token. The server calls the
/// same [PlannerRepository] as the UI, never the database directly.
class McpServer {
  McpServer({
    required PlannerRepository repository,
    required String Function() deviceTimeZone,
    DateTime Function()? clock,
  }) : _repository = repository,
       _deviceTimeZone = deviceTimeZone,
       _clock = clock ?? DateTime.now;

  static const protocolVersion = '2025-06-18';
  static const port = 8765;
  static const path = '/mcp';
  static const sessionHeader = 'mcp-session-id';
  static const sessionLifetime = Duration(hours: 1);

  final PlannerRepository _repository;
  final String Function() _deviceTimeZone;
  final DateTime Function() _clock;

  HttpServer? _server;
  LocalIdentity? _identity;
  bool _writesEnabled = false;
  final Map<String, DateTime> _sessions = {};

  int get boundPort => _server?.port ?? 0;

  Future<int> start({
    required LocalIdentity identity,
    required bool writesEnabled,
    int port = 0,
    InternetAddress? address,
  }) async {
    if (_server != null) {
      _writesEnabled = writesEnabled;
      return _server!.port;
    }
    _identity = identity;
    _writesEnabled = writesEnabled;
    final server = await HttpServer.bind(address ?? InternetAddress.loopbackIPv4, port, shared: false);
    _server = server;
    server.listen(_handle, onError: (Object _) {});
    return server.port;
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }

  Future<void> _handle(HttpRequest request) async {
    if (request.uri.path != path) {
      await _respond(request.response, HttpStatus.notFound, {'error': 'not_found'});
      return;
    }
    if (request.method == 'DELETE') {
      await _handleDelete(request);
      return;
    }
    if (request.method != 'POST') {
      request.response.headers.set(HttpHeaders.allowHeader, 'POST, DELETE');
      await _respond(request.response, HttpStatus.methodNotAllowed, {'error': 'method_not_allowed'});
      return;
    }
    final identity = _identity;
    if (identity == null) {
      await _respond(request.response, HttpStatus.serviceUnavailable, {'error': 'not_ready'});
      return;
    }
    final token = _bearerToken(request);
    if (!PairingCrypto.constantTimeEquals(utf8.encode(token), utf8.encode(identity.mcpToken))) {
      await _respond(request.response, HttpStatus.unauthorized, {'error': 'unauthorized'});
      return;
    }

    final sessionId = request.headers.value(sessionHeader);
    if (sessionId != null && !_touchSession(sessionId)) {
      await _respond(request.response, HttpStatus.notFound, {'error': 'unknown_session'});
      return;
    }

    final String body;
    try {
      body = await _readBody(request);
    } on McpException {
      await _respond(request.response, HttpStatus.requestEntityTooLarge, {'error': 'too_large'});
      return;
    }

    Object? decoded;
    try {
      decoded = jsonDecode(body);
    } on FormatException {
      await _respondRpc(request, _error(null, -32700, 'Parse error'));
      return;
    }
    if (decoded is! Map<String, dynamic>) {
      await _respondRpc(request, _error(null, -32600, 'Invalid request'));
      return;
    }

    final id = decoded['id'];
    final method = decoded['method'];
    if (decoded['jsonrpc'] != '2.0' || method is! String) {
      await _respondRpc(request, _error(id, -32600, 'Invalid request'));
      return;
    }
    if (method == 'notifications/initialized' || method.startsWith('notifications/')) {
      await _respond(request.response, HttpStatus.accepted, null);
      return;
    }

    try {
      final result = await _dispatch(method, decoded['params']);
      if (method == 'initialize') {
        final created = PairingCrypto.randomBase64(18);
        _sessions[created] = _clock().toUtc().add(sessionLifetime);
        request.response.headers.set(sessionHeader, created);
      }
      await _respondRpc(request, {'jsonrpc': '2.0', 'id': id, 'result': result});
    } on _RpcException catch (error) {
      await _respondRpc(request, _error(id, error.code, error.message));
    } on Object catch (error) {
      await _respondRpc(request, _error(id, -32603, 'Internal error: $error'));
    }
  }

  Future<void> _handleDelete(HttpRequest request) async {
    final identity = _identity;
    if (identity == null) {
      await _respond(request.response, HttpStatus.serviceUnavailable, {'error': 'not_ready'});
      return;
    }
    final token = _bearerToken(request);
    if (!PairingCrypto.constantTimeEquals(utf8.encode(token), utf8.encode(identity.mcpToken))) {
      await _respond(request.response, HttpStatus.unauthorized, {'error': 'unauthorized'});
      return;
    }
    final sessionId = request.headers.value(sessionHeader);
    if (sessionId != null) _sessions.remove(sessionId);
    request.response.statusCode = HttpStatus.noContent;
    await request.response.close();
  }

  /// Unknown explicit sessions are rejected, but a client that never sends the
  /// header keeps working. Expired sessions are cleaned on every request.
  bool _touchSession(String id) {
    final now = _clock().toUtc();
    _sessions.removeWhere((_, expiresAt) => now.isAfter(expiresAt));
    final expiresAt = _sessions[id];
    if (expiresAt == null) return false;
    _sessions[id] = now.add(sessionLifetime);
    return true;
  }

  Future<Object?> _dispatch(String method, Object? params) async {
    switch (method) {
      case 'initialize':
        return {
          'protocolVersion': protocolVersion,
          'capabilities': {
            'tools': {'listChanged': false},
          },
          'serverInfo': {'name': 'mane', 'version': appVersion},
        };
      case 'ping':
        return <String, Object?>{};
      case 'tools/list':
        return {'tools': _tools()};
      case 'tools/call':
        final arguments = params is Map ? params : const <String, Object?>{};
        final name = arguments['name'];
        final input = arguments['arguments'];
        if (name is! String) throw const _RpcException(-32602, 'Tool name is required');
        return _callTool(name, input is Map ? Map<String, Object?>.from(input) : const {});
      default:
        throw const _RpcException(-32601, 'Method not found');
    }
  }

  Future<Object?> _callTool(String name, Map<String, Object?> arguments) async {
    try {
      final result = await _runTool(name, arguments);
      return {
        'content': [
          {'type': 'text', 'text': jsonEncode(result)},
        ],
        'isError': false,
      };
    } on _RpcException {
      rethrow;
    } on Object catch (error) {
      return {
        'content': [
          {'type': 'text', 'text': '$error'},
        ],
        'isError': true,
      };
    }
  }

  Future<Object?> _runTool(String name, Map<String, Object?> arguments) async {
    final now = _clock();
    final timeZone = _deviceTimeZone();
    final today = localDateAt(now, timeZone);

    switch (name) {
      case 'personal.today':
        final entries = await _repository.loadEntries(today, today, timeZone);
        return {
          'date': today.iso,
          'entries': [
            for (final occurrence in entries)
              if (occurrence.entry.spaceId == 'personal') SyncPayloads.occurrenceJson(occurrence),
          ],
        };
      case 'work.next_shifts':
        final count = _intArg(arguments, 'count', fallback: 5).clamp(1, 50);
        final shifts = await _repository.watchShifts(today, today.addDays(30), timeZone).first;
        final next =
            shifts.where((shift) => shift.pattern.spaceId == 'work' && shift.startAt.isAfter(now)).toList()
              ..sort((a, b) => a.startAt.compareTo(b.startAt));
        return {
          'shifts': [for (final shift in next.take(count)) SyncPayloads.shiftJson(shift)],
        };
      case 'home.shopping':
        final items = (await _repository.watchShoppingItems().first).where((item) => !item.checked).toList();
        return {
          'items': [for (final item in items) SyncPayloads.shoppingItemJson(item)],
        };
      case 'plan.range':
        final range = _dateRange(arguments, today);
        final spaceId = arguments['spaceId'] as String?;
        final entries = await _repository.loadEntries(range.$1, range.$2, timeZone);
        return {
          'start': range.$1.iso,
          'end': range.$2.iso,
          'entries': [
            for (final occurrence in entries)
              if (spaceId == null || occurrence.entry.spaceId == spaceId)
                SyncPayloads.occurrenceJson(occurrence),
          ],
        };
      case 'plan.search':
        final query = _stringArg(arguments, 'query');
        final results = await _repository.search(query);
        return {
          'entries': [for (final entry in results.entries) SyncPayloads.entryJson(entry)],
          'home': [for (final item in results.homeItems) SyncPayloads.homeItemJson(item)],
        };
      case 'plan.get':
        final entryId = _stringArg(arguments, 'entryId');
        final entry = await _repository.readEntry(entryId);
        if (entry == null || entry.deletedAt != null) {
          throw const _RpcException(-32602, 'Unknown entryId');
        }
        final reminders = await _repository.readRemindersForEntry(entryId);
        return {
          'entry': SyncPayloads.entryJson(entry),
          'reminders': [
            for (final reminder in reminders)
              {
                'id': reminder.id,
                'offsetMinutes': reminder.offsetMinutes,
                'timeMinute': reminder.timeMinute,
                'enabled': reminder.enabled,
              },
          ],
        };
      case 'work.shifts':
        final range = _dateRange(arguments, today, defaultDays: 30);
        final spaceId = arguments['spaceId'] as String? ?? 'work';
        final shifts = await _repository.watchShifts(range.$1, range.$2, timeZone).first;
        return {
          'start': range.$1.iso,
          'end': range.$2.iso,
          'shifts': [
            for (final shift in shifts)
              if (shift.pattern.spaceId == spaceId) SyncPayloads.shiftJson(shift),
          ],
        };
      case 'home.inventory':
        final items = await _repository.watchHomeItems().first;
        return {
          'items': [for (final item in items) SyncPayloads.homeItemJson(item)],
        };
      case 'tags.list':
        final tags = await _repository.watchTags().first;
        return {
          'tags': [for (final tag in tags) SyncPayloads.tagJson(tag)],
        };
      case 'sleep.window':
        return _sleepWindow(arguments, today, timeZone);
      case 'plan.create':
        _requireWrites();
        return _createPlan(arguments, timeZone);
      case 'plan.complete':
        _requireWrites();
        return _completePlan(arguments, timeZone: timeZone, completed: true);
      case 'plan.uncomplete':
        _requireWrites();
        return _completePlan(arguments, timeZone: timeZone, completed: false);
      case 'plan.update':
        _requireWrites();
        return _updatePlan(arguments, timeZone);
      case 'plan.delete':
        _requireWrites();
        return _deletePlan(arguments);
      case 'home.shopping_add':
        _requireWrites();
        return _addShopping(arguments);
      case 'home.shopping_check':
        _requireWrites();
        return _checkShopping(arguments);
      default:
        throw const _RpcException(-32602, 'Unknown tool');
    }
  }

  (LocalDate, LocalDate) _dateRange(Map<String, Object?> arguments, LocalDate today, {int defaultDays = 7}) {
    final start = _dateArg(arguments, 'start') ?? today;
    final end = _dateArg(arguments, 'end') ?? start.addDays(defaultDays);
    if (end.isBefore(start) || end.differenceInDays(start) > 366) {
      throw const _RpcException(-32602, 'Invalid start/end range');
    }
    return (start, end);
  }

  Future<Map<String, Object?>> _sleepWindow(
    Map<String, Object?> arguments,
    LocalDate today,
    String timeZone,
  ) async {
    final date = _dateArg(arguments, 'date') ?? today;
    final settings = AppSettings.fromMap(await _repository.readSettings());
    if (!settings.sleepEnabled) return {'date': date.iso, 'enabled': false};
    final entries = await _repository.loadEntries(date.addDays(-1), date.addDays(1), timeZone);
    final shifts = await _repository.watchShifts(date.addDays(-1), date.addDays(1), timeZone).first;
    final lastEnds = <SleepCommitment>[
      for (final occurrence in entries)
        if (occurrence.endAt case final endAt?)
          if (localDateAt(endAt, timeZone) == date)
            SleepCommitment(at: endAt, commute: settings.commute, windDown: settings.windDown),
      for (final shift in shifts)
        if (localDateAt(shift.endAt, timeZone) == date)
          SleepCommitment(
            at: shift.endAt,
            commute: Duration(minutes: shift.pattern.commuteMinutes ?? settings.sleepCommuteMinutes),
            windDown: Duration(minutes: shift.pattern.windDownMinutes ?? settings.sleepWindDownMinutes),
          ),
    ];
    final firstStarts = <SleepCommitment>[
      for (final occurrence in entries)
        if (occurrence.startAt case final startAt?)
          if (localDateAt(startAt, timeZone) == date.addDays(1))
            SleepCommitment(at: startAt, commute: settings.commute),
      for (final shift in shifts)
        if (localDateAt(shift.startAt, timeZone) == date.addDays(1))
          SleepCommitment(
            at: shift.startAt,
            commute: Duration(minutes: shift.pattern.commuteMinutes ?? settings.sleepCommuteMinutes),
          ),
    ];
    final window = computeSleepWindowFromCommitments(
      lastEndsToday: lastEnds,
      firstStartsTomorrow: firstStarts,
      wakeBuffer: settings.wakeBuffer,
    );
    return {
      'date': date.iso,
      'enabled': true,
      'bedtime': window.bedtime?.toIso8601String(),
      'wakeTime': window.wakeTime?.toIso8601String(),
      'warning': window.warning,
    };
  }

  Future<Map<String, Object?>> _createPlan(Map<String, Object?> arguments, String timeZone) async {
    final title = _stringArg(arguments, 'title');
    if (title.trim().isEmpty) throw const _RpcException(-32602, 'title is required');
    final spaceId = _stringArg(arguments, 'spaceId');
    final spaces = await _repository.watchSpaces().first;
    if (!spaces.any((space) => space.id == spaceId)) {
      throw const _RpcException(-32602, 'Unknown spaceId');
    }

    final dateRaw = _stringArg(arguments, 'date');
    final LocalDate date;
    try {
      date = LocalDate.parse(dateRaw);
    } on FormatException {
      throw const _RpcException(-32602, 'date must be YYYY-MM-DD');
    }
    final allDay = arguments['allDay'] == true;
    final zone = allDay ? null : (arguments['timeZone'] as String? ?? timeZone);
    if (zone != null && !isKnownTimeZone(zone)) {
      throw const _RpcException(-32602, 'Unknown timeZone');
    }
    final startMinute = allDay ? null : _intArg(arguments, 'startMinute', fallback: 9 * 60);
    final endMinute = allDay ? null : _intArg(arguments, 'endMinute', fallback: startMinute! + 60);
    if (!allDay &&
        (startMinute! < 0 ||
            startMinute >= 1440 ||
            endMinute! <= startMinute ||
            endMinute - startMinute > 1440)) {
      throw const _RpcException(-32602, 'Invalid startMinute/endMinute');
    }

    final now = _clock().toUtc();
    final entry = Entry(
      id: const Uuid().v4(),
      spaceId: spaceId,
      title: title.trim(),
      notes: arguments['notes'] as String? ?? '',
      kind: EntryKind.task,
      date: date,
      allDay: allDay,
      startMinute: startMinute,
      endMinute: endMinute,
      timeZone: zone,
      createdAt: now,
      updatedAt: now,
    );
    await _repository.saveEntry(entry);
    return {'id': entry.id};
  }

  Future<Map<String, Object?>> _completePlan(
    Map<String, Object?> arguments, {
    required String timeZone,
    required bool completed,
  }) async {
    final entryId = _stringArg(arguments, 'entryId');
    final entry = await _repository.readEntry(entryId);
    if (entry == null || entry.deletedAt != null) {
      throw const _RpcException(-32602, 'Unknown entryId');
    }
    if (entry.readOnly) throw const _RpcException(-32602, 'This entry is read-only');
    if (entry.isMaintenance && completed) {
      final today = localDateAt(_clock(), timeZone);
      final next = await _repository.completeMaintenanceEntry(entryId, today);
      return {'completed': true, 'nextDate': next?.iso};
    }
    if (entry.recurrence == null) {
      await _repository.setEntryStatus(entryId, completed ? EntryStatus.done : EntryStatus.open);
      return {'completed': completed};
    }
    final dateRaw = arguments['date'] as String?;
    if (dateRaw == null) throw const _RpcException(-32602, 'date is required for a recurring entry');
    final LocalDate date;
    try {
      date = LocalDate.parse(dateRaw);
    } on FormatException {
      throw const _RpcException(-32602, 'date must be YYYY-MM-DD');
    }
    await _repository.setOccurrenceCompleted(entryId, date, completed);
    return {'completed': completed, 'date': date.iso};
  }

  Future<Map<String, Object?>> _updatePlan(Map<String, Object?> arguments, String deviceTimeZone) async {
    final entryId = _stringArg(arguments, 'entryId');
    final existing = await _repository.readEntry(entryId);
    if (existing == null || existing.deletedAt != null) {
      throw const _RpcException(-32602, 'Unknown entryId');
    }
    if (existing.readOnly) throw const _RpcException(-32602, 'This entry is read-only');

    final spaceId = arguments['spaceId'] as String? ?? existing.spaceId;
    final spaces = await _repository.watchSpaces().first;
    if (!spaces.any((space) => space.id == spaceId)) {
      throw const _RpcException(-32602, 'Unknown spaceId');
    }
    final allDay = arguments['allDay'] is bool ? arguments['allDay'] as bool : existing.allDay;
    final date = _dateArg(arguments, 'date') ?? existing.date;
    final endDate = _dateArg(arguments, 'endDate') ?? existing.endDate;
    final timeZone = arguments['timeZone'] is String
        ? arguments['timeZone'] as String
        : (existing.timeZone ?? deviceTimeZone);
    if (!isKnownTimeZone(timeZone)) throw const _RpcException(-32602, 'Unknown timeZone');
    final startMinute = _optionalIntArg(arguments, 'startMinute') ?? existing.startMinute ?? 9 * 60;
    final endMinute = _optionalIntArg(arguments, 'endMinute') ?? existing.endMinute ?? startMinute + 60;
    final kind = _enumArg(EntryKind.values, arguments['kind']) ?? existing.kind;
    final status = _enumArg(EntryStatus.values, arguments['status']) ?? existing.status;
    final tagIds = (arguments['tagIds'] as List?)?.whereType<String>().toSet() ?? existing.tagIds;

    final Entry updated;
    try {
      updated = Entry(
        id: existing.id,
        spaceId: spaceId,
        title: (arguments['title'] as String?)?.trim().isNotEmpty == true
            ? (arguments['title'] as String).trim()
            : existing.title,
        notes: arguments['notes'] as String? ?? existing.notes,
        kind: kind,
        date: date,
        endDate: allDay ? endDate : null,
        startMinute: allDay || date == null ? null : startMinute,
        endMinute: allDay || date == null ? null : endMinute,
        timeZone: allDay || date == null ? null : timeZone,
        tagIds: tagIds,
        allDay: allDay,
        source: existing.source,
        externalId: existing.externalId,
        readOnly: existing.readOnly,
        lastCompletedAt: existing.lastCompletedAt,
        repeatAfterCompletionDays: existing.repeatAfterCompletionDays,
        status: status,
        recurrence: existing.recurrence,
        createdAt: existing.createdAt,
        updatedAt: _clock().toUtc(),
      );
    } on ArgumentError catch (error) {
      throw _RpcException(-32602, '$error');
    }
    await _repository.saveEntry(updated);
    return {'id': updated.id};
  }

  Future<Map<String, Object?>> _deletePlan(Map<String, Object?> arguments) async {
    final entryId = _stringArg(arguments, 'entryId');
    final entry = await _repository.readEntry(entryId);
    if (entry == null || entry.deletedAt != null) {
      throw const _RpcException(-32602, 'Unknown entryId');
    }
    if (entry.readOnly) throw const _RpcException(-32602, 'This entry is read-only');
    await _repository.deleteEntry(entryId);
    return {'deleted': true, 'entryId': entryId};
  }

  Future<Map<String, Object?>> _addShopping(Map<String, Object?> arguments) async {
    final name = _stringArg(arguments, 'name').trim();
    final item = ShoppingItem(
      id: const Uuid().v4(),
      name: name,
      quantity: _numberArg(arguments, 'quantity', 1).clamp(0.01, double.infinity).toDouble(),
      unit: arguments['unit'] as String? ?? '',
      note: arguments['note'] as String? ?? '',
      homeItemId: arguments['homeItemId'] as String?,
    );
    await _repository.saveShoppingItem(item);
    return {'id': item.id};
  }

  Future<Map<String, Object?>> _checkShopping(Map<String, Object?> arguments) async {
    final id = _stringArg(arguments, 'id');
    final checked = arguments['checked'];
    if (checked is! bool) throw const _RpcException(-32602, 'checked must be a boolean');
    await _repository.setShoppingChecked(id, checked);
    return {'id': id, 'checked': checked};
  }

  void _requireWrites() {
    if (!_writesEnabled) {
      throw const _RpcException(-32602, 'Write tools are disabled in Mane settings');
    }
  }

  List<Map<String, Object?>> _tools() {
    final tools = <Map<String, Object?>>[
      {
        'name': 'personal.today',
        'description': "Personal entries planned for today in the viewer's timezone.",
        'inputSchema': {'type': 'object', 'properties': <String, Object?>{}},
      },
      {
        'name': 'work.next_shifts',
        'description': 'Upcoming work shifts, including labels and absolute times.',
        'inputSchema': {
          'type': 'object',
          'properties': {
            'count': {'type': 'integer', 'minimum': 1, 'maximum': 50, 'default': 5},
          },
        },
      },
      {
        'name': 'home.shopping',
        'description': 'Shopping-list lines that are not checked off yet.',
        'inputSchema': {'type': 'object', 'properties': <String, Object?>{}},
      },
      {
        'name': 'plan.range',
        'description': 'Entries between two dates (inclusive), optionally filtered by space.',
        'inputSchema': {
          'type': 'object',
          'properties': {
            'start': {'type': 'string', 'description': 'YYYY-MM-DD, defaults to today'},
            'end': {'type': 'string', 'description': 'YYYY-MM-DD, defaults to start + 7 days'},
            'spaceId': {
              'type': 'string',
              'enum': ['personal', 'work', 'home'],
            },
          },
        },
      },
      {
        'name': 'plan.search',
        'description': 'Search entry titles and notes, tag names and household items.',
        'inputSchema': {
          'type': 'object',
          'properties': {
            'query': {'type': 'string'},
          },
          'required': ['query'],
        },
      },
      {
        'name': 'plan.get',
        'description': 'Read one entry, its tags and its reminders.',
        'inputSchema': {
          'type': 'object',
          'properties': {
            'entryId': {'type': 'string'},
          },
          'required': ['entryId'],
        },
      },
      {
        'name': 'work.shifts',
        'description': 'Read shifts in a date range. Defaults to work shifts over 30 days.',
        'inputSchema': {
          'type': 'object',
          'properties': {
            'start': {'type': 'string', 'description': 'YYYY-MM-DD, defaults to today'},
            'end': {'type': 'string', 'description': 'YYYY-MM-DD, defaults to start + 30 days'},
            'spaceId': {'type': 'string', 'default': 'work'},
          },
        },
      },
      {
        'name': 'home.inventory',
        'description': 'Household inventory with quantities, locations and low-stock flags.',
        'inputSchema': {'type': 'object', 'properties': <String, Object?>{}},
      },
      {
        'name': 'tags.list',
        'description': 'All tags, including the space they belong to.',
        'inputSchema': {'type': 'object', 'properties': <String, Object?>{}},
      },
      {
        'name': 'sleep.window',
        'description': 'The soft sleep window for a date, using the last and first commitments.',
        'inputSchema': {
          'type': 'object',
          'properties': {
            'date': {'type': 'string', 'description': 'YYYY-MM-DD, defaults to today'},
          },
        },
      },
    ];
    if (_writesEnabled) {
      tools.addAll([
        {
          'name': 'plan.create',
          'description': 'Create a task or event in one of the three spaces.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'spaceId': {
                'type': 'string',
                'enum': ['personal', 'work', 'home'],
              },
              'title': {'type': 'string'},
              'date': {'type': 'string', 'description': 'YYYY-MM-DD'},
              'allDay': {'type': 'boolean', 'default': false},
              'startMinute': {'type': 'integer', 'minimum': 0, 'maximum': 1439},
              'endMinute': {'type': 'integer', 'minimum': 1, 'maximum': 2880},
              'timeZone': {'type': 'string'},
              'notes': {'type': 'string'},
            },
            'required': ['spaceId', 'title', 'date'],
          },
        },
        {
          'name': 'plan.update',
          'description': 'Update an existing writable entry.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'entryId': {'type': 'string'},
              'title': {'type': 'string'},
              'notes': {'type': 'string'},
              'spaceId': {'type': 'string'},
              'kind': {
                'type': 'string',
                'enum': ['task', 'event', 'obligation', 'deadline'],
              },
              'date': {'type': 'string', 'description': 'YYYY-MM-DD'},
              'endDate': {'type': 'string', 'description': 'YYYY-MM-DD'},
              'allDay': {'type': 'boolean'},
              'startMinute': {'type': 'integer'},
              'endMinute': {'type': 'integer'},
              'timeZone': {'type': 'string'},
              'status': {
                'type': 'string',
                'enum': ['open', 'done', 'cancelled'],
              },
              'tagIds': {
                'type': 'array',
                'items': {'type': 'string'},
              },
            },
            'required': ['entryId'],
          },
        },
        {
          'name': 'plan.complete',
          'description': 'Complete a task, or one occurrence of a recurring entry.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'entryId': {'type': 'string'},
              'date': {'type': 'string', 'description': 'Occurrence date for a recurring entry'},
            },
            'required': ['entryId'],
          },
        },
        {
          'name': 'plan.uncomplete',
          'description': 'Reopen a task or one completed occurrence.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'entryId': {'type': 'string'},
              'date': {'type': 'string', 'description': 'Occurrence date for a recurring entry'},
            },
            'required': ['entryId'],
          },
        },
        {
          'name': 'plan.delete',
          'description': 'Soft-delete a writable entry.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'entryId': {'type': 'string'},
            },
            'required': ['entryId'],
          },
        },
        {
          'name': 'home.shopping_add',
          'description': 'Add a shopping-list line.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'name': {'type': 'string'},
              'quantity': {'type': 'number', 'minimum': 0.01, 'default': 1},
              'unit': {'type': 'string'},
              'note': {'type': 'string'},
              'homeItemId': {'type': 'string'},
            },
            'required': ['name'],
          },
        },
        {
          'name': 'home.shopping_check',
          'description': 'Check or uncheck a shopping line, updating linked inventory.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'id': {'type': 'string'},
              'checked': {'type': 'boolean'},
            },
            'required': ['id', 'checked'],
          },
        },
      ]);
    }
    return tools;
  }

  String _bearerToken(HttpRequest request) {
    final header = request.headers.value(HttpHeaders.authorizationHeader);
    if (header == null) return request.headers.value('x-mane-mcp-token') ?? '';
    if (!header.toLowerCase().startsWith('bearer ')) return '';
    return header.substring(7).trim();
  }

  static String _stringArg(Map<String, Object?> arguments, String name) {
    final value = arguments[name];
    if (value is! String || value.trim().isEmpty) {
      throw _RpcException(-32602, '$name is required');
    }
    return value;
  }

  static int _intArg(Map<String, Object?> arguments, String name, {required int fallback}) {
    final value = arguments[name];
    if (value == null) return fallback;
    if (value is int) return value;
    throw _RpcException(-32602, '$name must be an integer');
  }

  static int? _optionalIntArg(Map<String, Object?> arguments, String name) {
    final value = arguments[name];
    if (value == null) return null;
    if (value is int) return value;
    throw _RpcException(-32602, '$name must be an integer');
  }

  static double _numberArg(Map<String, Object?> arguments, String name, double fallback) {
    final value = arguments[name];
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    throw _RpcException(-32602, '$name must be a number');
  }

  static LocalDate? _dateArg(Map<String, Object?> arguments, String name) {
    final value = arguments[name];
    if (value == null) return null;
    if (value is! String) throw _RpcException(-32602, '$name must be YYYY-MM-DD');
    try {
      return LocalDate.parse(value);
    } on FormatException {
      throw _RpcException(-32602, '$name must be YYYY-MM-DD');
    }
  }

  static T? _enumArg<T extends Enum>(List<T> values, Object? raw) {
    if (raw == null) return null;
    if (raw is! String) throw const _RpcException(-32602, 'Expected a string value');
    for (final value in values) {
      if (value.name == raw) return value;
    }
    throw _RpcException(-32602, 'Unknown value $raw');
  }

  static Map<String, Object?> _error(Object? id, int code, String message) => {
    'jsonrpc': '2.0',
    'id': id,
    'error': {'code': code, 'message': message},
  };

  Future<String> _readBody(HttpRequest request) async {
    final builder = BytesBuilder(copy: false);
    await for (final chunk in request) {
      builder.add(chunk);
      if (builder.length > 1024 * 1024) throw const McpException('Request too large');
    }
    return utf8.decode(builder.takeBytes());
  }

  Future<void> _respond(HttpResponse response, int status, Object? body) async {
    response.statusCode = status;
    response.headers.set(HttpHeaders.cacheControlHeader, 'no-store');
    if (body == null) {
      await response.close();
      return;
    }
    response.headers.contentType = ContentType.json;
    response.write(jsonEncode(body));
    await response.close();
  }

  /// Streamable HTTP clients that accept `text/event-stream` get one JSON-RPC
  /// message as an SSE event. Plain JSON clients keep the previous response.
  Future<void> _respondRpc(HttpRequest request, Object body) async {
    final accept = request.headers.value(HttpHeaders.acceptHeader) ?? '';
    if (accept.contains('text/event-stream')) {
      final response = request.response;
      response.statusCode = HttpStatus.ok;
      response.headers.contentType = ContentType('text', 'event-stream', charset: 'utf-8');
      response.headers.set(HttpHeaders.cacheControlHeader, 'no-store');
      response.write('event: message\ndata: ${jsonEncode(body)}\n\n');
      await response.close();
      return;
    }
    await _respond(request.response, HttpStatus.ok, body);
  }
}

class McpException implements Exception {
  const McpException(this.message);

  final String message;
}

class _RpcException implements Exception {
  const _RpcException(this.code, this.message);

  final int code;
  final String message;
}

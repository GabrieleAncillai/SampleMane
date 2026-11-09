import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mane_core/mane_core.dart';
import 'package:uuid/uuid.dart';

import '../../app_version.dart';
import '../../models/local_identity.dart';
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

  final PlannerRepository _repository;
  final String Function() _deviceTimeZone;
  final DateTime Function() _clock;

  HttpServer? _server;
  LocalIdentity? _identity;
  bool _writesEnabled = false;

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
    if (request.method != 'POST' || request.uri.path != path) {
      await _respond(request.response, HttpStatus.notFound, {'error': 'not_found'});
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
      await _respond(request.response, HttpStatus.ok, _error(null, -32700, 'Parse error'));
      return;
    }
    if (decoded is! Map<String, dynamic>) {
      await _respond(request.response, HttpStatus.ok, _error(null, -32600, 'Invalid request'));
      return;
    }

    final id = decoded['id'];
    final method = decoded['method'];
    if (decoded['jsonrpc'] != '2.0' || method is! String) {
      await _respond(request.response, HttpStatus.ok, _error(id, -32600, 'Invalid request'));
      return;
    }
    if (method == 'notifications/initialized' || method.startsWith('notifications/')) {
      await _respond(request.response, HttpStatus.accepted, null);
      return;
    }

    try {
      final result = await _dispatch(method, decoded['params']);
      await _respond(request.response, HttpStatus.ok, {'jsonrpc': '2.0', 'id': id, 'result': result});
    } on _RpcException catch (error) {
      await _respond(request.response, HttpStatus.ok, _error(id, error.code, error.message));
    } on Object catch (error) {
      await _respond(request.response, HttpStatus.ok, _error(id, -32603, 'Internal error: $error'));
    }
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
      case 'plan.create':
        _requireWrites();
        return _createPlan(arguments, timeZone);
      case 'plan.complete':
        _requireWrites();
        return _completePlan(arguments);
      default:
        throw const _RpcException(-32602, 'Unknown tool');
    }
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

  Future<Map<String, Object?>> _completePlan(Map<String, Object?> arguments) async {
    final entryId = _stringArg(arguments, 'entryId');
    final entry = await _repository.readEntry(entryId);
    if (entry == null || entry.deletedAt != null) {
      throw const _RpcException(-32602, 'Unknown entryId');
    }
    if (entry.readOnly) throw const _RpcException(-32602, 'This entry is read-only');
    if (entry.recurrence == null) {
      await _repository.setEntryStatus(entryId, EntryStatus.done);
      return {'completed': true};
    }
    final dateRaw = arguments['date'] as String?;
    if (dateRaw == null) throw const _RpcException(-32602, 'date is required for a recurring entry');
    final LocalDate date;
    try {
      date = LocalDate.parse(dateRaw);
    } on FormatException {
      throw const _RpcException(-32602, 'date must be YYYY-MM-DD');
    }
    await _repository.setOccurrenceCompleted(entryId, date, true);
    return {'completed': true, 'date': date.iso};
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

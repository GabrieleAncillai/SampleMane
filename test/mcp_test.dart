import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/mcp/mcp_server.dart';
import 'package:mane/models/home_item.dart';
import 'package:mane/models/local_identity.dart';
import 'package:mane/models/shopping_item.dart';
import 'package:mane/services/app_database.dart';
import 'package:mane/services/planner_repository.dart';
import 'package:mane_core/mane_core.dart';
import 'package:sqlite3/open.dart';

void main() {
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('libsqlite3.so.0'));
    initializeTimeZones();
  });

  late AppDatabase database;
  late McpServer server;
  final now = DateTime.utc(2026, 11, 9, 12);
  final identity = LocalIdentity(
    deviceId: 'self',
    deviceName: 'Linux',
    username: 'tester',
    pinSalt: 'c2FsdA==',
    pinHash: 'aGFzaA==',
    certificatePem: 'cert',
    privateKeyPem: 'key',
    mcpToken: 'secret-token',
    createdAt: now,
    updatedAt: now,
  );

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory(), defaultTimeZone: 'Europe/Madrid');
    await database.seedDefaults();
    await database.saveEntry(
      Entry(
        id: 'passport',
        spaceId: 'personal',
        title: 'Renew passport',
        date: LocalDate.parse('2026-11-09'),
        allDay: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.saveShoppingItem(const ShoppingItem(id: 'milk', name: 'Milk'));
    await database.saveHomeItem(const HomeItem(id: 'rice', name: 'Rice', quantity: 1, unit: 'kg'));
    server = McpServer(
      repository: PlannerRepository(database),
      deviceTimeZone: () => 'Europe/Madrid',
      clock: () => now,
    );
    await server.start(identity: identity, writesEnabled: false);
  });

  tearDown(() async {
    await server.stop();
    await database.close();
  });

  Future<(int, Map<String, dynamic>, HttpHeaders)> postFull(
    Map<String, Object?> body, {
    String? token = 'secret-token',
    String? sessionId,
    String? accept,
  }) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(
        Uri(scheme: 'http', host: '127.0.0.1', port: server.boundPort, path: '/mcp'),
      );
      request.headers.contentType = ContentType.json;
      if (token != null) request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      if (sessionId != null) request.headers.set(McpServer.sessionHeader, sessionId);
      if (accept != null) request.headers.set(HttpHeaders.acceptHeader, accept);
      request.write(jsonEncode(body));
      final response = await request.close();
      final text = await utf8.decoder.bind(response).join();
      final payload = accept == 'text/event-stream' && text.contains('data: ')
          ? text.substring(text.indexOf('data: ') + 6).trim()
          : text;
      final decoded = payload.isEmpty ? <String, dynamic>{} : jsonDecode(payload);
      return (response.statusCode, Map<String, dynamic>.from(decoded as Map), response.headers);
    } finally {
      client.close(force: true);
    }
  }

  Future<(int, Map<String, dynamic>)> post(
    Map<String, Object?> body, {
    String? token = 'secret-token',
    String? sessionId,
    String? accept,
  }) async {
    final (status, decoded, _) = await postFull(body, token: token, sessionId: sessionId, accept: accept);
    return (status, decoded);
  }

  test('rejects a request without the bearer token', () async {
    final (status, body) = await post({'jsonrpc': '2.0', 'id': 1, 'method': 'tools/list'}, token: null);
    expect(status, HttpStatus.unauthorized);
    expect(body['error'], 'unauthorized');
  });

  test('initializes and lists the read-only tools', () async {
    final (status, body) = await post({'jsonrpc': '2.0', 'id': 1, 'method': 'initialize', 'params': {}});
    expect(status, HttpStatus.ok);
    final result = Map<String, dynamic>.from(body['result'] as Map);
    expect(result['protocolVersion'], McpServer.protocolVersion);
    expect((result['serverInfo'] as Map)['name'], 'mane');

    final (_, listed) = await post({'jsonrpc': '2.0', 'id': 2, 'method': 'tools/list'});
    final tools = ((listed['result'] as Map)['tools'] as List).cast<Map>();
    expect(
      tools.map((tool) => tool['name']),
      containsAll([
        'personal.today',
        'work.next_shifts',
        'home.shopping',
        'plan.range',
        'plan.search',
        'plan.get',
        'work.shifts',
        'home.inventory',
        'tags.list',
        'sleep.window',
      ]),
    );
    expect(tools.map((tool) => tool['name']), isNot(contains('plan.create')));
  });

  test('returns a session id and accepts streaming responses', () async {
    final (_, initialized, headers) = await postFull({
      'jsonrpc': '2.0',
      'id': 10,
      'method': 'initialize',
      'params': {},
    });
    final sessionId = headers.value(McpServer.sessionHeader);
    expect(sessionId, isNotNull);
    expect(initialized['result'], isNotNull);

    final (status, listed) = await post({
      'jsonrpc': '2.0',
      'id': 11,
      'method': 'tools/list',
    }, sessionId: sessionId);
    expect(status, HttpStatus.ok);
    expect(listed['result'], isNotNull);

    final (unknownStatus, _) = await post({
      'jsonrpc': '2.0',
      'id': 12,
      'method': 'tools/list',
    }, sessionId: 'not-a-session');
    expect(unknownStatus, HttpStatus.notFound);

    final (streamStatus, streamed) = await post({
      'jsonrpc': '2.0',
      'id': 13,
      'method': 'tools/list',
    }, accept: 'text/event-stream');
    expect(streamStatus, HttpStatus.ok);
    expect(streamed['result'], isNotNull);
  });

  test('calls a read tool through the repository', () async {
    final (status, body) = await post({
      'jsonrpc': '2.0',
      'id': 3,
      'method': 'tools/call',
      'params': {'name': 'home.shopping', 'arguments': <String, Object?>{}},
    });
    expect(status, HttpStatus.ok);
    final result = Map<String, dynamic>.from(body['result'] as Map);
    expect(result['isError'], isFalse);
    final content = (result['content'] as List).single as Map;
    final payload = jsonDecode(content['text'] as String) as Map;
    expect(((payload['items'] as List).single as Map)['name'], 'Milk');
  });

  test('write tools stay disabled until the setting is on', () async {
    final (_, body) = await post({
      'jsonrpc': '2.0',
      'id': 4,
      'method': 'tools/call',
      'params': {
        'name': 'plan.create',
        'arguments': {'spaceId': 'personal', 'title': 'Taxes', 'date': '2026-11-10'},
      },
    });
    expect((body['error'] as Map)['message'], contains('disabled'));
    expect(await database.readEntry('taxes'), isNull);
  });

  test('creates and completes a plan when writes are enabled', () async {
    await server.start(identity: identity, writesEnabled: true);

    final (_, listed) = await post({'jsonrpc': '2.0', 'id': 5, 'method': 'tools/list'});
    final tools = ((listed['result'] as Map)['tools'] as List).cast<Map>();
    expect(tools.map((tool) => tool['name']), contains('plan.create'));

    final (_, created) = await post({
      'jsonrpc': '2.0',
      'id': 6,
      'method': 'tools/call',
      'params': {
        'name': 'plan.create',
        'arguments': <String, Object?>{
          'spaceId': 'personal',
          'title': 'Pay taxes',
          'date': '2026-11-10',
          'allDay': true,
        },
      },
    });
    final content = ((created['result'] as Map)['content'] as List).single as Map;
    final payload = jsonDecode(content['text'] as String) as Map;
    final entry = await database.readEntry(payload['id'] as String);
    expect(entry, isNotNull);
    expect(entry!.title, 'Pay taxes');
    expect(entry.allDay, isTrue);

    final (_, completed) = await post({
      'jsonrpc': '2.0',
      'id': 7,
      'method': 'tools/call',
      'params': {
        'name': 'plan.complete',
        'arguments': {'entryId': entry.id},
      },
    });
    expect((completed['result'] as Map)['isError'], isFalse);
    expect((await database.readEntry(entry.id))!.status, EntryStatus.done);
  });

  test('reads a range, search, inventory, tags and the sleep window', () async {
    final (_, rangeBody) = await post({
      'jsonrpc': '2.0',
      'id': 20,
      'method': 'tools/call',
      'params': {
        'name': 'plan.range',
        'arguments': {'start': '2026-11-09', 'end': '2026-11-10'},
      },
    });
    final range = _toolPayload(rangeBody);
    expect((range['entries'] as List), isNotEmpty);

    final (_, searchBody) = await post({
      'jsonrpc': '2.0',
      'id': 21,
      'method': 'tools/call',
      'params': {
        'name': 'plan.search',
        'arguments': {'query': 'passport'},
      },
    });
    expect(((_toolPayload(searchBody)['entries'] as List).single as Map)['title'], 'Renew passport');

    final (_, inventoryBody) = await post({
      'jsonrpc': '2.0',
      'id': 22,
      'method': 'tools/call',
      'params': {'name': 'home.inventory', 'arguments': <String, Object?>{}},
    });
    expect(((_toolPayload(inventoryBody)['items'] as List).single as Map)['name'], 'Rice');

    final (_, tagsBody) = await post({
      'jsonrpc': '2.0',
      'id': 23,
      'method': 'tools/call',
      'params': {'name': 'tags.list', 'arguments': <String, Object?>{}},
    });
    expect(_toolPayload(tagsBody)['tags'], isEmpty);

    await database.saveEntry(
      Entry(
        id: 'evening',
        spaceId: 'personal',
        title: 'Evening plan',
        date: LocalDate.parse('2026-11-09'),
        startMinute: 20 * 60,
        endMinute: 21 * 60,
        timeZone: 'Europe/Madrid',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await database.saveEntry(
      Entry(
        id: 'morning',
        spaceId: 'personal',
        title: 'Morning plan',
        date: LocalDate.parse('2026-11-10'),
        startMinute: 8 * 60,
        endMinute: 9 * 60,
        timeZone: 'Europe/Madrid',
        createdAt: now,
        updatedAt: now,
      ),
    );
    final (_, sleepBody) = await post({
      'jsonrpc': '2.0',
      'id': 24,
      'method': 'tools/call',
      'params': {
        'name': 'sleep.window',
        'arguments': {'date': '2026-11-09'},
      },
    });
    final sleep = _toolPayload(sleepBody);
    expect(sleep['bedtime'], '2026-11-09T21:30:00.000Z');
    expect(sleep['wakeTime'], '2026-11-10T06:00:00.000Z');
  });

  test('writes update, uncomplete, delete and shopping lines when enabled', () async {
    await server.start(identity: identity, writesEnabled: true);

    final (_, updatedBody) = await post({
      'jsonrpc': '2.0',
      'id': 30,
      'method': 'tools/call',
      'params': {
        'name': 'plan.update',
        'arguments': {'entryId': 'passport', 'title': 'New passport', 'notes': 'Updated'},
      },
    });
    expect((updatedBody['result'] as Map)['isError'], isFalse);
    final updated = await database.readEntry('passport');
    expect(updated!.title, 'New passport');
    expect(updated.notes, 'Updated');

    await database.setEntryStatus('passport', EntryStatus.done);
    final (_, uncompletedBody) = await post({
      'jsonrpc': '2.0',
      'id': 31,
      'method': 'tools/call',
      'params': {
        'name': 'plan.uncomplete',
        'arguments': {'entryId': 'passport'},
      },
    });
    expect((uncompletedBody['result'] as Map)['isError'], isFalse);
    expect((await database.readEntry('passport'))!.status, EntryStatus.open);

    final (_, addedBody) = await post({
      'jsonrpc': '2.0',
      'id': 32,
      'method': 'tools/call',
      'params': {
        'name': 'home.shopping_add',
        'arguments': {'name': 'Rice', 'quantity': 2, 'unit': 'kg', 'homeItemId': 'rice'},
      },
    });
    final added = _toolPayload(addedBody);
    final (_, checkedBody) = await post({
      'jsonrpc': '2.0',
      'id': 33,
      'method': 'tools/call',
      'params': {
        'name': 'home.shopping_check',
        'arguments': {'id': added['id'], 'checked': true},
      },
    });
    expect((checkedBody['result'] as Map)['isError'], isFalse);
    final home = (await database.watchHomeItems().first).singleWhere((item) => item.id == 'rice');
    expect(home.quantity, 3);

    final (_, deletedBody) = await post({
      'jsonrpc': '2.0',
      'id': 34,
      'method': 'tools/call',
      'params': {
        'name': 'plan.delete',
        'arguments': {'entryId': 'passport'},
      },
    });
    expect((deletedBody['result'] as Map)['isError'], isFalse);
    expect((await database.readEntry('passport'))!.deletedAt, isNotNull);
  });

  test('returns a JSON-RPC parse error for malformed input', () async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(
        Uri(scheme: 'http', host: '127.0.0.1', port: server.boundPort, path: '/mcp'),
      );
      request.headers.contentType = ContentType.json;
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer secret-token');
      request.write('{not json');
      final response = await request.close();
      final text = await utf8.decoder.bind(response).join();
      final body = jsonDecode(text) as Map;
      expect((body['error'] as Map)['code'], -32700);
    } finally {
      client.close(force: true);
    }
  });
}

Map<String, dynamic> _toolPayload(Map<String, dynamic> body) {
  final result = body['result'] as Map;
  final content = (result['content'] as List).single as Map;
  return jsonDecode(content['text'] as String) as Map<String, dynamic>;
}

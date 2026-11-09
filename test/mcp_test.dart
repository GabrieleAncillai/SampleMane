import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mane/features/mcp/mcp_server.dart';
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

  Future<(int, Map<String, dynamic>)> post(
    Map<String, Object?> body, {
    String? token = 'secret-token',
  }) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(
        Uri(scheme: 'http', host: '127.0.0.1', port: server.boundPort, path: '/mcp'),
      );
      request.headers.contentType = ContentType.json;
      if (token != null) request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      request.write(jsonEncode(body));
      final response = await request.close();
      final text = await utf8.decoder.bind(response).join();
      final decoded = text.isEmpty ? <String, dynamic>{} : jsonDecode(text);
      return (response.statusCode, Map<String, dynamic>.from(decoded as Map));
    } finally {
      client.close(force: true);
    }
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
      containsAll(['personal.today', 'work.next_shifts', 'home.shopping']),
    );
    expect(tools.map((tool) => tool['name']), isNot(contains('plan.create')));
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

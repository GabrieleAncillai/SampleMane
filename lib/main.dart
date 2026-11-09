import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/mane_app.dart';
import 'services/app_database.dart';
import 'state/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase.open();
  await database.seedDefaults();
  runApp(ProviderScope(overrides: [databaseProvider.overrideWithValue(database)], child: const ManeApp()));
}

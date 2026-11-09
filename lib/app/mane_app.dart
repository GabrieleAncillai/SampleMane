import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_shell.dart';

class ManeApp extends StatelessWidget {
  const ManeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mane',
      debugShowCheckedModeBanner: false,
      theme: ManeTheme.light,
      darkTheme: ManeTheme.dark,
      home: const AppShell(),
    );
  }
}

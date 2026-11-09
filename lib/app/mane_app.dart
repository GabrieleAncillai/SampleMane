import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/i18n/l10n.dart';
import '../features/app_lock/widgets/app_lock_gate.dart';
import '../state/settings_controller.dart';
import '../theme/app_theme.dart';
import 'app_shell.dart';

class ManeApp extends ConsumerWidget {
  const ManeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appName,
      debugShowCheckedModeBanner: false,
      theme: ManeTheme.light,
      darkTheme: ManeTheme.dark,
      themeMode: settings.themeMode,
      locale: settings.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: ManeTheme.systemBars(Theme.of(context).brightness),
        child: child ?? const SizedBox.shrink(),
      ),
      home: const AppLockGate(child: AppShell()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/i18n/l10n.dart';
import '../models/app_settings.dart';
import '../services/planner_repository.dart';
import 'providers.dart';

/// Overridden in `main()` with the values read from the database.
final initialSettingsProvider = Provider<AppSettings>((ref) => const AppSettings());

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(initialSettingsProvider);

  PlannerRepository get _repository => ref.read(repositoryProvider);

  /// Re-reads settings after a backup import replaced the table.
  Future<void> reload() async {
    final values = await _repository.readSettings();
    state = AppSettings.fromMap(values);
  }

  Future<void> setThemeMode(ThemeMode value) async {
    state = state.copyWith(themeMode: value);
    await _repository.writeSetting(SettingsKeys.themeMode, value.name);
  }

  Future<void> setLocale(Locale? value) async {
    state = value == null ? state.copyWith(clearLocale: true) : state.copyWith(locale: value);
    await _repository.writeSetting(SettingsKeys.locale, localeCode(value));
  }

  Future<void> setWeekStart(int day) async {
    if (day != DateTime.monday && day != DateTime.saturday && day != DateTime.sunday) return;
    state = state.copyWith(weekStart: day);
    await _repository.writeSetting(SettingsKeys.weekStart, '$day');
  }

  Future<void> setHideWorkSpace(bool value) async {
    state = state.copyWith(hideWorkSpace: value);
    await _repository.writeSetting(SettingsKeys.hideWorkSpace, '$value');
  }

  Future<void> setDefaultReminderOffsets(List<int> offsets) async {
    final clean = offsets.where((value) => value >= 0).toSet().toList()..sort();
    state = state.copyWith(defaultReminderOffsets: clean);
    await _repository.writeSetting(SettingsKeys.defaultReminderOffsets, clean.join(','));
  }

  Future<void> setSyncEnabled(bool value) async {
    state = state.copyWith(syncEnabled: value);
    await _repository.writeSetting(SettingsKeys.syncEnabled, '$value');
  }

  Future<void> setMcpEnabled(bool value) async {
    state = state.copyWith(mcpEnabled: value);
    await _repository.writeSetting(SettingsKeys.mcpEnabled, '$value');
  }
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

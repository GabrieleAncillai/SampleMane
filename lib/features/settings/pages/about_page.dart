import 'package:flutter/material.dart';

import '../../../app_version.dart';
import '../../../core/i18n/l10n.dart';
import '../widgets/settings_rows.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.about)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(Icons.event_note, color: theme.colorScheme.onPrimary, size: 36),
                ),
                const SizedBox(height: 12),
                Text(l10n.appName, style: theme.textTheme.headlineSmall),
                Text(
                  l10n.version(appVersion),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SettingsSection(
            title: l10n.license,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.licenseBody, style: theme.textTheme.bodyMedium),
              ),
            ],
          ),
          SettingsSection(
            title: l10n.credits,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.creditsBody, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    Text(l10n.basedOnMane, style: theme.textTheme.bodySmall),
                    Text(l10n.basedOnGymMane, style: theme.textTheme.bodySmall),
                    Text(l10n.basedOnStreak, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

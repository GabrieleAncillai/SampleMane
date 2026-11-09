import 'package:flutter/material.dart';

import '../../../app_version.dart';
import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.mc;
    return ManePage(
      title: l10n.about,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 6),
          Center(
            child: Column(
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: c.accent,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: c.accent.withValues(alpha: 0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(Icons.event_note, color: c.onAccent, size: 36),
                ),
                const SizedBox(height: 12),
                Text(l10n.appName, style: ManeType.headline(22, color: c.text)),
                Text(l10n.version(appVersion), style: ManeType.body(12, color: c.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SectionLabel(l10n.license),
          SoftCard(
            child: Text(l10n.licenseBody, style: ManeType.body(13.5, color: c.textSecondary)),
          ),
          const SizedBox(height: 20),
          SectionLabel(l10n.credits),
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.creditsBody, style: ManeType.body(13.5, color: c.textSecondary)),
                const SizedBox(height: 14),
                _CreditLine(text: l10n.basedOnMane),
                const SizedBox(height: 4),
                _CreditLine(text: l10n.basedOnGymMane),
                const SizedBox(height: 4),
                _CreditLine(text: l10n.basedOnStreak),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditLine extends StatelessWidget {
  const _CreditLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: c.accent, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: ManeType.body(12.5, color: c.text)),
        ),
      ],
    );
  }
}

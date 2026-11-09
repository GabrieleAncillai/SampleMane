import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../state/providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../state/settings_controller.dart';
import '../../settings/widgets/settings_rows.dart';
import '../../sync/pages/devices_page.dart';
import '../mcp_server.dart';

class McpPage extends ConsumerWidget {
  const McpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);
    final identity = ref.watch(identityProvider).value;

    return ManePage(
      title: l10n.mcpEndpoint,
      subtitle: l10n.mcpEndpointSubtitle,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          if (identity == null)
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.identityRequired),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: () => Navigator.of(
                      context,
                    ).push(MaterialPageRoute<void>(builder: (_) => const DevicesPage())),
                    child: Text(l10n.pairingIdentity),
                  ),
                ],
              ),
            )
          else ...[
            SettingsSection(
              title: l10n.mcpEndpoint,
              children: [
                SettingsSwitchRow(
                  icon: Icons.terminal,
                  title: l10n.mcpEndpoint,
                  subtitle: l10n.mcpEndpointSubtitle,
                  value: settings.mcpEnabled,
                  onChanged: (value) async {
                    await controller.setMcpEnabled(value);
                    await ref.read(serviceCoordinatorProvider).apply(ref.read(settingsProvider));
                  },
                ),
                SettingsSwitchRow(
                  icon: Icons.edit_outlined,
                  title: l10n.mcpWriteTools,
                  subtitle: l10n.mcpWriteToolsSubtitle,
                  value: settings.mcpWritesEnabled,
                  onChanged: settings.mcpEnabled
                      ? (value) async {
                          await controller.setMcpWritesEnabled(value);
                          await ref.read(serviceCoordinatorProvider).apply(ref.read(settingsProvider));
                        }
                      : null,
                ),
              ],
            ),
            SettingsSection(
              title: l10n.mcpToken,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        'http://127.0.0.1:${McpServer.port}${McpServer.path}',
                        style: ManeType.body(13, weight: FontWeight.w700, color: context.mc.text),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        settings.mcpEnabled ? l10n.mcpRunning(McpServer.port) : l10n.mcpStopped,
                        style: ManeType.body(
                          11.5,
                          color: settings.mcpEnabled ? context.mc.success : context.mc.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        identity.mcpToken,
                        style: ManeType.body(
                          11.5,
                          color: context.mc.textSecondary,
                        ).copyWith(fontFamily: 'monospace'),
                      ),
                      const SizedBox(height: 6),
                      Text(l10n.mcpTokenHint, style: ManeType.body(11.5, color: context.mc.textSecondary)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(text: identity.mcpToken));
                              if (context.mounted) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(l10n.copied)));
                              }
                            },
                            icon: const Icon(Icons.copy, size: 18),
                            label: Text(l10n.copy),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              await ref.read(identityServiceProvider).rotateMcpToken(identity);
                              ref.invalidate(identityProvider);
                              await ref.read(serviceCoordinatorProvider).apply(ref.read(settingsProvider));
                            },
                            icon: const Icon(Icons.autorenew, size: 18),
                            label: Text(l10n.rotateToken),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.mcpLoopbackHint, style: ManeType.body(11.5, color: context.mc.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

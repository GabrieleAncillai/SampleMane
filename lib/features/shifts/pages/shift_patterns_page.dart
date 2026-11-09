import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../state/providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import 'shift_pattern_editor_page.dart';

class ShiftPatternsPage extends ConsumerWidget {
  const ShiftPatternsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.mc;
    final patterns = ref.watch(shiftPatternsProvider).value ?? const <ShiftPattern>[];
    final spaces = ref.watch(spacesProvider).value ?? fallbackSpaces;
    final spaceNames = {for (final space in spaces) space.id: space.name};

    void openEditor([ShiftPattern? pattern]) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => ShiftPatternEditorPage(pattern: pattern)));
    }

    return ManePage(
      title: l10n.shiftPatterns,
      subtitle: l10n.shiftPatternsSubtitle,
      floatingAction: ManeAddButton(tooltip: l10n.newShiftPattern, onTap: () => openEditor()),
      child: patterns.isEmpty
          ? AppEmptyState(
              icon: Icons.schedule,
              title: l10n.noShiftPatterns,
              message: l10n.shiftPatternsSubtitle,
              action: FilledButton.tonalIcon(
                onPressed: () => openEditor(),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.newShiftPattern),
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 88),
              children: [
                SoftCard(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  clip: true,
                  child: Column(
                    children: [
                      for (var index = 0; index < patterns.length; index++) ...[
                        if (index > 0) const Divider(height: 1, indent: 52),
                        _PatternRow(
                          pattern: patterns[index],
                          subtitle:
                              '${spaceNames[patterns[index].spaceId] ?? patterns[index].spaceId} · '
                              '${l10n.cycleLengthValue(patterns[index].cycleDays)} · ${patterns[index].timeZone}',
                          onTap: () => openEditor(patterns[index]),
                          onDelete: () => _delete(context, ref, patterns[index]),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(l10n.shiftPatternsSubtitle, style: ManeType.body(12, color: c.textTertiary)),
                ),
              ],
            ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, ShiftPattern pattern) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deletePatternQuestion),
        content: Text(l10n.deletePatternBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(repositoryProvider).deleteShiftPattern(pattern.id);
    }
  }
}

class _PatternRow extends StatelessWidget {
  const _PatternRow({
    required this.pattern,
    required this.subtitle,
    required this.onTap,
    required this.onDelete,
  });

  final ShiftPattern pattern;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.mc;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 3, 4, 3),
      child: Row(
        children: [
          Expanded(
            child: Pressable(
              onTap: onTap,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: c.workSoft, borderRadius: BorderRadius.circular(11)),
                    child: Icon(Icons.work_outline, size: 19, color: c.work),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pattern.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ManeType.body(14, weight: FontWeight.w700, color: c.text),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ManeType.body(11.5, color: c.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz, color: c.textTertiary),
            onSelected: (value) => value == 'edit' ? onTap() : onDelete(),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
              PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
            ],
          ),
        ],
      ),
    );
  }
}

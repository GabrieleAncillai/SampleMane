import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/l10n.dart';
import '../../../state/providers.dart';
import 'shift_pattern_editor_page.dart';

class ShiftPatternsPage extends ConsumerWidget {
  const ShiftPatternsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final patterns = ref.watch(shiftPatternsProvider).value ?? const <ShiftPattern>[];
    final spaces = ref.watch(spacesProvider).value ?? fallbackSpaces;
    final spaceNames = {for (final space in spaces) space.id: space.name};

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shiftPatterns)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const ShiftPatternEditorPage())),
        tooltip: l10n.newShiftPattern,
        child: const Icon(Icons.add),
      ),
      body: patterns.isEmpty
          ? Center(
              child: Text(
                l10n.noShiftPatterns,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: patterns.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final pattern = patterns[index];
                return ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(pattern.name),
                  subtitle: Text(
                    '${spaceNames[pattern.spaceId] ?? pattern.spaceId} · '
                    '${l10n.cycleLengthValue(pattern.cycleDays)} · ${pattern.timeZone}',
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => ShiftPatternEditorPage(pattern: pattern)),
                        );
                        return;
                      }
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: Text(l10n.deletePatternQuestion),
                          content: Text(l10n.deletePatternBody),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(dialogContext).pop(false),
                              child: Text(l10n.cancel),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.of(dialogContext).pop(true),
                              child: Text(l10n.delete),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await ref.read(repositoryProvider).deleteShiftPattern(pattern.id);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                      PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                    ],
                  ),
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute<void>(builder: (_) => ShiftPatternEditorPage(pattern: pattern))),
                );
              },
            ),
    );
  }
}

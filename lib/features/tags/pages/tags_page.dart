import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/l10n.dart';
import '../../../state/providers.dart';
import '../tag_colors.dart';
import '../widgets/tag_editor_sheet.dart';

class TagsPage extends ConsumerWidget {
  const TagsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tags = ref.watch(tagsProvider).value ?? const <Tag>[];
    final spaces = ref.watch(spacesProvider).value ?? fallbackSpaces;
    final spaceNames = {for (final space in spaces) space.id: space.name};

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tagsManager)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTagEditor(context, spaces: spaces),
        tooltip: l10n.addTag,
        child: const Icon(Icons.add),
      ),
      body: tags.isEmpty
          ? Center(
              child: Text(
                l10n.noTags,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: tags.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final tag = tags[index];
                final spaceName = tag.spaceId == null
                    ? l10n.tagSpaceAny
                    : spaceNames[tag.spaceId] ?? tag.spaceId!;
                return ListTile(
                  leading: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(color: tagColor(tag.colorValue), shape: BoxShape.circle),
                  ),
                  title: Text(tag.name),
                  subtitle: Text(spaceName),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        await showTagEditor(context, tag: tag, spaces: spaces);
                        return;
                      }
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: Text(l10n.deleteTagQuestion),
                          content: Text(l10n.deleteTagBody),
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
                        if (ref.read(tagFilterProvider).contains(tag.id)) {
                          ref.read(tagFilterProvider.notifier).toggle(tag.id);
                        }
                        await ref.read(repositoryProvider).deleteTag(tag.id);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                      PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

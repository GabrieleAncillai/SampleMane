import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../state/providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../tag_colors.dart';
import '../widgets/tag_editor_sheet.dart';

class TagsPage extends ConsumerWidget {
  const TagsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.mc;
    final tags = ref.watch(tagsProvider).value ?? const <Tag>[];
    final spaces = ref.watch(spacesProvider).value ?? fallbackSpaces;
    final spaceNames = {for (final space in spaces) space.id: space.name};

    return ManePage(
      title: l10n.tagsManager,
      floatingAction: ManeAddButton(
        tooltip: l10n.addTag,
        onTap: () => showTagEditor(context, spaces: spaces),
      ),
      child: tags.isEmpty
          ? AppEmptyState(
              icon: Icons.sell_outlined,
              title: l10n.noTags,
              message: l10n.tagsManagerSubtitle,
              action: FilledButton.tonalIcon(
                onPressed: () => showTagEditor(context, spaces: spaces),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.addTag),
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
                      for (var index = 0; index < tags.length; index++) ...[
                        if (index > 0) const Divider(height: 1, indent: 46),
                        _TagRow(
                          tag: tags[index],
                          spaceName: tags[index].spaceId == null
                              ? l10n.tagSpaceAny
                              : spaceNames[tags[index].spaceId] ?? tags[index].spaceId!,
                          onEdit: () => showTagEditor(context, tag: tags[index], spaces: spaces),
                          onDelete: () => _delete(context, ref, tags[index]),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(l10n.tagsManagerSubtitle, style: ManeType.body(12, color: c.textTertiary)),
                ),
              ],
            ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, Tag tag) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteTagQuestion),
        content: Text(l10n.deleteTagBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (confirmed == true) {
      if (ref.read(tagFilterProvider).contains(tag.id)) {
        ref.read(tagFilterProvider.notifier).toggle(tag.id);
      }
      await ref.read(repositoryProvider).deleteTag(tag.id);
    }
  }
}

class _TagRow extends StatelessWidget {
  const _TagRow({required this.tag, required this.spaceName, required this.onEdit, required this.onDelete});

  final Tag tag;
  final String spaceName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.mc;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 3, 4, 3),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: tagColor(tag.colorValue).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: tagColor(tag.colorValue), shape: BoxShape.circle),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Pressable(
              onTap: onEdit,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tag.name,
                      style: ManeType.body(14, weight: FontWeight.w700, color: c.text),
                    ),
                    Text(spaceName, style: ManeType.body(11.5, color: c.textSecondary)),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz, color: c.textTertiary),
            onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
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

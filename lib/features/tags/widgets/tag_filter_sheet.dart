import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/l10n.dart';
import '../../../state/providers.dart';
import '../pages/tags_page.dart';
import '../tag_colors.dart';

Future<void> showTagFilterSheet(BuildContext context) async {
  final manage = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => const _TagFilterSheet(),
  );
  if (manage == true && context.mounted) {
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const TagsPage()));
  }
}

class _TagFilterSheet extends ConsumerWidget {
  const _TagFilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tags = ref.watch(tagsProvider).value ?? const <Tag>[];
    final spaces = ref.watch(spacesProvider).value ?? fallbackSpaces;
    final selected = ref.watch(tagFilterProvider);
    final spaceNames = {for (final space in spaces) space.id: space.name};

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 12, 8),
            child: Row(
              children: [
                Expanded(child: Text(l10n.filterByTag, style: Theme.of(context).textTheme.titleLarge)),
                if (selected.isNotEmpty)
                  TextButton(
                    onPressed: () => ref.read(tagFilterProvider.notifier).clear(),
                    child: Text(l10n.clearFilters),
                  ),
              ],
            ),
          ),
          Flexible(
            child: tags.isEmpty
                ? Padding(padding: const EdgeInsets.all(24), child: Text(l10n.noTags))
                : ListView(
                    shrinkWrap: true,
                    children: [
                      for (final tag in tags)
                        CheckboxListTile(
                          value: selected.contains(tag.id),
                          onChanged: (_) => ref.read(tagFilterProvider.notifier).toggle(tag.id),
                          secondary: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: tagColor(tag.colorValue),
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(tag.name),
                          subtitle: tag.spaceId == null
                              ? null
                              : Text(spaceNames[tag.spaceId] ?? tag.spaceId!),
                        ),
                    ],
                  ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.sell_outlined),
            title: Text(l10n.manageTags),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).pop(true),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

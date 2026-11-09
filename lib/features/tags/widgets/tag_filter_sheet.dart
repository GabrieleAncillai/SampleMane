import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../state/providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../pages/tags_page.dart';
import '../tag_colors.dart';

Future<void> showTagFilterSheet(BuildContext context) async {
  final manage = await showAppSheet<bool>(context: context, builder: (context) => const _TagFilterSheet());
  if (manage == true && context.mounted) {
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const TagsPage()));
  }
}

class _TagFilterSheet extends ConsumerWidget {
  const _TagFilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.mc;
    final tags = ref.watch(tagsProvider).value ?? const <Tag>[];
    final spaces = ref.watch(spacesProvider).value ?? fallbackSpaces;
    final selected = ref.watch(tagFilterProvider);
    final spaceNames = {for (final space in spaces) space.id: space.name};

    return AppSheet(
      title: l10n.filterByTag,
      children: [
        if (selected.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => ref.read(tagFilterProvider.notifier).clear(),
              child: Text(l10n.clearFilters),
            ),
          ),
        if (tags.isEmpty)
          AppEmptyState(icon: Icons.sell_outlined, title: l10n.noTags, compact: true)
        else
          for (final tag in tags)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Pressable(
                onTap: () => ref.read(tagFilterProvider.notifier).toggle(tag.id),
                child: Row(
                  children: [
                    SizedBox(
                      width: 34,
                      height: 40,
                      child: Checkbox(
                        value: selected.contains(tag.id),
                        visualDensity: VisualDensity.compact,
                        onChanged: (_) => ref.read(tagFilterProvider.notifier).toggle(tag.id),
                      ),
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: tagColor(tag.colorValue), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tag.name,
                              style: ManeType.body(14, weight: FontWeight.w700, color: c.text),
                            ),
                            if (tag.spaceId != null)
                              Text(
                                spaceNames[tag.spaceId] ?? tag.spaceId!,
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
        const SizedBox(height: 10),
        const Divider(),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.sell_outlined, color: c.accent),
          title: Text(l10n.manageTags, style: ManeType.body(14, color: c.text)),
          trailing: Icon(Icons.chevron_right, color: c.textTertiary),
          onTap: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}

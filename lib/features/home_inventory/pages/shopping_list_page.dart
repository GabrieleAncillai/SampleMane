import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../models/home_item.dart';
import '../../../models/shopping_item.dart';
import '../../../state/providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../low_stock.dart';
import '../widgets/shopping_item_sheet.dart';

class ShoppingListPage extends ConsumerWidget {
  const ShoppingListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.mc;
    final items = ref.watch(shoppingItemsProvider).value ?? const <ShoppingItem>[];
    final homeItems = ref.watch(homeItemsProvider).value ?? const <HomeItem>[];
    final homeById = {for (final item in homeItems) item.id: item};
    final lowStock = homeItems.where((item) => item.isLowStock).toList();
    final available = items.where((item) => !item.checked).toList();
    final bought = items.where((item) => item.checked).toList();
    final done = bought.length;
    final groups = _groupItems(available, homeById, l10n.shoppingOther);

    return ManePage(
      title: l10n.shoppingList,
      subtitle: items.isEmpty ? null : l10n.shoppingProgress(done, items.length),
      floatingAction: ManeAddButton(
        tooltip: l10n.addShoppingItem,
        onTap: () => showShoppingItemSheet(context),
      ),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 88),
        children: [
          if (lowStock.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 8),
              decoration: BoxDecoration(
                color: c.dangerSoft,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: c.danger.withValues(alpha: 0.22)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_outlined, size: 18, color: c.danger),
                      const SizedBox(width: 8),
                      Text(l10n.lowStock, style: ManeType.label(13, color: c.danger)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    l10n.lowStockCount(lowStock.length),
                    style: ManeType.body(11.5, color: c.textSecondary),
                  ),
                  Text(
                    lowStock.map((item) => item.name).join(', '),
                    style: ManeType.body(11.5, color: c.textSecondary),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () async => addLowStockToShopping(ref, lowStock),
                      icon: const Icon(Icons.add_shopping_cart, size: 17),
                      label: Text(l10n.addLowStockItems),
                    ),
                  ),
                ],
              ),
            ),
          if (items.isEmpty)
            AppEmptyState(
              icon: Icons.shopping_basket_outlined,
              title: l10n.shoppingListEmpty,
              message: l10n.shoppingListSubtitle,
              action: FilledButton.tonalIcon(
                onPressed: () => showShoppingItemSheet(context),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.addShoppingItem),
              ),
            )
          else ...[
            if (groups.isNotEmpty) ...[
              SectionLabel(l10n.shoppingToBuy),
              for (final group in groups) ...[
                if (group.label.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 6),
                    child: Text(group.label, style: ManeType.label(12, color: c.textSecondary)),
                  ),
                ],
                SoftCard(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  clip: true,
                  child: Column(
                    children: [
                      for (var index = 0; index < group.items.length; index++) ...[
                        if (index > 0) const Divider(height: 1, indent: 50),
                        _ShoppingRow(
                          item: group.items[index],
                          homeName: homeById[group.items[index].homeItemId]?.name,
                          onChecked: (value) =>
                              ref.read(repositoryProvider).setShoppingChecked(group.items[index].id, value),
                          onEdit: () => showShoppingItemSheet(context, item: group.items[index]),
                          onDelete: () =>
                              ref.read(repositoryProvider).deleteShoppingItem(group.items[index].id),
                          onMoveUp: index == 0
                              ? null
                              : () =>
                                    ref.read(repositoryProvider).moveShoppingItem(group.items[index].id, -1),
                          onMoveDown: index == group.items.length - 1
                              ? null
                              : () => ref.read(repositoryProvider).moveShoppingItem(group.items[index].id, 1),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
            if (bought.isNotEmpty) ...[
              SectionLabel(
                l10n.shoppingBought,
                trailing: TextButton(
                  onPressed: () => _clearBought(context, ref),
                  child: Text(l10n.clearChecked),
                ),
              ),
              SoftCard(
                padding: const EdgeInsets.symmetric(vertical: 4),
                clip: true,
                child: Column(
                  children: [
                    for (var index = 0; index < bought.length; index++) ...[
                      if (index > 0) const Divider(height: 1, indent: 50),
                      _ShoppingRow(
                        item: bought[index],
                        homeName: homeById[bought[index].homeItemId]?.name,
                        onChecked: (value) =>
                            ref.read(repositoryProvider).setShoppingChecked(bought[index].id, value),
                        onEdit: () => showShoppingItemSheet(context, item: bought[index]),
                        onDelete: () => ref.read(repositoryProvider).deleteShoppingItem(bought[index].id),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(l10n.shoppingListSubtitle, style: ManeType.body(12, color: c.textTertiary)),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _clearBought(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.clearChecked),
        content: Text(l10n.clearCheckedBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.clearChecked),
          ),
        ],
      ),
    );
    if (confirmed == true) await ref.read(repositoryProvider).clearCheckedShopping();
  }

  static List<_ShoppingGroup> _groupItems(
    List<ShoppingItem> items,
    Map<String, HomeItem> homeById,
    String otherLabel,
  ) {
    final groups = <String, List<ShoppingItem>>{};
    for (final item in items) {
      final home = homeById[item.homeItemId];
      final parts = [
        if (home != null && home.category.trim().isNotEmpty) home.category.trim(),
        if (home != null && home.location.trim().isNotEmpty) home.location.trim(),
      ];
      final label = parts.isEmpty ? otherLabel : parts.join(' · ');
      (groups[label] ??= <ShoppingItem>[]).add(item);
    }
    final labels = groups.keys.toList()
      ..sort((a, b) {
        if (a == otherLabel) return 1;
        if (b == otherLabel) return -1;
        return a.compareTo(b);
      });
    return [for (final label in labels) _ShoppingGroup(label: label, items: groups[label]!)];
  }
}

class _ShoppingGroup {
  const _ShoppingGroup({required this.label, required this.items});

  final String label;
  final List<ShoppingItem> items;
}

class _ShoppingRow extends StatelessWidget {
  const _ShoppingRow({
    required this.item,
    required this.homeName,
    required this.onChecked,
    required this.onEdit,
    required this.onDelete,
    this.onMoveUp,
    this.onMoveDown,
  });

  final ShoppingItem item;
  final String? homeName;
  final ValueChanged<bool> onChecked;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = context.mc;
    final details = [
      '${_number(item.quantity)}${item.unit.isEmpty ? '' : ' ${item.unit}'}',
      if (homeName != null && homeName!.isNotEmpty && homeName!.toLowerCase() != item.name.toLowerCase())
        homeName!,
      if (item.note.isNotEmpty) item.note,
    ].where((part) => part.isNotEmpty).join(' · ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 2, 4, 2),
      child: Row(
        children: [
          SizedBox(
            width: 38,
            height: 40,
            child: Checkbox(
              value: item.checked,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (value) => onChecked(value == true),
            ),
          ),
          Expanded(
            child: Pressable(
              onTap: onEdit,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ManeType.body(
                        14,
                        weight: FontWeight.w700,
                        color: item.checked ? c.textTertiary : c.text,
                      ).copyWith(decoration: item.checked ? TextDecoration.lineThrough : null),
                    ),
                    if (details.isNotEmpty) ...[
                      const SizedBox(height: 1),
                      Text(
                        details,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ManeType.body(11.5, color: c.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz, color: c.textTertiary),
            onSelected: (value) => switch (value) {
              'up' => onMoveUp?.call(),
              'down' => onMoveDown?.call(),
              'edit' => onEdit(),
              _ => onDelete(),
            },
            itemBuilder: (context) => [
              if (onMoveUp != null) PopupMenuItem(value: 'up', child: Text(l10n.moveUp)),
              if (onMoveDown != null) PopupMenuItem(value: 'down', child: Text(l10n.moveDown)),
              PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
              PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
            ],
          ),
        ],
      ),
    );
  }

  static String _number(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : value.toString();
}

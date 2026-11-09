import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/l10n.dart';
import '../../../models/home_item.dart';
import '../../../models/shopping_item.dart';
import '../../../state/providers.dart';
import '../low_stock.dart';
import '../widgets/shopping_item_sheet.dart';

class ShoppingListPage extends ConsumerWidget {
  const ShoppingListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final items = ref.watch(shoppingItemsProvider).value ?? const <ShoppingItem>[];
    final homeItems = ref.watch(homeItemsProvider).value ?? const <HomeItem>[];
    final lowStock = homeItems.where((item) => item.isLowStock).toList();
    final homeNames = {for (final item in homeItems) item.id: item.name};
    final done = items.where((item) => item.checked).length;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shoppingList)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showShoppingItemSheet(context),
        tooltip: l10n.addShoppingItem,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          if (lowStock.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_outlined, size: 18, color: theme.colorScheme.error),
                      const SizedBox(width: 8),
                      Text(l10n.lowStock, style: theme.textTheme.titleSmall),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lowStock.map((item) => item.name).join(', '),
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () async {
                        await addLowStockToShopping(ref, lowStock);
                      },
                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                      label: Text(l10n.addLowStockItems),
                    ),
                  ),
                ],
              ),
            ),
          if (items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 4),
              child: Text(
                l10n.shoppingProgress(done, items.length),
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  l10n.shoppingListEmpty,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            )
          else
            for (final item in items)
              CheckboxListTile(
                value: item.checked,
                onChanged: (value) => ref.read(repositoryProvider).setShoppingChecked(item.id, value == true),
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  item.name,
                  style: TextStyle(
                    decoration: item.checked ? TextDecoration.lineThrough : null,
                    color: item.checked ? theme.colorScheme.onSurfaceVariant : null,
                  ),
                ),
                subtitle: Text(
                  [
                    '${_number(item.quantity)}${item.unit.isEmpty ? '' : ' ${item.unit}'}',
                    if (item.homeItemId != null) homeNames[item.homeItemId] ?? '',
                    if (item.note.isNotEmpty) item.note,
                  ].where((part) => part.isNotEmpty).join(' · '),
                ),
                secondary: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      await showShoppingItemSheet(context, item: item);
                      return;
                    }
                    await ref.read(repositoryProvider).deleteShoppingItem(item.id);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                    PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  static String _number(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : value.toString();
}

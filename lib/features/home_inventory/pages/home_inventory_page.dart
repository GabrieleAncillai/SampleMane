import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/l10n.dart';
import '../../../models/home_item.dart';
import '../../../state/providers.dart';
import '../low_stock.dart';
import '../widgets/home_item_sheet.dart';

class HomeInventoryPage extends ConsumerWidget {
  const HomeInventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final items = ref.watch(homeItemsProvider).value ?? const <HomeItem>[];
    final lowStock = items.where((item) => item.isLowStock).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeInventory)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showHomeItemSheet(context),
        tooltip: l10n.addHomeItem,
        child: const Icon(Icons.add),
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                l10n.homeInventoryEmpty,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                if (lowStock.isNotEmpty)
                  _LowStockCard(items: lowStock, onAdd: () => _addLowStock(context, ref, lowStock)),
                for (final item in items) _HomeItemTile(item: item),
              ],
            ),
    );
  }

  Future<void> _addLowStock(BuildContext context, WidgetRef ref, List<HomeItem> lowStock) async {
    await addLowStockToShopping(ref, lowStock);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.addLowStockItems)));
  }
}

class _LowStockCard extends StatelessWidget {
  const _LowStockCard({required this.items, required this.onAdd});

  final List<HomeItem> items;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
              Icon(Icons.inventory_2_outlined, size: 18, color: theme.colorScheme.error),
              const SizedBox(width: 8),
              Text(context.l10n.lowStock, style: theme.textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            items.map((item) => item.name).join(', '),
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_shopping_cart, size: 18),
              label: Text(context.l10n.addLowStockItems),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeItemTile extends ConsumerWidget {
  const _HomeItemTile({required this.item});

  final HomeItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final details = [
      if (item.category.isNotEmpty) item.category,
      if (item.location.isNotEmpty) item.location,
      '${_number(item.quantity)}${item.unit.isEmpty ? '' : ' ${item.unit}'}',
      if (item.reorderLevel != null) '${l10n.reorderLevel}: ${_number(item.reorderLevel!)}',
    ].join(' · ');

    return ListTile(
      leading: Icon(
        item.isLowStock ? Icons.warning_amber_outlined : Icons.inventory_2_outlined,
        color: item.isLowStock ? theme.colorScheme.error : theme.colorScheme.primary,
      ),
      title: Text(item.name),
      subtitle: Text(details),
      trailing: PopupMenuButton<String>(
        onSelected: (value) async {
          if (value == 'edit') {
            await showHomeItemSheet(context, item: item);
            return;
          }
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text(l10n.archiveItemQuestion),
              content: Text(l10n.archiveItemBody),
              actions: [
                TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(l10n.delete),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            await ref.read(repositoryProvider).archiveHomeItem(item.id);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
          PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
        ],
      ),
      onTap: () => showHomeItemSheet(context, item: item),
    );
  }

  static String _number(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : value.toString();
}

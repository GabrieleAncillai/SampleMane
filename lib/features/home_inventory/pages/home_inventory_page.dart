import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../models/home_item.dart';
import '../../../state/providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../low_stock.dart';
import '../widgets/home_item_sheet.dart';

class HomeInventoryPage extends ConsumerWidget {
  const HomeInventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final c = context.mc;
    final items = ref.watch(homeItemsProvider).value ?? const <HomeItem>[];
    final lowStock = items.where((item) => item.isLowStock).toList();

    return ManePage(
      title: l10n.homeInventory,
      subtitle: l10n.homeInventorySubtitle,
      floatingAction: ManeAddButton(tooltip: l10n.addHomeItem, onTap: () => showHomeItemSheet(context)),
      child: items.isEmpty
          ? AppEmptyState(
              icon: Icons.inventory_2_outlined,
              title: l10n.homeInventoryEmpty,
              message: l10n.homeInventorySubtitle,
              action: FilledButton.tonalIcon(
                onPressed: () => showHomeItemSheet(context),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.addHomeItem),
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 88),
              children: [
                if (lowStock.isNotEmpty)
                  _LowStockCard(items: lowStock, onAdd: () => _addLowStock(context, ref, lowStock)),
                SoftCard(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  clip: true,
                  child: Column(
                    children: [
                      for (var index = 0; index < items.length; index++) ...[
                        if (index > 0) const Divider(height: 1, indent: 52),
                        _HomeItemTile(item: items[index]),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(l10n.homeInventorySubtitle, style: ManeType.body(12, color: c.textTertiary)),
                ),
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
    final c = context.mc;
    final l10n = context.l10n;
    return Container(
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
              Icon(Icons.inventory_2_outlined, size: 18, color: c.danger),
              const SizedBox(width: 8),
              Text(l10n.lowStock, style: ManeType.label(13, color: c.danger)),
            ],
          ),
          const SizedBox(height: 5),
          Text(items.map((item) => item.name).join(', '), style: ManeType.body(11.5, color: c.textSecondary)),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_shopping_cart, size: 17),
              label: Text(l10n.addLowStockItems),
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
    final c = context.mc;
    final l10n = context.l10n;
    final details = [
      if (item.category.isNotEmpty) item.category,
      if (item.location.isNotEmpty) item.location,
      '${_number(item.quantity)}${item.unit.isEmpty ? '' : ' ${item.unit}'}',
      if (item.reorderLevel != null) '${l10n.reorderLevel}: ${_number(item.reorderLevel!)}',
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 3, 4, 3),
      child: Row(
        children: [
          Expanded(
            child: Pressable(
              onTap: () => showHomeItemSheet(context, item: item),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: item.isLowStock ? c.dangerSoft : c.homeSoft,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      item.isLowStock ? Icons.warning_amber_outlined : Icons.inventory_2_outlined,
                      size: 19,
                      color: item.isLowStock ? c.danger : c.home,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ManeType.body(14, weight: FontWeight.w700, color: c.text),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            details,
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
            onSelected: (value) async {
              if (value == 'edit') {
                await showHomeItemSheet(context, item: item);
                return;
              }
              await _archive(context, ref);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
              PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _archive(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.archiveItemQuestion),
        content: Text(l10n.archiveItemBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(repositoryProvider).archiveHomeItem(item.id);
    }
  }

  static String _number(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : value.toString();
}

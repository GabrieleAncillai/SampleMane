import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../models/home_item.dart';
import '../../models/shopping_item.dart';
import '../../state/providers.dart';

/// Adds one linked shopping line per low-stock item that is not already on the
/// list. Returns how many lines were added.
Future<int> addLowStockToShopping(WidgetRef ref, Iterable<HomeItem> lowStock) async {
  final existing = ref.read(shoppingItemsProvider).value ?? const <ShoppingItem>[];
  final repository = ref.read(repositoryProvider);
  var added = 0;
  for (final item in lowStock) {
    final alreadyListed = existing.any((shopping) => !shopping.checked && shopping.homeItemId == item.id);
    if (alreadyListed) continue;
    await repository.saveShoppingItem(
      ShoppingItem(
        id: const Uuid().v4(),
        name: item.name,
        quantity: item.suggestedPurchase,
        unit: item.unit,
        homeItemId: item.id,
      ),
    );
    added++;
  }
  return added;
}

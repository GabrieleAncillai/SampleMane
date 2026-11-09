/// A lightweight record of stock entering the household inventory.
///
/// [shoppingItemId] links a purchase to the shopping line that produced it so
/// unchecking that line can reverse both the quantity and its history row.
class HomePurchase {
  const HomePurchase({
    required this.id,
    required this.homeItemId,
    required this.quantity,
    required this.purchasedAt,
    this.shoppingItemId,
    this.note = '',
  });

  final String id;
  final String homeItemId;
  final String? shoppingItemId;
  final double quantity;
  final String note;
  final DateTime purchasedAt;
}

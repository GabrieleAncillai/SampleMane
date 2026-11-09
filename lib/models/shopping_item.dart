/// One line on the shopping list. A linked [homeItemId] means checking it off
/// adjusts the household inventory.
class ShoppingItem {
  const ShoppingItem({
    required this.id,
    required this.name,
    this.quantity = 1,
    this.unit = '',
    this.checked = false,
    this.note = '',
    this.homeItemId,
  });

  final String id;
  final String name;
  final double quantity;
  final String unit;
  final bool checked;
  final String note;
  final String? homeItemId;

  ShoppingItem copyWith({
    String? name,
    double? quantity,
    String? unit,
    bool? checked,
    String? note,
    String? homeItemId,
    bool clearHomeItem = false,
  }) => ShoppingItem(
    id: id,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    checked: checked ?? this.checked,
    note: note ?? this.note,
    homeItemId: clearHomeItem ? null : (homeItemId ?? this.homeItemId),
  );
}

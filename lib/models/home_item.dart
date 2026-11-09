/// A household item with quantity, unit, location and an optional reorder
/// threshold. Quantities are doubles so units like kilograms work.
class HomeItem {
  const HomeItem({
    required this.id,
    required this.name,
    this.category = '',
    this.location = '',
    this.quantity = 0,
    this.unit = '',
    this.reorderLevel,
    this.notes = '',
    this.lastPurchasedAt,
  });

  final String id;
  final String name;
  final String category;
  final String location;
  final double quantity;
  final String unit;
  final double? reorderLevel;
  final String notes;
  final DateTime? lastPurchasedAt;

  bool get isLowStock => reorderLevel != null && quantity <= reorderLevel!;

  /// Enough to get back above the threshold, with a minimum of one unit.
  double get suggestedPurchase {
    final level = reorderLevel;
    if (level == null) return quantity <= 0 ? 1 : 0;
    final target = (level * 2) - quantity;
    return target <= 1 ? 1 : target;
  }

  HomeItem copyWith({
    String? name,
    String? category,
    String? location,
    double? quantity,
    String? unit,
    double? reorderLevel,
    bool clearReorderLevel = false,
    String? notes,
    DateTime? lastPurchasedAt,
  }) => HomeItem(
    id: id,
    name: name ?? this.name,
    category: category ?? this.category,
    location: location ?? this.location,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    reorderLevel: clearReorderLevel ? null : (reorderLevel ?? this.reorderLevel),
    notes: notes ?? this.notes,
    lastPurchasedAt: lastPurchasedAt ?? this.lastPurchasedAt,
  );
}

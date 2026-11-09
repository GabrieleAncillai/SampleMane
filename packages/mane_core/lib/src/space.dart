/// A top-level context: Home or Work.
///
/// Spaces are rows, not an enum, so adding "Personal" later is a data change
/// rather than a schema change.
class Space {
  const Space({required this.id, required this.name, required this.colorValue, this.position = 0});

  final String id;
  final String name;

  /// ARGB value, stored as an int so the core package stays Flutter-free.
  final int colorValue;
  final int position;
}

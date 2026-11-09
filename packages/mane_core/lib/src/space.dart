/// A top-level context: Personal, Work or Home.
///
/// Spaces are rows, not an enum, so a user can add a fourth later without a
/// schema change. Tags, not extra spaces, separate the jobs and people inside
/// one space.
class Space {
  const Space({required this.id, required this.name, required this.colorValue, this.position = 0});

  final String id;
  final String name;

  /// ARGB value, stored as an int so the core package stays Flutter-free.
  final int colorValue;
  final int position;
}

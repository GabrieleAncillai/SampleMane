/// A label for jobs, projects, people or groups inside a space.
///
/// [spaceId] is null for a tag usable in every space. Tags are rows, not an
/// enum, so the user can rename or remove them without a schema change.
class Tag {
  const Tag({
    required this.id,
    this.spaceId,
    required this.name,
    required this.colorValue,
    this.position = 0,
  });

  final String id;
  final String? spaceId;
  final String name;

  /// ARGB value, stored as an int so the core package stays Flutter-free.
  final int colorValue;
  final int position;

  bool appliesTo(String space) => spaceId == null || spaceId == space;

  Tag copyWith({String? spaceId, bool clearSpace = false, String? name, int? colorValue, int? position}) =>
      Tag(
        id: id,
        spaceId: clearSpace ? null : (spaceId ?? this.spaceId),
        name: name ?? this.name,
        colorValue: colorValue ?? this.colorValue,
        position: position ?? this.position,
      );
}

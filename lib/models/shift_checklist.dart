/// One checklist line attached to a shift pattern.
class ShiftChecklistItem {
  const ShiftChecklistItem({
    required this.id,
    required this.patternId,
    required this.label,
    this.position = 0,
  });

  final String id;
  final String patternId;
  final String label;
  final int position;

  ShiftChecklistItem copyWith({String? label, int? position}) => ShiftChecklistItem(
    id: id,
    patternId: patternId,
    label: label ?? this.label,
    position: position ?? this.position,
  );
}

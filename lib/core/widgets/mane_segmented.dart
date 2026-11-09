import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class ManeSegment<T> {
  const ManeSegment({required this.value, required this.label, this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

/// The reference pill segmented control. It keeps the selected state readable
/// without the heavy Material segment border.
class ManeSegmented<T> extends StatelessWidget {
  const ManeSegmented({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.compact = false,
  });

  final List<ManeSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: c.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final segment in segments)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(segment.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 170),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 16, vertical: compact ? 7 : 9),
                decoration: BoxDecoration(
                  color: segment.value == selected ? c.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: segment.value == selected
                      ? [BoxShadow(color: c.shadow, blurRadius: 8, offset: const Offset(0, 2))]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (segment.icon != null) ...[
                      Icon(
                        segment.icon,
                        size: 15,
                        color: segment.value == selected ? c.accent : c.textSecondary,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      segment.label,
                      style: ManeType.label(
                        compact ? 11.5 : 12.5,
                        color: segment.value == selected ? c.text : c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

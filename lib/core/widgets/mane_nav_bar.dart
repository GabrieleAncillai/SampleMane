import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'pressable.dart';

typedef ManeNavItem = ({IconData icon, IconData selectedIcon, String label});

/// The floating bottom navigation from the reference shell. A soft lens slides
/// between three destinations; labels stay visible for accessibility.
class ManeNavBar extends StatelessWidget {
  const ManeNavBar({super.key, required this.items, required this.index, required this.onSelected});

  final List<ManeNavItem> items;
  final int index;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    final radius = BorderRadius.circular(26);
    return Container(
      height: 64,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(color: c.shadow, blurRadius: 24, offset: const Offset(0, 10)),
          BoxShadow(color: c.shadow.withValues(alpha: 0.35), blurRadius: 4, offset: const Offset(0, 1)),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: c.navBg,
            borderRadius: radius,
            border: Border.all(color: c.border),
          ),
          child: LayoutBuilder(
            builder: (context, box) {
              final slot = box.maxWidth / items.length;
              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    left: slot * index + 6,
                    top: 6,
                    width: slot - 12,
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: c.accentSoft,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: c.accent.withValues(alpha: 0.22)),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < items.length; i++)
                        Expanded(
                          child: _NavItem(item: items[i], selected: i == index, onTap: () => onSelected(i)),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.item, required this.selected, required this.onTap});

  final ManeNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    final tint = selected ? c.accent : c.textSecondary;
    return Pressable(
      onTap: onTap,
      semanticButton: true,
      semanticLabel: item.label,
      scale: 0.94,
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? item.selectedIcon : item.icon, size: 21, color: tint),
            const SizedBox(height: 3),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textScaler: TextScaler.noScaling,
              style: ManeType.label(
                10.5,
                color: tint,
              ).copyWith(fontWeight: selected ? FontWeight.w800 : FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

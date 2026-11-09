import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// A calm empty state with a soft halo, a title, one supporting line and an
/// optional action. The reference uses the same shape for every "nothing here
/// yet" surface.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    final halo = compact ? 68.0 : 96.0;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 36, vertical: compact ? 24 : 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: halo,
              height: halo,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [c.accent.withValues(alpha: 0.16), c.accent.withValues(alpha: 0.02)],
                ),
              ),
              child: Icon(icon, size: compact ? 30 : 40, color: c.accent),
            ),
            SizedBox(height: compact ? 14 : 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: ManeType.headline(compact ? 16 : 19, color: c.text),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: ManeType.body(compact ? 13 : 14, color: c.textSecondary),
              ),
            ],
            if (action != null) ...[SizedBox(height: compact ? 18 : 24), action!],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'app_background.dart';
import 'pressable.dart';

/// A pushed page with the reference header: round back button, strong title,
/// optional subtitle and glass actions. It replaces stock AppBar scaffolds.
class ManePage extends StatelessWidget {
  const ManePage({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.actions = const [],
    this.onBack,
    this.padding = const EdgeInsets.fromLTRB(20, 4, 20, 28),
    this.floatingAction,
    this.bottomBar,
    this.backgroundColor,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget> actions;
  final VoidCallback? onBack;
  final EdgeInsets padding;
  final Widget? floatingAction;
  final Widget? bottomBar;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: AppBackground(
        child: SafeArea(
          bottom: bottomBar == null,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                child: ManePageHeader(
                  title: title,
                  subtitle: subtitle,
                  actions: actions,
                  onBack: onBack ?? () => Navigator.of(context).maybePop(),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(padding: padding, child: child),
                    ),
                    if (floatingAction != null) Positioned(right: 20, bottom: 20, child: floatingAction!),
                  ],
                ),
              ),
              if (bottomBar != null)
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 12 + MediaQuery.paddingOf(context).bottom),
                  decoration: BoxDecoration(
                    color: c.surface,
                    border: Border(top: BorderSide(color: c.border)),
                  ),
                  child: bottomBar,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ManePageHeader extends StatelessWidget {
  const ManePageHeader({super.key, required this.title, this.subtitle, this.actions = const [], this.onBack});

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    return Row(
      children: [
        if (onBack != null) ...[
          Pressable(
            onTap: onBack,
            semanticButton: true,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.surface,
                border: Border.all(color: c.border),
              ),
              child: Icon(Icons.chevron_left, size: 22, color: c.text),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ManeType.headline(21, color: c.text),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 1),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ManeType.body(12, color: c.textSecondary),
                ),
              ],
            ],
          ),
        ),
        for (final action in actions) ...[const SizedBox(width: 8), action],
      ],
    );
  }
}

/// A round filled action used for "add" and primary page actions.
class ManeAddButton extends StatelessWidget {
  const ManeAddButton({super.key, required this.onTap, required this.tooltip, this.icon = Icons.add});

  final VoidCallback onTap;
  final String tooltip;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    return Tooltip(
      message: tooltip,
      child: Pressable(
        onTap: onTap,
        semanticLabel: tooltip,
        semanticButton: true,
        scale: 0.92,
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: c.accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: c.accent.withValues(alpha: 0.28), blurRadius: 18, offset: const Offset(0, 8)),
            ],
          ),
          child: Icon(icon, size: 26, color: c.onAccent),
        ),
      ),
    );
  }
}

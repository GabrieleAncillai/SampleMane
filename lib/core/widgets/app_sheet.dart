import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Opens a bottom sheet with the reference shape, backing surface and drag
/// behaviour. Kept as a function so every feature sheet gets the same motion.
Future<T?> showAppSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
  bool isDismissible = true,
  bool enableDrag = true,
  bool useSafeArea = true,
}) {
  final c = context.mc;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    useSafeArea: useSafeArea,
    showDragHandle: false,
    backgroundColor: c.surface,
    barrierColor: Colors.black.withValues(alpha: 0.38),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheetContext).bottom),
      child: builder(sheetContext),
    ),
  );
}

class AppSheet extends StatelessWidget {
  const AppSheet({
    super.key,
    required this.children,
    this.title,
    this.subtitle,
    this.bottom = 24,
    this.top = 10,
    this.scroll = true,
    this.maxHeight = 0.9,
  });

  final List<Widget> children;
  final String? title;
  final String? subtitle;
  final double bottom;
  final double top;
  final bool scroll;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SheetHandle(),
        if (title != null) ...[
          SizedBox(height: top),
          Text(
            title!,
            textAlign: TextAlign.center,
            style: ManeType.headline(19, color: c.text),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 5),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: ManeType.body(13, color: c.textSecondary),
            ),
          ],
        ],
        SizedBox(height: title == null ? top : 16),
        ...children,
      ],
    );
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * maxHeight),
      padding: EdgeInsets.fromLTRB(20, 10, 20, bottom + MediaQuery.paddingOf(context).bottom),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: scroll ? SingleChildScrollView(child: content) : content,
    );
  }
}

class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key, this.margin = const EdgeInsets.only(bottom: 2)});

  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: margin,
        decoration: BoxDecoration(color: c.borderStrong, borderRadius: BorderRadius.circular(2)),
      ),
    );
  }
}

class SheetTitle extends StatelessWidget {
  const SheetTitle(this.title, {super.key, this.subtitle, this.trailing});

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: ManeType.headline(20, color: c.text)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: ManeType.body(13, color: c.textSecondary)),
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class SheetAction extends StatelessWidget {
  const SheetAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.accent,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final IconData? trailing;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    final color = accent ?? c.accent;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label, style: ManeType.body(14, color: c.text)),
              ),
              if (trailing != null) Icon(trailing, size: 18, color: c.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';

/// Asks which space an imported read-only schedule belongs to.
Future<String?> pickImportSpace(BuildContext context, WidgetRef ref, {required String title}) async {
  final spaces = ref.read(spacesProvider).value ?? fallbackSpaces;
  var selected = spaces.first.id;
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(title),
        content: DropdownButtonFormField<String>(
          initialValue: selected,
          items: [for (final space in spaces) DropdownMenuItem(value: space.id, child: Text(space.name))],
          onChanged: (value) {
            if (value != null) setDialogState(() => selected = value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(selected),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    ),
  );
}

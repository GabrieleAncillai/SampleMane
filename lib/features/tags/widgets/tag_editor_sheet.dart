import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';
import 'package:uuid/uuid.dart';

import '../../../core/i18n/l10n.dart';
import '../../../state/providers.dart';
import '../tag_colors.dart';

Future<void> showTagEditor(BuildContext context, {Tag? tag, required List<Space> spaces}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => TagEditorSheet(tag: tag, spaces: spaces),
    );

class TagEditorSheet extends ConsumerStatefulWidget {
  const TagEditorSheet({super.key, this.tag, required this.spaces});

  final Tag? tag;
  final List<Space> spaces;

  @override
  ConsumerState<TagEditorSheet> createState() => _TagEditorSheetState();
}

class _TagEditorSheetState extends ConsumerState<TagEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String? _spaceId;
  late int _color;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tag?.name ?? '');
    _spaceId = widget.tag?.spaceId;
    _color = widget.tag?.colorValue ?? tagPalette.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.tag == null ? l10n.addTag : l10n.editTag,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: l10n.close,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l10n.tagName, border: const OutlineInputBorder()),
                validator: (value) => value == null || value.trim().isEmpty ? l10n.tagNameRequired : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                initialValue: _spaceId,
                decoration: InputDecoration(labelText: l10n.tagSpace, border: const OutlineInputBorder()),
                items: [
                  DropdownMenuItem<String?>(value: null, child: Text(l10n.tagSpaceAny)),
                  for (final space in widget.spaces)
                    DropdownMenuItem<String?>(
                      value: space.id,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(color: Color(space.colorValue), shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Text(space.name),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) => setState(() => _spaceId = value),
              ),
              const SizedBox(height: 16),
              Text(l10n.tagColor, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final color in tagPalette)
                    InkWell(
                      onTap: () => setState(() => _color = color),
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: tagColor(color),
                          shape: BoxShape.circle,
                          border: color == _color
                              ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 2.5)
                              : null,
                        ),
                        child: color == _color
                            ? Icon(Icons.check, size: 18, color: Theme.of(context).colorScheme.onPrimary)
                            : null,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final existing = widget.tag;
    final tag = Tag(
      id: existing?.id ?? const Uuid().v4(),
      spaceId: _spaceId,
      name: _nameController.text.trim(),
      colorValue: _color,
      position: existing?.position ?? 0,
    );
    try {
      await ref.read(repositoryProvider).saveTag(tag);
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.couldNotSave('$error'))));
      return;
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}

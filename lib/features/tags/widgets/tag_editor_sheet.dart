import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';
import 'package:uuid/uuid.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../state/providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../tag_colors.dart';

Future<void> showTagEditor(BuildContext context, {Tag? tag, required List<Space> spaces}) =>
    showAppSheet<void>(
      context: context,
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
    final c = context.mc;
    return AppSheet(
      title: widget.tag == null ? l10n.addTag : l10n.editTag,
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l10n.tagName),
                validator: (value) => value == null || value.trim().isEmpty ? l10n.tagNameRequired : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                initialValue: _spaceId,
                decoration: InputDecoration(labelText: l10n.tagSpace),
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
              Text(l10n.tagColor, style: ManeType.label(12.5, color: c.textSecondary)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final color in tagPalette)
                    Pressable(
                      onTap: () => setState(() => _color = color),
                      scale: 0.9,
                      semanticLabel: l10n.tagColor,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: tagColor(color),
                          shape: BoxShape.circle,
                          border: color == _color ? Border.all(color: c.text, width: 2.5) : null,
                        ),
                        child: color == _color ? Icon(Icons.check, size: 18, color: c.onAccent) : null,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(l10n.save),
              ),
            ],
          ),
        ),
      ],
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

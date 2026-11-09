import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../models/shopping_item.dart';
import '../../../state/providers.dart';

Future<void> showShoppingItemSheet(BuildContext context, {ShoppingItem? item}) => showAppSheet<void>(
  context: context,
  builder: (context) => ShoppingItemSheet(item: item),
);

class ShoppingItemSheet extends ConsumerStatefulWidget {
  const ShoppingItemSheet({super.key, this.item});

  final ShoppingItem? item;

  @override
  ConsumerState<ShoppingItemSheet> createState() => _ShoppingItemSheetState();
}

class _ShoppingItemSheetState extends ConsumerState<ShoppingItemSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _quantity;
  late final TextEditingController _unit;
  late final TextEditingController _note;
  String? _homeItemId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _name = TextEditingController(text: item?.name ?? '');
    _quantity = TextEditingController(text: _number(item?.quantity ?? 1));
    _unit = TextEditingController(text: item?.unit ?? '');
    _note = TextEditingController(text: item?.note ?? '');
    _homeItemId = item?.homeItemId;
  }

  @override
  void dispose() {
    _name.dispose();
    _quantity.dispose();
    _unit.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final homeItems = ref.watch(homeItemsProvider).value ?? const [];
    return AppSheet(
      title: widget.item == null ? l10n.addShoppingItem : l10n.editShoppingItem,
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _name,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l10n.itemName),
                validator: (value) => value == null || value.trim().isEmpty ? l10n.titleRequired : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantity,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: l10n.quantity),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unit,
                      decoration: InputDecoration(labelText: l10n.unit),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                initialValue: _homeItemId,
                decoration: InputDecoration(labelText: l10n.linkedItem),
                items: [
                  DropdownMenuItem<String?>(value: null, child: Text(l10n.noLink)),
                  for (final item in homeItems)
                    DropdownMenuItem<String?>(value: item.id, child: Text(item.name)),
                ],
                onChanged: (value) => setState(() => _homeItemId = value),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _note,
                maxLines: 2,
                decoration: InputDecoration(labelText: l10n.note),
              ),
              const SizedBox(height: 20),
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
    final existing = widget.item;
    final item = ShoppingItem(
      id: existing?.id ?? const Uuid().v4(),
      name: _name.text.trim(),
      quantity: _parse(_quantity.text),
      unit: _unit.text.trim(),
      checked: existing?.checked ?? false,
      note: _note.text.trim(),
      homeItemId: _homeItemId,
    );
    try {
      await ref.read(repositoryProvider).saveShoppingItem(item);
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

  static double _parse(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    return parsed == null || parsed <= 0 ? 1 : parsed;
  }

  static String _number(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : value.toString();
}

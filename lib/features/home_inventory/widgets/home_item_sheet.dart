import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/i18n/l10n.dart';
import '../../../models/home_item.dart';
import '../../../state/providers.dart';

Future<void> showHomeItemSheet(BuildContext context, {HomeItem? item}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (context) => HomeItemSheet(item: item),
);

class HomeItemSheet extends ConsumerStatefulWidget {
  const HomeItemSheet({super.key, this.item});

  final HomeItem? item;

  @override
  ConsumerState<HomeItemSheet> createState() => _HomeItemSheetState();
}

class _HomeItemSheetState extends ConsumerState<HomeItemSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _category;
  late final TextEditingController _location;
  late final TextEditingController _quantity;
  late final TextEditingController _unit;
  late final TextEditingController _reorder;
  late final TextEditingController _notes;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _name = TextEditingController(text: item?.name ?? '');
    _category = TextEditingController(text: item?.category ?? '');
    _location = TextEditingController(text: item?.location ?? '');
    _quantity = TextEditingController(text: _number(item?.quantity ?? 0));
    _unit = TextEditingController(text: item?.unit ?? '');
    _reorder = TextEditingController(text: item?.reorderLevel == null ? '' : _number(item!.reorderLevel!));
    _notes = TextEditingController(text: item?.notes ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _category.dispose();
    _location.dispose();
    _quantity.dispose();
    _unit.dispose();
    _reorder.dispose();
    _notes.dispose();
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
                      widget.item == null ? l10n.addHomeItem : l10n.editHomeItem,
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
                controller: _name,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l10n.itemName, border: const OutlineInputBorder()),
                validator: (value) => value == null || value.trim().isEmpty ? l10n.titleRequired : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _category,
                      decoration: InputDecoration(
                        labelText: l10n.category,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _location,
                      decoration: InputDecoration(
                        labelText: l10n.location,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantity,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.quantity,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unit,
                      decoration: InputDecoration(labelText: l10n.unit, border: const OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _reorder,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.reorderLevel,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notes,
                maxLines: 2,
                decoration: InputDecoration(labelText: l10n.note, border: const OutlineInputBorder()),
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
    final existing = widget.item;
    final item = HomeItem(
      id: existing?.id ?? const Uuid().v4(),
      name: _name.text.trim(),
      category: _category.text.trim(),
      location: _location.text.trim(),
      quantity: _parse(_quantity.text),
      unit: _unit.text.trim(),
      reorderLevel: _reorder.text.trim().isEmpty ? null : _parse(_reorder.text),
      notes: _notes.text.trim(),
      lastPurchasedAt: existing?.lastPurchasedAt,
    );
    try {
      await ref.read(repositoryProvider).saveHomeItem(item);
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
    return double.tryParse(normalized) ?? 0;
  }

  static String _number(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : value.toString();
}

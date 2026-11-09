import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/l10n.dart';
import '../../../models/home_item.dart';
import '../../../models/search_results.dart';
import '../../../state/providers.dart';
import '../../../widgets/entry_widgets.dart';
import '../../home_inventory/pages/home_inventory_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;
  Future<SearchResults>? _results;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _changed(String value) {
    _debounce?.cancel();
    final term = value.trim();
    setState(() {
      _query = term;
      if (term.isEmpty) _results = null;
    });
    if (term.isEmpty) return;
    _debounce = Timer(const Duration(milliseconds: 250), () => _run(term));
  }

  void _run(String term) {
    setState(() {
      _results = ref.read(repositoryProvider).search(term);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          focusNode: _focus,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(hintText: l10n.searchHint, border: InputBorder.none),
          onChanged: _changed,
          onSubmitted: (value) {
            _debounce?.cancel();
            if (value.trim().isNotEmpty) _run(value.trim());
          },
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              tooltip: l10n.cancel,
              onPressed: () {
                _controller.clear();
                _changed('');
                _focus.requestFocus();
              },
              icon: const Icon(Icons.close),
            ),
        ],
      ),
      body: _query.isEmpty
          ? _Prompt(text: l10n.searchPrompt)
          : FutureBuilder<SearchResults>(
              future: _results,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return _Prompt(text: '${snapshot.error}');
                }
                final results = snapshot.data;
                if (results == null) return const SizedBox.shrink();
                if (results.isEmpty) return _Prompt(text: l10n.searchNoResults(_query));
                return _Results(results: results);
              },
            ),
    );
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, size: 40, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({required this.results});

  final SearchResults results;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spaces = ref.watch(spacesProvider).value ?? fallbackSpaces;
    final viewerTimeZone = ref.watch(deviceTimeZoneProvider);
    final today = localDateAt(ref.watch(nowProvider), viewerTimeZone);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        if (results.entries.isNotEmpty) ...[
          _SectionHeader(l10n.searchEntries),
          for (final entry in results.entries)
            EntryTile(
              occurrence: EntryOccurrence(
                date: entry.date ?? today,
                displayDate: entry.date == null ? today : entry.displayDateIn(viewerTimeZone),
                entry: entry,
                completed: entry.status == EntryStatus.done,
                startAt: entry.startAt,
                endAt: entry.endAt,
              ),
              spaces: spaces,
            ),
        ],
        if (results.homeItems.isNotEmpty) ...[
          _SectionHeader(l10n.searchHomeItems),
          for (final item in results.homeItems) _HomeTile(item: item),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  const _HomeTile({required this.item});

  final HomeItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final details = [
      if (item.category.isNotEmpty) item.category,
      if (item.location.isNotEmpty) item.location,
      '${_quantity(item.quantity)}${item.unit.isEmpty ? '' : ' ${item.unit}'}',
    ];
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: const Icon(Icons.inventory_2_outlined),
      title: Text(item.name),
      subtitle: Text(details.join(' · '), maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: item.isLowStock
          ? Chip(
              label: Text(context.l10n.lowStock),
              labelStyle: theme.textTheme.labelSmall,
              visualDensity: VisualDensity.compact,
            )
          : null,
      onTap: () =>
          Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const HomeInventoryPage())),
    );
  }

  static String _quantity(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : value.toStringAsFixed(2);
}

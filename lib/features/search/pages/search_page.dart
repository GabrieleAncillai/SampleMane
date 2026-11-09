import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mane_core/mane_core.dart';

import '../../../core/i18n/l10n.dart';
import '../../../core/widgets/ui_kit.dart';
import '../../../models/home_item.dart';
import '../../../models/search_results.dart';
import '../../../state/providers.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
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
    return ManePage(
      title: l10n.search,
      child: Column(
        children: [
          ManeSearchField(
            controller: _controller,
            focusNode: _focus,
            autofocus: true,
            hint: l10n.searchHint,
            onChanged: _changed,
            onSubmitted: (value) {
              _debounce?.cancel();
              if (value.trim().isNotEmpty) _run(value.trim());
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _query.isEmpty
                ? AppEmptyState(icon: Icons.search, title: l10n.search, message: l10n.searchPrompt)
                : FutureBuilder<SearchResults>(
                    future: _results,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return AppEmptyState(
                          icon: Icons.error_outline,
                          title: l10n.search,
                          message: '${snapshot.error}',
                        );
                      }
                      final results = snapshot.data;
                      if (results == null) return const SizedBox.shrink();
                      if (results.isEmpty) {
                        return AppEmptyState(
                          icon: Icons.search_off,
                          title: l10n.searchNoResults(_query),
                          message: l10n.searchPrompt,
                        );
                      }
                      return _Results(results: results);
                    },
                  ),
          ),
        ],
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
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        if (results.entries.isNotEmpty) ...[
          SectionLabel(l10n.searchEntries),
          SoftCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            clip: true,
            child: Column(
              children: [
                for (var index = 0; index < results.entries.length; index++) ...[
                  if (index > 0) const Divider(height: 1, indent: 44),
                  EntryTile(
                    occurrence: EntryOccurrence(
                      date: results.entries[index].date ?? today,
                      displayDate: results.entries[index].date == null
                          ? today
                          : results.entries[index].displayDateIn(viewerTimeZone),
                      entry: results.entries[index],
                      completed: results.entries[index].status == EntryStatus.done,
                      startAt: results.entries[index].startAt,
                      endAt: results.entries[index].endAt,
                    ),
                    spaces: spaces,
                  ),
                ],
              ],
            ),
          ),
        ],
        if (results.homeItems.isNotEmpty) ...[
          const SizedBox(height: 18),
          SectionLabel(l10n.searchHomeItems),
          SoftCard(
            padding: const EdgeInsets.symmetric(vertical: 4),
            clip: true,
            child: Column(
              children: [
                for (var index = 0; index < results.homeItems.length; index++) ...[
                  if (index > 0) const Divider(height: 1, indent: 52),
                  _HomeTile(item: results.homeItems[index]),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _HomeTile extends StatelessWidget {
  const _HomeTile({required this.item});

  final HomeItem item;

  @override
  Widget build(BuildContext context) {
    final c = context.mc;
    final details = [
      if (item.category.isNotEmpty) item.category,
      if (item.location.isNotEmpty) item.location,
      '${_quantity(item.quantity)}${item.unit.isEmpty ? '' : ' ${item.unit}'}',
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
      child: Row(
        children: [
          Expanded(
            child: Pressable(
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute<void>(builder: (_) => const HomeInventoryPage())),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: c.homeSoft, borderRadius: BorderRadius.circular(11)),
                    child: Icon(Icons.inventory_2_outlined, size: 19, color: c.home),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ManeType.body(14, weight: FontWeight.w700, color: c.text),
                          ),
                          Text(
                            details.join(' · '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ManeType.body(11.5, color: c.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (item.isLowStock)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: c.dangerSoft, borderRadius: BorderRadius.circular(8)),
              child: Text(context.l10n.lowStock, style: ManeType.label(10, color: c.danger)),
            ),
        ],
      ),
    );
  }

  static String _quantity(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : value.toStringAsFixed(2);
}

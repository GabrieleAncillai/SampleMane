import 'package:mane_core/mane_core.dart';

import 'home_item.dart';

/// Results for the global search. Entries and household items are returned
/// separately so the UI can group them without guessing from titles.
class SearchResults {
  const SearchResults({required this.entries, required this.homeItems});

  final List<Entry> entries;
  final List<HomeItem> homeItems;

  bool get isEmpty => entries.isEmpty && homeItems.isEmpty;
}

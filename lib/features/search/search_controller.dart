import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../data/models/search_query.dart';
import '../../data/repositories/providers.dart';

/// Holds the live search query the UI edits. Results derive from it.
class SearchQueryNotifier extends Notifier<SearchQuery> {
  @override
  SearchQuery build() => const SearchQuery();

  void setText(String text) => state = state.copyWith(text: text);

  void toggleType(String type) {
    final next = {...state.docTypes};
    next.contains(type) ? next.remove(type) : next.add(type);
    state = state.copyWith(docTypes: next);
  }

  void toggleTag(String uid) {
    final next = {...state.tagUids};
    next.contains(uid) ? next.remove(uid) : next.add(uid);
    state = state.copyWith(tagUids: next);
  }

  void setDateRange(int? fromMs, int? toMs) =>
      state = state.copyWith(createdFromMs: fromMs, createdToMs: toMs);

  void load(SearchQuery query) => state = query;

  void clear() => state = const SearchQuery();
}

final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, SearchQuery>(
  SearchQueryNotifier.new,
);

/// Search results for the current query. Empty query yields no results (the UI
/// shows a prompt instead).
final searchResultsProvider = FutureProvider.autoDispose<List<Document>>(
  (ref) async {
    final query = ref.watch(searchQueryProvider);
    if (query.isEmpty) return const [];
    return ref.watch(searchRepositoryProvider).search(query);
  },
);

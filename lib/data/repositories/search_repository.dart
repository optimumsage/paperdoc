import 'package:drift/drift.dart';

import '../db/app_database.dart';
import '../models/search_query.dart';

/// Runs searches against the catalog. Free-text goes through the FTS5 index
/// (`documents_fts`); facets (type, tags, category, date) are SQL filters on
/// `documents`. Results exclude trashed documents.
class SearchRepository {
  SearchRepository(this._db);

  final AppDatabase _db;

  Future<List<Document>> search(SearchQuery query) async {
    // 1) Free-text → ordered list of matching uids via FTS.
    List<String>? ftsUids;
    final match = _ftsMatch(query.text);
    if (match != null) {
      final rows = await _db.customSelect(
        'SELECT uid FROM documents_fts WHERE documents_fts MATCH ? '
        'ORDER BY rank',
        variables: [Variable<String>(match)],
      ).get();
      ftsUids = rows.map((r) => r.read<String>('uid')).toList();
      if (ftsUids.isEmpty) return const [];
    }

    // 2) Tag facet → set of document uids carrying any of the tags.
    Set<String>? tagDocUids;
    if (query.tagUids.isNotEmpty) {
      final rows = await (_db.select(_db.documentTags)
            ..where((t) =>
                t.tagUid.isIn(query.tagUids.toList()) &
                t.deleted.equals(false)))
          .get();
      tagDocUids = rows.map((r) => r.documentUid).toSet();
      if (tagDocUids.isEmpty) return const [];
    }

    // 3) Structured query on documents.
    final select = _db.select(_db.documents)
      ..where((t) {
        var cond = t.deleted.equals(false);
        if (ftsUids != null) cond = cond & t.uid.isIn(ftsUids);
        if (tagDocUids != null) cond = cond & t.uid.isIn(tagDocUids.toList());
        if (query.docTypes.isNotEmpty) {
          cond = cond & t.docType.isIn(query.docTypes.toList());
        }
        if (query.categoryUid != null) {
          cond = cond & t.categoryUid.equals(query.categoryUid!);
        }
        if (query.createdFromMs != null) {
          cond = cond & t.createdAt.isBiggerOrEqualValue(query.createdFromMs!);
        }
        if (query.createdToMs != null) {
          cond = cond & t.createdAt.isSmallerOrEqualValue(query.createdToMs!);
        }
        return cond;
      });

    if (ftsUids == null) {
      select.orderBy([
        (t) =>
            OrderingTerm(expression: t.importedAt, mode: OrderingMode.desc),
      ]);
    }

    final docs = await select.get();

    // Preserve FTS relevance ordering (isIn loses it).
    if (ftsUids != null) {
      final rank = {for (var i = 0; i < ftsUids.length; i++) ftsUids[i]: i};
      docs.sort((a, b) =>
          (rank[a.uid] ?? 1 << 30).compareTo(rank[b.uid] ?? 1 << 30));
    }
    return docs;
  }

  /// Builds a safe FTS5 MATCH expression: word-character tokens turned into
  /// prefix queries joined by AND. Returns null when there's nothing to match
  /// (so the caller skips the text filter entirely).
  String? _ftsMatch(String text) {
    final terms = RegExp(r'\w+')
        .allMatches(text.toLowerCase())
        .map((m) => '${m.group(0)}*')
        .toList();
    if (terms.isEmpty) return null;
    return terms.join(' ');
  }
}

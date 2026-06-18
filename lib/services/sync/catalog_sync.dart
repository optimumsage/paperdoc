import 'package:drift/drift.dart';

import '../../data/db/app_database.dart';

/// Syncs the organizational catalog — folders, categories, tags, labels, and
/// each document's organization (title, folder, category, tags, labels) — as a
/// per-device JSON snapshot. Everything is keyed by stable uid and merged
/// last-writer-wins by `updatedAt`, so renames, moves, recolors, tag changes,
/// and deletes (tombstones) propagate — independent of whether a document's
/// file bytes changed. Blob contents sync separately via the reconciler.
class CatalogSync {
  CatalogSync(this._db);

  final AppDatabase _db;

  Future<Map<String, dynamic>> exportLocal() async {
    final folders = await _db.select(_db.folders).get();
    final categories = await _db.select(_db.categories).get();
    final tags = await _db.select(_db.tags).get();
    final labels = await _db.select(_db.labels).get();
    final documents = await _db.select(_db.documents).get();

    final docMaps = <Map<String, dynamic>>[];
    for (final d in documents) {
      final tagUids = (await (_db.select(_db.documentTags)
                ..where((t) =>
                    t.documentUid.equals(d.uid) & t.deleted.equals(false)))
              .get())
          .map((r) => r.tagUid)
          .toList();
      final labelUids = (await (_db.select(_db.documentLabels)
                ..where((t) =>
                    t.documentUid.equals(d.uid) & t.deleted.equals(false)))
              .get())
          .map((r) => r.labelUid)
          .toList();
      docMaps.add({
        'uid': d.uid,
        'title': d.title,
        'folderUid': d.folderUid,
        'categoryUid': d.categoryUid,
        'starred': d.starred,
        'updatedAt': d.updatedAt,
        'deleted': d.deleted,
        'tagUids': tagUids,
        'labelUids': labelUids,
      });
    }

    return {
      'folders': [
        for (final f in folders)
          {
            'uid': f.uid,
            'parentUid': f.parentUid,
            'name': f.name,
            'color': f.color,
            'sortOrder': f.sortOrder,
            'createdAt': f.createdAt,
            'updatedAt': f.updatedAt,
            'deleted': f.deleted,
          }
      ],
      'categories': [
        for (final c in categories)
          {
            'uid': c.uid,
            'name': c.name,
            'icon': c.icon,
            'color': c.color,
            'createdAt': c.createdAt,
            'updatedAt': c.updatedAt,
            'deleted': c.deleted,
          }
      ],
      'tags': [
        for (final t in tags)
          {
            'uid': t.uid,
            'name': t.name,
            'color': t.color,
            'createdAt': t.createdAt,
            'updatedAt': t.updatedAt,
            'deleted': t.deleted,
          }
      ],
      'labels': [
        for (final l in labels)
          {
            'uid': l.uid,
            'name': l.name,
            'color': l.color,
            'kind': l.kind,
            'createdAt': l.createdAt,
            'updatedAt': l.updatedAt,
            'deleted': l.deleted,
          }
      ],
      'documents': docMaps,
    };
  }

  /// Merges folders/categories/tags/labels. Call before blob sync so entities
  /// exist for documents that reference them.
  Future<void> mergeEntities(Map<String, dynamic> snapshot) async {
    for (final m in (snapshot['folders'] as List? ?? const [])) {
      await _mergeFolder((m as Map).cast<String, dynamic>());
    }
    for (final m in (snapshot['categories'] as List? ?? const [])) {
      await _mergeCategory((m as Map).cast<String, dynamic>());
    }
    for (final m in (snapshot['tags'] as List? ?? const [])) {
      await _mergeTag((m as Map).cast<String, dynamic>());
    }
    for (final m in (snapshot['labels'] as List? ?? const [])) {
      await _mergeLabel((m as Map).cast<String, dynamic>());
    }
  }

  /// Merges per-document organization (title/folder/category/tags). Call after
  /// blob sync so the document rows exist. Only updates rows that are present
  /// locally and only when the remote copy is newer (LWW).
  Future<void> mergeDocuments(Map<String, dynamic> snapshot) async {
    for (final raw in (snapshot['documents'] as List? ?? const [])) {
      final m = (raw as Map).cast<String, dynamic>();
      final uid = m['uid'] as String;
      final updatedAt = m['updatedAt'] as int? ?? 0;
      final existing = await (_db.select(_db.documents)
            ..where((t) => t.uid.equals(uid)))
          .getSingleOrNull();
      if (existing == null || updatedAt <= existing.updatedAt) continue;

      await (_db.update(_db.documents)..where((t) => t.uid.equals(uid)))
          .write(DocumentsCompanion(
        title: Value(m['title'] as String? ?? existing.title),
        folderUid: Value(m['folderUid'] as String?),
        categoryUid: Value(m['categoryUid'] as String?),
        starred: Value(m['starred'] as bool? ?? existing.starred),
        deleted: Value(m['deleted'] as bool? ?? existing.deleted),
        updatedAt: Value(updatedAt),
      ));
      await _replaceLinks(
          uid, (m['tagUids'] as List?)?.cast<String>() ?? const [], isTag: true);
      await _replaceLinks(uid,
          (m['labelUids'] as List?)?.cast<String>() ?? const [],
          isTag: false);
    }
  }

  /// Sets a document's tag/label set to exactly [uids] (the LWW winner).
  Future<void> _replaceLinks(String docUid, List<String> uids,
      {required bool isTag}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (isTag) {
      await (_db.update(_db.documentTags)
            ..where((t) => t.documentUid.equals(docUid)))
          .write(DocumentTagsCompanion(deleted: const Value(true), updatedAt: Value(now)));
      for (final tagUid in uids) {
        await _db.into(_db.documentTags).insertOnConflictUpdate(
            DocumentTagsCompanion.insert(
                documentUid: docUid,
                tagUid: tagUid,
                createdAt: now,
                updatedAt: now,
                deleted: const Value(false)));
      }
    } else {
      await (_db.update(_db.documentLabels)
            ..where((t) => t.documentUid.equals(docUid)))
          .write(DocumentLabelsCompanion(
              deleted: const Value(true), updatedAt: Value(now)));
      for (final labelUid in uids) {
        await _db.into(_db.documentLabels).insertOnConflictUpdate(
            DocumentLabelsCompanion.insert(
                documentUid: docUid,
                labelUid: labelUid,
                createdAt: now,
                updatedAt: now,
                deleted: const Value(false)));
      }
    }
  }

  Future<void> _mergeFolder(Map<String, dynamic> m) async {
    final uid = m['uid'] as String;
    final updatedAt = m['updatedAt'] as int? ?? 0;
    final existing =
        await (_db.select(_db.folders)..where((t) => t.uid.equals(uid)))
            .getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.folders).insert(FoldersCompanion.insert(
            uid: uid,
            name: m['name'] as String? ?? '',
            createdAt: m['createdAt'] as int? ?? updatedAt,
            updatedAt: updatedAt,
            parentUid: Value(m['parentUid'] as String?),
            color: Value(m['color'] as String?),
            sortOrder: Value(m['sortOrder'] as int? ?? 0),
            deleted: Value(m['deleted'] as bool? ?? false),
          ));
    } else if (updatedAt > existing.updatedAt) {
      await (_db.update(_db.folders)..where((t) => t.uid.equals(uid)))
          .write(FoldersCompanion(
        name: Value(m['name'] as String? ?? existing.name),
        parentUid: Value(m['parentUid'] as String?),
        color: Value(m['color'] as String?),
        sortOrder: Value(m['sortOrder'] as int? ?? existing.sortOrder),
        updatedAt: Value(updatedAt),
        deleted: Value(m['deleted'] as bool? ?? false),
      ));
    }
  }

  Future<void> _mergeCategory(Map<String, dynamic> m) async {
    final uid = m['uid'] as String;
    final updatedAt = m['updatedAt'] as int? ?? 0;
    final existing =
        await (_db.select(_db.categories)..where((t) => t.uid.equals(uid)))
            .getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.categories).insert(CategoriesCompanion.insert(
            uid: uid,
            name: m['name'] as String? ?? '',
            createdAt: m['createdAt'] as int? ?? updatedAt,
            updatedAt: updatedAt,
            icon: Value(m['icon'] as String?),
            color: Value(m['color'] as String?),
            deleted: Value(m['deleted'] as bool? ?? false),
          ));
    } else if (updatedAt > existing.updatedAt) {
      await (_db.update(_db.categories)..where((t) => t.uid.equals(uid)))
          .write(CategoriesCompanion(
        name: Value(m['name'] as String? ?? existing.name),
        icon: Value(m['icon'] as String?),
        color: Value(m['color'] as String?),
        updatedAt: Value(updatedAt),
        deleted: Value(m['deleted'] as bool? ?? false),
      ));
    }
  }

  Future<void> _mergeTag(Map<String, dynamic> m) async {
    final uid = m['uid'] as String;
    final updatedAt = m['updatedAt'] as int? ?? 0;
    final existing =
        await (_db.select(_db.tags)..where((t) => t.uid.equals(uid)))
            .getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.tags).insert(TagsCompanion.insert(
            uid: uid,
            name: m['name'] as String? ?? '',
            createdAt: m['createdAt'] as int? ?? updatedAt,
            updatedAt: updatedAt,
            color: Value(m['color'] as String?),
            deleted: Value(m['deleted'] as bool? ?? false),
          ));
    } else if (updatedAt > existing.updatedAt) {
      await (_db.update(_db.tags)..where((t) => t.uid.equals(uid)))
          .write(TagsCompanion(
        name: Value(m['name'] as String? ?? existing.name),
        color: Value(m['color'] as String?),
        updatedAt: Value(updatedAt),
        deleted: Value(m['deleted'] as bool? ?? false),
      ));
    }
  }

  Future<void> _mergeLabel(Map<String, dynamic> m) async {
    final uid = m['uid'] as String;
    final updatedAt = m['updatedAt'] as int? ?? 0;
    final existing =
        await (_db.select(_db.labels)..where((t) => t.uid.equals(uid)))
            .getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.labels).insert(LabelsCompanion.insert(
            uid: uid,
            name: m['name'] as String? ?? '',
            createdAt: m['createdAt'] as int? ?? updatedAt,
            updatedAt: updatedAt,
            color: Value(m['color'] as String?),
            kind: Value(m['kind'] as String?),
            deleted: Value(m['deleted'] as bool? ?? false),
          ));
    } else if (updatedAt > existing.updatedAt) {
      await (_db.update(_db.labels)..where((t) => t.uid.equals(uid)))
          .write(LabelsCompanion(
        name: Value(m['name'] as String? ?? existing.name),
        color: Value(m['color'] as String?),
        kind: Value(m['kind'] as String?),
        updatedAt: Value(updatedAt),
        deleted: Value(m['deleted'] as bool? ?? false),
      ));
    }
  }
}

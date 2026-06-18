import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../data/repositories/document_repository.dart';
import '../../data/repositories/providers.dart';

/// Loads the configured library root from settings and lets the first-run flow
/// set it. The UI gates on this: null → setup screen, a path → browser.
class LibraryRootNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() => ref.watch(libraryServiceProvider).currentRoot();

  Future<void> choose(String path) async {
    await ref.read(libraryServiceProvider).setRoot(path);
    state = AsyncData(path);
  }
}

final currentLibraryRootProvider =
    AsyncNotifierProvider<LibraryRootNotifier, String?>(
  LibraryRootNotifier.new,
);

/// The current browser scope: a specific folder, all documents, or unfiled.
enum BrowseScope { all, unfiled, folder }

class FolderSelection {
  const FolderSelection(this.scope, [this.folderUid]);
  const FolderSelection.all() : this(BrowseScope.all, null);
  const FolderSelection.unfiled() : this(BrowseScope.unfiled, null);

  final BrowseScope scope;
  final String? folderUid;

  @override
  bool operator ==(Object other) =>
      other is FolderSelection &&
      other.scope == scope &&
      other.folderUid == folderUid;

  @override
  int get hashCode => Object.hash(scope, folderUid);
}

class FolderSelectionNotifier extends Notifier<FolderSelection> {
  @override
  FolderSelection build() => const FolderSelection.all();

  void set(FolderSelection selection) => state = selection;
}

final folderSelectionProvider =
    NotifierProvider<FolderSelectionNotifier, FolderSelection>(
  FolderSelectionNotifier.new,
);

/// The folder new imports should land in for the current selection. Only a
/// concrete folder scope files imports; All/Unfiled leave them unfiled.
String? importFolderForSelection(FolderSelection selection) =>
    selection.scope == BrowseScope.folder ? selection.folderUid : null;

/// Grid vs list presentation of the document area.
enum DocumentViewMode { grid, list }

class DocumentViewModeNotifier extends Notifier<DocumentViewMode> {
  @override
  DocumentViewMode build() => DocumentViewMode.grid;

  void toggle() => state = state == DocumentViewMode.grid
      ? DocumentViewMode.list
      : DocumentViewMode.grid;
}

final documentViewModeProvider =
    NotifierProvider<DocumentViewModeNotifier, DocumentViewMode>(
  DocumentViewModeNotifier.new,
);

class DocumentSortNotifier extends Notifier<DocumentSort> {
  @override
  DocumentSort build() => DocumentSort.recent;

  void set(DocumentSort sort) => state = sort;
}

final documentSortProvider =
    NotifierProvider<DocumentSortNotifier, DocumentSort>(
  DocumentSortNotifier.new,
);

/// Documents shown for the active selection, in the chosen sort order.
final visibleDocumentsProvider = StreamProvider.autoDispose<List<Document>>(
  (ref) {
    final selection = ref.watch(folderSelectionProvider);
    final sort = ref.watch(documentSortProvider);
    final repo = ref.watch(documentRepositoryProvider);
    return switch (selection.scope) {
      BrowseScope.all => repo.watchAll(sort: sort),
      BrowseScope.unfiled => repo.watchInFolder(null, sort: sort),
      BrowseScope.folder => repo.watchInFolder(selection.folderUid, sort: sort),
    };
  },
);

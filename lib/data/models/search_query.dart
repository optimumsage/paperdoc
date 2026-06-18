import 'dart:convert';

import 'package:collection/collection.dart';

const _setEq = SetEquality<String>();
const _sentinel = Object();

/// A search request: free-text plus structured facets. Serializes to JSON so a
/// query can be persisted as a smart folder.
class SearchQuery {
  const SearchQuery({
    this.text = '',
    this.docTypes = const {},
    this.tagUids = const {},
    this.categoryUid,
    this.createdFromMs,
    this.createdToMs,
  });

  final String text;
  final Set<String> docTypes;
  final Set<String> tagUids;
  final String? categoryUid;
  final int? createdFromMs;
  final int? createdToMs;

  bool get isEmpty =>
      text.trim().isEmpty &&
      docTypes.isEmpty &&
      tagUids.isEmpty &&
      categoryUid == null &&
      createdFromMs == null &&
      createdToMs == null;

  SearchQuery copyWith({
    String? text,
    Set<String>? docTypes,
    Set<String>? tagUids,
    Object? categoryUid = _sentinel,
    Object? createdFromMs = _sentinel,
    Object? createdToMs = _sentinel,
  }) {
    return SearchQuery(
      text: text ?? this.text,
      docTypes: docTypes ?? this.docTypes,
      tagUids: tagUids ?? this.tagUids,
      categoryUid: categoryUid == _sentinel
          ? this.categoryUid
          : categoryUid as String?,
      createdFromMs: createdFromMs == _sentinel
          ? this.createdFromMs
          : createdFromMs as int?,
      createdToMs:
          createdToMs == _sentinel ? this.createdToMs : createdToMs as int?,
    );
  }

  Map<String, dynamic> toMap() => {
        'text': text,
        'docTypes': docTypes.toList()..sort(),
        'tagUids': tagUids.toList()..sort(),
        'categoryUid': categoryUid,
        'createdFromMs': createdFromMs,
        'createdToMs': createdToMs,
      };

  String toJson() => jsonEncode(toMap());

  factory SearchQuery.fromMap(Map<String, dynamic> map) => SearchQuery(
        text: map['text'] as String? ?? '',
        docTypes:
            ((map['docTypes'] as List?)?.cast<String>() ?? const []).toSet(),
        tagUids:
            ((map['tagUids'] as List?)?.cast<String>() ?? const []).toSet(),
        categoryUid: map['categoryUid'] as String?,
        createdFromMs: map['createdFromMs'] as int?,
        createdToMs: map['createdToMs'] as int?,
      );

  factory SearchQuery.fromJson(String source) =>
      SearchQuery.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) =>
      other is SearchQuery &&
      other.text == text &&
      other.categoryUid == categoryUid &&
      other.createdFromMs == createdFromMs &&
      other.createdToMs == createdToMs &&
      _setEq.equals(other.docTypes, docTypes) &&
      _setEq.equals(other.tagUids, tagUids);

  @override
  int get hashCode => Object.hash(
        text,
        categoryUid,
        createdFromMs,
        createdToMs,
        Object.hashAllUnordered(docTypes),
        Object.hashAllUnordered(tagUids),
      );
}

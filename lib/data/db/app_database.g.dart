// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String? value;
  const AppSetting({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  AppSetting copyWith({
    String? key,
    Value<String?> value = const Value.absent(),
  }) => AppSetting(
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String?> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String?>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FoldersTable extends Folders with TableInfo<$FoldersTable, Folder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoldersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _parentUidMeta = const VerificationMeta(
    'parentUid',
  );
  @override
  late final GeneratedColumn<String> parentUid = GeneratedColumn<String>(
    'parent_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    uid,
    createdAt,
    updatedAt,
    deleted,
    revision,
    id,
    parentUid,
    name,
    color,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Folder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parent_uid')) {
      context.handle(
        _parentUidMeta,
        parentUid.isAcceptableOrUnknown(data['parent_uid']!, _parentUidMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Folder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Folder(
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      parentUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_uid'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(attachedDatabase, alias);
  }
}

class Folder extends DataClass implements Insertable<Folder> {
  final String uid;
  final int createdAt;
  final int updatedAt;
  final bool deleted;
  final int revision;
  final int id;
  final String? parentUid;
  final String name;
  final String? color;
  final int sortOrder;
  const Folder({
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    required this.revision,
    required this.id,
    this.parentUid,
    required this.name,
    this.color,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['revision'] = Variable<int>(revision);
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || parentUid != null) {
      map['parent_uid'] = Variable<String>(parentUid);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      uid: Value(uid),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      revision: Value(revision),
      id: Value(id),
      parentUid: parentUid == null && nullToAbsent
          ? const Value.absent()
          : Value(parentUid),
      name: Value(name),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      sortOrder: Value(sortOrder),
    );
  }

  factory Folder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Folder(
      uid: serializer.fromJson<String>(json['uid']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      revision: serializer.fromJson<int>(json['revision']),
      id: serializer.fromJson<int>(json['id']),
      parentUid: serializer.fromJson<String?>(json['parentUid']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String?>(json['color']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'revision': serializer.toJson<int>(revision),
      'id': serializer.toJson<int>(id),
      'parentUid': serializer.toJson<String?>(parentUid),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String?>(color),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Folder copyWith({
    String? uid,
    int? createdAt,
    int? updatedAt,
    bool? deleted,
    int? revision,
    int? id,
    Value<String?> parentUid = const Value.absent(),
    String? name,
    Value<String?> color = const Value.absent(),
    int? sortOrder,
  }) => Folder(
    uid: uid ?? this.uid,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    revision: revision ?? this.revision,
    id: id ?? this.id,
    parentUid: parentUid.present ? parentUid.value : this.parentUid,
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Folder copyWithCompanion(FoldersCompanion data) {
    return Folder(
      uid: data.uid.present ? data.uid.value : this.uid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      revision: data.revision.present ? data.revision.value : this.revision,
      id: data.id.present ? data.id.value : this.id,
      parentUid: data.parentUid.present ? data.parentUid.value : this.parentUid,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Folder(')
          ..write('uid: $uid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('revision: $revision, ')
          ..write('id: $id, ')
          ..write('parentUid: $parentUid, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uid,
    createdAt,
    updatedAt,
    deleted,
    revision,
    id,
    parentUid,
    name,
    color,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Folder &&
          other.uid == this.uid &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.revision == this.revision &&
          other.id == this.id &&
          other.parentUid == this.parentUid &&
          other.name == this.name &&
          other.color == this.color &&
          other.sortOrder == this.sortOrder);
}

class FoldersCompanion extends UpdateCompanion<Folder> {
  final Value<String> uid;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> revision;
  final Value<int> id;
  final Value<String?> parentUid;
  final Value<String> name;
  final Value<String?> color;
  final Value<int> sortOrder;
  const FoldersCompanion({
    this.uid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.revision = const Value.absent(),
    this.id = const Value.absent(),
    this.parentUid = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  FoldersCompanion.insert({
    required String uid,
    required int createdAt,
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.revision = const Value.absent(),
    this.id = const Value.absent(),
    this.parentUid = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : uid = Value(uid),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name);
  static Insertable<Folder> custom({
    Expression<String>? uid,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? revision,
    Expression<int>? id,
    Expression<String>? parentUid,
    Expression<String>? name,
    Expression<String>? color,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (revision != null) 'revision': revision,
      if (id != null) 'id': id,
      if (parentUid != null) 'parent_uid': parentUid,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  FoldersCompanion copyWith({
    Value<String>? uid,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? revision,
    Value<int>? id,
    Value<String?>? parentUid,
    Value<String>? name,
    Value<String?>? color,
    Value<int>? sortOrder,
  }) {
    return FoldersCompanion(
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      revision: revision ?? this.revision,
      id: id ?? this.id,
      parentUid: parentUid ?? this.parentUid,
      name: name ?? this.name,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (parentUid.present) {
      map['parent_uid'] = Variable<String>(parentUid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('uid: $uid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('revision: $revision, ')
          ..write('id: $id, ')
          ..write('parentUid: $parentUid, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uid,
    createdAt,
    updatedAt,
    deleted,
    revision,
    id,
    name,
    icon,
    color,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String uid;
  final int createdAt;
  final int updatedAt;
  final bool deleted;
  final int revision;
  final int id;
  final String name;
  final String? icon;
  final String? color;
  const Category({
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    required this.revision,
    required this.id,
    required this.name,
    this.icon,
    this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['revision'] = Variable<int>(revision);
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      uid: Value(uid),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      revision: Value(revision),
      id: Value(id),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      uid: serializer.fromJson<String>(json['uid']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      revision: serializer.fromJson<int>(json['revision']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'revision': serializer.toJson<int>(revision),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<String?>(color),
    };
  }

  Category copyWith({
    String? uid,
    int? createdAt,
    int? updatedAt,
    bool? deleted,
    int? revision,
    int? id,
    String? name,
    Value<String?> icon = const Value.absent(),
    Value<String?> color = const Value.absent(),
  }) => Category(
    uid: uid ?? this.uid,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    revision: revision ?? this.revision,
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon.present ? icon.value : this.icon,
    color: color.present ? color.value : this.color,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      uid: data.uid.present ? data.uid.value : this.uid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      revision: data.revision.present ? data.revision.value : this.revision,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('uid: $uid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('revision: $revision, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uid,
    createdAt,
    updatedAt,
    deleted,
    revision,
    id,
    name,
    icon,
    color,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.uid == this.uid &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.revision == this.revision &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> uid;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> revision;
  final Value<int> id;
  final Value<String> name;
  final Value<String?> icon;
  final Value<String?> color;
  const CategoriesCompanion({
    this.uid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.revision = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String uid,
    required int createdAt,
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.revision = const Value.absent(),
    this.id = const Value.absent(),
    required String name,
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
  }) : uid = Value(uid),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name);
  static Insertable<Category> custom({
    Expression<String>? uid,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? revision,
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? color,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (revision != null) 'revision': revision,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? uid,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? revision,
    Value<int>? id,
    Value<String>? name,
    Value<String?>? icon,
    Value<String?>? color,
  }) {
    return CategoriesCompanion(
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      revision: revision ?? this.revision,
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('uid: $uid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('revision: $revision, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uid,
    createdAt,
    updatedAt,
    deleted,
    revision,
    id,
    name,
    color,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String uid;
  final int createdAt;
  final int updatedAt;
  final bool deleted;
  final int revision;
  final int id;
  final String name;
  final String? color;
  const Tag({
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    required this.revision,
    required this.id,
    required this.name,
    this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['revision'] = Variable<int>(revision);
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      uid: Value(uid),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      revision: Value(revision),
      id: Value(id),
      name: Value(name),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      uid: serializer.fromJson<String>(json['uid']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      revision: serializer.fromJson<int>(json['revision']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'revision': serializer.toJson<int>(revision),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String?>(color),
    };
  }

  Tag copyWith({
    String? uid,
    int? createdAt,
    int? updatedAt,
    bool? deleted,
    int? revision,
    int? id,
    String? name,
    Value<String?> color = const Value.absent(),
  }) => Tag(
    uid: uid ?? this.uid,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    revision: revision ?? this.revision,
    id: id ?? this.id,
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      uid: data.uid.present ? data.uid.value : this.uid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      revision: data.revision.present ? data.revision.value : this.revision,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('uid: $uid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('revision: $revision, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uid,
    createdAt,
    updatedAt,
    deleted,
    revision,
    id,
    name,
    color,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.uid == this.uid &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.revision == this.revision &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> uid;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> revision;
  final Value<int> id;
  final Value<String> name;
  final Value<String?> color;
  const TagsCompanion({
    this.uid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.revision = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
  });
  TagsCompanion.insert({
    required String uid,
    required int createdAt,
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.revision = const Value.absent(),
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
  }) : uid = Value(uid),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name);
  static Insertable<Tag> custom({
    Expression<String>? uid,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? revision,
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? color,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (revision != null) 'revision': revision,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
    });
  }

  TagsCompanion copyWith({
    Value<String>? uid,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? revision,
    Value<int>? id,
    Value<String>? name,
    Value<String?>? color,
  }) {
    return TagsCompanion(
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      revision: revision ?? this.revision,
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('uid: $uid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('revision: $revision, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $LabelsTable extends Labels with TableInfo<$LabelsTable, Label> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uid,
    createdAt,
    updatedAt,
    deleted,
    revision,
    id,
    name,
    color,
    kind,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'labels';
  @override
  VerificationContext validateIntegrity(
    Insertable<Label> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Label map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Label(
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      ),
    );
  }

  @override
  $LabelsTable createAlias(String alias) {
    return $LabelsTable(attachedDatabase, alias);
  }
}

class Label extends DataClass implements Insertable<Label> {
  final String uid;
  final int createdAt;
  final int updatedAt;
  final bool deleted;
  final int revision;
  final int id;
  final String name;
  final String? color;

  /// e.g. 'status', 'priority' — lets the UI render constrained label sets
  /// differently from free-form tags.
  final String? kind;
  const Label({
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    required this.revision,
    required this.id,
    required this.name,
    this.color,
    this.kind,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['revision'] = Variable<int>(revision);
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || kind != null) {
      map['kind'] = Variable<String>(kind);
    }
    return map;
  }

  LabelsCompanion toCompanion(bool nullToAbsent) {
    return LabelsCompanion(
      uid: Value(uid),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      revision: Value(revision),
      id: Value(id),
      name: Value(name),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      kind: kind == null && nullToAbsent ? const Value.absent() : Value(kind),
    );
  }

  factory Label.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Label(
      uid: serializer.fromJson<String>(json['uid']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      revision: serializer.fromJson<int>(json['revision']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String?>(json['color']),
      kind: serializer.fromJson<String?>(json['kind']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'revision': serializer.toJson<int>(revision),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String?>(color),
      'kind': serializer.toJson<String?>(kind),
    };
  }

  Label copyWith({
    String? uid,
    int? createdAt,
    int? updatedAt,
    bool? deleted,
    int? revision,
    int? id,
    String? name,
    Value<String?> color = const Value.absent(),
    Value<String?> kind = const Value.absent(),
  }) => Label(
    uid: uid ?? this.uid,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    revision: revision ?? this.revision,
    id: id ?? this.id,
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
    kind: kind.present ? kind.value : this.kind,
  );
  Label copyWithCompanion(LabelsCompanion data) {
    return Label(
      uid: data.uid.present ? data.uid.value : this.uid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      revision: data.revision.present ? data.revision.value : this.revision,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      kind: data.kind.present ? data.kind.value : this.kind,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Label(')
          ..write('uid: $uid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('revision: $revision, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uid,
    createdAt,
    updatedAt,
    deleted,
    revision,
    id,
    name,
    color,
    kind,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Label &&
          other.uid == this.uid &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.revision == this.revision &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.kind == this.kind);
}

class LabelsCompanion extends UpdateCompanion<Label> {
  final Value<String> uid;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> revision;
  final Value<int> id;
  final Value<String> name;
  final Value<String?> color;
  final Value<String?> kind;
  const LabelsCompanion({
    this.uid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.revision = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.kind = const Value.absent(),
  });
  LabelsCompanion.insert({
    required String uid,
    required int createdAt,
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.revision = const Value.absent(),
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.kind = const Value.absent(),
  }) : uid = Value(uid),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name);
  static Insertable<Label> custom({
    Expression<String>? uid,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? revision,
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<String>? kind,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (revision != null) 'revision': revision,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (kind != null) 'kind': kind,
    });
  }

  LabelsCompanion copyWith({
    Value<String>? uid,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? revision,
    Value<int>? id,
    Value<String>? name,
    Value<String?>? color,
    Value<String?>? kind,
  }) {
    return LabelsCompanion(
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      revision: revision ?? this.revision,
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      kind: kind ?? this.kind,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabelsCompanion(')
          ..write('uid: $uid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('revision: $revision, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }
}

class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _folderUidMeta = const VerificationMeta(
    'folderUid',
  );
  @override
  late final GeneratedColumn<String> folderUid = GeneratedColumn<String>(
    'folder_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryUidMeta = const VerificationMeta(
    'categoryUid',
  );
  @override
  late final GeneratedColumn<String> categoryUid = GeneratedColumn<String>(
    'category_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalNameMeta = const VerificationMeta(
    'originalName',
  );
  @override
  late final GeneratedColumn<String> originalName = GeneratedColumn<String>(
    'original_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _extMeta = const VerificationMeta('ext');
  @override
  late final GeneratedColumn<String> ext = GeneratedColumn<String>(
    'ext',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mimeMeta = const VerificationMeta('mime');
  @override
  late final GeneratedColumn<String> mime = GeneratedColumn<String>(
    'mime',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _docTypeMeta = const VerificationMeta(
    'docType',
  );
  @override
  late final GeneratedColumn<String> docType = GeneratedColumn<String>(
    'doc_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
  );
  static const VerificationMeta _relPathMeta = const VerificationMeta(
    'relPath',
  );
  @override
  late final GeneratedColumn<String> relPath = GeneratedColumn<String>(
    'rel_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _encHashMeta = const VerificationMeta(
    'encHash',
  );
  @override
  late final GeneratedColumn<String> encHash = GeneratedColumn<String>(
    'enc_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isEncryptedMeta = const VerificationMeta(
    'isEncrypted',
  );
  @override
  late final GeneratedColumn<bool> isEncrypted = GeneratedColumn<bool>(
    'is_encrypted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_encrypted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ocrStatusMeta = const VerificationMeta(
    'ocrStatus',
  );
  @override
  late final GeneratedColumn<String> ocrStatus = GeneratedColumn<String>(
    'ocr_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _starredMeta = const VerificationMeta(
    'starred',
  );
  @override
  late final GeneratedColumn<bool> starred = GeneratedColumn<bool>(
    'starred',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("starred" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _importedAtMeta = const VerificationMeta(
    'importedAt',
  );
  @override
  late final GeneratedColumn<int> importedAt = GeneratedColumn<int>(
    'imported_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileMtimeMeta = const VerificationMeta(
    'fileMtime',
  );
  @override
  late final GeneratedColumn<int> fileMtime = GeneratedColumn<int>(
    'file_mtime',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uid,
    createdAt,
    updatedAt,
    deleted,
    revision,
    id,
    folderUid,
    categoryUid,
    title,
    originalName,
    ext,
    mime,
    docType,
    relPath,
    sizeBytes,
    contentHash,
    encHash,
    isEncrypted,
    ocrStatus,
    starred,
    importedAt,
    fileMtime,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<Document> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('folder_uid')) {
      context.handle(
        _folderUidMeta,
        folderUid.isAcceptableOrUnknown(data['folder_uid']!, _folderUidMeta),
      );
    }
    if (data.containsKey('category_uid')) {
      context.handle(
        _categoryUidMeta,
        categoryUid.isAcceptableOrUnknown(
          data['category_uid']!,
          _categoryUidMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('original_name')) {
      context.handle(
        _originalNameMeta,
        originalName.isAcceptableOrUnknown(
          data['original_name']!,
          _originalNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalNameMeta);
    }
    if (data.containsKey('ext')) {
      context.handle(
        _extMeta,
        ext.isAcceptableOrUnknown(data['ext']!, _extMeta),
      );
    }
    if (data.containsKey('mime')) {
      context.handle(
        _mimeMeta,
        mime.isAcceptableOrUnknown(data['mime']!, _mimeMeta),
      );
    }
    if (data.containsKey('doc_type')) {
      context.handle(
        _docTypeMeta,
        docType.isAcceptableOrUnknown(data['doc_type']!, _docTypeMeta),
      );
    }
    if (data.containsKey('rel_path')) {
      context.handle(
        _relPathMeta,
        relPath.isAcceptableOrUnknown(data['rel_path']!, _relPathMeta),
      );
    } else if (isInserting) {
      context.missing(_relPathMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentHashMeta);
    }
    if (data.containsKey('enc_hash')) {
      context.handle(
        _encHashMeta,
        encHash.isAcceptableOrUnknown(data['enc_hash']!, _encHashMeta),
      );
    }
    if (data.containsKey('is_encrypted')) {
      context.handle(
        _isEncryptedMeta,
        isEncrypted.isAcceptableOrUnknown(
          data['is_encrypted']!,
          _isEncryptedMeta,
        ),
      );
    }
    if (data.containsKey('ocr_status')) {
      context.handle(
        _ocrStatusMeta,
        ocrStatus.isAcceptableOrUnknown(data['ocr_status']!, _ocrStatusMeta),
      );
    }
    if (data.containsKey('starred')) {
      context.handle(
        _starredMeta,
        starred.isAcceptableOrUnknown(data['starred']!, _starredMeta),
      );
    }
    if (data.containsKey('imported_at')) {
      context.handle(
        _importedAtMeta,
        importedAt.isAcceptableOrUnknown(data['imported_at']!, _importedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    if (data.containsKey('file_mtime')) {
      context.handle(
        _fileMtimeMeta,
        fileMtime.isAcceptableOrUnknown(data['file_mtime']!, _fileMtimeMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Document(
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      folderUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folder_uid'],
      ),
      categoryUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_uid'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      originalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_name'],
      )!,
      ext: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ext'],
      ),
      mime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime'],
      ),
      docType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}doc_type'],
      )!,
      relPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rel_path'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      )!,
      encHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enc_hash'],
      ),
      isEncrypted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_encrypted'],
      )!,
      ocrStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ocr_status'],
      )!,
      starred: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}starred'],
      )!,
      importedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}imported_at'],
      )!,
      fileMtime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_mtime'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(attachedDatabase, alias);
  }
}

class Document extends DataClass implements Insertable<Document> {
  final String uid;
  final int createdAt;
  final int updatedAt;
  final bool deleted;
  final int revision;
  final int id;
  final String? folderUid;
  final String? categoryUid;
  final String title;
  final String originalName;
  final String? ext;
  final String? mime;

  /// Normalized bucket: pdf | image | office | archive | text | other.
  final String docType;

  /// Path under the library root, e.g. `files/ab/<uid>.pdf`.
  final String relPath;
  final int sizeBytes;

  /// sha256 of the plaintext bytes (stable identity for dedup).
  final String contentHash;

  /// sha256 of the on-disk (possibly encrypted) blob — what the cloud sees.
  final String? encHash;
  final bool isEncrypted;

  /// none | pending | running | done | failed | not_needed
  final String ocrStatus;
  final bool starred;
  final int importedAt;
  final int? fileMtime;
  final int? deletedAt;
  const Document({
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    required this.revision,
    required this.id,
    this.folderUid,
    this.categoryUid,
    required this.title,
    required this.originalName,
    this.ext,
    this.mime,
    required this.docType,
    required this.relPath,
    required this.sizeBytes,
    required this.contentHash,
    this.encHash,
    required this.isEncrypted,
    required this.ocrStatus,
    required this.starred,
    required this.importedAt,
    this.fileMtime,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['revision'] = Variable<int>(revision);
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || folderUid != null) {
      map['folder_uid'] = Variable<String>(folderUid);
    }
    if (!nullToAbsent || categoryUid != null) {
      map['category_uid'] = Variable<String>(categoryUid);
    }
    map['title'] = Variable<String>(title);
    map['original_name'] = Variable<String>(originalName);
    if (!nullToAbsent || ext != null) {
      map['ext'] = Variable<String>(ext);
    }
    if (!nullToAbsent || mime != null) {
      map['mime'] = Variable<String>(mime);
    }
    map['doc_type'] = Variable<String>(docType);
    map['rel_path'] = Variable<String>(relPath);
    map['size_bytes'] = Variable<int>(sizeBytes);
    map['content_hash'] = Variable<String>(contentHash);
    if (!nullToAbsent || encHash != null) {
      map['enc_hash'] = Variable<String>(encHash);
    }
    map['is_encrypted'] = Variable<bool>(isEncrypted);
    map['ocr_status'] = Variable<String>(ocrStatus);
    map['starred'] = Variable<bool>(starred);
    map['imported_at'] = Variable<int>(importedAt);
    if (!nullToAbsent || fileMtime != null) {
      map['file_mtime'] = Variable<int>(fileMtime);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      uid: Value(uid),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      revision: Value(revision),
      id: Value(id),
      folderUid: folderUid == null && nullToAbsent
          ? const Value.absent()
          : Value(folderUid),
      categoryUid: categoryUid == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryUid),
      title: Value(title),
      originalName: Value(originalName),
      ext: ext == null && nullToAbsent ? const Value.absent() : Value(ext),
      mime: mime == null && nullToAbsent ? const Value.absent() : Value(mime),
      docType: Value(docType),
      relPath: Value(relPath),
      sizeBytes: Value(sizeBytes),
      contentHash: Value(contentHash),
      encHash: encHash == null && nullToAbsent
          ? const Value.absent()
          : Value(encHash),
      isEncrypted: Value(isEncrypted),
      ocrStatus: Value(ocrStatus),
      starred: Value(starred),
      importedAt: Value(importedAt),
      fileMtime: fileMtime == null && nullToAbsent
          ? const Value.absent()
          : Value(fileMtime),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Document.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Document(
      uid: serializer.fromJson<String>(json['uid']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      revision: serializer.fromJson<int>(json['revision']),
      id: serializer.fromJson<int>(json['id']),
      folderUid: serializer.fromJson<String?>(json['folderUid']),
      categoryUid: serializer.fromJson<String?>(json['categoryUid']),
      title: serializer.fromJson<String>(json['title']),
      originalName: serializer.fromJson<String>(json['originalName']),
      ext: serializer.fromJson<String?>(json['ext']),
      mime: serializer.fromJson<String?>(json['mime']),
      docType: serializer.fromJson<String>(json['docType']),
      relPath: serializer.fromJson<String>(json['relPath']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      contentHash: serializer.fromJson<String>(json['contentHash']),
      encHash: serializer.fromJson<String?>(json['encHash']),
      isEncrypted: serializer.fromJson<bool>(json['isEncrypted']),
      ocrStatus: serializer.fromJson<String>(json['ocrStatus']),
      starred: serializer.fromJson<bool>(json['starred']),
      importedAt: serializer.fromJson<int>(json['importedAt']),
      fileMtime: serializer.fromJson<int?>(json['fileMtime']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'revision': serializer.toJson<int>(revision),
      'id': serializer.toJson<int>(id),
      'folderUid': serializer.toJson<String?>(folderUid),
      'categoryUid': serializer.toJson<String?>(categoryUid),
      'title': serializer.toJson<String>(title),
      'originalName': serializer.toJson<String>(originalName),
      'ext': serializer.toJson<String?>(ext),
      'mime': serializer.toJson<String?>(mime),
      'docType': serializer.toJson<String>(docType),
      'relPath': serializer.toJson<String>(relPath),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'contentHash': serializer.toJson<String>(contentHash),
      'encHash': serializer.toJson<String?>(encHash),
      'isEncrypted': serializer.toJson<bool>(isEncrypted),
      'ocrStatus': serializer.toJson<String>(ocrStatus),
      'starred': serializer.toJson<bool>(starred),
      'importedAt': serializer.toJson<int>(importedAt),
      'fileMtime': serializer.toJson<int?>(fileMtime),
      'deletedAt': serializer.toJson<int?>(deletedAt),
    };
  }

  Document copyWith({
    String? uid,
    int? createdAt,
    int? updatedAt,
    bool? deleted,
    int? revision,
    int? id,
    Value<String?> folderUid = const Value.absent(),
    Value<String?> categoryUid = const Value.absent(),
    String? title,
    String? originalName,
    Value<String?> ext = const Value.absent(),
    Value<String?> mime = const Value.absent(),
    String? docType,
    String? relPath,
    int? sizeBytes,
    String? contentHash,
    Value<String?> encHash = const Value.absent(),
    bool? isEncrypted,
    String? ocrStatus,
    bool? starred,
    int? importedAt,
    Value<int?> fileMtime = const Value.absent(),
    Value<int?> deletedAt = const Value.absent(),
  }) => Document(
    uid: uid ?? this.uid,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    revision: revision ?? this.revision,
    id: id ?? this.id,
    folderUid: folderUid.present ? folderUid.value : this.folderUid,
    categoryUid: categoryUid.present ? categoryUid.value : this.categoryUid,
    title: title ?? this.title,
    originalName: originalName ?? this.originalName,
    ext: ext.present ? ext.value : this.ext,
    mime: mime.present ? mime.value : this.mime,
    docType: docType ?? this.docType,
    relPath: relPath ?? this.relPath,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    contentHash: contentHash ?? this.contentHash,
    encHash: encHash.present ? encHash.value : this.encHash,
    isEncrypted: isEncrypted ?? this.isEncrypted,
    ocrStatus: ocrStatus ?? this.ocrStatus,
    starred: starred ?? this.starred,
    importedAt: importedAt ?? this.importedAt,
    fileMtime: fileMtime.present ? fileMtime.value : this.fileMtime,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Document copyWithCompanion(DocumentsCompanion data) {
    return Document(
      uid: data.uid.present ? data.uid.value : this.uid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      revision: data.revision.present ? data.revision.value : this.revision,
      id: data.id.present ? data.id.value : this.id,
      folderUid: data.folderUid.present ? data.folderUid.value : this.folderUid,
      categoryUid: data.categoryUid.present
          ? data.categoryUid.value
          : this.categoryUid,
      title: data.title.present ? data.title.value : this.title,
      originalName: data.originalName.present
          ? data.originalName.value
          : this.originalName,
      ext: data.ext.present ? data.ext.value : this.ext,
      mime: data.mime.present ? data.mime.value : this.mime,
      docType: data.docType.present ? data.docType.value : this.docType,
      relPath: data.relPath.present ? data.relPath.value : this.relPath,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      encHash: data.encHash.present ? data.encHash.value : this.encHash,
      isEncrypted: data.isEncrypted.present
          ? data.isEncrypted.value
          : this.isEncrypted,
      ocrStatus: data.ocrStatus.present ? data.ocrStatus.value : this.ocrStatus,
      starred: data.starred.present ? data.starred.value : this.starred,
      importedAt: data.importedAt.present
          ? data.importedAt.value
          : this.importedAt,
      fileMtime: data.fileMtime.present ? data.fileMtime.value : this.fileMtime,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('uid: $uid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('revision: $revision, ')
          ..write('id: $id, ')
          ..write('folderUid: $folderUid, ')
          ..write('categoryUid: $categoryUid, ')
          ..write('title: $title, ')
          ..write('originalName: $originalName, ')
          ..write('ext: $ext, ')
          ..write('mime: $mime, ')
          ..write('docType: $docType, ')
          ..write('relPath: $relPath, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('contentHash: $contentHash, ')
          ..write('encHash: $encHash, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('ocrStatus: $ocrStatus, ')
          ..write('starred: $starred, ')
          ..write('importedAt: $importedAt, ')
          ..write('fileMtime: $fileMtime, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    uid,
    createdAt,
    updatedAt,
    deleted,
    revision,
    id,
    folderUid,
    categoryUid,
    title,
    originalName,
    ext,
    mime,
    docType,
    relPath,
    sizeBytes,
    contentHash,
    encHash,
    isEncrypted,
    ocrStatus,
    starred,
    importedAt,
    fileMtime,
    deletedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.uid == this.uid &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.revision == this.revision &&
          other.id == this.id &&
          other.folderUid == this.folderUid &&
          other.categoryUid == this.categoryUid &&
          other.title == this.title &&
          other.originalName == this.originalName &&
          other.ext == this.ext &&
          other.mime == this.mime &&
          other.docType == this.docType &&
          other.relPath == this.relPath &&
          other.sizeBytes == this.sizeBytes &&
          other.contentHash == this.contentHash &&
          other.encHash == this.encHash &&
          other.isEncrypted == this.isEncrypted &&
          other.ocrStatus == this.ocrStatus &&
          other.starred == this.starred &&
          other.importedAt == this.importedAt &&
          other.fileMtime == this.fileMtime &&
          other.deletedAt == this.deletedAt);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<String> uid;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> revision;
  final Value<int> id;
  final Value<String?> folderUid;
  final Value<String?> categoryUid;
  final Value<String> title;
  final Value<String> originalName;
  final Value<String?> ext;
  final Value<String?> mime;
  final Value<String> docType;
  final Value<String> relPath;
  final Value<int> sizeBytes;
  final Value<String> contentHash;
  final Value<String?> encHash;
  final Value<bool> isEncrypted;
  final Value<String> ocrStatus;
  final Value<bool> starred;
  final Value<int> importedAt;
  final Value<int?> fileMtime;
  final Value<int?> deletedAt;
  const DocumentsCompanion({
    this.uid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.revision = const Value.absent(),
    this.id = const Value.absent(),
    this.folderUid = const Value.absent(),
    this.categoryUid = const Value.absent(),
    this.title = const Value.absent(),
    this.originalName = const Value.absent(),
    this.ext = const Value.absent(),
    this.mime = const Value.absent(),
    this.docType = const Value.absent(),
    this.relPath = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.encHash = const Value.absent(),
    this.isEncrypted = const Value.absent(),
    this.ocrStatus = const Value.absent(),
    this.starred = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.fileMtime = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  DocumentsCompanion.insert({
    required String uid,
    required int createdAt,
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.revision = const Value.absent(),
    this.id = const Value.absent(),
    this.folderUid = const Value.absent(),
    this.categoryUid = const Value.absent(),
    required String title,
    required String originalName,
    this.ext = const Value.absent(),
    this.mime = const Value.absent(),
    this.docType = const Value.absent(),
    required String relPath,
    this.sizeBytes = const Value.absent(),
    required String contentHash,
    this.encHash = const Value.absent(),
    this.isEncrypted = const Value.absent(),
    this.ocrStatus = const Value.absent(),
    this.starred = const Value.absent(),
    required int importedAt,
    this.fileMtime = const Value.absent(),
    this.deletedAt = const Value.absent(),
  }) : uid = Value(uid),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       title = Value(title),
       originalName = Value(originalName),
       relPath = Value(relPath),
       contentHash = Value(contentHash),
       importedAt = Value(importedAt);
  static Insertable<Document> custom({
    Expression<String>? uid,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? revision,
    Expression<int>? id,
    Expression<String>? folderUid,
    Expression<String>? categoryUid,
    Expression<String>? title,
    Expression<String>? originalName,
    Expression<String>? ext,
    Expression<String>? mime,
    Expression<String>? docType,
    Expression<String>? relPath,
    Expression<int>? sizeBytes,
    Expression<String>? contentHash,
    Expression<String>? encHash,
    Expression<bool>? isEncrypted,
    Expression<String>? ocrStatus,
    Expression<bool>? starred,
    Expression<int>? importedAt,
    Expression<int>? fileMtime,
    Expression<int>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (revision != null) 'revision': revision,
      if (id != null) 'id': id,
      if (folderUid != null) 'folder_uid': folderUid,
      if (categoryUid != null) 'category_uid': categoryUid,
      if (title != null) 'title': title,
      if (originalName != null) 'original_name': originalName,
      if (ext != null) 'ext': ext,
      if (mime != null) 'mime': mime,
      if (docType != null) 'doc_type': docType,
      if (relPath != null) 'rel_path': relPath,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (contentHash != null) 'content_hash': contentHash,
      if (encHash != null) 'enc_hash': encHash,
      if (isEncrypted != null) 'is_encrypted': isEncrypted,
      if (ocrStatus != null) 'ocr_status': ocrStatus,
      if (starred != null) 'starred': starred,
      if (importedAt != null) 'imported_at': importedAt,
      if (fileMtime != null) 'file_mtime': fileMtime,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  DocumentsCompanion copyWith({
    Value<String>? uid,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? revision,
    Value<int>? id,
    Value<String?>? folderUid,
    Value<String?>? categoryUid,
    Value<String>? title,
    Value<String>? originalName,
    Value<String?>? ext,
    Value<String?>? mime,
    Value<String>? docType,
    Value<String>? relPath,
    Value<int>? sizeBytes,
    Value<String>? contentHash,
    Value<String?>? encHash,
    Value<bool>? isEncrypted,
    Value<String>? ocrStatus,
    Value<bool>? starred,
    Value<int>? importedAt,
    Value<int?>? fileMtime,
    Value<int?>? deletedAt,
  }) {
    return DocumentsCompanion(
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      revision: revision ?? this.revision,
      id: id ?? this.id,
      folderUid: folderUid ?? this.folderUid,
      categoryUid: categoryUid ?? this.categoryUid,
      title: title ?? this.title,
      originalName: originalName ?? this.originalName,
      ext: ext ?? this.ext,
      mime: mime ?? this.mime,
      docType: docType ?? this.docType,
      relPath: relPath ?? this.relPath,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      contentHash: contentHash ?? this.contentHash,
      encHash: encHash ?? this.encHash,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      ocrStatus: ocrStatus ?? this.ocrStatus,
      starred: starred ?? this.starred,
      importedAt: importedAt ?? this.importedAt,
      fileMtime: fileMtime ?? this.fileMtime,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (folderUid.present) {
      map['folder_uid'] = Variable<String>(folderUid.value);
    }
    if (categoryUid.present) {
      map['category_uid'] = Variable<String>(categoryUid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (originalName.present) {
      map['original_name'] = Variable<String>(originalName.value);
    }
    if (ext.present) {
      map['ext'] = Variable<String>(ext.value);
    }
    if (mime.present) {
      map['mime'] = Variable<String>(mime.value);
    }
    if (docType.present) {
      map['doc_type'] = Variable<String>(docType.value);
    }
    if (relPath.present) {
      map['rel_path'] = Variable<String>(relPath.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (encHash.present) {
      map['enc_hash'] = Variable<String>(encHash.value);
    }
    if (isEncrypted.present) {
      map['is_encrypted'] = Variable<bool>(isEncrypted.value);
    }
    if (ocrStatus.present) {
      map['ocr_status'] = Variable<String>(ocrStatus.value);
    }
    if (starred.present) {
      map['starred'] = Variable<bool>(starred.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<int>(importedAt.value);
    }
    if (fileMtime.present) {
      map['file_mtime'] = Variable<int>(fileMtime.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('uid: $uid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('revision: $revision, ')
          ..write('id: $id, ')
          ..write('folderUid: $folderUid, ')
          ..write('categoryUid: $categoryUid, ')
          ..write('title: $title, ')
          ..write('originalName: $originalName, ')
          ..write('ext: $ext, ')
          ..write('mime: $mime, ')
          ..write('docType: $docType, ')
          ..write('relPath: $relPath, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('contentHash: $contentHash, ')
          ..write('encHash: $encHash, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('ocrStatus: $ocrStatus, ')
          ..write('starred: $starred, ')
          ..write('importedAt: $importedAt, ')
          ..write('fileMtime: $fileMtime, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $DocumentTagsTable extends DocumentTags
    with TableInfo<$DocumentTagsTable, DocumentTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _documentUidMeta = const VerificationMeta(
    'documentUid',
  );
  @override
  late final GeneratedColumn<String> documentUid = GeneratedColumn<String>(
    'document_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagUidMeta = const VerificationMeta('tagUid');
  @override
  late final GeneratedColumn<String> tagUid = GeneratedColumn<String>(
    'tag_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    documentUid,
    tagUid,
    createdAt,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('document_uid')) {
      context.handle(
        _documentUidMeta,
        documentUid.isAcceptableOrUnknown(
          data['document_uid']!,
          _documentUidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_documentUidMeta);
    }
    if (data.containsKey('tag_uid')) {
      context.handle(
        _tagUidMeta,
        tagUid.isAcceptableOrUnknown(data['tag_uid']!, _tagUidMeta),
      );
    } else if (isInserting) {
      context.missing(_tagUidMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {documentUid, tagUid};
  @override
  DocumentTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentTag(
      documentUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_uid'],
      )!,
      tagUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_uid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $DocumentTagsTable createAlias(String alias) {
    return $DocumentTagsTable(attachedDatabase, alias);
  }
}

class DocumentTag extends DataClass implements Insertable<DocumentTag> {
  final String documentUid;
  final String tagUid;
  final int createdAt;
  final int updatedAt;
  final bool deleted;
  const DocumentTag({
    required this.documentUid,
    required this.tagUid,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['document_uid'] = Variable<String>(documentUid);
    map['tag_uid'] = Variable<String>(tagUid);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  DocumentTagsCompanion toCompanion(bool nullToAbsent) {
    return DocumentTagsCompanion(
      documentUid: Value(documentUid),
      tagUid: Value(tagUid),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory DocumentTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentTag(
      documentUid: serializer.fromJson<String>(json['documentUid']),
      tagUid: serializer.fromJson<String>(json['tagUid']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'documentUid': serializer.toJson<String>(documentUid),
      'tagUid': serializer.toJson<String>(tagUid),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  DocumentTag copyWith({
    String? documentUid,
    String? tagUid,
    int? createdAt,
    int? updatedAt,
    bool? deleted,
  }) => DocumentTag(
    documentUid: documentUid ?? this.documentUid,
    tagUid: tagUid ?? this.tagUid,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  DocumentTag copyWithCompanion(DocumentTagsCompanion data) {
    return DocumentTag(
      documentUid: data.documentUid.present
          ? data.documentUid.value
          : this.documentUid,
      tagUid: data.tagUid.present ? data.tagUid.value : this.tagUid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentTag(')
          ..write('documentUid: $documentUid, ')
          ..write('tagUid: $tagUid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(documentUid, tagUid, createdAt, updatedAt, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentTag &&
          other.documentUid == this.documentUid &&
          other.tagUid == this.tagUid &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class DocumentTagsCompanion extends UpdateCompanion<DocumentTag> {
  final Value<String> documentUid;
  final Value<String> tagUid;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const DocumentTagsCompanion({
    this.documentUid = const Value.absent(),
    this.tagUid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentTagsCompanion.insert({
    required String documentUid,
    required String tagUid,
    required int createdAt,
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : documentUid = Value(documentUid),
       tagUid = Value(tagUid),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DocumentTag> custom({
    Expression<String>? documentUid,
    Expression<String>? tagUid,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (documentUid != null) 'document_uid': documentUid,
      if (tagUid != null) 'tag_uid': tagUid,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentTagsCompanion copyWith({
    Value<String>? documentUid,
    Value<String>? tagUid,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return DocumentTagsCompanion(
      documentUid: documentUid ?? this.documentUid,
      tagUid: tagUid ?? this.tagUid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (documentUid.present) {
      map['document_uid'] = Variable<String>(documentUid.value);
    }
    if (tagUid.present) {
      map['tag_uid'] = Variable<String>(tagUid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentTagsCompanion(')
          ..write('documentUid: $documentUid, ')
          ..write('tagUid: $tagUid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentLabelsTable extends DocumentLabels
    with TableInfo<$DocumentLabelsTable, DocumentLabel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentLabelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _documentUidMeta = const VerificationMeta(
    'documentUid',
  );
  @override
  late final GeneratedColumn<String> documentUid = GeneratedColumn<String>(
    'document_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelUidMeta = const VerificationMeta(
    'labelUid',
  );
  @override
  late final GeneratedColumn<String> labelUid = GeneratedColumn<String>(
    'label_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    documentUid,
    labelUid,
    createdAt,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_labels';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentLabel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('document_uid')) {
      context.handle(
        _documentUidMeta,
        documentUid.isAcceptableOrUnknown(
          data['document_uid']!,
          _documentUidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_documentUidMeta);
    }
    if (data.containsKey('label_uid')) {
      context.handle(
        _labelUidMeta,
        labelUid.isAcceptableOrUnknown(data['label_uid']!, _labelUidMeta),
      );
    } else if (isInserting) {
      context.missing(_labelUidMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {documentUid, labelUid};
  @override
  DocumentLabel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentLabel(
      documentUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_uid'],
      )!,
      labelUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label_uid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $DocumentLabelsTable createAlias(String alias) {
    return $DocumentLabelsTable(attachedDatabase, alias);
  }
}

class DocumentLabel extends DataClass implements Insertable<DocumentLabel> {
  final String documentUid;
  final String labelUid;
  final int createdAt;
  final int updatedAt;
  final bool deleted;
  const DocumentLabel({
    required this.documentUid,
    required this.labelUid,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['document_uid'] = Variable<String>(documentUid);
    map['label_uid'] = Variable<String>(labelUid);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  DocumentLabelsCompanion toCompanion(bool nullToAbsent) {
    return DocumentLabelsCompanion(
      documentUid: Value(documentUid),
      labelUid: Value(labelUid),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory DocumentLabel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentLabel(
      documentUid: serializer.fromJson<String>(json['documentUid']),
      labelUid: serializer.fromJson<String>(json['labelUid']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'documentUid': serializer.toJson<String>(documentUid),
      'labelUid': serializer.toJson<String>(labelUid),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  DocumentLabel copyWith({
    String? documentUid,
    String? labelUid,
    int? createdAt,
    int? updatedAt,
    bool? deleted,
  }) => DocumentLabel(
    documentUid: documentUid ?? this.documentUid,
    labelUid: labelUid ?? this.labelUid,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  DocumentLabel copyWithCompanion(DocumentLabelsCompanion data) {
    return DocumentLabel(
      documentUid: data.documentUid.present
          ? data.documentUid.value
          : this.documentUid,
      labelUid: data.labelUid.present ? data.labelUid.value : this.labelUid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentLabel(')
          ..write('documentUid: $documentUid, ')
          ..write('labelUid: $labelUid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(documentUid, labelUid, createdAt, updatedAt, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentLabel &&
          other.documentUid == this.documentUid &&
          other.labelUid == this.labelUid &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class DocumentLabelsCompanion extends UpdateCompanion<DocumentLabel> {
  final Value<String> documentUid;
  final Value<String> labelUid;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const DocumentLabelsCompanion({
    this.documentUid = const Value.absent(),
    this.labelUid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentLabelsCompanion.insert({
    required String documentUid,
    required String labelUid,
    required int createdAt,
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : documentUid = Value(documentUid),
       labelUid = Value(labelUid),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DocumentLabel> custom({
    Expression<String>? documentUid,
    Expression<String>? labelUid,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (documentUid != null) 'document_uid': documentUid,
      if (labelUid != null) 'label_uid': labelUid,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentLabelsCompanion copyWith({
    Value<String>? documentUid,
    Value<String>? labelUid,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return DocumentLabelsCompanion(
      documentUid: documentUid ?? this.documentUid,
      labelUid: labelUid ?? this.labelUid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (documentUid.present) {
      map['document_uid'] = Variable<String>(documentUid.value);
    }
    if (labelUid.present) {
      map['label_uid'] = Variable<String>(labelUid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentLabelsCompanion(')
          ..write('documentUid: $documentUid, ')
          ..write('labelUid: $labelUid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrashMetaTable extends TrashMeta
    with TableInfo<$TrashMetaTable, TrashMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrashMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _documentUidMeta = const VerificationMeta(
    'documentUid',
  );
  @override
  late final GeneratedColumn<String> documentUid = GeneratedColumn<String>(
    'document_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trashedAtMeta = const VerificationMeta(
    'trashedAt',
  );
  @override
  late final GeneratedColumn<int> trashedAt = GeneratedColumn<int>(
    'trashed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originFolderUidMeta = const VerificationMeta(
    'originFolderUid',
  );
  @override
  late final GeneratedColumn<String> originFolderUid = GeneratedColumn<String>(
    'origin_folder_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purgeAfterMeta = const VerificationMeta(
    'purgeAfter',
  );
  @override
  late final GeneratedColumn<int> purgeAfter = GeneratedColumn<int>(
    'purge_after',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoteDeletedMeta = const VerificationMeta(
    'remoteDeleted',
  );
  @override
  late final GeneratedColumn<bool> remoteDeleted = GeneratedColumn<bool>(
    'remote_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("remote_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    documentUid,
    trashedAt,
    originFolderUid,
    purgeAfter,
    remoteDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trash_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrashMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('document_uid')) {
      context.handle(
        _documentUidMeta,
        documentUid.isAcceptableOrUnknown(
          data['document_uid']!,
          _documentUidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_documentUidMeta);
    }
    if (data.containsKey('trashed_at')) {
      context.handle(
        _trashedAtMeta,
        trashedAt.isAcceptableOrUnknown(data['trashed_at']!, _trashedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_trashedAtMeta);
    }
    if (data.containsKey('origin_folder_uid')) {
      context.handle(
        _originFolderUidMeta,
        originFolderUid.isAcceptableOrUnknown(
          data['origin_folder_uid']!,
          _originFolderUidMeta,
        ),
      );
    }
    if (data.containsKey('purge_after')) {
      context.handle(
        _purgeAfterMeta,
        purgeAfter.isAcceptableOrUnknown(data['purge_after']!, _purgeAfterMeta),
      );
    }
    if (data.containsKey('remote_deleted')) {
      context.handle(
        _remoteDeletedMeta,
        remoteDeleted.isAcceptableOrUnknown(
          data['remote_deleted']!,
          _remoteDeletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {documentUid};
  @override
  TrashMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrashMetaData(
      documentUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_uid'],
      )!,
      trashedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trashed_at'],
      )!,
      originFolderUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_folder_uid'],
      ),
      purgeAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purge_after'],
      ),
      remoteDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}remote_deleted'],
      )!,
    );
  }

  @override
  $TrashMetaTable createAlias(String alias) {
    return $TrashMetaTable(attachedDatabase, alias);
  }
}

class TrashMetaData extends DataClass implements Insertable<TrashMetaData> {
  final String documentUid;
  final int trashedAt;
  final String? originFolderUid;
  final int? purgeAfter;
  final bool remoteDeleted;
  const TrashMetaData({
    required this.documentUid,
    required this.trashedAt,
    this.originFolderUid,
    this.purgeAfter,
    required this.remoteDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['document_uid'] = Variable<String>(documentUid);
    map['trashed_at'] = Variable<int>(trashedAt);
    if (!nullToAbsent || originFolderUid != null) {
      map['origin_folder_uid'] = Variable<String>(originFolderUid);
    }
    if (!nullToAbsent || purgeAfter != null) {
      map['purge_after'] = Variable<int>(purgeAfter);
    }
    map['remote_deleted'] = Variable<bool>(remoteDeleted);
    return map;
  }

  TrashMetaCompanion toCompanion(bool nullToAbsent) {
    return TrashMetaCompanion(
      documentUid: Value(documentUid),
      trashedAt: Value(trashedAt),
      originFolderUid: originFolderUid == null && nullToAbsent
          ? const Value.absent()
          : Value(originFolderUid),
      purgeAfter: purgeAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(purgeAfter),
      remoteDeleted: Value(remoteDeleted),
    );
  }

  factory TrashMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrashMetaData(
      documentUid: serializer.fromJson<String>(json['documentUid']),
      trashedAt: serializer.fromJson<int>(json['trashedAt']),
      originFolderUid: serializer.fromJson<String?>(json['originFolderUid']),
      purgeAfter: serializer.fromJson<int?>(json['purgeAfter']),
      remoteDeleted: serializer.fromJson<bool>(json['remoteDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'documentUid': serializer.toJson<String>(documentUid),
      'trashedAt': serializer.toJson<int>(trashedAt),
      'originFolderUid': serializer.toJson<String?>(originFolderUid),
      'purgeAfter': serializer.toJson<int?>(purgeAfter),
      'remoteDeleted': serializer.toJson<bool>(remoteDeleted),
    };
  }

  TrashMetaData copyWith({
    String? documentUid,
    int? trashedAt,
    Value<String?> originFolderUid = const Value.absent(),
    Value<int?> purgeAfter = const Value.absent(),
    bool? remoteDeleted,
  }) => TrashMetaData(
    documentUid: documentUid ?? this.documentUid,
    trashedAt: trashedAt ?? this.trashedAt,
    originFolderUid: originFolderUid.present
        ? originFolderUid.value
        : this.originFolderUid,
    purgeAfter: purgeAfter.present ? purgeAfter.value : this.purgeAfter,
    remoteDeleted: remoteDeleted ?? this.remoteDeleted,
  );
  TrashMetaData copyWithCompanion(TrashMetaCompanion data) {
    return TrashMetaData(
      documentUid: data.documentUid.present
          ? data.documentUid.value
          : this.documentUid,
      trashedAt: data.trashedAt.present ? data.trashedAt.value : this.trashedAt,
      originFolderUid: data.originFolderUid.present
          ? data.originFolderUid.value
          : this.originFolderUid,
      purgeAfter: data.purgeAfter.present
          ? data.purgeAfter.value
          : this.purgeAfter,
      remoteDeleted: data.remoteDeleted.present
          ? data.remoteDeleted.value
          : this.remoteDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrashMetaData(')
          ..write('documentUid: $documentUid, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('originFolderUid: $originFolderUid, ')
          ..write('purgeAfter: $purgeAfter, ')
          ..write('remoteDeleted: $remoteDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    documentUid,
    trashedAt,
    originFolderUid,
    purgeAfter,
    remoteDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrashMetaData &&
          other.documentUid == this.documentUid &&
          other.trashedAt == this.trashedAt &&
          other.originFolderUid == this.originFolderUid &&
          other.purgeAfter == this.purgeAfter &&
          other.remoteDeleted == this.remoteDeleted);
}

class TrashMetaCompanion extends UpdateCompanion<TrashMetaData> {
  final Value<String> documentUid;
  final Value<int> trashedAt;
  final Value<String?> originFolderUid;
  final Value<int?> purgeAfter;
  final Value<bool> remoteDeleted;
  final Value<int> rowid;
  const TrashMetaCompanion({
    this.documentUid = const Value.absent(),
    this.trashedAt = const Value.absent(),
    this.originFolderUid = const Value.absent(),
    this.purgeAfter = const Value.absent(),
    this.remoteDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrashMetaCompanion.insert({
    required String documentUid,
    required int trashedAt,
    this.originFolderUid = const Value.absent(),
    this.purgeAfter = const Value.absent(),
    this.remoteDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : documentUid = Value(documentUid),
       trashedAt = Value(trashedAt);
  static Insertable<TrashMetaData> custom({
    Expression<String>? documentUid,
    Expression<int>? trashedAt,
    Expression<String>? originFolderUid,
    Expression<int>? purgeAfter,
    Expression<bool>? remoteDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (documentUid != null) 'document_uid': documentUid,
      if (trashedAt != null) 'trashed_at': trashedAt,
      if (originFolderUid != null) 'origin_folder_uid': originFolderUid,
      if (purgeAfter != null) 'purge_after': purgeAfter,
      if (remoteDeleted != null) 'remote_deleted': remoteDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrashMetaCompanion copyWith({
    Value<String>? documentUid,
    Value<int>? trashedAt,
    Value<String?>? originFolderUid,
    Value<int?>? purgeAfter,
    Value<bool>? remoteDeleted,
    Value<int>? rowid,
  }) {
    return TrashMetaCompanion(
      documentUid: documentUid ?? this.documentUid,
      trashedAt: trashedAt ?? this.trashedAt,
      originFolderUid: originFolderUid ?? this.originFolderUid,
      purgeAfter: purgeAfter ?? this.purgeAfter,
      remoteDeleted: remoteDeleted ?? this.remoteDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (documentUid.present) {
      map['document_uid'] = Variable<String>(documentUid.value);
    }
    if (trashedAt.present) {
      map['trashed_at'] = Variable<int>(trashedAt.value);
    }
    if (originFolderUid.present) {
      map['origin_folder_uid'] = Variable<String>(originFolderUid.value);
    }
    if (purgeAfter.present) {
      map['purge_after'] = Variable<int>(purgeAfter.value);
    }
    if (remoteDeleted.present) {
      map['remote_deleted'] = Variable<bool>(remoteDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrashMetaCompanion(')
          ..write('documentUid: $documentUid, ')
          ..write('trashedAt: $trashedAt, ')
          ..write('originFolderUid: $originFolderUid, ')
          ..write('purgeAfter: $purgeAfter, ')
          ..write('remoteDeleted: $remoteDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentTextTable extends DocumentText
    with TableInfo<$DocumentTextTable, DocumentTextData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentTextTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _documentUidMeta = const VerificationMeta(
    'documentUid',
  );
  @override
  late final GeneratedColumn<String> documentUid = GeneratedColumn<String>(
    'document_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
    'lang',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _charCountMeta = const VerificationMeta(
    'charCount',
  );
  @override
  late final GeneratedColumn<int> charCount = GeneratedColumn<int>(
    'char_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _extractedAtMeta = const VerificationMeta(
    'extractedAt',
  );
  @override
  late final GeneratedColumn<int> extractedAt = GeneratedColumn<int>(
    'extracted_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _engineMeta = const VerificationMeta('engine');
  @override
  late final GeneratedColumn<String> engine = GeneratedColumn<String>(
    'engine',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    documentUid,
    source,
    lang,
    content,
    charCount,
    extractedAt,
    engine,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_text';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentTextData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('document_uid')) {
      context.handle(
        _documentUidMeta,
        documentUid.isAcceptableOrUnknown(
          data['document_uid']!,
          _documentUidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_documentUidMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('lang')) {
      context.handle(
        _langMeta,
        lang.isAcceptableOrUnknown(data['lang']!, _langMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('char_count')) {
      context.handle(
        _charCountMeta,
        charCount.isAcceptableOrUnknown(data['char_count']!, _charCountMeta),
      );
    }
    if (data.containsKey('extracted_at')) {
      context.handle(
        _extractedAtMeta,
        extractedAt.isAcceptableOrUnknown(
          data['extracted_at']!,
          _extractedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_extractedAtMeta);
    }
    if (data.containsKey('engine')) {
      context.handle(
        _engineMeta,
        engine.isAcceptableOrUnknown(data['engine']!, _engineMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {documentUid};
  @override
  DocumentTextData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentTextData(
      documentUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_uid'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      lang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      charCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}char_count'],
      ),
      extractedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}extracted_at'],
      )!,
      engine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}engine'],
      ),
    );
  }

  @override
  $DocumentTextTable createAlias(String alias) {
    return $DocumentTextTable(attachedDatabase, alias);
  }
}

class DocumentTextData extends DataClass
    implements Insertable<DocumentTextData> {
  final String documentUid;

  /// plain | text_layer | office | ocr — where the text came from.
  final String source;
  final String? lang;
  final String? content;
  final int? charCount;
  final int extractedAt;
  final String? engine;
  const DocumentTextData({
    required this.documentUid,
    required this.source,
    this.lang,
    this.content,
    this.charCount,
    required this.extractedAt,
    this.engine,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['document_uid'] = Variable<String>(documentUid);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || lang != null) {
      map['lang'] = Variable<String>(lang);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || charCount != null) {
      map['char_count'] = Variable<int>(charCount);
    }
    map['extracted_at'] = Variable<int>(extractedAt);
    if (!nullToAbsent || engine != null) {
      map['engine'] = Variable<String>(engine);
    }
    return map;
  }

  DocumentTextCompanion toCompanion(bool nullToAbsent) {
    return DocumentTextCompanion(
      documentUid: Value(documentUid),
      source: Value(source),
      lang: lang == null && nullToAbsent ? const Value.absent() : Value(lang),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      charCount: charCount == null && nullToAbsent
          ? const Value.absent()
          : Value(charCount),
      extractedAt: Value(extractedAt),
      engine: engine == null && nullToAbsent
          ? const Value.absent()
          : Value(engine),
    );
  }

  factory DocumentTextData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentTextData(
      documentUid: serializer.fromJson<String>(json['documentUid']),
      source: serializer.fromJson<String>(json['source']),
      lang: serializer.fromJson<String?>(json['lang']),
      content: serializer.fromJson<String?>(json['content']),
      charCount: serializer.fromJson<int?>(json['charCount']),
      extractedAt: serializer.fromJson<int>(json['extractedAt']),
      engine: serializer.fromJson<String?>(json['engine']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'documentUid': serializer.toJson<String>(documentUid),
      'source': serializer.toJson<String>(source),
      'lang': serializer.toJson<String?>(lang),
      'content': serializer.toJson<String?>(content),
      'charCount': serializer.toJson<int?>(charCount),
      'extractedAt': serializer.toJson<int>(extractedAt),
      'engine': serializer.toJson<String?>(engine),
    };
  }

  DocumentTextData copyWith({
    String? documentUid,
    String? source,
    Value<String?> lang = const Value.absent(),
    Value<String?> content = const Value.absent(),
    Value<int?> charCount = const Value.absent(),
    int? extractedAt,
    Value<String?> engine = const Value.absent(),
  }) => DocumentTextData(
    documentUid: documentUid ?? this.documentUid,
    source: source ?? this.source,
    lang: lang.present ? lang.value : this.lang,
    content: content.present ? content.value : this.content,
    charCount: charCount.present ? charCount.value : this.charCount,
    extractedAt: extractedAt ?? this.extractedAt,
    engine: engine.present ? engine.value : this.engine,
  );
  DocumentTextData copyWithCompanion(DocumentTextCompanion data) {
    return DocumentTextData(
      documentUid: data.documentUid.present
          ? data.documentUid.value
          : this.documentUid,
      source: data.source.present ? data.source.value : this.source,
      lang: data.lang.present ? data.lang.value : this.lang,
      content: data.content.present ? data.content.value : this.content,
      charCount: data.charCount.present ? data.charCount.value : this.charCount,
      extractedAt: data.extractedAt.present
          ? data.extractedAt.value
          : this.extractedAt,
      engine: data.engine.present ? data.engine.value : this.engine,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentTextData(')
          ..write('documentUid: $documentUid, ')
          ..write('source: $source, ')
          ..write('lang: $lang, ')
          ..write('content: $content, ')
          ..write('charCount: $charCount, ')
          ..write('extractedAt: $extractedAt, ')
          ..write('engine: $engine')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    documentUid,
    source,
    lang,
    content,
    charCount,
    extractedAt,
    engine,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentTextData &&
          other.documentUid == this.documentUid &&
          other.source == this.source &&
          other.lang == this.lang &&
          other.content == this.content &&
          other.charCount == this.charCount &&
          other.extractedAt == this.extractedAt &&
          other.engine == this.engine);
}

class DocumentTextCompanion extends UpdateCompanion<DocumentTextData> {
  final Value<String> documentUid;
  final Value<String> source;
  final Value<String?> lang;
  final Value<String?> content;
  final Value<int?> charCount;
  final Value<int> extractedAt;
  final Value<String?> engine;
  final Value<int> rowid;
  const DocumentTextCompanion({
    this.documentUid = const Value.absent(),
    this.source = const Value.absent(),
    this.lang = const Value.absent(),
    this.content = const Value.absent(),
    this.charCount = const Value.absent(),
    this.extractedAt = const Value.absent(),
    this.engine = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentTextCompanion.insert({
    required String documentUid,
    required String source,
    this.lang = const Value.absent(),
    this.content = const Value.absent(),
    this.charCount = const Value.absent(),
    required int extractedAt,
    this.engine = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : documentUid = Value(documentUid),
       source = Value(source),
       extractedAt = Value(extractedAt);
  static Insertable<DocumentTextData> custom({
    Expression<String>? documentUid,
    Expression<String>? source,
    Expression<String>? lang,
    Expression<String>? content,
    Expression<int>? charCount,
    Expression<int>? extractedAt,
    Expression<String>? engine,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (documentUid != null) 'document_uid': documentUid,
      if (source != null) 'source': source,
      if (lang != null) 'lang': lang,
      if (content != null) 'content': content,
      if (charCount != null) 'char_count': charCount,
      if (extractedAt != null) 'extracted_at': extractedAt,
      if (engine != null) 'engine': engine,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentTextCompanion copyWith({
    Value<String>? documentUid,
    Value<String>? source,
    Value<String?>? lang,
    Value<String?>? content,
    Value<int?>? charCount,
    Value<int>? extractedAt,
    Value<String?>? engine,
    Value<int>? rowid,
  }) {
    return DocumentTextCompanion(
      documentUid: documentUid ?? this.documentUid,
      source: source ?? this.source,
      lang: lang ?? this.lang,
      content: content ?? this.content,
      charCount: charCount ?? this.charCount,
      extractedAt: extractedAt ?? this.extractedAt,
      engine: engine ?? this.engine,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (documentUid.present) {
      map['document_uid'] = Variable<String>(documentUid.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (charCount.present) {
      map['char_count'] = Variable<int>(charCount.value);
    }
    if (extractedAt.present) {
      map['extracted_at'] = Variable<int>(extractedAt.value);
    }
    if (engine.present) {
      map['engine'] = Variable<String>(engine.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentTextCompanion(')
          ..write('documentUid: $documentUid, ')
          ..write('source: $source, ')
          ..write('lang: $lang, ')
          ..write('content: $content, ')
          ..write('charCount: $charCount, ')
          ..write('extractedAt: $extractedAt, ')
          ..write('engine: $engine, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SmartFoldersTable extends SmartFolders
    with TableInfo<$SmartFoldersTable, SmartFolder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmartFoldersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _queryJsonMeta = const VerificationMeta(
    'queryJson',
  );
  @override
  late final GeneratedColumn<String> queryJson = GeneratedColumn<String>(
    'query_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    uid,
    createdAt,
    updatedAt,
    deleted,
    revision,
    id,
    name,
    icon,
    queryJson,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'smart_folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<SmartFolder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('query_json')) {
      context.handle(
        _queryJsonMeta,
        queryJson.isAcceptableOrUnknown(data['query_json']!, _queryJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_queryJsonMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SmartFolder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmartFolder(
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      queryJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}query_json'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $SmartFoldersTable createAlias(String alias) {
    return $SmartFoldersTable(attachedDatabase, alias);
  }
}

class SmartFolder extends DataClass implements Insertable<SmartFolder> {
  final String uid;
  final int createdAt;
  final int updatedAt;
  final bool deleted;
  final int revision;
  final int id;
  final String name;
  final String? icon;
  final String queryJson;
  final int sortOrder;
  const SmartFolder({
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
    required this.revision,
    required this.id,
    required this.name,
    this.icon,
    required this.queryJson,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['revision'] = Variable<int>(revision);
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['query_json'] = Variable<String>(queryJson);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  SmartFoldersCompanion toCompanion(bool nullToAbsent) {
    return SmartFoldersCompanion(
      uid: Value(uid),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      revision: Value(revision),
      id: Value(id),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      queryJson: Value(queryJson),
      sortOrder: Value(sortOrder),
    );
  }

  factory SmartFolder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmartFolder(
      uid: serializer.fromJson<String>(json['uid']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      revision: serializer.fromJson<int>(json['revision']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      queryJson: serializer.fromJson<String>(json['queryJson']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'revision': serializer.toJson<int>(revision),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'queryJson': serializer.toJson<String>(queryJson),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  SmartFolder copyWith({
    String? uid,
    int? createdAt,
    int? updatedAt,
    bool? deleted,
    int? revision,
    int? id,
    String? name,
    Value<String?> icon = const Value.absent(),
    String? queryJson,
    int? sortOrder,
  }) => SmartFolder(
    uid: uid ?? this.uid,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    revision: revision ?? this.revision,
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon.present ? icon.value : this.icon,
    queryJson: queryJson ?? this.queryJson,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  SmartFolder copyWithCompanion(SmartFoldersCompanion data) {
    return SmartFolder(
      uid: data.uid.present ? data.uid.value : this.uid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      revision: data.revision.present ? data.revision.value : this.revision,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      queryJson: data.queryJson.present ? data.queryJson.value : this.queryJson,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmartFolder(')
          ..write('uid: $uid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('revision: $revision, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('queryJson: $queryJson, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uid,
    createdAt,
    updatedAt,
    deleted,
    revision,
    id,
    name,
    icon,
    queryJson,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmartFolder &&
          other.uid == this.uid &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.revision == this.revision &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.queryJson == this.queryJson &&
          other.sortOrder == this.sortOrder);
}

class SmartFoldersCompanion extends UpdateCompanion<SmartFolder> {
  final Value<String> uid;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<int> revision;
  final Value<int> id;
  final Value<String> name;
  final Value<String?> icon;
  final Value<String> queryJson;
  final Value<int> sortOrder;
  const SmartFoldersCompanion({
    this.uid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.revision = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.queryJson = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  SmartFoldersCompanion.insert({
    required String uid,
    required int createdAt,
    required int updatedAt,
    this.deleted = const Value.absent(),
    this.revision = const Value.absent(),
    this.id = const Value.absent(),
    required String name,
    this.icon = const Value.absent(),
    required String queryJson,
    this.sortOrder = const Value.absent(),
  }) : uid = Value(uid),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       name = Value(name),
       queryJson = Value(queryJson);
  static Insertable<SmartFolder> custom({
    Expression<String>? uid,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? revision,
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? queryJson,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (revision != null) 'revision': revision,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (queryJson != null) 'query_json': queryJson,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  SmartFoldersCompanion copyWith({
    Value<String>? uid,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<int>? revision,
    Value<int>? id,
    Value<String>? name,
    Value<String?>? icon,
    Value<String>? queryJson,
    Value<int>? sortOrder,
  }) {
    return SmartFoldersCompanion(
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      revision: revision ?? this.revision,
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      queryJson: queryJson ?? this.queryJson,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (queryJson.present) {
      map['query_json'] = Variable<String>(queryJson.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmartFoldersCompanion(')
          ..write('uid: $uid, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('revision: $revision, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('queryJson: $queryJson, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $SyncAccountsTable extends SyncAccounts
    with TableInfo<$SyncAccountsTable, SyncAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rootRemoteIdMeta = const VerificationMeta(
    'rootRemoteId',
  );
  @override
  late final GeneratedColumn<String> rootRemoteId = GeneratedColumn<String>(
    'root_remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deltaTokenMeta = const VerificationMeta(
    'deltaToken',
  );
  @override
  late final GeneratedColumn<String> deltaToken = GeneratedColumn<String>(
    'delta_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<int> lastSyncAt = GeneratedColumn<int>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    provider,
    accountId,
    displayName,
    rootRemoteId,
    deltaToken,
    enabled,
    lastSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('root_remote_id')) {
      context.handle(
        _rootRemoteIdMeta,
        rootRemoteId.isAcceptableOrUnknown(
          data['root_remote_id']!,
          _rootRemoteIdMeta,
        ),
      );
    }
    if (data.containsKey('delta_token')) {
      context.handle(
        _deltaTokenMeta,
        deltaToken.isAcceptableOrUnknown(data['delta_token']!, _deltaTokenMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncAccount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      rootRemoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_remote_id'],
      ),
      deltaToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delta_token'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $SyncAccountsTable createAlias(String alias) {
    return $SyncAccountsTable(attachedDatabase, alias);
  }
}

class SyncAccount extends DataClass implements Insertable<SyncAccount> {
  final int id;
  final String provider;
  final String accountId;
  final String? displayName;

  /// Remote id of the app's dedicated root folder.
  final String? rootRemoteId;

  /// Provider delta cursor (Drive changes pageToken / Graph deltaLink).
  final String? deltaToken;
  final bool enabled;
  final int? lastSyncAt;
  const SyncAccount({
    required this.id,
    required this.provider,
    required this.accountId,
    this.displayName,
    this.rootRemoteId,
    this.deltaToken,
    required this.enabled,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['provider'] = Variable<String>(provider);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || rootRemoteId != null) {
      map['root_remote_id'] = Variable<String>(rootRemoteId);
    }
    if (!nullToAbsent || deltaToken != null) {
      map['delta_token'] = Variable<String>(deltaToken);
    }
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<int>(lastSyncAt);
    }
    return map;
  }

  SyncAccountsCompanion toCompanion(bool nullToAbsent) {
    return SyncAccountsCompanion(
      id: Value(id),
      provider: Value(provider),
      accountId: Value(accountId),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      rootRemoteId: rootRemoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(rootRemoteId),
      deltaToken: deltaToken == null && nullToAbsent
          ? const Value.absent()
          : Value(deltaToken),
      enabled: Value(enabled),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory SyncAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncAccount(
      id: serializer.fromJson<int>(json['id']),
      provider: serializer.fromJson<String>(json['provider']),
      accountId: serializer.fromJson<String>(json['accountId']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      rootRemoteId: serializer.fromJson<String?>(json['rootRemoteId']),
      deltaToken: serializer.fromJson<String?>(json['deltaToken']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      lastSyncAt: serializer.fromJson<int?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'provider': serializer.toJson<String>(provider),
      'accountId': serializer.toJson<String>(accountId),
      'displayName': serializer.toJson<String?>(displayName),
      'rootRemoteId': serializer.toJson<String?>(rootRemoteId),
      'deltaToken': serializer.toJson<String?>(deltaToken),
      'enabled': serializer.toJson<bool>(enabled),
      'lastSyncAt': serializer.toJson<int?>(lastSyncAt),
    };
  }

  SyncAccount copyWith({
    int? id,
    String? provider,
    String? accountId,
    Value<String?> displayName = const Value.absent(),
    Value<String?> rootRemoteId = const Value.absent(),
    Value<String?> deltaToken = const Value.absent(),
    bool? enabled,
    Value<int?> lastSyncAt = const Value.absent(),
  }) => SyncAccount(
    id: id ?? this.id,
    provider: provider ?? this.provider,
    accountId: accountId ?? this.accountId,
    displayName: displayName.present ? displayName.value : this.displayName,
    rootRemoteId: rootRemoteId.present ? rootRemoteId.value : this.rootRemoteId,
    deltaToken: deltaToken.present ? deltaToken.value : this.deltaToken,
    enabled: enabled ?? this.enabled,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  SyncAccount copyWithCompanion(SyncAccountsCompanion data) {
    return SyncAccount(
      id: data.id.present ? data.id.value : this.id,
      provider: data.provider.present ? data.provider.value : this.provider,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      rootRemoteId: data.rootRemoteId.present
          ? data.rootRemoteId.value
          : this.rootRemoteId,
      deltaToken: data.deltaToken.present
          ? data.deltaToken.value
          : this.deltaToken,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncAccount(')
          ..write('id: $id, ')
          ..write('provider: $provider, ')
          ..write('accountId: $accountId, ')
          ..write('displayName: $displayName, ')
          ..write('rootRemoteId: $rootRemoteId, ')
          ..write('deltaToken: $deltaToken, ')
          ..write('enabled: $enabled, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    provider,
    accountId,
    displayName,
    rootRemoteId,
    deltaToken,
    enabled,
    lastSyncAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncAccount &&
          other.id == this.id &&
          other.provider == this.provider &&
          other.accountId == this.accountId &&
          other.displayName == this.displayName &&
          other.rootRemoteId == this.rootRemoteId &&
          other.deltaToken == this.deltaToken &&
          other.enabled == this.enabled &&
          other.lastSyncAt == this.lastSyncAt);
}

class SyncAccountsCompanion extends UpdateCompanion<SyncAccount> {
  final Value<int> id;
  final Value<String> provider;
  final Value<String> accountId;
  final Value<String?> displayName;
  final Value<String?> rootRemoteId;
  final Value<String?> deltaToken;
  final Value<bool> enabled;
  final Value<int?> lastSyncAt;
  const SyncAccountsCompanion({
    this.id = const Value.absent(),
    this.provider = const Value.absent(),
    this.accountId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.rootRemoteId = const Value.absent(),
    this.deltaToken = const Value.absent(),
    this.enabled = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  SyncAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String provider,
    required String accountId,
    this.displayName = const Value.absent(),
    this.rootRemoteId = const Value.absent(),
    this.deltaToken = const Value.absent(),
    this.enabled = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  }) : provider = Value(provider),
       accountId = Value(accountId);
  static Insertable<SyncAccount> custom({
    Expression<int>? id,
    Expression<String>? provider,
    Expression<String>? accountId,
    Expression<String>? displayName,
    Expression<String>? rootRemoteId,
    Expression<String>? deltaToken,
    Expression<bool>? enabled,
    Expression<int>? lastSyncAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (provider != null) 'provider': provider,
      if (accountId != null) 'account_id': accountId,
      if (displayName != null) 'display_name': displayName,
      if (rootRemoteId != null) 'root_remote_id': rootRemoteId,
      if (deltaToken != null) 'delta_token': deltaToken,
      if (enabled != null) 'enabled': enabled,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
    });
  }

  SyncAccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? provider,
    Value<String>? accountId,
    Value<String?>? displayName,
    Value<String?>? rootRemoteId,
    Value<String?>? deltaToken,
    Value<bool>? enabled,
    Value<int?>? lastSyncAt,
  }) {
    return SyncAccountsCompanion(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      accountId: accountId ?? this.accountId,
      displayName: displayName ?? this.displayName,
      rootRemoteId: rootRemoteId ?? this.rootRemoteId,
      deltaToken: deltaToken ?? this.deltaToken,
      enabled: enabled ?? this.enabled,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (rootRemoteId.present) {
      map['root_remote_id'] = Variable<String>(rootRemoteId.value);
    }
    if (deltaToken.present) {
      map['delta_token'] = Variable<String>(deltaToken.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<int>(lastSyncAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncAccountsCompanion(')
          ..write('id: $id, ')
          ..write('provider: $provider, ')
          ..write('accountId: $accountId, ')
          ..write('displayName: $displayName, ')
          ..write('rootRemoteId: $rootRemoteId, ')
          ..write('deltaToken: $deltaToken, ')
          ..write('enabled: $enabled, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relPathMeta = const VerificationMeta(
    'relPath',
  );
  @override
  late final GeneratedColumn<String> relPath = GeneratedColumn<String>(
    'rel_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localHashMeta = const VerificationMeta(
    'localHash',
  );
  @override
  late final GeneratedColumn<String> localHash = GeneratedColumn<String>(
    'local_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remoteHashMeta = const VerificationMeta(
    'remoteHash',
  );
  @override
  late final GeneratedColumn<String> remoteHash = GeneratedColumn<String>(
    'remote_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baseHashMeta = const VerificationMeta(
    'baseHash',
  );
  @override
  late final GeneratedColumn<String> baseHash = GeneratedColumn<String>(
    'base_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<int> lastSyncedAt = GeneratedColumn<int>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    relPath,
    localHash,
    remoteId,
    remoteHash,
    baseHash,
    state,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('rel_path')) {
      context.handle(
        _relPathMeta,
        relPath.isAcceptableOrUnknown(data['rel_path']!, _relPathMeta),
      );
    } else if (isInserting) {
      context.missing(_relPathMeta);
    }
    if (data.containsKey('local_hash')) {
      context.handle(
        _localHashMeta,
        localHash.isAcceptableOrUnknown(data['local_hash']!, _localHashMeta),
      );
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('remote_hash')) {
      context.handle(
        _remoteHashMeta,
        remoteHash.isAcceptableOrUnknown(data['remote_hash']!, _remoteHashMeta),
      );
    }
    if (data.containsKey('base_hash')) {
      context.handle(
        _baseHashMeta,
        baseHash.isAcceptableOrUnknown(data['base_hash']!, _baseHashMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      relPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rel_path'],
      )!,
      localHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_hash'],
      ),
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      remoteHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_hash'],
      ),
      baseHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_hash'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateData extends DataClass implements Insertable<SyncStateData> {
  final int id;
  final int accountId;
  final String relPath;

  /// Hash of the on-disk (possibly encrypted) blob at last sync.
  final String? localHash;
  final String? remoteId;
  final String? remoteHash;

  /// Common-ancestor hash for three-way reconciliation.
  final String? baseHash;
  final String state;
  final int? lastSyncedAt;
  const SyncStateData({
    required this.id,
    required this.accountId,
    required this.relPath,
    this.localHash,
    this.remoteId,
    this.remoteHash,
    this.baseHash,
    required this.state,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['rel_path'] = Variable<String>(relPath);
    if (!nullToAbsent || localHash != null) {
      map['local_hash'] = Variable<String>(localHash);
    }
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    if (!nullToAbsent || remoteHash != null) {
      map['remote_hash'] = Variable<String>(remoteHash);
    }
    if (!nullToAbsent || baseHash != null) {
      map['base_hash'] = Variable<String>(baseHash);
    }
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt);
    }
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(
      id: Value(id),
      accountId: Value(accountId),
      relPath: Value(relPath),
      localHash: localHash == null && nullToAbsent
          ? const Value.absent()
          : Value(localHash),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      remoteHash: remoteHash == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteHash),
      baseHash: baseHash == null && nullToAbsent
          ? const Value.absent()
          : Value(baseHash),
      state: Value(state),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory SyncStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateData(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      relPath: serializer.fromJson<String>(json['relPath']),
      localHash: serializer.fromJson<String?>(json['localHash']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      remoteHash: serializer.fromJson<String?>(json['remoteHash']),
      baseHash: serializer.fromJson<String?>(json['baseHash']),
      state: serializer.fromJson<String>(json['state']),
      lastSyncedAt: serializer.fromJson<int?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'relPath': serializer.toJson<String>(relPath),
      'localHash': serializer.toJson<String?>(localHash),
      'remoteId': serializer.toJson<String?>(remoteId),
      'remoteHash': serializer.toJson<String?>(remoteHash),
      'baseHash': serializer.toJson<String?>(baseHash),
      'state': serializer.toJson<String>(state),
      'lastSyncedAt': serializer.toJson<int?>(lastSyncedAt),
    };
  }

  SyncStateData copyWith({
    int? id,
    int? accountId,
    String? relPath,
    Value<String?> localHash = const Value.absent(),
    Value<String?> remoteId = const Value.absent(),
    Value<String?> remoteHash = const Value.absent(),
    Value<String?> baseHash = const Value.absent(),
    String? state,
    Value<int?> lastSyncedAt = const Value.absent(),
  }) => SyncStateData(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    relPath: relPath ?? this.relPath,
    localHash: localHash.present ? localHash.value : this.localHash,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    remoteHash: remoteHash.present ? remoteHash.value : this.remoteHash,
    baseHash: baseHash.present ? baseHash.value : this.baseHash,
    state: state ?? this.state,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  SyncStateData copyWithCompanion(SyncStateCompanion data) {
    return SyncStateData(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      relPath: data.relPath.present ? data.relPath.value : this.relPath,
      localHash: data.localHash.present ? data.localHash.value : this.localHash,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      remoteHash: data.remoteHash.present
          ? data.remoteHash.value
          : this.remoteHash,
      baseHash: data.baseHash.present ? data.baseHash.value : this.baseHash,
      state: data.state.present ? data.state.value : this.state,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateData(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('relPath: $relPath, ')
          ..write('localHash: $localHash, ')
          ..write('remoteId: $remoteId, ')
          ..write('remoteHash: $remoteHash, ')
          ..write('baseHash: $baseHash, ')
          ..write('state: $state, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    relPath,
    localHash,
    remoteId,
    remoteHash,
    baseHash,
    state,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateData &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.relPath == this.relPath &&
          other.localHash == this.localHash &&
          other.remoteId == this.remoteId &&
          other.remoteHash == this.remoteHash &&
          other.baseHash == this.baseHash &&
          other.state == this.state &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateData> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String> relPath;
  final Value<String?> localHash;
  final Value<String?> remoteId;
  final Value<String?> remoteHash;
  final Value<String?> baseHash;
  final Value<String> state;
  final Value<int?> lastSyncedAt;
  const SyncStateCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.relPath = const Value.absent(),
    this.localHash = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.remoteHash = const Value.absent(),
    this.baseHash = const Value.absent(),
    this.state = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  });
  SyncStateCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required String relPath,
    this.localHash = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.remoteHash = const Value.absent(),
    this.baseHash = const Value.absent(),
    this.state = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  }) : accountId = Value(accountId),
       relPath = Value(relPath);
  static Insertable<SyncStateData> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? relPath,
    Expression<String>? localHash,
    Expression<String>? remoteId,
    Expression<String>? remoteHash,
    Expression<String>? baseHash,
    Expression<String>? state,
    Expression<int>? lastSyncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (relPath != null) 'rel_path': relPath,
      if (localHash != null) 'local_hash': localHash,
      if (remoteId != null) 'remote_id': remoteId,
      if (remoteHash != null) 'remote_hash': remoteHash,
      if (baseHash != null) 'base_hash': baseHash,
      if (state != null) 'state': state,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
    });
  }

  SyncStateCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<String>? relPath,
    Value<String?>? localHash,
    Value<String?>? remoteId,
    Value<String?>? remoteHash,
    Value<String?>? baseHash,
    Value<String>? state,
    Value<int?>? lastSyncedAt,
  }) {
    return SyncStateCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      relPath: relPath ?? this.relPath,
      localHash: localHash ?? this.localHash,
      remoteId: remoteId ?? this.remoteId,
      remoteHash: remoteHash ?? this.remoteHash,
      baseHash: baseHash ?? this.baseHash,
      state: state ?? this.state,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (relPath.present) {
      map['rel_path'] = Variable<String>(relPath.value);
    }
    if (localHash.present) {
      map['local_hash'] = Variable<String>(localHash.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (remoteHash.present) {
      map['remote_hash'] = Variable<String>(remoteHash.value);
    }
    if (baseHash.present) {
      map['base_hash'] = Variable<String>(baseHash.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<int>(lastSyncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('relPath: $relPath, ')
          ..write('localHash: $localHash, ')
          ..write('remoteId: $remoteId, ')
          ..write('remoteHash: $remoteHash, ')
          ..write('baseHash: $baseHash, ')
          ..write('state: $state, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }
}

class $ChangeLogTable extends ChangeLog
    with TableInfo<$ChangeLogTable, ChangeLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChangeLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityUidMeta = const VerificationMeta(
    'entityUid',
  );
  @override
  late final GeneratedColumn<String> entityUid = GeneratedColumn<String>(
    'entity_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opMeta = const VerificationMeta('op');
  @override
  late final GeneratedColumn<String> op = GeneratedColumn<String>(
    'op',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entity,
    entityUid,
    op,
    payloadJson,
    createdAt,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'change_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChangeLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity')) {
      context.handle(
        _entityMeta,
        entity.isAcceptableOrUnknown(data['entity']!, _entityMeta),
      );
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_uid')) {
      context.handle(
        _entityUidMeta,
        entityUid.isAcceptableOrUnknown(data['entity_uid']!, _entityUidMeta),
      );
    } else if (isInserting) {
      context.missing(_entityUidMeta);
    }
    if (data.containsKey('op')) {
      context.handle(_opMeta, op.isAcceptableOrUnknown(data['op']!, _opMeta));
    } else if (isInserting) {
      context.missing(_opMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChangeLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChangeLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity'],
      )!,
      entityUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_uid'],
      )!,
      op: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}op'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $ChangeLogTable createAlias(String alias) {
    return $ChangeLogTable(attachedDatabase, alias);
  }
}

class ChangeLogData extends DataClass implements Insertable<ChangeLogData> {
  final int id;
  final String entity;
  final String entityUid;
  final String op;
  final String? payloadJson;
  final int createdAt;
  final bool synced;
  const ChangeLogData({
    required this.id,
    required this.entity,
    required this.entityUid,
    required this.op,
    this.payloadJson,
    required this.createdAt,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity'] = Variable<String>(entity);
    map['entity_uid'] = Variable<String>(entityUid);
    map['op'] = Variable<String>(op);
    if (!nullToAbsent || payloadJson != null) {
      map['payload_json'] = Variable<String>(payloadJson);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  ChangeLogCompanion toCompanion(bool nullToAbsent) {
    return ChangeLogCompanion(
      id: Value(id),
      entity: Value(entity),
      entityUid: Value(entityUid),
      op: Value(op),
      payloadJson: payloadJson == null && nullToAbsent
          ? const Value.absent()
          : Value(payloadJson),
      createdAt: Value(createdAt),
      synced: Value(synced),
    );
  }

  factory ChangeLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChangeLogData(
      id: serializer.fromJson<int>(json['id']),
      entity: serializer.fromJson<String>(json['entity']),
      entityUid: serializer.fromJson<String>(json['entityUid']),
      op: serializer.fromJson<String>(json['op']),
      payloadJson: serializer.fromJson<String?>(json['payloadJson']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entity': serializer.toJson<String>(entity),
      'entityUid': serializer.toJson<String>(entityUid),
      'op': serializer.toJson<String>(op),
      'payloadJson': serializer.toJson<String?>(payloadJson),
      'createdAt': serializer.toJson<int>(createdAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  ChangeLogData copyWith({
    int? id,
    String? entity,
    String? entityUid,
    String? op,
    Value<String?> payloadJson = const Value.absent(),
    int? createdAt,
    bool? synced,
  }) => ChangeLogData(
    id: id ?? this.id,
    entity: entity ?? this.entity,
    entityUid: entityUid ?? this.entityUid,
    op: op ?? this.op,
    payloadJson: payloadJson.present ? payloadJson.value : this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    synced: synced ?? this.synced,
  );
  ChangeLogData copyWithCompanion(ChangeLogCompanion data) {
    return ChangeLogData(
      id: data.id.present ? data.id.value : this.id,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityUid: data.entityUid.present ? data.entityUid.value : this.entityUid,
      op: data.op.present ? data.op.value : this.op,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChangeLogData(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('entityUid: $entityUid, ')
          ..write('op: $op, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entity, entityUid, op, payloadJson, createdAt, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChangeLogData &&
          other.id == this.id &&
          other.entity == this.entity &&
          other.entityUid == this.entityUid &&
          other.op == this.op &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.synced == this.synced);
}

class ChangeLogCompanion extends UpdateCompanion<ChangeLogData> {
  final Value<int> id;
  final Value<String> entity;
  final Value<String> entityUid;
  final Value<String> op;
  final Value<String?> payloadJson;
  final Value<int> createdAt;
  final Value<bool> synced;
  const ChangeLogCompanion({
    this.id = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityUid = const Value.absent(),
    this.op = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
  });
  ChangeLogCompanion.insert({
    this.id = const Value.absent(),
    required String entity,
    required String entityUid,
    required String op,
    this.payloadJson = const Value.absent(),
    required int createdAt,
    this.synced = const Value.absent(),
  }) : entity = Value(entity),
       entityUid = Value(entityUid),
       op = Value(op),
       createdAt = Value(createdAt);
  static Insertable<ChangeLogData> custom({
    Expression<int>? id,
    Expression<String>? entity,
    Expression<String>? entityUid,
    Expression<String>? op,
    Expression<String>? payloadJson,
    Expression<int>? createdAt,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entity != null) 'entity': entity,
      if (entityUid != null) 'entity_uid': entityUid,
      if (op != null) 'op': op,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
    });
  }

  ChangeLogCompanion copyWith({
    Value<int>? id,
    Value<String>? entity,
    Value<String>? entityUid,
    Value<String>? op,
    Value<String?>? payloadJson,
    Value<int>? createdAt,
    Value<bool>? synced,
  }) {
    return ChangeLogCompanion(
      id: id ?? this.id,
      entity: entity ?? this.entity,
      entityUid: entityUid ?? this.entityUid,
      op: op ?? this.op,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityUid.present) {
      map['entity_uid'] = Variable<String>(entityUid.value);
    }
    if (op.present) {
      map['op'] = Variable<String>(op.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChangeLogCompanion(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('entityUid: $entityUid, ')
          ..write('op: $op, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $WatchDirsTable extends WatchDirs
    with TableInfo<$WatchDirsTable, WatchDir> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WatchDirsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _recursiveMeta = const VerificationMeta(
    'recursive',
  );
  @override
  late final GeneratedColumn<bool> recursive = GeneratedColumn<bool>(
    'recursive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("recursive" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _autoImportMeta = const VerificationMeta(
    'autoImport',
  );
  @override
  late final GeneratedColumn<bool> autoImport = GeneratedColumn<bool>(
    'auto_import',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_import" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _defaultFolderUidMeta = const VerificationMeta(
    'defaultFolderUid',
  );
  @override
  late final GeneratedColumn<String> defaultFolderUid = GeneratedColumn<String>(
    'default_folder_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _globIncludeMeta = const VerificationMeta(
    'globInclude',
  );
  @override
  late final GeneratedColumn<String> globInclude = GeneratedColumn<String>(
    'glob_include',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _globExcludeMeta = const VerificationMeta(
    'globExclude',
  );
  @override
  late final GeneratedColumn<String> globExclude = GeneratedColumn<String>(
    'glob_exclude',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    path,
    enabled,
    recursive,
    autoImport,
    defaultFolderUid,
    globInclude,
    globExclude,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'watch_dirs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WatchDir> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('recursive')) {
      context.handle(
        _recursiveMeta,
        recursive.isAcceptableOrUnknown(data['recursive']!, _recursiveMeta),
      );
    }
    if (data.containsKey('auto_import')) {
      context.handle(
        _autoImportMeta,
        autoImport.isAcceptableOrUnknown(data['auto_import']!, _autoImportMeta),
      );
    }
    if (data.containsKey('default_folder_uid')) {
      context.handle(
        _defaultFolderUidMeta,
        defaultFolderUid.isAcceptableOrUnknown(
          data['default_folder_uid']!,
          _defaultFolderUidMeta,
        ),
      );
    }
    if (data.containsKey('glob_include')) {
      context.handle(
        _globIncludeMeta,
        globInclude.isAcceptableOrUnknown(
          data['glob_include']!,
          _globIncludeMeta,
        ),
      );
    }
    if (data.containsKey('glob_exclude')) {
      context.handle(
        _globExcludeMeta,
        globExclude.isAcceptableOrUnknown(
          data['glob_exclude']!,
          _globExcludeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WatchDir map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WatchDir(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      recursive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}recursive'],
      )!,
      autoImport: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_import'],
      )!,
      defaultFolderUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_folder_uid'],
      ),
      globInclude: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}glob_include'],
      ),
      globExclude: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}glob_exclude'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WatchDirsTable createAlias(String alias) {
    return $WatchDirsTable(attachedDatabase, alias);
  }
}

class WatchDir extends DataClass implements Insertable<WatchDir> {
  final int id;
  final String path;
  final bool enabled;
  final bool recursive;
  final bool autoImport;
  final String? defaultFolderUid;

  /// Semicolon-separated `*.ext` globs; null = all recognized document types.
  final String? globInclude;
  final String? globExclude;
  final int createdAt;
  const WatchDir({
    required this.id,
    required this.path,
    required this.enabled,
    required this.recursive,
    required this.autoImport,
    this.defaultFolderUid,
    this.globInclude,
    this.globExclude,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['path'] = Variable<String>(path);
    map['enabled'] = Variable<bool>(enabled);
    map['recursive'] = Variable<bool>(recursive);
    map['auto_import'] = Variable<bool>(autoImport);
    if (!nullToAbsent || defaultFolderUid != null) {
      map['default_folder_uid'] = Variable<String>(defaultFolderUid);
    }
    if (!nullToAbsent || globInclude != null) {
      map['glob_include'] = Variable<String>(globInclude);
    }
    if (!nullToAbsent || globExclude != null) {
      map['glob_exclude'] = Variable<String>(globExclude);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  WatchDirsCompanion toCompanion(bool nullToAbsent) {
    return WatchDirsCompanion(
      id: Value(id),
      path: Value(path),
      enabled: Value(enabled),
      recursive: Value(recursive),
      autoImport: Value(autoImport),
      defaultFolderUid: defaultFolderUid == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultFolderUid),
      globInclude: globInclude == null && nullToAbsent
          ? const Value.absent()
          : Value(globInclude),
      globExclude: globExclude == null && nullToAbsent
          ? const Value.absent()
          : Value(globExclude),
      createdAt: Value(createdAt),
    );
  }

  factory WatchDir.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WatchDir(
      id: serializer.fromJson<int>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      recursive: serializer.fromJson<bool>(json['recursive']),
      autoImport: serializer.fromJson<bool>(json['autoImport']),
      defaultFolderUid: serializer.fromJson<String?>(json['defaultFolderUid']),
      globInclude: serializer.fromJson<String?>(json['globInclude']),
      globExclude: serializer.fromJson<String?>(json['globExclude']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'path': serializer.toJson<String>(path),
      'enabled': serializer.toJson<bool>(enabled),
      'recursive': serializer.toJson<bool>(recursive),
      'autoImport': serializer.toJson<bool>(autoImport),
      'defaultFolderUid': serializer.toJson<String?>(defaultFolderUid),
      'globInclude': serializer.toJson<String?>(globInclude),
      'globExclude': serializer.toJson<String?>(globExclude),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  WatchDir copyWith({
    int? id,
    String? path,
    bool? enabled,
    bool? recursive,
    bool? autoImport,
    Value<String?> defaultFolderUid = const Value.absent(),
    Value<String?> globInclude = const Value.absent(),
    Value<String?> globExclude = const Value.absent(),
    int? createdAt,
  }) => WatchDir(
    id: id ?? this.id,
    path: path ?? this.path,
    enabled: enabled ?? this.enabled,
    recursive: recursive ?? this.recursive,
    autoImport: autoImport ?? this.autoImport,
    defaultFolderUid: defaultFolderUid.present
        ? defaultFolderUid.value
        : this.defaultFolderUid,
    globInclude: globInclude.present ? globInclude.value : this.globInclude,
    globExclude: globExclude.present ? globExclude.value : this.globExclude,
    createdAt: createdAt ?? this.createdAt,
  );
  WatchDir copyWithCompanion(WatchDirsCompanion data) {
    return WatchDir(
      id: data.id.present ? data.id.value : this.id,
      path: data.path.present ? data.path.value : this.path,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      recursive: data.recursive.present ? data.recursive.value : this.recursive,
      autoImport: data.autoImport.present
          ? data.autoImport.value
          : this.autoImport,
      defaultFolderUid: data.defaultFolderUid.present
          ? data.defaultFolderUid.value
          : this.defaultFolderUid,
      globInclude: data.globInclude.present
          ? data.globInclude.value
          : this.globInclude,
      globExclude: data.globExclude.present
          ? data.globExclude.value
          : this.globExclude,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WatchDir(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('enabled: $enabled, ')
          ..write('recursive: $recursive, ')
          ..write('autoImport: $autoImport, ')
          ..write('defaultFolderUid: $defaultFolderUid, ')
          ..write('globInclude: $globInclude, ')
          ..write('globExclude: $globExclude, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    path,
    enabled,
    recursive,
    autoImport,
    defaultFolderUid,
    globInclude,
    globExclude,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WatchDir &&
          other.id == this.id &&
          other.path == this.path &&
          other.enabled == this.enabled &&
          other.recursive == this.recursive &&
          other.autoImport == this.autoImport &&
          other.defaultFolderUid == this.defaultFolderUid &&
          other.globInclude == this.globInclude &&
          other.globExclude == this.globExclude &&
          other.createdAt == this.createdAt);
}

class WatchDirsCompanion extends UpdateCompanion<WatchDir> {
  final Value<int> id;
  final Value<String> path;
  final Value<bool> enabled;
  final Value<bool> recursive;
  final Value<bool> autoImport;
  final Value<String?> defaultFolderUid;
  final Value<String?> globInclude;
  final Value<String?> globExclude;
  final Value<int> createdAt;
  const WatchDirsCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.enabled = const Value.absent(),
    this.recursive = const Value.absent(),
    this.autoImport = const Value.absent(),
    this.defaultFolderUid = const Value.absent(),
    this.globInclude = const Value.absent(),
    this.globExclude = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WatchDirsCompanion.insert({
    this.id = const Value.absent(),
    required String path,
    this.enabled = const Value.absent(),
    this.recursive = const Value.absent(),
    this.autoImport = const Value.absent(),
    this.defaultFolderUid = const Value.absent(),
    this.globInclude = const Value.absent(),
    this.globExclude = const Value.absent(),
    required int createdAt,
  }) : path = Value(path),
       createdAt = Value(createdAt);
  static Insertable<WatchDir> custom({
    Expression<int>? id,
    Expression<String>? path,
    Expression<bool>? enabled,
    Expression<bool>? recursive,
    Expression<bool>? autoImport,
    Expression<String>? defaultFolderUid,
    Expression<String>? globInclude,
    Expression<String>? globExclude,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (enabled != null) 'enabled': enabled,
      if (recursive != null) 'recursive': recursive,
      if (autoImport != null) 'auto_import': autoImport,
      if (defaultFolderUid != null) 'default_folder_uid': defaultFolderUid,
      if (globInclude != null) 'glob_include': globInclude,
      if (globExclude != null) 'glob_exclude': globExclude,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WatchDirsCompanion copyWith({
    Value<int>? id,
    Value<String>? path,
    Value<bool>? enabled,
    Value<bool>? recursive,
    Value<bool>? autoImport,
    Value<String?>? defaultFolderUid,
    Value<String?>? globInclude,
    Value<String?>? globExclude,
    Value<int>? createdAt,
  }) {
    return WatchDirsCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      enabled: enabled ?? this.enabled,
      recursive: recursive ?? this.recursive,
      autoImport: autoImport ?? this.autoImport,
      defaultFolderUid: defaultFolderUid ?? this.defaultFolderUid,
      globInclude: globInclude ?? this.globInclude,
      globExclude: globExclude ?? this.globExclude,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (recursive.present) {
      map['recursive'] = Variable<bool>(recursive.value);
    }
    if (autoImport.present) {
      map['auto_import'] = Variable<bool>(autoImport.value);
    }
    if (defaultFolderUid.present) {
      map['default_folder_uid'] = Variable<String>(defaultFolderUid.value);
    }
    if (globInclude.present) {
      map['glob_include'] = Variable<String>(globInclude.value);
    }
    if (globExclude.present) {
      map['glob_exclude'] = Variable<String>(globExclude.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WatchDirsCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('enabled: $enabled, ')
          ..write('recursive: $recursive, ')
          ..write('autoImport: $autoImport, ')
          ..write('defaultFolderUid: $defaultFolderUid, ')
          ..write('globInclude: $globInclude, ')
          ..write('globExclude: $globExclude, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WatchSuggestionsTable extends WatchSuggestions
    with TableInfo<$WatchSuggestionsTable, WatchSuggestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WatchSuggestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _srcPathMeta = const VerificationMeta(
    'srcPath',
  );
  @override
  late final GeneratedColumn<String> srcPath = GeneratedColumn<String>(
    'src_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _suggestedFolderUidMeta =
      const VerificationMeta('suggestedFolderUid');
  @override
  late final GeneratedColumn<String> suggestedFolderUid =
      GeneratedColumn<String>(
        'suggested_folder_uid',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _suggestedCategoryUidMeta =
      const VerificationMeta('suggestedCategoryUid');
  @override
  late final GeneratedColumn<String> suggestedCategoryUid =
      GeneratedColumn<String>(
        'suggested_category_uid',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _detectedAtMeta = const VerificationMeta(
    'detectedAt',
  );
  @override
  late final GeneratedColumn<int> detectedAt = GeneratedColumn<int>(
    'detected_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    srcPath,
    fileHash,
    suggestedFolderUid,
    suggestedCategoryUid,
    status,
    detectedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'watch_suggestions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WatchSuggestion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('src_path')) {
      context.handle(
        _srcPathMeta,
        srcPath.isAcceptableOrUnknown(data['src_path']!, _srcPathMeta),
      );
    } else if (isInserting) {
      context.missing(_srcPathMeta);
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    }
    if (data.containsKey('suggested_folder_uid')) {
      context.handle(
        _suggestedFolderUidMeta,
        suggestedFolderUid.isAcceptableOrUnknown(
          data['suggested_folder_uid']!,
          _suggestedFolderUidMeta,
        ),
      );
    }
    if (data.containsKey('suggested_category_uid')) {
      context.handle(
        _suggestedCategoryUidMeta,
        suggestedCategoryUid.isAcceptableOrUnknown(
          data['suggested_category_uid']!,
          _suggestedCategoryUidMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('detected_at')) {
      context.handle(
        _detectedAtMeta,
        detectedAt.isAcceptableOrUnknown(data['detected_at']!, _detectedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_detectedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WatchSuggestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WatchSuggestion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      srcPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}src_path'],
      )!,
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      ),
      suggestedFolderUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggested_folder_uid'],
      ),
      suggestedCategoryUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggested_category_uid'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      detectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}detected_at'],
      )!,
    );
  }

  @override
  $WatchSuggestionsTable createAlias(String alias) {
    return $WatchSuggestionsTable(attachedDatabase, alias);
  }
}

class WatchSuggestion extends DataClass implements Insertable<WatchSuggestion> {
  final int id;
  final String srcPath;
  final String? fileHash;
  final String? suggestedFolderUid;
  final String? suggestedCategoryUid;

  /// pending | accepted | dismissed
  final String status;
  final int detectedAt;
  const WatchSuggestion({
    required this.id,
    required this.srcPath,
    this.fileHash,
    this.suggestedFolderUid,
    this.suggestedCategoryUid,
    required this.status,
    required this.detectedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['src_path'] = Variable<String>(srcPath);
    if (!nullToAbsent || fileHash != null) {
      map['file_hash'] = Variable<String>(fileHash);
    }
    if (!nullToAbsent || suggestedFolderUid != null) {
      map['suggested_folder_uid'] = Variable<String>(suggestedFolderUid);
    }
    if (!nullToAbsent || suggestedCategoryUid != null) {
      map['suggested_category_uid'] = Variable<String>(suggestedCategoryUid);
    }
    map['status'] = Variable<String>(status);
    map['detected_at'] = Variable<int>(detectedAt);
    return map;
  }

  WatchSuggestionsCompanion toCompanion(bool nullToAbsent) {
    return WatchSuggestionsCompanion(
      id: Value(id),
      srcPath: Value(srcPath),
      fileHash: fileHash == null && nullToAbsent
          ? const Value.absent()
          : Value(fileHash),
      suggestedFolderUid: suggestedFolderUid == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedFolderUid),
      suggestedCategoryUid: suggestedCategoryUid == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedCategoryUid),
      status: Value(status),
      detectedAt: Value(detectedAt),
    );
  }

  factory WatchSuggestion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WatchSuggestion(
      id: serializer.fromJson<int>(json['id']),
      srcPath: serializer.fromJson<String>(json['srcPath']),
      fileHash: serializer.fromJson<String?>(json['fileHash']),
      suggestedFolderUid: serializer.fromJson<String?>(
        json['suggestedFolderUid'],
      ),
      suggestedCategoryUid: serializer.fromJson<String?>(
        json['suggestedCategoryUid'],
      ),
      status: serializer.fromJson<String>(json['status']),
      detectedAt: serializer.fromJson<int>(json['detectedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'srcPath': serializer.toJson<String>(srcPath),
      'fileHash': serializer.toJson<String?>(fileHash),
      'suggestedFolderUid': serializer.toJson<String?>(suggestedFolderUid),
      'suggestedCategoryUid': serializer.toJson<String?>(suggestedCategoryUid),
      'status': serializer.toJson<String>(status),
      'detectedAt': serializer.toJson<int>(detectedAt),
    };
  }

  WatchSuggestion copyWith({
    int? id,
    String? srcPath,
    Value<String?> fileHash = const Value.absent(),
    Value<String?> suggestedFolderUid = const Value.absent(),
    Value<String?> suggestedCategoryUid = const Value.absent(),
    String? status,
    int? detectedAt,
  }) => WatchSuggestion(
    id: id ?? this.id,
    srcPath: srcPath ?? this.srcPath,
    fileHash: fileHash.present ? fileHash.value : this.fileHash,
    suggestedFolderUid: suggestedFolderUid.present
        ? suggestedFolderUid.value
        : this.suggestedFolderUid,
    suggestedCategoryUid: suggestedCategoryUid.present
        ? suggestedCategoryUid.value
        : this.suggestedCategoryUid,
    status: status ?? this.status,
    detectedAt: detectedAt ?? this.detectedAt,
  );
  WatchSuggestion copyWithCompanion(WatchSuggestionsCompanion data) {
    return WatchSuggestion(
      id: data.id.present ? data.id.value : this.id,
      srcPath: data.srcPath.present ? data.srcPath.value : this.srcPath,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      suggestedFolderUid: data.suggestedFolderUid.present
          ? data.suggestedFolderUid.value
          : this.suggestedFolderUid,
      suggestedCategoryUid: data.suggestedCategoryUid.present
          ? data.suggestedCategoryUid.value
          : this.suggestedCategoryUid,
      status: data.status.present ? data.status.value : this.status,
      detectedAt: data.detectedAt.present
          ? data.detectedAt.value
          : this.detectedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WatchSuggestion(')
          ..write('id: $id, ')
          ..write('srcPath: $srcPath, ')
          ..write('fileHash: $fileHash, ')
          ..write('suggestedFolderUid: $suggestedFolderUid, ')
          ..write('suggestedCategoryUid: $suggestedCategoryUid, ')
          ..write('status: $status, ')
          ..write('detectedAt: $detectedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    srcPath,
    fileHash,
    suggestedFolderUid,
    suggestedCategoryUid,
    status,
    detectedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WatchSuggestion &&
          other.id == this.id &&
          other.srcPath == this.srcPath &&
          other.fileHash == this.fileHash &&
          other.suggestedFolderUid == this.suggestedFolderUid &&
          other.suggestedCategoryUid == this.suggestedCategoryUid &&
          other.status == this.status &&
          other.detectedAt == this.detectedAt);
}

class WatchSuggestionsCompanion extends UpdateCompanion<WatchSuggestion> {
  final Value<int> id;
  final Value<String> srcPath;
  final Value<String?> fileHash;
  final Value<String?> suggestedFolderUid;
  final Value<String?> suggestedCategoryUid;
  final Value<String> status;
  final Value<int> detectedAt;
  const WatchSuggestionsCompanion({
    this.id = const Value.absent(),
    this.srcPath = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.suggestedFolderUid = const Value.absent(),
    this.suggestedCategoryUid = const Value.absent(),
    this.status = const Value.absent(),
    this.detectedAt = const Value.absent(),
  });
  WatchSuggestionsCompanion.insert({
    this.id = const Value.absent(),
    required String srcPath,
    this.fileHash = const Value.absent(),
    this.suggestedFolderUid = const Value.absent(),
    this.suggestedCategoryUid = const Value.absent(),
    this.status = const Value.absent(),
    required int detectedAt,
  }) : srcPath = Value(srcPath),
       detectedAt = Value(detectedAt);
  static Insertable<WatchSuggestion> custom({
    Expression<int>? id,
    Expression<String>? srcPath,
    Expression<String>? fileHash,
    Expression<String>? suggestedFolderUid,
    Expression<String>? suggestedCategoryUid,
    Expression<String>? status,
    Expression<int>? detectedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (srcPath != null) 'src_path': srcPath,
      if (fileHash != null) 'file_hash': fileHash,
      if (suggestedFolderUid != null)
        'suggested_folder_uid': suggestedFolderUid,
      if (suggestedCategoryUid != null)
        'suggested_category_uid': suggestedCategoryUid,
      if (status != null) 'status': status,
      if (detectedAt != null) 'detected_at': detectedAt,
    });
  }

  WatchSuggestionsCompanion copyWith({
    Value<int>? id,
    Value<String>? srcPath,
    Value<String?>? fileHash,
    Value<String?>? suggestedFolderUid,
    Value<String?>? suggestedCategoryUid,
    Value<String>? status,
    Value<int>? detectedAt,
  }) {
    return WatchSuggestionsCompanion(
      id: id ?? this.id,
      srcPath: srcPath ?? this.srcPath,
      fileHash: fileHash ?? this.fileHash,
      suggestedFolderUid: suggestedFolderUid ?? this.suggestedFolderUid,
      suggestedCategoryUid: suggestedCategoryUid ?? this.suggestedCategoryUid,
      status: status ?? this.status,
      detectedAt: detectedAt ?? this.detectedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (srcPath.present) {
      map['src_path'] = Variable<String>(srcPath.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (suggestedFolderUid.present) {
      map['suggested_folder_uid'] = Variable<String>(suggestedFolderUid.value);
    }
    if (suggestedCategoryUid.present) {
      map['suggested_category_uid'] = Variable<String>(
        suggestedCategoryUid.value,
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (detectedAt.present) {
      map['detected_at'] = Variable<int>(detectedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WatchSuggestionsCompanion(')
          ..write('id: $id, ')
          ..write('srcPath: $srcPath, ')
          ..write('fileHash: $fileHash, ')
          ..write('suggestedFolderUid: $suggestedFolderUid, ')
          ..write('suggestedCategoryUid: $suggestedCategoryUid, ')
          ..write('status: $status, ')
          ..write('detectedAt: $detectedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $FoldersTable folders = $FoldersTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $LabelsTable labels = $LabelsTable(this);
  late final $DocumentsTable documents = $DocumentsTable(this);
  late final $DocumentTagsTable documentTags = $DocumentTagsTable(this);
  late final $DocumentLabelsTable documentLabels = $DocumentLabelsTable(this);
  late final $TrashMetaTable trashMeta = $TrashMetaTable(this);
  late final $DocumentTextTable documentText = $DocumentTextTable(this);
  late final $SmartFoldersTable smartFolders = $SmartFoldersTable(this);
  late final $SyncAccountsTable syncAccounts = $SyncAccountsTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  late final $ChangeLogTable changeLog = $ChangeLogTable(this);
  late final $WatchDirsTable watchDirs = $WatchDirsTable(this);
  late final $WatchSuggestionsTable watchSuggestions = $WatchSuggestionsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettings,
    folders,
    categories,
    tags,
    labels,
    documents,
    documentTags,
    documentLabels,
    trashMeta,
    documentText,
    smartFolders,
    syncAccounts,
    syncState,
    changeLog,
    watchDirs,
    watchSuggestions,
  ];
}

typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      Value<String?> value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String?> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$FoldersTableCreateCompanionBuilder =
    FoldersCompanion Function({
      required String uid,
      required int createdAt,
      required int updatedAt,
      Value<bool> deleted,
      Value<int> revision,
      Value<int> id,
      Value<String?> parentUid,
      required String name,
      Value<String?> color,
      Value<int> sortOrder,
    });
typedef $$FoldersTableUpdateCompanionBuilder =
    FoldersCompanion Function({
      Value<String> uid,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> deleted,
      Value<int> revision,
      Value<int> id,
      Value<String?> parentUid,
      Value<String> name,
      Value<String?> color,
      Value<int> sortOrder,
    });

class $$FoldersTableFilterComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentUid => $composableBuilder(
    column: $table.parentUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoldersTableOrderingComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentUid => $composableBuilder(
    column: $table.parentUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoldersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get parentUid =>
      $composableBuilder(column: $table.parentUid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$FoldersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoldersTable,
          Folder,
          $$FoldersTableFilterComposer,
          $$FoldersTableOrderingComposer,
          $$FoldersTableAnnotationComposer,
          $$FoldersTableCreateCompanionBuilder,
          $$FoldersTableUpdateCompanionBuilder,
          (Folder, BaseReferences<_$AppDatabase, $FoldersTable, Folder>),
          Folder,
          PrefetchHooks Function()
        > {
  $$FoldersTableTableManager(_$AppDatabase db, $FoldersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uid = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String?> parentUid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => FoldersCompanion(
                uid: uid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                revision: revision,
                id: id,
                parentUid: parentUid,
                name: name,
                color: color,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                required String uid,
                required int createdAt,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String?> parentUid = const Value.absent(),
                required String name,
                Value<String?> color = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => FoldersCompanion.insert(
                uid: uid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                revision: revision,
                id: id,
                parentUid: parentUid,
                name: name,
                color: color,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoldersTable,
      Folder,
      $$FoldersTableFilterComposer,
      $$FoldersTableOrderingComposer,
      $$FoldersTableAnnotationComposer,
      $$FoldersTableCreateCompanionBuilder,
      $$FoldersTableUpdateCompanionBuilder,
      (Folder, BaseReferences<_$AppDatabase, $FoldersTable, Folder>),
      Folder,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String uid,
      required int createdAt,
      required int updatedAt,
      Value<bool> deleted,
      Value<int> revision,
      Value<int> id,
      required String name,
      Value<String?> icon,
      Value<String?> color,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> uid,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> deleted,
      Value<int> revision,
      Value<int> id,
      Value<String> name,
      Value<String?> icon,
      Value<String?> color,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uid = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
              }) => CategoriesCompanion(
                uid: uid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                revision: revision,
                id: id,
                name: name,
                icon: icon,
                color: color,
              ),
          createCompanionCallback:
              ({
                required String uid,
                required int createdAt,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
              }) => CategoriesCompanion.insert(
                uid: uid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                revision: revision,
                id: id,
                name: name,
                icon: icon,
                color: color,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      required String uid,
      required int createdAt,
      required int updatedAt,
      Value<bool> deleted,
      Value<int> revision,
      Value<int> id,
      required String name,
      Value<String?> color,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<String> uid,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> deleted,
      Value<int> revision,
      Value<int> id,
      Value<String> name,
      Value<String?> color,
    });

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
          Tag,
          PrefetchHooks Function()
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uid = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> color = const Value.absent(),
              }) => TagsCompanion(
                uid: uid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                revision: revision,
                id: id,
                name: name,
                color: color,
              ),
          createCompanionCallback:
              ({
                required String uid,
                required int createdAt,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> color = const Value.absent(),
              }) => TagsCompanion.insert(
                uid: uid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                revision: revision,
                id: id,
                name: name,
                color: color,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
      Tag,
      PrefetchHooks Function()
    >;
typedef $$LabelsTableCreateCompanionBuilder =
    LabelsCompanion Function({
      required String uid,
      required int createdAt,
      required int updatedAt,
      Value<bool> deleted,
      Value<int> revision,
      Value<int> id,
      required String name,
      Value<String?> color,
      Value<String?> kind,
    });
typedef $$LabelsTableUpdateCompanionBuilder =
    LabelsCompanion Function({
      Value<String> uid,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> deleted,
      Value<int> revision,
      Value<int> id,
      Value<String> name,
      Value<String?> color,
      Value<String?> kind,
    });

class $$LabelsTableFilterComposer
    extends Composer<_$AppDatabase, $LabelsTable> {
  $$LabelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LabelsTableOrderingComposer
    extends Composer<_$AppDatabase, $LabelsTable> {
  $$LabelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LabelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LabelsTable> {
  $$LabelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);
}

class $$LabelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LabelsTable,
          Label,
          $$LabelsTableFilterComposer,
          $$LabelsTableOrderingComposer,
          $$LabelsTableAnnotationComposer,
          $$LabelsTableCreateCompanionBuilder,
          $$LabelsTableUpdateCompanionBuilder,
          (Label, BaseReferences<_$AppDatabase, $LabelsTable, Label>),
          Label,
          PrefetchHooks Function()
        > {
  $$LabelsTableTableManager(_$AppDatabase db, $LabelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LabelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LabelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LabelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uid = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> kind = const Value.absent(),
              }) => LabelsCompanion(
                uid: uid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                revision: revision,
                id: id,
                name: name,
                color: color,
                kind: kind,
              ),
          createCompanionCallback:
              ({
                required String uid,
                required int createdAt,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> color = const Value.absent(),
                Value<String?> kind = const Value.absent(),
              }) => LabelsCompanion.insert(
                uid: uid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                revision: revision,
                id: id,
                name: name,
                color: color,
                kind: kind,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LabelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LabelsTable,
      Label,
      $$LabelsTableFilterComposer,
      $$LabelsTableOrderingComposer,
      $$LabelsTableAnnotationComposer,
      $$LabelsTableCreateCompanionBuilder,
      $$LabelsTableUpdateCompanionBuilder,
      (Label, BaseReferences<_$AppDatabase, $LabelsTable, Label>),
      Label,
      PrefetchHooks Function()
    >;
typedef $$DocumentsTableCreateCompanionBuilder =
    DocumentsCompanion Function({
      required String uid,
      required int createdAt,
      required int updatedAt,
      Value<bool> deleted,
      Value<int> revision,
      Value<int> id,
      Value<String?> folderUid,
      Value<String?> categoryUid,
      required String title,
      required String originalName,
      Value<String?> ext,
      Value<String?> mime,
      Value<String> docType,
      required String relPath,
      Value<int> sizeBytes,
      required String contentHash,
      Value<String?> encHash,
      Value<bool> isEncrypted,
      Value<String> ocrStatus,
      Value<bool> starred,
      required int importedAt,
      Value<int?> fileMtime,
      Value<int?> deletedAt,
    });
typedef $$DocumentsTableUpdateCompanionBuilder =
    DocumentsCompanion Function({
      Value<String> uid,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> deleted,
      Value<int> revision,
      Value<int> id,
      Value<String?> folderUid,
      Value<String?> categoryUid,
      Value<String> title,
      Value<String> originalName,
      Value<String?> ext,
      Value<String?> mime,
      Value<String> docType,
      Value<String> relPath,
      Value<int> sizeBytes,
      Value<String> contentHash,
      Value<String?> encHash,
      Value<bool> isEncrypted,
      Value<String> ocrStatus,
      Value<bool> starred,
      Value<int> importedAt,
      Value<int?> fileMtime,
      Value<int?> deletedAt,
    });

class $$DocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folderUid => $composableBuilder(
    column: $table.folderUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryUid => $composableBuilder(
    column: $table.categoryUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ext => $composableBuilder(
    column: $table.ext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mime => $composableBuilder(
    column: $table.mime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get docType => $composableBuilder(
    column: $table.docType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relPath => $composableBuilder(
    column: $table.relPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encHash => $composableBuilder(
    column: $table.encHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEncrypted => $composableBuilder(
    column: $table.isEncrypted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ocrStatus => $composableBuilder(
    column: $table.ocrStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get starred => $composableBuilder(
    column: $table.starred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileMtime => $composableBuilder(
    column: $table.fileMtime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folderUid => $composableBuilder(
    column: $table.folderUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryUid => $composableBuilder(
    column: $table.categoryUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ext => $composableBuilder(
    column: $table.ext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mime => $composableBuilder(
    column: $table.mime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get docType => $composableBuilder(
    column: $table.docType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relPath => $composableBuilder(
    column: $table.relPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encHash => $composableBuilder(
    column: $table.encHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEncrypted => $composableBuilder(
    column: $table.isEncrypted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ocrStatus => $composableBuilder(
    column: $table.ocrStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get starred => $composableBuilder(
    column: $table.starred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileMtime => $composableBuilder(
    column: $table.fileMtime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get folderUid =>
      $composableBuilder(column: $table.folderUid, builder: (column) => column);

  GeneratedColumn<String> get categoryUid => $composableBuilder(
    column: $table.categoryUid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get originalName => $composableBuilder(
    column: $table.originalName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ext =>
      $composableBuilder(column: $table.ext, builder: (column) => column);

  GeneratedColumn<String> get mime =>
      $composableBuilder(column: $table.mime, builder: (column) => column);

  GeneratedColumn<String> get docType =>
      $composableBuilder(column: $table.docType, builder: (column) => column);

  GeneratedColumn<String> get relPath =>
      $composableBuilder(column: $table.relPath, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get encHash =>
      $composableBuilder(column: $table.encHash, builder: (column) => column);

  GeneratedColumn<bool> get isEncrypted => $composableBuilder(
    column: $table.isEncrypted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ocrStatus =>
      $composableBuilder(column: $table.ocrStatus, builder: (column) => column);

  GeneratedColumn<bool> get starred =>
      $composableBuilder(column: $table.starred, builder: (column) => column);

  GeneratedColumn<int> get importedAt => $composableBuilder(
    column: $table.importedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileMtime =>
      $composableBuilder(column: $table.fileMtime, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$DocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentsTable,
          Document,
          $$DocumentsTableFilterComposer,
          $$DocumentsTableOrderingComposer,
          $$DocumentsTableAnnotationComposer,
          $$DocumentsTableCreateCompanionBuilder,
          $$DocumentsTableUpdateCompanionBuilder,
          (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
          Document,
          PrefetchHooks Function()
        > {
  $$DocumentsTableTableManager(_$AppDatabase db, $DocumentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uid = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String?> folderUid = const Value.absent(),
                Value<String?> categoryUid = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> originalName = const Value.absent(),
                Value<String?> ext = const Value.absent(),
                Value<String?> mime = const Value.absent(),
                Value<String> docType = const Value.absent(),
                Value<String> relPath = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<String> contentHash = const Value.absent(),
                Value<String?> encHash = const Value.absent(),
                Value<bool> isEncrypted = const Value.absent(),
                Value<String> ocrStatus = const Value.absent(),
                Value<bool> starred = const Value.absent(),
                Value<int> importedAt = const Value.absent(),
                Value<int?> fileMtime = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
              }) => DocumentsCompanion(
                uid: uid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                revision: revision,
                id: id,
                folderUid: folderUid,
                categoryUid: categoryUid,
                title: title,
                originalName: originalName,
                ext: ext,
                mime: mime,
                docType: docType,
                relPath: relPath,
                sizeBytes: sizeBytes,
                contentHash: contentHash,
                encHash: encHash,
                isEncrypted: isEncrypted,
                ocrStatus: ocrStatus,
                starred: starred,
                importedAt: importedAt,
                fileMtime: fileMtime,
                deletedAt: deletedAt,
              ),
          createCompanionCallback:
              ({
                required String uid,
                required int createdAt,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String?> folderUid = const Value.absent(),
                Value<String?> categoryUid = const Value.absent(),
                required String title,
                required String originalName,
                Value<String?> ext = const Value.absent(),
                Value<String?> mime = const Value.absent(),
                Value<String> docType = const Value.absent(),
                required String relPath,
                Value<int> sizeBytes = const Value.absent(),
                required String contentHash,
                Value<String?> encHash = const Value.absent(),
                Value<bool> isEncrypted = const Value.absent(),
                Value<String> ocrStatus = const Value.absent(),
                Value<bool> starred = const Value.absent(),
                required int importedAt,
                Value<int?> fileMtime = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
              }) => DocumentsCompanion.insert(
                uid: uid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                revision: revision,
                id: id,
                folderUid: folderUid,
                categoryUid: categoryUid,
                title: title,
                originalName: originalName,
                ext: ext,
                mime: mime,
                docType: docType,
                relPath: relPath,
                sizeBytes: sizeBytes,
                contentHash: contentHash,
                encHash: encHash,
                isEncrypted: isEncrypted,
                ocrStatus: ocrStatus,
                starred: starred,
                importedAt: importedAt,
                fileMtime: fileMtime,
                deletedAt: deletedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentsTable,
      Document,
      $$DocumentsTableFilterComposer,
      $$DocumentsTableOrderingComposer,
      $$DocumentsTableAnnotationComposer,
      $$DocumentsTableCreateCompanionBuilder,
      $$DocumentsTableUpdateCompanionBuilder,
      (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
      Document,
      PrefetchHooks Function()
    >;
typedef $$DocumentTagsTableCreateCompanionBuilder =
    DocumentTagsCompanion Function({
      required String documentUid,
      required String tagUid,
      required int createdAt,
      required int updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$DocumentTagsTableUpdateCompanionBuilder =
    DocumentTagsCompanion Function({
      Value<String> documentUid,
      Value<String> tagUid,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$DocumentTagsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentTagsTable> {
  $$DocumentTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get documentUid => $composableBuilder(
    column: $table.documentUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagUid => $composableBuilder(
    column: $table.tagUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DocumentTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentTagsTable> {
  $$DocumentTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get documentUid => $composableBuilder(
    column: $table.documentUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagUid => $composableBuilder(
    column: $table.tagUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentTagsTable> {
  $$DocumentTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get documentUid => $composableBuilder(
    column: $table.documentUid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tagUid =>
      $composableBuilder(column: $table.tagUid, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$DocumentTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentTagsTable,
          DocumentTag,
          $$DocumentTagsTableFilterComposer,
          $$DocumentTagsTableOrderingComposer,
          $$DocumentTagsTableAnnotationComposer,
          $$DocumentTagsTableCreateCompanionBuilder,
          $$DocumentTagsTableUpdateCompanionBuilder,
          (
            DocumentTag,
            BaseReferences<_$AppDatabase, $DocumentTagsTable, DocumentTag>,
          ),
          DocumentTag,
          PrefetchHooks Function()
        > {
  $$DocumentTagsTableTableManager(_$AppDatabase db, $DocumentTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> documentUid = const Value.absent(),
                Value<String> tagUid = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentTagsCompanion(
                documentUid: documentUid,
                tagUid: tagUid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String documentUid,
                required String tagUid,
                required int createdAt,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentTagsCompanion.insert(
                documentUid: documentUid,
                tagUid: tagUid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DocumentTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentTagsTable,
      DocumentTag,
      $$DocumentTagsTableFilterComposer,
      $$DocumentTagsTableOrderingComposer,
      $$DocumentTagsTableAnnotationComposer,
      $$DocumentTagsTableCreateCompanionBuilder,
      $$DocumentTagsTableUpdateCompanionBuilder,
      (
        DocumentTag,
        BaseReferences<_$AppDatabase, $DocumentTagsTable, DocumentTag>,
      ),
      DocumentTag,
      PrefetchHooks Function()
    >;
typedef $$DocumentLabelsTableCreateCompanionBuilder =
    DocumentLabelsCompanion Function({
      required String documentUid,
      required String labelUid,
      required int createdAt,
      required int updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$DocumentLabelsTableUpdateCompanionBuilder =
    DocumentLabelsCompanion Function({
      Value<String> documentUid,
      Value<String> labelUid,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$DocumentLabelsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentLabelsTable> {
  $$DocumentLabelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get documentUid => $composableBuilder(
    column: $table.documentUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get labelUid => $composableBuilder(
    column: $table.labelUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DocumentLabelsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentLabelsTable> {
  $$DocumentLabelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get documentUid => $composableBuilder(
    column: $table.documentUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get labelUid => $composableBuilder(
    column: $table.labelUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentLabelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentLabelsTable> {
  $$DocumentLabelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get documentUid => $composableBuilder(
    column: $table.documentUid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get labelUid =>
      $composableBuilder(column: $table.labelUid, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$DocumentLabelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentLabelsTable,
          DocumentLabel,
          $$DocumentLabelsTableFilterComposer,
          $$DocumentLabelsTableOrderingComposer,
          $$DocumentLabelsTableAnnotationComposer,
          $$DocumentLabelsTableCreateCompanionBuilder,
          $$DocumentLabelsTableUpdateCompanionBuilder,
          (
            DocumentLabel,
            BaseReferences<_$AppDatabase, $DocumentLabelsTable, DocumentLabel>,
          ),
          DocumentLabel,
          PrefetchHooks Function()
        > {
  $$DocumentLabelsTableTableManager(
    _$AppDatabase db,
    $DocumentLabelsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentLabelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentLabelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentLabelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> documentUid = const Value.absent(),
                Value<String> labelUid = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentLabelsCompanion(
                documentUid: documentUid,
                labelUid: labelUid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String documentUid,
                required String labelUid,
                required int createdAt,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentLabelsCompanion.insert(
                documentUid: documentUid,
                labelUid: labelUid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DocumentLabelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentLabelsTable,
      DocumentLabel,
      $$DocumentLabelsTableFilterComposer,
      $$DocumentLabelsTableOrderingComposer,
      $$DocumentLabelsTableAnnotationComposer,
      $$DocumentLabelsTableCreateCompanionBuilder,
      $$DocumentLabelsTableUpdateCompanionBuilder,
      (
        DocumentLabel,
        BaseReferences<_$AppDatabase, $DocumentLabelsTable, DocumentLabel>,
      ),
      DocumentLabel,
      PrefetchHooks Function()
    >;
typedef $$TrashMetaTableCreateCompanionBuilder =
    TrashMetaCompanion Function({
      required String documentUid,
      required int trashedAt,
      Value<String?> originFolderUid,
      Value<int?> purgeAfter,
      Value<bool> remoteDeleted,
      Value<int> rowid,
    });
typedef $$TrashMetaTableUpdateCompanionBuilder =
    TrashMetaCompanion Function({
      Value<String> documentUid,
      Value<int> trashedAt,
      Value<String?> originFolderUid,
      Value<int?> purgeAfter,
      Value<bool> remoteDeleted,
      Value<int> rowid,
    });

class $$TrashMetaTableFilterComposer
    extends Composer<_$AppDatabase, $TrashMetaTable> {
  $$TrashMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get documentUid => $composableBuilder(
    column: $table.documentUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originFolderUid => $composableBuilder(
    column: $table.originFolderUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purgeAfter => $composableBuilder(
    column: $table.purgeAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remoteDeleted => $composableBuilder(
    column: $table.remoteDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrashMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $TrashMetaTable> {
  $$TrashMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get documentUid => $composableBuilder(
    column: $table.documentUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trashedAt => $composableBuilder(
    column: $table.trashedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originFolderUid => $composableBuilder(
    column: $table.originFolderUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purgeAfter => $composableBuilder(
    column: $table.purgeAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remoteDeleted => $composableBuilder(
    column: $table.remoteDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrashMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrashMetaTable> {
  $$TrashMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get documentUid => $composableBuilder(
    column: $table.documentUid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get trashedAt =>
      $composableBuilder(column: $table.trashedAt, builder: (column) => column);

  GeneratedColumn<String> get originFolderUid => $composableBuilder(
    column: $table.originFolderUid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get purgeAfter => $composableBuilder(
    column: $table.purgeAfter,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get remoteDeleted => $composableBuilder(
    column: $table.remoteDeleted,
    builder: (column) => column,
  );
}

class $$TrashMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrashMetaTable,
          TrashMetaData,
          $$TrashMetaTableFilterComposer,
          $$TrashMetaTableOrderingComposer,
          $$TrashMetaTableAnnotationComposer,
          $$TrashMetaTableCreateCompanionBuilder,
          $$TrashMetaTableUpdateCompanionBuilder,
          (
            TrashMetaData,
            BaseReferences<_$AppDatabase, $TrashMetaTable, TrashMetaData>,
          ),
          TrashMetaData,
          PrefetchHooks Function()
        > {
  $$TrashMetaTableTableManager(_$AppDatabase db, $TrashMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrashMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrashMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrashMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> documentUid = const Value.absent(),
                Value<int> trashedAt = const Value.absent(),
                Value<String?> originFolderUid = const Value.absent(),
                Value<int?> purgeAfter = const Value.absent(),
                Value<bool> remoteDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrashMetaCompanion(
                documentUid: documentUid,
                trashedAt: trashedAt,
                originFolderUid: originFolderUid,
                purgeAfter: purgeAfter,
                remoteDeleted: remoteDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String documentUid,
                required int trashedAt,
                Value<String?> originFolderUid = const Value.absent(),
                Value<int?> purgeAfter = const Value.absent(),
                Value<bool> remoteDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrashMetaCompanion.insert(
                documentUid: documentUid,
                trashedAt: trashedAt,
                originFolderUid: originFolderUid,
                purgeAfter: purgeAfter,
                remoteDeleted: remoteDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrashMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrashMetaTable,
      TrashMetaData,
      $$TrashMetaTableFilterComposer,
      $$TrashMetaTableOrderingComposer,
      $$TrashMetaTableAnnotationComposer,
      $$TrashMetaTableCreateCompanionBuilder,
      $$TrashMetaTableUpdateCompanionBuilder,
      (
        TrashMetaData,
        BaseReferences<_$AppDatabase, $TrashMetaTable, TrashMetaData>,
      ),
      TrashMetaData,
      PrefetchHooks Function()
    >;
typedef $$DocumentTextTableCreateCompanionBuilder =
    DocumentTextCompanion Function({
      required String documentUid,
      required String source,
      Value<String?> lang,
      Value<String?> content,
      Value<int?> charCount,
      required int extractedAt,
      Value<String?> engine,
      Value<int> rowid,
    });
typedef $$DocumentTextTableUpdateCompanionBuilder =
    DocumentTextCompanion Function({
      Value<String> documentUid,
      Value<String> source,
      Value<String?> lang,
      Value<String?> content,
      Value<int?> charCount,
      Value<int> extractedAt,
      Value<String?> engine,
      Value<int> rowid,
    });

class $$DocumentTextTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentTextTable> {
  $$DocumentTextTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get documentUid => $composableBuilder(
    column: $table.documentUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get charCount => $composableBuilder(
    column: $table.charCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get extractedAt => $composableBuilder(
    column: $table.extractedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get engine => $composableBuilder(
    column: $table.engine,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DocumentTextTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentTextTable> {
  $$DocumentTextTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get documentUid => $composableBuilder(
    column: $table.documentUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get charCount => $composableBuilder(
    column: $table.charCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get extractedAt => $composableBuilder(
    column: $table.extractedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get engine => $composableBuilder(
    column: $table.engine,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DocumentTextTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentTextTable> {
  $$DocumentTextTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get documentUid => $composableBuilder(
    column: $table.documentUid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get charCount =>
      $composableBuilder(column: $table.charCount, builder: (column) => column);

  GeneratedColumn<int> get extractedAt => $composableBuilder(
    column: $table.extractedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get engine =>
      $composableBuilder(column: $table.engine, builder: (column) => column);
}

class $$DocumentTextTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentTextTable,
          DocumentTextData,
          $$DocumentTextTableFilterComposer,
          $$DocumentTextTableOrderingComposer,
          $$DocumentTextTableAnnotationComposer,
          $$DocumentTextTableCreateCompanionBuilder,
          $$DocumentTextTableUpdateCompanionBuilder,
          (
            DocumentTextData,
            BaseReferences<_$AppDatabase, $DocumentTextTable, DocumentTextData>,
          ),
          DocumentTextData,
          PrefetchHooks Function()
        > {
  $$DocumentTextTableTableManager(_$AppDatabase db, $DocumentTextTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentTextTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentTextTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentTextTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> documentUid = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> lang = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<int?> charCount = const Value.absent(),
                Value<int> extractedAt = const Value.absent(),
                Value<String?> engine = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentTextCompanion(
                documentUid: documentUid,
                source: source,
                lang: lang,
                content: content,
                charCount: charCount,
                extractedAt: extractedAt,
                engine: engine,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String documentUid,
                required String source,
                Value<String?> lang = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<int?> charCount = const Value.absent(),
                required int extractedAt,
                Value<String?> engine = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentTextCompanion.insert(
                documentUid: documentUid,
                source: source,
                lang: lang,
                content: content,
                charCount: charCount,
                extractedAt: extractedAt,
                engine: engine,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DocumentTextTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentTextTable,
      DocumentTextData,
      $$DocumentTextTableFilterComposer,
      $$DocumentTextTableOrderingComposer,
      $$DocumentTextTableAnnotationComposer,
      $$DocumentTextTableCreateCompanionBuilder,
      $$DocumentTextTableUpdateCompanionBuilder,
      (
        DocumentTextData,
        BaseReferences<_$AppDatabase, $DocumentTextTable, DocumentTextData>,
      ),
      DocumentTextData,
      PrefetchHooks Function()
    >;
typedef $$SmartFoldersTableCreateCompanionBuilder =
    SmartFoldersCompanion Function({
      required String uid,
      required int createdAt,
      required int updatedAt,
      Value<bool> deleted,
      Value<int> revision,
      Value<int> id,
      required String name,
      Value<String?> icon,
      required String queryJson,
      Value<int> sortOrder,
    });
typedef $$SmartFoldersTableUpdateCompanionBuilder =
    SmartFoldersCompanion Function({
      Value<String> uid,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<bool> deleted,
      Value<int> revision,
      Value<int> id,
      Value<String> name,
      Value<String?> icon,
      Value<String> queryJson,
      Value<int> sortOrder,
    });

class $$SmartFoldersTableFilterComposer
    extends Composer<_$AppDatabase, $SmartFoldersTable> {
  $$SmartFoldersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get queryJson => $composableBuilder(
    column: $table.queryJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SmartFoldersTableOrderingComposer
    extends Composer<_$AppDatabase, $SmartFoldersTable> {
  $$SmartFoldersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get queryJson => $composableBuilder(
    column: $table.queryJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SmartFoldersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SmartFoldersTable> {
  $$SmartFoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get queryJson =>
      $composableBuilder(column: $table.queryJson, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$SmartFoldersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SmartFoldersTable,
          SmartFolder,
          $$SmartFoldersTableFilterComposer,
          $$SmartFoldersTableOrderingComposer,
          $$SmartFoldersTableAnnotationComposer,
          $$SmartFoldersTableCreateCompanionBuilder,
          $$SmartFoldersTableUpdateCompanionBuilder,
          (
            SmartFolder,
            BaseReferences<_$AppDatabase, $SmartFoldersTable, SmartFolder>,
          ),
          SmartFolder,
          PrefetchHooks Function()
        > {
  $$SmartFoldersTableTableManager(_$AppDatabase db, $SmartFoldersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmartFoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmartFoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmartFoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uid = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String> queryJson = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => SmartFoldersCompanion(
                uid: uid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                revision: revision,
                id: id,
                name: name,
                icon: icon,
                queryJson: queryJson,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                required String uid,
                required int createdAt,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> icon = const Value.absent(),
                required String queryJson,
                Value<int> sortOrder = const Value.absent(),
              }) => SmartFoldersCompanion.insert(
                uid: uid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                revision: revision,
                id: id,
                name: name,
                icon: icon,
                queryJson: queryJson,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SmartFoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SmartFoldersTable,
      SmartFolder,
      $$SmartFoldersTableFilterComposer,
      $$SmartFoldersTableOrderingComposer,
      $$SmartFoldersTableAnnotationComposer,
      $$SmartFoldersTableCreateCompanionBuilder,
      $$SmartFoldersTableUpdateCompanionBuilder,
      (
        SmartFolder,
        BaseReferences<_$AppDatabase, $SmartFoldersTable, SmartFolder>,
      ),
      SmartFolder,
      PrefetchHooks Function()
    >;
typedef $$SyncAccountsTableCreateCompanionBuilder =
    SyncAccountsCompanion Function({
      Value<int> id,
      required String provider,
      required String accountId,
      Value<String?> displayName,
      Value<String?> rootRemoteId,
      Value<String?> deltaToken,
      Value<bool> enabled,
      Value<int?> lastSyncAt,
    });
typedef $$SyncAccountsTableUpdateCompanionBuilder =
    SyncAccountsCompanion Function({
      Value<int> id,
      Value<String> provider,
      Value<String> accountId,
      Value<String?> displayName,
      Value<String?> rootRemoteId,
      Value<String?> deltaToken,
      Value<bool> enabled,
      Value<int?> lastSyncAt,
    });

class $$SyncAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncAccountsTable> {
  $$SyncAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rootRemoteId => $composableBuilder(
    column: $table.rootRemoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deltaToken => $composableBuilder(
    column: $table.deltaToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncAccountsTable> {
  $$SyncAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rootRemoteId => $composableBuilder(
    column: $table.rootRemoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deltaToken => $composableBuilder(
    column: $table.deltaToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncAccountsTable> {
  $$SyncAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rootRemoteId => $composableBuilder(
    column: $table.rootRemoteId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deltaToken => $composableBuilder(
    column: $table.deltaToken,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );
}

class $$SyncAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncAccountsTable,
          SyncAccount,
          $$SyncAccountsTableFilterComposer,
          $$SyncAccountsTableOrderingComposer,
          $$SyncAccountsTableAnnotationComposer,
          $$SyncAccountsTableCreateCompanionBuilder,
          $$SyncAccountsTableUpdateCompanionBuilder,
          (
            SyncAccount,
            BaseReferences<_$AppDatabase, $SyncAccountsTable, SyncAccount>,
          ),
          SyncAccount,
          PrefetchHooks Function()
        > {
  $$SyncAccountsTableTableManager(_$AppDatabase db, $SyncAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> rootRemoteId = const Value.absent(),
                Value<String?> deltaToken = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int?> lastSyncAt = const Value.absent(),
              }) => SyncAccountsCompanion(
                id: id,
                provider: provider,
                accountId: accountId,
                displayName: displayName,
                rootRemoteId: rootRemoteId,
                deltaToken: deltaToken,
                enabled: enabled,
                lastSyncAt: lastSyncAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String provider,
                required String accountId,
                Value<String?> displayName = const Value.absent(),
                Value<String?> rootRemoteId = const Value.absent(),
                Value<String?> deltaToken = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int?> lastSyncAt = const Value.absent(),
              }) => SyncAccountsCompanion.insert(
                id: id,
                provider: provider,
                accountId: accountId,
                displayName: displayName,
                rootRemoteId: rootRemoteId,
                deltaToken: deltaToken,
                enabled: enabled,
                lastSyncAt: lastSyncAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncAccountsTable,
      SyncAccount,
      $$SyncAccountsTableFilterComposer,
      $$SyncAccountsTableOrderingComposer,
      $$SyncAccountsTableAnnotationComposer,
      $$SyncAccountsTableCreateCompanionBuilder,
      $$SyncAccountsTableUpdateCompanionBuilder,
      (
        SyncAccount,
        BaseReferences<_$AppDatabase, $SyncAccountsTable, SyncAccount>,
      ),
      SyncAccount,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder =
    SyncStateCompanion Function({
      Value<int> id,
      required int accountId,
      required String relPath,
      Value<String?> localHash,
      Value<String?> remoteId,
      Value<String?> remoteHash,
      Value<String?> baseHash,
      Value<String> state,
      Value<int?> lastSyncedAt,
    });
typedef $$SyncStateTableUpdateCompanionBuilder =
    SyncStateCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<String> relPath,
      Value<String?> localHash,
      Value<String?> remoteId,
      Value<String?> remoteHash,
      Value<String?> baseHash,
      Value<String> state,
      Value<int?> lastSyncedAt,
    });

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relPath => $composableBuilder(
    column: $table.relPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localHash => $composableBuilder(
    column: $table.localHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteHash => $composableBuilder(
    column: $table.remoteHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseHash => $composableBuilder(
    column: $table.baseHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relPath => $composableBuilder(
    column: $table.relPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localHash => $composableBuilder(
    column: $table.localHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteHash => $composableBuilder(
    column: $table.remoteHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseHash => $composableBuilder(
    column: $table.baseHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get relPath =>
      $composableBuilder(column: $table.relPath, builder: (column) => column);

  GeneratedColumn<String> get localHash =>
      $composableBuilder(column: $table.localHash, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get remoteHash => $composableBuilder(
    column: $table.remoteHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baseHash =>
      $composableBuilder(column: $table.baseHash, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncStateData,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateData,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
          ),
          SyncStateData,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String> relPath = const Value.absent(),
                Value<String?> localHash = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String?> remoteHash = const Value.absent(),
                Value<String?> baseHash = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int?> lastSyncedAt = const Value.absent(),
              }) => SyncStateCompanion(
                id: id,
                accountId: accountId,
                relPath: relPath,
                localHash: localHash,
                remoteId: remoteId,
                remoteHash: remoteHash,
                baseHash: baseHash,
                state: state,
                lastSyncedAt: lastSyncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required String relPath,
                Value<String?> localHash = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String?> remoteHash = const Value.absent(),
                Value<String?> baseHash = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int?> lastSyncedAt = const Value.absent(),
              }) => SyncStateCompanion.insert(
                id: id,
                accountId: accountId,
                relPath: relPath,
                localHash: localHash,
                remoteId: remoteId,
                remoteHash: remoteHash,
                baseHash: baseHash,
                state: state,
                lastSyncedAt: lastSyncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncStateData,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateData,
        BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>,
      ),
      SyncStateData,
      PrefetchHooks Function()
    >;
typedef $$ChangeLogTableCreateCompanionBuilder =
    ChangeLogCompanion Function({
      Value<int> id,
      required String entity,
      required String entityUid,
      required String op,
      Value<String?> payloadJson,
      required int createdAt,
      Value<bool> synced,
    });
typedef $$ChangeLogTableUpdateCompanionBuilder =
    ChangeLogCompanion Function({
      Value<int> id,
      Value<String> entity,
      Value<String> entityUid,
      Value<String> op,
      Value<String?> payloadJson,
      Value<int> createdAt,
      Value<bool> synced,
    });

class $$ChangeLogTableFilterComposer
    extends Composer<_$AppDatabase, $ChangeLogTable> {
  $$ChangeLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityUid => $composableBuilder(
    column: $table.entityUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChangeLogTableOrderingComposer
    extends Composer<_$AppDatabase, $ChangeLogTable> {
  $$ChangeLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entity => $composableBuilder(
    column: $table.entity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityUid => $composableBuilder(
    column: $table.entityUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get op => $composableBuilder(
    column: $table.op,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChangeLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChangeLogTable> {
  $$ChangeLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityUid =>
      $composableBuilder(column: $table.entityUid, builder: (column) => column);

  GeneratedColumn<String> get op =>
      $composableBuilder(column: $table.op, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$ChangeLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChangeLogTable,
          ChangeLogData,
          $$ChangeLogTableFilterComposer,
          $$ChangeLogTableOrderingComposer,
          $$ChangeLogTableAnnotationComposer,
          $$ChangeLogTableCreateCompanionBuilder,
          $$ChangeLogTableUpdateCompanionBuilder,
          (
            ChangeLogData,
            BaseReferences<_$AppDatabase, $ChangeLogTable, ChangeLogData>,
          ),
          ChangeLogData,
          PrefetchHooks Function()
        > {
  $$ChangeLogTableTableManager(_$AppDatabase db, $ChangeLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChangeLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChangeLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChangeLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> entityUid = const Value.absent(),
                Value<String> op = const Value.absent(),
                Value<String?> payloadJson = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => ChangeLogCompanion(
                id: id,
                entity: entity,
                entityUid: entityUid,
                op: op,
                payloadJson: payloadJson,
                createdAt: createdAt,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entity,
                required String entityUid,
                required String op,
                Value<String?> payloadJson = const Value.absent(),
                required int createdAt,
                Value<bool> synced = const Value.absent(),
              }) => ChangeLogCompanion.insert(
                id: id,
                entity: entity,
                entityUid: entityUid,
                op: op,
                payloadJson: payloadJson,
                createdAt: createdAt,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChangeLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChangeLogTable,
      ChangeLogData,
      $$ChangeLogTableFilterComposer,
      $$ChangeLogTableOrderingComposer,
      $$ChangeLogTableAnnotationComposer,
      $$ChangeLogTableCreateCompanionBuilder,
      $$ChangeLogTableUpdateCompanionBuilder,
      (
        ChangeLogData,
        BaseReferences<_$AppDatabase, $ChangeLogTable, ChangeLogData>,
      ),
      ChangeLogData,
      PrefetchHooks Function()
    >;
typedef $$WatchDirsTableCreateCompanionBuilder =
    WatchDirsCompanion Function({
      Value<int> id,
      required String path,
      Value<bool> enabled,
      Value<bool> recursive,
      Value<bool> autoImport,
      Value<String?> defaultFolderUid,
      Value<String?> globInclude,
      Value<String?> globExclude,
      required int createdAt,
    });
typedef $$WatchDirsTableUpdateCompanionBuilder =
    WatchDirsCompanion Function({
      Value<int> id,
      Value<String> path,
      Value<bool> enabled,
      Value<bool> recursive,
      Value<bool> autoImport,
      Value<String?> defaultFolderUid,
      Value<String?> globInclude,
      Value<String?> globExclude,
      Value<int> createdAt,
    });

class $$WatchDirsTableFilterComposer
    extends Composer<_$AppDatabase, $WatchDirsTable> {
  $$WatchDirsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get recursive => $composableBuilder(
    column: $table.recursive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoImport => $composableBuilder(
    column: $table.autoImport,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultFolderUid => $composableBuilder(
    column: $table.defaultFolderUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get globInclude => $composableBuilder(
    column: $table.globInclude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get globExclude => $composableBuilder(
    column: $table.globExclude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WatchDirsTableOrderingComposer
    extends Composer<_$AppDatabase, $WatchDirsTable> {
  $$WatchDirsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get recursive => $composableBuilder(
    column: $table.recursive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoImport => $composableBuilder(
    column: $table.autoImport,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultFolderUid => $composableBuilder(
    column: $table.defaultFolderUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get globInclude => $composableBuilder(
    column: $table.globInclude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get globExclude => $composableBuilder(
    column: $table.globExclude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WatchDirsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WatchDirsTable> {
  $$WatchDirsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get recursive =>
      $composableBuilder(column: $table.recursive, builder: (column) => column);

  GeneratedColumn<bool> get autoImport => $composableBuilder(
    column: $table.autoImport,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultFolderUid => $composableBuilder(
    column: $table.defaultFolderUid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get globInclude => $composableBuilder(
    column: $table.globInclude,
    builder: (column) => column,
  );

  GeneratedColumn<String> get globExclude => $composableBuilder(
    column: $table.globExclude,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WatchDirsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WatchDirsTable,
          WatchDir,
          $$WatchDirsTableFilterComposer,
          $$WatchDirsTableOrderingComposer,
          $$WatchDirsTableAnnotationComposer,
          $$WatchDirsTableCreateCompanionBuilder,
          $$WatchDirsTableUpdateCompanionBuilder,
          (WatchDir, BaseReferences<_$AppDatabase, $WatchDirsTable, WatchDir>),
          WatchDir,
          PrefetchHooks Function()
        > {
  $$WatchDirsTableTableManager(_$AppDatabase db, $WatchDirsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WatchDirsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WatchDirsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WatchDirsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> recursive = const Value.absent(),
                Value<bool> autoImport = const Value.absent(),
                Value<String?> defaultFolderUid = const Value.absent(),
                Value<String?> globInclude = const Value.absent(),
                Value<String?> globExclude = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => WatchDirsCompanion(
                id: id,
                path: path,
                enabled: enabled,
                recursive: recursive,
                autoImport: autoImport,
                defaultFolderUid: defaultFolderUid,
                globInclude: globInclude,
                globExclude: globExclude,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String path,
                Value<bool> enabled = const Value.absent(),
                Value<bool> recursive = const Value.absent(),
                Value<bool> autoImport = const Value.absent(),
                Value<String?> defaultFolderUid = const Value.absent(),
                Value<String?> globInclude = const Value.absent(),
                Value<String?> globExclude = const Value.absent(),
                required int createdAt,
              }) => WatchDirsCompanion.insert(
                id: id,
                path: path,
                enabled: enabled,
                recursive: recursive,
                autoImport: autoImport,
                defaultFolderUid: defaultFolderUid,
                globInclude: globInclude,
                globExclude: globExclude,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WatchDirsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WatchDirsTable,
      WatchDir,
      $$WatchDirsTableFilterComposer,
      $$WatchDirsTableOrderingComposer,
      $$WatchDirsTableAnnotationComposer,
      $$WatchDirsTableCreateCompanionBuilder,
      $$WatchDirsTableUpdateCompanionBuilder,
      (WatchDir, BaseReferences<_$AppDatabase, $WatchDirsTable, WatchDir>),
      WatchDir,
      PrefetchHooks Function()
    >;
typedef $$WatchSuggestionsTableCreateCompanionBuilder =
    WatchSuggestionsCompanion Function({
      Value<int> id,
      required String srcPath,
      Value<String?> fileHash,
      Value<String?> suggestedFolderUid,
      Value<String?> suggestedCategoryUid,
      Value<String> status,
      required int detectedAt,
    });
typedef $$WatchSuggestionsTableUpdateCompanionBuilder =
    WatchSuggestionsCompanion Function({
      Value<int> id,
      Value<String> srcPath,
      Value<String?> fileHash,
      Value<String?> suggestedFolderUid,
      Value<String?> suggestedCategoryUid,
      Value<String> status,
      Value<int> detectedAt,
    });

class $$WatchSuggestionsTableFilterComposer
    extends Composer<_$AppDatabase, $WatchSuggestionsTable> {
  $$WatchSuggestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get srcPath => $composableBuilder(
    column: $table.srcPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestedFolderUid => $composableBuilder(
    column: $table.suggestedFolderUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestedCategoryUid => $composableBuilder(
    column: $table.suggestedCategoryUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WatchSuggestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WatchSuggestionsTable> {
  $$WatchSuggestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get srcPath => $composableBuilder(
    column: $table.srcPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestedFolderUid => $composableBuilder(
    column: $table.suggestedFolderUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestedCategoryUid => $composableBuilder(
    column: $table.suggestedCategoryUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WatchSuggestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WatchSuggestionsTable> {
  $$WatchSuggestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get srcPath =>
      $composableBuilder(column: $table.srcPath, builder: (column) => column);

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<String> get suggestedFolderUid => $composableBuilder(
    column: $table.suggestedFolderUid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get suggestedCategoryUid => $composableBuilder(
    column: $table.suggestedCategoryUid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => column,
  );
}

class $$WatchSuggestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WatchSuggestionsTable,
          WatchSuggestion,
          $$WatchSuggestionsTableFilterComposer,
          $$WatchSuggestionsTableOrderingComposer,
          $$WatchSuggestionsTableAnnotationComposer,
          $$WatchSuggestionsTableCreateCompanionBuilder,
          $$WatchSuggestionsTableUpdateCompanionBuilder,
          (
            WatchSuggestion,
            BaseReferences<
              _$AppDatabase,
              $WatchSuggestionsTable,
              WatchSuggestion
            >,
          ),
          WatchSuggestion,
          PrefetchHooks Function()
        > {
  $$WatchSuggestionsTableTableManager(
    _$AppDatabase db,
    $WatchSuggestionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WatchSuggestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WatchSuggestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WatchSuggestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> srcPath = const Value.absent(),
                Value<String?> fileHash = const Value.absent(),
                Value<String?> suggestedFolderUid = const Value.absent(),
                Value<String?> suggestedCategoryUid = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> detectedAt = const Value.absent(),
              }) => WatchSuggestionsCompanion(
                id: id,
                srcPath: srcPath,
                fileHash: fileHash,
                suggestedFolderUid: suggestedFolderUid,
                suggestedCategoryUid: suggestedCategoryUid,
                status: status,
                detectedAt: detectedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String srcPath,
                Value<String?> fileHash = const Value.absent(),
                Value<String?> suggestedFolderUid = const Value.absent(),
                Value<String?> suggestedCategoryUid = const Value.absent(),
                Value<String> status = const Value.absent(),
                required int detectedAt,
              }) => WatchSuggestionsCompanion.insert(
                id: id,
                srcPath: srcPath,
                fileHash: fileHash,
                suggestedFolderUid: suggestedFolderUid,
                suggestedCategoryUid: suggestedCategoryUid,
                status: status,
                detectedAt: detectedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WatchSuggestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WatchSuggestionsTable,
      WatchSuggestion,
      $$WatchSuggestionsTableFilterComposer,
      $$WatchSuggestionsTableOrderingComposer,
      $$WatchSuggestionsTableAnnotationComposer,
      $$WatchSuggestionsTableCreateCompanionBuilder,
      $$WatchSuggestionsTableUpdateCompanionBuilder,
      (
        WatchSuggestion,
        BaseReferences<_$AppDatabase, $WatchSuggestionsTable, WatchSuggestion>,
      ),
      WatchSuggestion,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$FoldersTableTableManager get folders =>
      $$FoldersTableTableManager(_db, _db.folders);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$LabelsTableTableManager get labels =>
      $$LabelsTableTableManager(_db, _db.labels);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db, _db.documents);
  $$DocumentTagsTableTableManager get documentTags =>
      $$DocumentTagsTableTableManager(_db, _db.documentTags);
  $$DocumentLabelsTableTableManager get documentLabels =>
      $$DocumentLabelsTableTableManager(_db, _db.documentLabels);
  $$TrashMetaTableTableManager get trashMeta =>
      $$TrashMetaTableTableManager(_db, _db.trashMeta);
  $$DocumentTextTableTableManager get documentText =>
      $$DocumentTextTableTableManager(_db, _db.documentText);
  $$SmartFoldersTableTableManager get smartFolders =>
      $$SmartFoldersTableTableManager(_db, _db.smartFolders);
  $$SyncAccountsTableTableManager get syncAccounts =>
      $$SyncAccountsTableTableManager(_db, _db.syncAccounts);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
  $$ChangeLogTableTableManager get changeLog =>
      $$ChangeLogTableTableManager(_db, _db.changeLog);
  $$WatchDirsTableTableManager get watchDirs =>
      $$WatchDirsTableTableManager(_db, _db.watchDirs);
  $$WatchSuggestionsTableTableManager get watchSuggestions =>
      $$WatchSuggestionsTableTableManager(_db, _db.watchSuggestions);
}

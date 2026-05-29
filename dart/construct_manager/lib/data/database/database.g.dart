// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ConstructionsTableTable extends ConstructionsTable
    with TableInfo<$ConstructionsTableTable, ConstructionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConstructionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stageMeta = const VerificationMeta('stage');
  @override
  late final GeneratedColumn<String> stage = GeneratedColumn<String>(
    'stage',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responsiblesJsonMeta = const VerificationMeta(
    'responsiblesJson',
  );
  @override
  late final GeneratedColumn<String> responsiblesJson = GeneratedColumn<String>(
    'responsibles_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<String> ownerUid = GeneratedColumn<String>(
    'owner_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mapAddressMeta = const VerificationMeta(
    'mapAddress',
  );
  @override
  late final GeneratedColumn<String> mapAddress = GeneratedColumn<String>(
    'map_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _informationMeta = const VerificationMeta(
    'information',
  );
  @override
  late final GeneratedColumn<String> information = GeneratedColumn<String>(
    'information',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _budgetMeta = const VerificationMeta('budget');
  @override
  late final GeneratedColumn<double> budget = GeneratedColumn<double>(
    'budget',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedWithServerMeta = const VerificationMeta(
    'syncedWithServer',
  );
  @override
  late final GeneratedColumn<bool> syncedWithServer = GeneratedColumn<bool>(
    'synced_with_server',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced_with_server" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    uid,
    title,
    address,
    type,
    stage,
    responsiblesJson,
    ownerUid,
    mapAddress,
    information,
    createdAt,
    budget,
    syncedWithServer,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'constructions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConstructionsTableData> instance, {
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
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('stage')) {
      context.handle(
        _stageMeta,
        stage.isAcceptableOrUnknown(data['stage']!, _stageMeta),
      );
    } else if (isInserting) {
      context.missing(_stageMeta);
    }
    if (data.containsKey('responsibles_json')) {
      context.handle(
        _responsiblesJsonMeta,
        responsiblesJson.isAcceptableOrUnknown(
          data['responsibles_json']!,
          _responsiblesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_responsiblesJsonMeta);
    }
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerUidMeta);
    }
    if (data.containsKey('map_address')) {
      context.handle(
        _mapAddressMeta,
        mapAddress.isAcceptableOrUnknown(data['map_address']!, _mapAddressMeta),
      );
    } else if (isInserting) {
      context.missing(_mapAddressMeta);
    }
    if (data.containsKey('information')) {
      context.handle(
        _informationMeta,
        information.isAcceptableOrUnknown(
          data['information']!,
          _informationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_informationMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('budget')) {
      context.handle(
        _budgetMeta,
        budget.isAcceptableOrUnknown(data['budget']!, _budgetMeta),
      );
    }
    if (data.containsKey('synced_with_server')) {
      context.handle(
        _syncedWithServerMeta,
        syncedWithServer.isAcceptableOrUnknown(
          data['synced_with_server']!,
          _syncedWithServerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncedWithServerMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uid};
  @override
  ConstructionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConstructionsTableData(
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      stage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stage'],
      )!,
      responsiblesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}responsibles_json'],
      )!,
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_uid'],
      )!,
      mapAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}map_address'],
      )!,
      information: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}information'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      budget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}budget'],
      ),
      syncedWithServer: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced_with_server'],
      )!,
    );
  }

  @override
  $ConstructionsTableTable createAlias(String alias) {
    return $ConstructionsTableTable(attachedDatabase, alias);
  }
}

class ConstructionsTableData extends DataClass
    implements Insertable<ConstructionsTableData> {
  final String uid;
  final String title;
  final String address;
  final String type;
  final String stage;
  final String responsiblesJson;
  final String ownerUid;
  final String mapAddress;
  final String information;
  final DateTime? createdAt;
  final double? budget;
  final bool syncedWithServer;
  const ConstructionsTableData({
    required this.uid,
    required this.title,
    required this.address,
    required this.type,
    required this.stage,
    required this.responsiblesJson,
    required this.ownerUid,
    required this.mapAddress,
    required this.information,
    this.createdAt,
    this.budget,
    required this.syncedWithServer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    map['title'] = Variable<String>(title);
    map['address'] = Variable<String>(address);
    map['type'] = Variable<String>(type);
    map['stage'] = Variable<String>(stage);
    map['responsibles_json'] = Variable<String>(responsiblesJson);
    map['owner_uid'] = Variable<String>(ownerUid);
    map['map_address'] = Variable<String>(mapAddress);
    map['information'] = Variable<String>(information);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || budget != null) {
      map['budget'] = Variable<double>(budget);
    }
    map['synced_with_server'] = Variable<bool>(syncedWithServer);
    return map;
  }

  ConstructionsTableCompanion toCompanion(bool nullToAbsent) {
    return ConstructionsTableCompanion(
      uid: Value(uid),
      title: Value(title),
      address: Value(address),
      type: Value(type),
      stage: Value(stage),
      responsiblesJson: Value(responsiblesJson),
      ownerUid: Value(ownerUid),
      mapAddress: Value(mapAddress),
      information: Value(information),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      budget: budget == null && nullToAbsent
          ? const Value.absent()
          : Value(budget),
      syncedWithServer: Value(syncedWithServer),
    );
  }

  factory ConstructionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConstructionsTableData(
      uid: serializer.fromJson<String>(json['uid']),
      title: serializer.fromJson<String>(json['title']),
      address: serializer.fromJson<String>(json['address']),
      type: serializer.fromJson<String>(json['type']),
      stage: serializer.fromJson<String>(json['stage']),
      responsiblesJson: serializer.fromJson<String>(json['responsiblesJson']),
      ownerUid: serializer.fromJson<String>(json['ownerUid']),
      mapAddress: serializer.fromJson<String>(json['mapAddress']),
      information: serializer.fromJson<String>(json['information']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      budget: serializer.fromJson<double?>(json['budget']),
      syncedWithServer: serializer.fromJson<bool>(json['syncedWithServer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'title': serializer.toJson<String>(title),
      'address': serializer.toJson<String>(address),
      'type': serializer.toJson<String>(type),
      'stage': serializer.toJson<String>(stage),
      'responsiblesJson': serializer.toJson<String>(responsiblesJson),
      'ownerUid': serializer.toJson<String>(ownerUid),
      'mapAddress': serializer.toJson<String>(mapAddress),
      'information': serializer.toJson<String>(information),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'budget': serializer.toJson<double?>(budget),
      'syncedWithServer': serializer.toJson<bool>(syncedWithServer),
    };
  }

  ConstructionsTableData copyWith({
    String? uid,
    String? title,
    String? address,
    String? type,
    String? stage,
    String? responsiblesJson,
    String? ownerUid,
    String? mapAddress,
    String? information,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<double?> budget = const Value.absent(),
    bool? syncedWithServer,
  }) => ConstructionsTableData(
    uid: uid ?? this.uid,
    title: title ?? this.title,
    address: address ?? this.address,
    type: type ?? this.type,
    stage: stage ?? this.stage,
    responsiblesJson: responsiblesJson ?? this.responsiblesJson,
    ownerUid: ownerUid ?? this.ownerUid,
    mapAddress: mapAddress ?? this.mapAddress,
    information: information ?? this.information,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    budget: budget.present ? budget.value : this.budget,
    syncedWithServer: syncedWithServer ?? this.syncedWithServer,
  );
  ConstructionsTableData copyWithCompanion(ConstructionsTableCompanion data) {
    return ConstructionsTableData(
      uid: data.uid.present ? data.uid.value : this.uid,
      title: data.title.present ? data.title.value : this.title,
      address: data.address.present ? data.address.value : this.address,
      type: data.type.present ? data.type.value : this.type,
      stage: data.stage.present ? data.stage.value : this.stage,
      responsiblesJson: data.responsiblesJson.present
          ? data.responsiblesJson.value
          : this.responsiblesJson,
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
      mapAddress: data.mapAddress.present
          ? data.mapAddress.value
          : this.mapAddress,
      information: data.information.present
          ? data.information.value
          : this.information,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      budget: data.budget.present ? data.budget.value : this.budget,
      syncedWithServer: data.syncedWithServer.present
          ? data.syncedWithServer.value
          : this.syncedWithServer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConstructionsTableData(')
          ..write('uid: $uid, ')
          ..write('title: $title, ')
          ..write('address: $address, ')
          ..write('type: $type, ')
          ..write('stage: $stage, ')
          ..write('responsiblesJson: $responsiblesJson, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('mapAddress: $mapAddress, ')
          ..write('information: $information, ')
          ..write('createdAt: $createdAt, ')
          ..write('budget: $budget, ')
          ..write('syncedWithServer: $syncedWithServer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uid,
    title,
    address,
    type,
    stage,
    responsiblesJson,
    ownerUid,
    mapAddress,
    information,
    createdAt,
    budget,
    syncedWithServer,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConstructionsTableData &&
          other.uid == this.uid &&
          other.title == this.title &&
          other.address == this.address &&
          other.type == this.type &&
          other.stage == this.stage &&
          other.responsiblesJson == this.responsiblesJson &&
          other.ownerUid == this.ownerUid &&
          other.mapAddress == this.mapAddress &&
          other.information == this.information &&
          other.createdAt == this.createdAt &&
          other.budget == this.budget &&
          other.syncedWithServer == this.syncedWithServer);
}

class ConstructionsTableCompanion
    extends UpdateCompanion<ConstructionsTableData> {
  final Value<String> uid;
  final Value<String> title;
  final Value<String> address;
  final Value<String> type;
  final Value<String> stage;
  final Value<String> responsiblesJson;
  final Value<String> ownerUid;
  final Value<String> mapAddress;
  final Value<String> information;
  final Value<DateTime?> createdAt;
  final Value<double?> budget;
  final Value<bool> syncedWithServer;
  final Value<int> rowid;
  const ConstructionsTableCompanion({
    this.uid = const Value.absent(),
    this.title = const Value.absent(),
    this.address = const Value.absent(),
    this.type = const Value.absent(),
    this.stage = const Value.absent(),
    this.responsiblesJson = const Value.absent(),
    this.ownerUid = const Value.absent(),
    this.mapAddress = const Value.absent(),
    this.information = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.budget = const Value.absent(),
    this.syncedWithServer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConstructionsTableCompanion.insert({
    required String uid,
    required String title,
    required String address,
    required String type,
    required String stage,
    required String responsiblesJson,
    required String ownerUid,
    required String mapAddress,
    required String information,
    this.createdAt = const Value.absent(),
    this.budget = const Value.absent(),
    required bool syncedWithServer,
    this.rowid = const Value.absent(),
  }) : uid = Value(uid),
       title = Value(title),
       address = Value(address),
       type = Value(type),
       stage = Value(stage),
       responsiblesJson = Value(responsiblesJson),
       ownerUid = Value(ownerUid),
       mapAddress = Value(mapAddress),
       information = Value(information),
       syncedWithServer = Value(syncedWithServer);
  static Insertable<ConstructionsTableData> custom({
    Expression<String>? uid,
    Expression<String>? title,
    Expression<String>? address,
    Expression<String>? type,
    Expression<String>? stage,
    Expression<String>? responsiblesJson,
    Expression<String>? ownerUid,
    Expression<String>? mapAddress,
    Expression<String>? information,
    Expression<DateTime>? createdAt,
    Expression<double>? budget,
    Expression<bool>? syncedWithServer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (title != null) 'title': title,
      if (address != null) 'address': address,
      if (type != null) 'type': type,
      if (stage != null) 'stage': stage,
      if (responsiblesJson != null) 'responsibles_json': responsiblesJson,
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (mapAddress != null) 'map_address': mapAddress,
      if (information != null) 'information': information,
      if (createdAt != null) 'created_at': createdAt,
      if (budget != null) 'budget': budget,
      if (syncedWithServer != null) 'synced_with_server': syncedWithServer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConstructionsTableCompanion copyWith({
    Value<String>? uid,
    Value<String>? title,
    Value<String>? address,
    Value<String>? type,
    Value<String>? stage,
    Value<String>? responsiblesJson,
    Value<String>? ownerUid,
    Value<String>? mapAddress,
    Value<String>? information,
    Value<DateTime?>? createdAt,
    Value<double?>? budget,
    Value<bool>? syncedWithServer,
    Value<int>? rowid,
  }) {
    return ConstructionsTableCompanion(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      address: address ?? this.address,
      type: type ?? this.type,
      stage: stage ?? this.stage,
      responsiblesJson: responsiblesJson ?? this.responsiblesJson,
      ownerUid: ownerUid ?? this.ownerUid,
      mapAddress: mapAddress ?? this.mapAddress,
      information: information ?? this.information,
      createdAt: createdAt ?? this.createdAt,
      budget: budget ?? this.budget,
      syncedWithServer: syncedWithServer ?? this.syncedWithServer,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (stage.present) {
      map['stage'] = Variable<String>(stage.value);
    }
    if (responsiblesJson.present) {
      map['responsibles_json'] = Variable<String>(responsiblesJson.value);
    }
    if (ownerUid.present) {
      map['owner_uid'] = Variable<String>(ownerUid.value);
    }
    if (mapAddress.present) {
      map['map_address'] = Variable<String>(mapAddress.value);
    }
    if (information.present) {
      map['information'] = Variable<String>(information.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (budget.present) {
      map['budget'] = Variable<double>(budget.value);
    }
    if (syncedWithServer.present) {
      map['synced_with_server'] = Variable<bool>(syncedWithServer.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConstructionsTableCompanion(')
          ..write('uid: $uid, ')
          ..write('title: $title, ')
          ..write('address: $address, ')
          ..write('type: $type, ')
          ..write('stage: $stage, ')
          ..write('responsiblesJson: $responsiblesJson, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('mapAddress: $mapAddress, ')
          ..write('information: $information, ')
          ..write('createdAt: $createdAt, ')
          ..write('budget: $budget, ')
          ..write('syncedWithServer: $syncedWithServer, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ConstructionsTableTable constructionsTable =
      $ConstructionsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [constructionsTable];
}

typedef $$ConstructionsTableTableCreateCompanionBuilder =
    ConstructionsTableCompanion Function({
      required String uid,
      required String title,
      required String address,
      required String type,
      required String stage,
      required String responsiblesJson,
      required String ownerUid,
      required String mapAddress,
      required String information,
      Value<DateTime?> createdAt,
      Value<double?> budget,
      required bool syncedWithServer,
      Value<int> rowid,
    });
typedef $$ConstructionsTableTableUpdateCompanionBuilder =
    ConstructionsTableCompanion Function({
      Value<String> uid,
      Value<String> title,
      Value<String> address,
      Value<String> type,
      Value<String> stage,
      Value<String> responsiblesJson,
      Value<String> ownerUid,
      Value<String> mapAddress,
      Value<String> information,
      Value<DateTime?> createdAt,
      Value<double?> budget,
      Value<bool> syncedWithServer,
      Value<int> rowid,
    });

class $$ConstructionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ConstructionsTableTable> {
  $$ConstructionsTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responsiblesJson => $composableBuilder(
    column: $table.responsiblesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mapAddress => $composableBuilder(
    column: $table.mapAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get information => $composableBuilder(
    column: $table.information,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get budget => $composableBuilder(
    column: $table.budget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncedWithServer => $composableBuilder(
    column: $table.syncedWithServer,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConstructionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ConstructionsTableTable> {
  $$ConstructionsTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responsiblesJson => $composableBuilder(
    column: $table.responsiblesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mapAddress => $composableBuilder(
    column: $table.mapAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get information => $composableBuilder(
    column: $table.information,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get budget => $composableBuilder(
    column: $table.budget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncedWithServer => $composableBuilder(
    column: $table.syncedWithServer,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConstructionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConstructionsTableTable> {
  $$ConstructionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get stage =>
      $composableBuilder(column: $table.stage, builder: (column) => column);

  GeneratedColumn<String> get responsiblesJson => $composableBuilder(
    column: $table.responsiblesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);

  GeneratedColumn<String> get mapAddress => $composableBuilder(
    column: $table.mapAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get information => $composableBuilder(
    column: $table.information,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get budget =>
      $composableBuilder(column: $table.budget, builder: (column) => column);

  GeneratedColumn<bool> get syncedWithServer => $composableBuilder(
    column: $table.syncedWithServer,
    builder: (column) => column,
  );
}

class $$ConstructionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConstructionsTableTable,
          ConstructionsTableData,
          $$ConstructionsTableTableFilterComposer,
          $$ConstructionsTableTableOrderingComposer,
          $$ConstructionsTableTableAnnotationComposer,
          $$ConstructionsTableTableCreateCompanionBuilder,
          $$ConstructionsTableTableUpdateCompanionBuilder,
          (
            ConstructionsTableData,
            BaseReferences<
              _$AppDatabase,
              $ConstructionsTableTable,
              ConstructionsTableData
            >,
          ),
          ConstructionsTableData,
          PrefetchHooks Function()
        > {
  $$ConstructionsTableTableTableManager(
    _$AppDatabase db,
    $ConstructionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConstructionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConstructionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConstructionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> uid = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> stage = const Value.absent(),
                Value<String> responsiblesJson = const Value.absent(),
                Value<String> ownerUid = const Value.absent(),
                Value<String> mapAddress = const Value.absent(),
                Value<String> information = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<double?> budget = const Value.absent(),
                Value<bool> syncedWithServer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConstructionsTableCompanion(
                uid: uid,
                title: title,
                address: address,
                type: type,
                stage: stage,
                responsiblesJson: responsiblesJson,
                ownerUid: ownerUid,
                mapAddress: mapAddress,
                information: information,
                createdAt: createdAt,
                budget: budget,
                syncedWithServer: syncedWithServer,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uid,
                required String title,
                required String address,
                required String type,
                required String stage,
                required String responsiblesJson,
                required String ownerUid,
                required String mapAddress,
                required String information,
                Value<DateTime?> createdAt = const Value.absent(),
                Value<double?> budget = const Value.absent(),
                required bool syncedWithServer,
                Value<int> rowid = const Value.absent(),
              }) => ConstructionsTableCompanion.insert(
                uid: uid,
                title: title,
                address: address,
                type: type,
                stage: stage,
                responsiblesJson: responsiblesJson,
                ownerUid: ownerUid,
                mapAddress: mapAddress,
                information: information,
                createdAt: createdAt,
                budget: budget,
                syncedWithServer: syncedWithServer,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConstructionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConstructionsTableTable,
      ConstructionsTableData,
      $$ConstructionsTableTableFilterComposer,
      $$ConstructionsTableTableOrderingComposer,
      $$ConstructionsTableTableAnnotationComposer,
      $$ConstructionsTableTableCreateCompanionBuilder,
      $$ConstructionsTableTableUpdateCompanionBuilder,
      (
        ConstructionsTableData,
        BaseReferences<
          _$AppDatabase,
          $ConstructionsTableTable,
          ConstructionsTableData
        >,
      ),
      ConstructionsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ConstructionsTableTableTableManager get constructionsTable =>
      $$ConstructionsTableTableTableManager(_db, _db.constructionsTable);
}

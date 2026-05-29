import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/construction.dart';
import '../models/user.dart';
import 'dao/construction_dao.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [ConstructionsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  ConstructionDao get constructionDao => ConstructionDao(this);

  @override
  int get schemaVersion => 1;
}

Construction entityToModel(ConstructionsTableData entity) {
  return Construction(
    title: entity.title,
    address: entity.address,
    type: entity.type,
    stage: entity.stage,
    responsibles: (entity.responsiblesJson.isNotEmpty
            ? (const JsonDecoder().convert(entity.responsiblesJson) as List<dynamic>)
            : <dynamic>[])
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList(),
    constructionUid: entity.uid,
    ownerUid: entity.ownerUid,
    mapAddress: entity.mapAddress,
    information: entity.information,
    createdAt: entity.createdAt,
    budget: entity.budget,
  );
}

ConstructionsTableCompanion modelToEntity(Construction model, {bool synced = true}) {
  return ConstructionsTableCompanion(
    uid: Value(model.constructionUid),
    title: Value(model.title),
    address: Value(model.address),
    type: Value(model.type),
    stage: Value(model.stage),
    responsiblesJson: Value(
        const JsonEncoder().convert(model.responsibles.map((e) => e.toJson()).toList())),
    ownerUid: Value(model.ownerUid),
    mapAddress: Value(model.mapAddress),
    information: Value(model.information),
    createdAt: Value(model.createdAt),
    budget: Value(model.budget),
    syncedWithServer: Value(synced),
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'construct_manager.sqlite'));
    return NativeDatabase(file);
  });
}

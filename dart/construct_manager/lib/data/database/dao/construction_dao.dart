import 'package:drift/drift.dart';

import '../database.dart';

class ConstructionDao {
  final AppDatabase _db;

  ConstructionDao(this._db);

  Stream<List<ConstructionsTableData>> watchAll() {
    return _db.select(_db.constructionsTable).watch();
  }

  Future<List<ConstructionsTableData>> getAll() async {
    return await _db.select(_db.constructionsTable).get();
  }

  Future<ConstructionsTableData?> getById(String uid) async {
    return await (_db.select(_db.constructionsTable)
          ..where((t) => t.uid.equals(uid)))
        .getSingleOrNull();
  }

  Future<void> upsert(ConstructionsTableCompanion entity) async {
    await _db.into(_db.constructionsTable).insertOnConflictUpdate(entity);
  }

  Future<void> upsertAll(List<ConstructionsTableCompanion> entities) async {
    await _db.batch((batch) {
      for (final entity in entities) {
        batch.insert(_db.constructionsTable, entity,
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> delete(String uid) async {
    await (_db.delete(_db.constructionsTable)
          ..where((t) => t.uid.equals(uid)))
        .go();
  }

  Future<void> deleteAll() async {
    await _db.delete(_db.constructionsTable).go();
  }

  Future<int> getCount() async {
    final rows = await _db.select(_db.constructionsTable).get();
    return rows.length;
  }

  Future<List<ConstructionsTableData>> getUnsynced() async {
    return await (_db.select(_db.constructionsTable)
          ..where((t) => t.syncedWithServer.equals(false)))
        .get();
  }

  Future<void> markSynced(String uid) async {
    await (_db.update(_db.constructionsTable)
          ..where((t) => t.uid.equals(uid)))
        .write(const ConstructionsTableCompanion(syncedWithServer: Value(true)));
  }
}

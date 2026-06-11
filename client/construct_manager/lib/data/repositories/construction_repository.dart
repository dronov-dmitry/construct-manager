import '../database/database.dart';
import '../database/dao/construction_dao.dart';
import '../models/construction.dart';
import '../services/construction_service.dart';

class ConstructionRepository {
  final ConstructionService _remoteService;
  final ConstructionDao _localDao;

  ConstructionRepository(this._remoteService, this._localDao);

  Stream<List<Construction>> watchConstructions() {
    return _localDao.watchAll().map((entities) =>
        entities.map((e) => entityToModel(e)).toList());
  }

  Future<List<Construction>> getLocalConstructions() async {
    final entities = await _localDao.getAll();
    return entities.map((e) => entityToModel(e)).toList();
  }

  Future<void> syncFromServer() async {
    try {
      final remote = await _remoteService.getConstructions();
      await _localDao.deleteAll();
      await _localDao.upsertAll(
        remote.map((c) => modelToEntity(c, synced: true)).toList(),
      );
    } catch (_) {}
  }

  Future<void> createConstruction(Construction construction) async {
    await _localDao.upsert(modelToEntity(construction, synced: false));

    try {
      await _remoteService.writeConstruction(
        construction.ownerUid,
        construction.title,
        construction.address,
        construction.stage,
        construction.type,
        construction.responsibles,
        construction.constructionUid.isNotEmpty ? construction.constructionUid : null,
      );
      await _localDao.markSynced(construction.constructionUid);
    } catch (_) {}
  }

  Future<void> updateConstruction(Construction construction) async {
    await _localDao.upsert(modelToEntity(construction, synced: false));

    try {
      await _remoteService.writeConstruction(
        construction.ownerUid,
        construction.title,
        construction.address,
        construction.stage,
        construction.type,
        construction.responsibles,
        construction.constructionUid,
      );
      await _localDao.markSynced(construction.constructionUid);
    } catch (_) {}
  }

  Future<void> deleteConstruction(String constructionUid) async {
    await _localDao.delete(constructionUid);

    try {
      await _remoteService.deleteConstruction(constructionUid);
    } catch (_) {}
  }

  Future<void> advanceStage(String constructionUid, String newStage) async {
    final existing = await _localDao.getById(constructionUid);
    if (existing != null) {
      final updated = entityToModel(existing);
      updated.stage = newStage;
      await _localDao.upsert(modelToEntity(updated, synced: false));
    }

    try {
      await _remoteService.advanceStage(constructionUid, newStage);
      await _localDao.markSynced(constructionUid);
    } catch (_) {}
  }
}

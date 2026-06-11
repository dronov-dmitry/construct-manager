import 'package:uuid/uuid.dart';

import '../../core/network/supabase_client.dart';
import '../models/construction.dart';
import '../models/user.dart';

class ConstructionService {
  Future<List<Construction>> getConstructions() async {
    final data = await SupabaseClientManager.instance.client
        .from('constructions')
        .select()
        .order('created_at', ascending: false);
    final list = data as List<dynamic>;
    return list.map((e) => Construction.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Construction?> getConstruction(String uid) async {
    final data = await SupabaseClientManager.instance.client
        .from('constructions')
        .select()
        .eq('uid', uid)
        .maybeSingle();
    if (data == null) return null;
    return Construction.fromJson(data);
  }

  Future<String> writeConstruction(
    String userId,
    String title,
    String address,
    String stage,
    String type,
    List<User> responsibles,
    String? constructionUid,
  ) async {
    final uid = constructionUid ?? const Uuid().v4();
    final construction = Construction(
      title: title,
      address: address,
      type: type,
      stage: stage,
      responsibles: responsibles,
      constructionUid: uid,
      ownerUid: userId,
    );
    await SupabaseClientManager.instance.client
        .from('constructions')
        .upsert(construction.toJson());
    return uid;
  }

  Future<void> deleteConstruction(String constructionUid) async {
    await SupabaseClientManager.instance.client
        .from('constructions')
        .delete()
        .eq('uid', constructionUid);
  }

  Future<void> advanceStage(String constructionUid, String newStage) async {
    await SupabaseClientManager.instance.client
        .from('constructions')
        .update({'stage': newStage})
        .eq('uid', constructionUid);
  }

  Future<void> advanceStageToExec(String constructionUid) async {
    final current = await getConstruction(constructionUid);
    if (current == null) throw Exception('Construction not found');
    if (current.stage != 'ПОДГОТОВКА') {
      throw Exception('Can only advance to execution from preparation stage');
    }
    await advanceStage(constructionUid, 'В_ИСПОЛНЕНИИ');
  }

  Future<void> advanceStageToFinished(String constructionUid) async {
    final current = await getConstruction(constructionUid);
    if (current == null) throw Exception('Construction not found');
    if (current.stage != 'В_ИСПОЛНЕНИИ') {
      throw Exception('Can only finish objects in execution stage');
    }
    await advanceStage(constructionUid, 'ЗАВЕРШЕНО');
  }

  Future<void> cancelConstruction(String constructionUid) async {
    await advanceStage(constructionUid, 'ОТМЕНЕНО');
  }

  Future<void> updateMapAddress(String constructionUid, String mapAddress) async {
    await SupabaseClientManager.instance.client
        .from('constructions')
        .update({'map_address': mapAddress})
        .eq('uid', constructionUid);
  }

  Future<void> updateConstruction(String constructionUid, {
    required String title,
    required String address,
    required String type,
    required String information,
  }) async {
    await SupabaseClientManager.instance.client
        .from('constructions')
        .update({
          'title': title,
          'address': address,
          'type': type,
          'information': information,
        })
        .eq('uid', constructionUid);
  }

  Future<void> updateInformation(String constructionUid, String information) async {
    await SupabaseClientManager.instance.client
        .from('constructions')
        .update({'information': information})
        .eq('uid', constructionUid);
  }

  Future<void> updateResponsibles(String constructionUid, List<User> responsibles) async {
    final json = responsibles.map((e) => e.toJson()).toList();
    await SupabaseClientManager.instance.client
        .from('constructions')
        .update({'responsibles': json})
        .eq('uid', constructionUid);
  }
}

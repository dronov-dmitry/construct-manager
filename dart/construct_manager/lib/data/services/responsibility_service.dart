import '../../core/network/supabase_client.dart';
import '../models/responsibility.dart';

class ResponsibilityService {
  Future<List<Responsibility>> getResponsibilities(String constructionUid) async {
    final data = await SupabaseClientManager.instance.client
        .from('responsabilities')
        .select()
        .eq('construction_uid', constructionUid);
    final list = data as List<dynamic>;
    return list.map((e) => Responsibility.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> writeResponsibility(
    String constructionUid,
    String? responsabilityUid,
    String title,
    String desc,
    String deadline,
    String state,
    String responsibleEmail,
  ) async {
    final responsibility = Responsibility(
      constructionUid: constructionUid,
      title: title,
      desc: desc,
      deadline: deadline,
      state: state,
      responsibleEmail: responsibleEmail,
      responsabilityUid: responsabilityUid ?? '',
    );
    await SupabaseClientManager.instance.client
        .from('responsabilities')
        .upsert(responsibility.toJson());
  }

  Future<void> deleteResponsibility(String constructionUid, String responsabilityUid) async {
    await SupabaseClientManager.instance.client
        .from('responsabilities')
        .delete()
        .eq('uid', responsabilityUid)
        .eq('construction_uid', constructionUid);
  }

  Future<void> solveResponsibility(String constructionUid, String responsabilityUid) async {
    await SupabaseClientManager.instance.client
        .from('responsabilities')
        .update({'state': 'SOLVED'})
        .eq('uid', responsabilityUid)
        .eq('construction_uid', constructionUid);
  }
}

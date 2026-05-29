import '../../core/network/supabase_client.dart';
import '../models/schedule.dart';
import '../models/delay.dart';

class ScheduleService {
  Future<List<Schedule>> getSchedules(String constructionUid) async {
    final data = await SupabaseClientManager.instance.client
        .from('schedules')
        .select()
        .eq('construction_uid', constructionUid);
    final list = data as List<dynamic>;
    return list.map((e) => Schedule.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> writeSchedule(
    String constructionUid,
    String title,
    String deadline,
    String state,
    String? scheduleUid,
  ) async {
    final schedule = Schedule(
      constructionUid: constructionUid,
      title: title,
      deadline: deadline,
      state: state,
      scheduleUid: scheduleUid ?? '',
    );
    await SupabaseClientManager.instance.client
        .from('schedules')
        .upsert(schedule.toJson());
  }

  Future<void> deleteSchedule(String constructionUid, String scheduleUid) async {
    await SupabaseClientManager.instance.client
        .from('schedules')
        .delete()
        .eq('uid', scheduleUid)
        .eq('construction_uid', constructionUid);
  }

  Future<void> solveSchedule(String constructionUid, String scheduleUid) async {
    final now = DateTime.now();
    final dateStr = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    await SupabaseClientManager.instance.client
        .from('schedules')
        .update({
          'finish_date': dateStr,
          'state': 'SOLVED',
        })
        .eq('uid', scheduleUid)
        .eq('construction_uid', constructionUid);
  }

  Future<List<Delay>> getDelays(String constructionUid, String scheduleUid) async {
    final data = await SupabaseClientManager.instance.client
        .from('delays')
        .select()
        .eq('construction_uid', constructionUid)
        .eq('schedule_uid', scheduleUid);
    final list = data as List<dynamic>;
    return list.map((e) => Delay.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> writeDelay(Delay delay) async {
    await SupabaseClientManager.instance.client
        .from('delays')
        .upsert(delay.toJson());
  }

  Future<void> finishDelay(String delayUid) async {
    await SupabaseClientManager.instance.client
        .from('delays')
        .update({'finished': true})
        .eq('uid', delayUid);
  }
}

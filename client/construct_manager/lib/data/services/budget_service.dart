import '../../core/network/supabase_client.dart';
import '../models/budget.dart';

class BudgetService {
  Future<List<Budget>> getBudgets(String constructionUid) async {
    final data = await SupabaseClientManager.instance.client
        .from('budgets')
        .select()
        .eq('construction_uid', constructionUid);
    final list = data as List<dynamic>;
    return list.map((e) => Budget.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> writeBudget(Budget budget) async {
    await SupabaseClientManager.instance.client
        .from('budgets')
        .upsert(budget.toJson());
  }

  Future<void> deleteBudget(String budgetUid) async {
    await SupabaseClientManager.instance.client
        .from('budgets')
        .delete()
        .eq('uid', budgetUid);
  }
}

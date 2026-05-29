import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/budget.dart';
import '../../data/services/budget_service.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state.dart';

class BudgetListScreen extends StatefulWidget {
  final String constructionUid;

  const BudgetListScreen({super.key, required this.constructionUid});

  @override
  State<BudgetListScreen> createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends State<BudgetListScreen> {
  final _service = BudgetService();
  List<Budget> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final items = await _service.getBudgets(widget.constructionUid);
      setState(() => _items = items);
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _delete(Budget item) async {
    try {
      await _service.deleteBudget(item.budgetUid);
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(s.budget)),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.push('/constructions/${widget.constructionUid}/budgets/new'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? EmptyState(icon: Icons.attach_money, message: s.no_budget_items)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ListTile(
                          title: Text(item.title),
                          subtitle: Text(item.desc),
                          trailing: Text('\$${item.value.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleMedium),
                          onLongPress: () => _delete(item),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

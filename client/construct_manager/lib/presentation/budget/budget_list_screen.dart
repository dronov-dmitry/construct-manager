import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/budget.dart';
import '../../data/services/budget_service.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/error_screen.dart';
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
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _delete(Budget item) async {
    try {
      await _service.deleteBudget(item.budgetUid);
      _load();
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    }
  }

  Future<void> _confirmDelete(Budget item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить'),
        content: Text('Удалить «${item.title}»?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) _delete(item);
  }

  Widget _buildTotalCard() {
    final total = _items.fold(0.0, (sum, item) => sum + item.value);
    final theme = Theme.of(context);
    final s = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.account_balance_wallet, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Text(s.budget_total, style: theme.textTheme.titleMedium),
            const Spacer(),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(s.budget)),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (mounted) {
            await context.push('/constructions/${widget.constructionUid}/budgets/new');
            _load();
          }
        }),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? EmptyState(icon: Icons.attach_money, message: s.no_budget_items)
              : Column(
                  children: [
                    _buildTotalCard(),
                    Expanded(
                      child: RefreshIndicator(
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
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('\$${item.value.toStringAsFixed(2)}',
                                        style: Theme.of(context).textTheme.titleMedium),
                                    const SizedBox(width: 4),
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, size: 20),
                                      onPressed: () => WidgetsBinding.instance.addPostFrameCallback((_) async {
                                        if (mounted) {
                                          await context.push(
                                            '/constructions/${widget.constructionUid}/budgets/edit',
                                            extra: item,
                                          );
                                          _load();
                                        }
                                      }),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, size: 20),
                                      onPressed: () => _confirmDelete(item),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

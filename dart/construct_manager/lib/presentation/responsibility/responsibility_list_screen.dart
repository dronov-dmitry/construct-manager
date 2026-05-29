import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/responsibility.dart';
import '../../data/services/responsibility_service.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state.dart';

class ResponsibilityListScreen extends StatefulWidget {
  final String constructionUid;

  const ResponsibilityListScreen({super.key, required this.constructionUid});

  @override
  State<ResponsibilityListScreen> createState() => _ResponsibilityListScreenState();
}

class _ResponsibilityListScreenState extends State<ResponsibilityListScreen> {
  final _service = ResponsibilityService();
  List<Responsibility> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final items = await _service.getResponsibilities(widget.constructionUid);
      setState(() => _items = items);
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _solve(Responsibility item) async {
    try {
      await _service.solveResponsibility(widget.constructionUid, item.responsabilityUid);
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _delete(Responsibility item) async {
    try {
      await _service.deleteResponsibility(widget.constructionUid, item.responsabilityUid);
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
      appBar: AppBar(title: Text(s.responsibility)),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.push('/constructions/${widget.constructionUid}/responsibilities/new'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? EmptyState(icon: Icons.assignment, message: s.no_responsibilities)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      final isSolved = item.state == 'SOLVED';
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ListTile(
                          leading: Icon(
                            isSolved ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: isSolved ? Colors.green : Colors.orange,
                          ),
                          title: Text(item.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.desc),
                              Text('${item.responsibleEmail} | ${s.deadline}: ${item.deadline}'),
                            ],
                          ),
                          trailing: isSolved
                              ? const Icon(Icons.check, color: Colors.green)
                              : IconButton(
                                  icon: const Icon(Icons.check_circle_outline),
                                  onPressed: () => _solve(item),
                                ),
                          onLongPress: () => _delete(item),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

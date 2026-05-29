import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/schedule.dart';
import '../../data/services/schedule_service.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state.dart';

class ScheduleListScreen extends StatefulWidget {
  final String constructionUid;

  const ScheduleListScreen({super.key, required this.constructionUid});

  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  final _service = ScheduleService();
  List<Schedule> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final items = await _service.getSchedules(widget.constructionUid);
      setState(() => _items = items);
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _solve(Schedule item) async {
    try {
      await _service.solveSchedule(widget.constructionUid, item.scheduleUid);
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _delete(Schedule item) async {
    try {
      await _service.deleteSchedule(widget.constructionUid, item.scheduleUid);
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Color _stateColor(String state) {
    switch (state) {
      case 'SOLVED':
        return Colors.green;
      case 'LATE':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(s.schedule)),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => context.push('/constructions/${widget.constructionUid}/schedules/new'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? EmptyState(icon: Icons.calendar_today, message: s.no_schedules)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ExpansionTile(
                          title: Text(item.title),
                          subtitle: Text('${s.deadline}: ${item.deadline}'),
                          leading: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _stateColor(item.state),
                              shape: BoxShape.circle,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton.icon(
                                    icon: const Icon(Icons.check_circle, size: 18),
                                    label: Text(s.solved_state),
                                    onPressed: item.state != 'SOLVED' ? () => _solve(item) : null,
                                  ),
                                  TextButton.icon(
                                    icon: const Icon(Icons.warning, size: 18),
                                    label: Text(s.delay),
                                    onPressed: () => context.push(
                                      '/constructions/${widget.constructionUid}/schedules/${item.scheduleUid}/delays/new',
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _delete(item),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

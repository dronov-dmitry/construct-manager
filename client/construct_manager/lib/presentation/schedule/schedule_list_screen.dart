import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/schedule.dart';
import '../../data/services/schedule_service.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/error_screen.dart';
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
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _solve(Schedule item) async {
    try {
      await _service.solveSchedule(widget.constructionUid, item.scheduleUid);
      _load();
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    }
  }

  Future<void> _unsolve(Schedule item) async {
    try {
      await _service.unsolveSchedule(widget.constructionUid, item.scheduleUid);
      _load();
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    }
  }

  Future<void> _delete(Schedule item) async {
    try {
      await _service.deleteSchedule(widget.constructionUid, item.scheduleUid);
      _load();
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    }
  }

  Color _stateColor(String state) {
    switch (state) {
      case 'SOLVED':
        return Colors.green;
      case 'LATE':
        return Colors.red;
      default:
        return Colors.red;
    }
  }

  Widget _fabCalendar(AppLocalizations s) {
    return FloatingActionButton.small(
      heroTag: 'schedule_calendar',
      tooltip: s.calendar_view,
      child: const Icon(Icons.calendar_month),
      onPressed: () => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.push('/constructions/${widget.constructionUid}/schedules/calendar');
      }),
    );
  }

  Widget _fabGantt(AppLocalizations s) {
    return FloatingActionButton.small(
      heroTag: 'schedule_gantt',
      tooltip: 'Диаграмма Ганта',
      child: const Icon(Icons.bar_chart),
      onPressed: () => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.push('/constructions/${widget.constructionUid}/schedules/gantt');
      }),
    );
  }

  Widget _fabAdd() {
    return FloatingActionButton(
      heroTag: 'schedule_add',
      child: const Icon(Icons.add),
      onPressed: () => WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
          await context.push('/constructions/${widget.constructionUid}/schedules/new');
          _load();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(s.schedule)),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _fabCalendar(s),
          const SizedBox(height: 8),
          _fabGantt(s),
          const SizedBox(height: 8),
          _fabAdd(),
        ],
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
                          subtitle: Text(item.startDate != null && item.startDate!.isNotEmpty
                              ? '${item.startDate} — ${item.deadline}'
                              : '${s.deadline}: ${item.deadline}'),
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
                                    icon: Icon(
                                      item.state == 'SOLVED' ? Icons.undo : Icons.check_circle,
                                      size: 18,
                                    ),
                                    label: Text(item.state == 'SOLVED' ? s.unsolve : s.solved_state),
                                    onPressed: () {
                                      if (item.state == 'SOLVED') {
                                        _unsolve(item);
                                      } else {
                                        _solve(item);
                                      }
                                    },
                                  ),
                                  TextButton.icon(
                                    icon: const Icon(Icons.warning, size: 18),
                                    label: Text(s.delay),
                                    onPressed: () {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (mounted) {
                                          context.push(
                                            '/constructions/${widget.constructionUid}/schedules/${item.scheduleUid}/delays/new',
                                          );
                                        }
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    tooltip: 'Редактировать',
                                    onPressed: () {
                                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                                        if (mounted) {
                                          await context.push(
                                            '/constructions/${widget.constructionUid}/schedules/edit',
                                            extra: item,
                                          );
                                          _load();
                                        }
                                      });
                                    },
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

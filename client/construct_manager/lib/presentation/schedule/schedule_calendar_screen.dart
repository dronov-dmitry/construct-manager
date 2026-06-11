import 'package:flutter/material.dart';

import '../../data/models/schedule.dart';
import '../../data/services/schedule_service.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/error_screen.dart';

class ScheduleCalendarScreen extends StatefulWidget {
  final String constructionUid;

  const ScheduleCalendarScreen({super.key, required this.constructionUid});

  @override
  State<ScheduleCalendarScreen> createState() => _ScheduleCalendarScreenState();
}

class _ScheduleCalendarScreenState extends State<ScheduleCalendarScreen> {
  final _service = ScheduleService();
  List<Schedule> _allItems = [];
  bool _isLoading = true;
  late DateTime _currentMonth;

  static const _monthNames = [
    'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
    'Июль', 'Август', 'Сентябрь', 'Окторябрь', 'Ноябрь', 'Декабрь',
  ];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final items = await _service.getSchedules(widget.constructionUid);
      setState(() => _allItems = items);
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    }
    if (mounted) setState(() => _isLoading = false);
  }

  bool _overlapsMonth(Schedule item, DateTime month) {
    final start = item.startDate != null ? _parseDate(item.startDate!) : null;
    final end = _parseDate(item.deadline);
    if (end == null) return false;
    final monthStart = month;
    final monthEnd = DateTime(month.year, month.month + 1, 0);
    final s = start ?? end;
    return !(s.isAfter(monthEnd) || end.isBefore(monthStart));
  }

  List<Schedule> _itemsForMonth() {
    final result = _allItems.where((item) => _overlapsMonth(item, _currentMonth)).toList();
    DateTime? sortDate(Schedule item) {
      if (item.startDate != null) {
        final d = _parseDate(item.startDate!);
        if (d != null) return d;
      }
      return _parseDate(item.deadline);
    }
    result.sort((a, b) {
      final sa = sortDate(a);
      final sb = sortDate(b);
      if (sa == null && sb == null) return 0;
      if (sa == null) return 1;
      if (sb == null) return -1;
      return sa.compareTo(sb);
    });
    return result;
  }

  DateTime? _parseDate(String deadline) {
    try {
      final parts = deadline.split('/');
      if (parts.length != 3) return null;
      return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    } catch (_) {
      return null;
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

  String _stateLabel(String state, AppLocalizations s) {
    switch (state) {
      case 'SOLVED':
        return s.solved;
      case 'LATE':
        return s.late;
      default:
        return s.on_schedule;
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  bool _isCurrentMonth() {
    final now = DateTime.now();
    return _currentMonth.year == now.year && _currentMonth.month == now.month;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(s.calendar_view)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(theme, s),
    );
  }

  Widget _buildContent(ThemeData theme, AppLocalizations s) {
    final monthItems = _itemsForMonth();
    final monthLabel = '${_monthNames[_currentMonth.month - 1]} ${_currentMonth.year}';

    return Column(
      children: [
        _buildMonthNav(monthLabel),
        _buildCalendarGrid(theme, s, monthItems),
        const Divider(height: 1),
        Expanded(
          child: monthItems.isEmpty
              ? Center(
                  child: Text(
                    'Нет задач на этот месяц',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: monthItems.length,
                  itemBuilder: (_, i) => _buildTimelineItem(monthItems[i], theme, s),
                ),
        ),
      ],
    );
  }

  Widget _buildMonthNav(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousMonth,
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextMonth,
          ),
          if (!_isCurrentMonth())
            IconButton(
              icon: const Icon(Icons.today),
              tooltip: 'Сегодня',
              onPressed: () {
                setState(() {
                  _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
                });
              },
            ),
        ],
      ),
    );
  }

  Map<int, List<({Schedule item, Color color})>> _dayTasks(List<Schedule> items) {
    final map = <int, List<({Schedule item, Color color})>>{};
    final monthStart = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final monthEnd = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    for (final item in items) {
      final start = item.startDate != null ? _parseDate(item.startDate!) : null;
      final end = _parseDate(item.deadline);
      if (end == null) continue;
      final s = start ?? end;
      final color = _stateColor(item.state);
      final rangeStart = s.isBefore(monthStart) ? monthStart.day : s.day;
      final rangeEnd = end.isAfter(monthEnd) ? monthEnd.day : end.day;
      for (int d = rangeStart; d <= rangeEnd; d++) {
        map.putIfAbsent(d, () => []).add((item: item, color: color));
      }
    }
    return map;
  }

  void _showDayTasks(int day, List<({Schedule item, Color color})> tasks, ThemeData theme, AppLocalizations s) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${day.toString().padLeft(2, '0')}.${_currentMonth.month.toString().padLeft(2, '0')}.${_currentMonth.year}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (_, i) {
              final t = tasks[i];
              return ListTile(
                dense: true,
                leading: Container(
                  width: 12, height: 12,
                  decoration: BoxDecoration(color: t.color, shape: BoxShape.circle),
                ),
                title: Text(t.item.title, style: const TextStyle(fontSize: 14)),
                subtitle: Text(
                  t.item.startDate != null && t.item.startDate!.isNotEmpty
                      ? '${t.item.startDate} — ${t.item.deadline}'
                      : '${s.deadline}: ${t.item.deadline}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Text(
                  _stateLabel(t.item.state, s),
                  style: TextStyle(fontSize: 12, color: t.color),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(s.cancel),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(ThemeData theme, AppLocalizations s, List<Schedule> monthItems) {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final daysInMonth = lastDay.day;
    final startWeekday = firstDay.weekday % 7;

    final tasksByDay = _dayTasks(monthItems);

    final today = DateTime.now();
    final isCurrentMonth = _isCurrentMonth();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            children: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']
                .map((d) => Expanded(
                      child: Center(
                        child: Text(d, style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        )),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 4),
          ...List.generate(
            ((daysInMonth + startWeekday) / 7).ceil(),
            (week) => Row(
              children: List.generate(7, (wday) {
                final day = week * 7 + wday - startWeekday + 1;
                if (day < 1 || day > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 44));
                }

                final dayTasks = tasksByDay[day] ?? [];
                final isToday = isCurrentMonth && today.day == day;

                return Expanded(
                  child: GestureDetector(
                    onTap: dayTasks.isNotEmpty
                        ? () => _showDayTasks(day, dayTasks, theme, s)
                        : null,
                    child: Container(
                      height: 44,
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: isToday
                            ? theme.colorScheme.primaryContainer
                            : (dayTasks.isNotEmpty
                                ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.2)
                                : null),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 2),
                          Text(
                            day.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                              color: isToday
                                  ? theme.colorScheme.onPrimaryContainer
                                  : (wday >= 5
                                      ? theme.colorScheme.onSurfaceVariant
                                      : null),
                            ),
                          ),
                          if (dayTasks.isNotEmpty)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 1),
                                child: _buildTaskDots(dayTasks),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDots(List<({Schedule item, Color color})> tasks) {
    const maxDots = 4;
    return LayoutBuilder(
      builder: (_, constraints) {
        final dotSize = (constraints.maxWidth / maxDots).clamp(4.0, 10.0);
        final dotCount = tasks.length > maxDots ? maxDots - 1 : tasks.length;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < dotCount; i++)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: dotSize * 0.2),
                child: Container(
                  width: dotSize * 0.5,
                  height: dotSize * 0.5,
                  decoration: BoxDecoration(
                    color: tasks[i].color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            if (tasks.length > maxDots)
              Text(
                '+${tasks.length - dotCount}',
                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTimelineItem(Schedule item, ThemeData theme, AppLocalizations s) {
    final color = _stateColor(item.state);
    final end = _parseDate(item.deadline);
    final start = item.startDate != null ? _parseDate(item.startDate!) : null;

    String dateStr;
    if (start != null) {
      dateStr = '${start.day.toString().padLeft(2, '0')}.${start.month.toString().padLeft(2, '0')}'
          ' — ${end?.day.toString().padLeft(2, '0')}.${end?.month.toString().padLeft(2, '0')}';
    } else if (end != null) {
      dateStr = '${s.deadline}: ${end.day.toString().padLeft(2, '0')}.${end.month.toString().padLeft(2, '0')}';
    } else {
      dateStr = '--';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        child: ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  start != null
                      ? start.day.toString()
                      : (end?.day.toString() ?? '--'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
                Text(
                  start != null
                      ? '${start.month.toString().padLeft(2, '0')}→${end?.day.toString().padLeft(2, '0')}'
                      : (end?.month.toString().padLeft(2, '0') ?? ''),
                  style: TextStyle(fontSize: 10, color: color),
                ),
              ],
            ),
          ),
          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(dateStr),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _stateLabel(item.state, s),
              style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

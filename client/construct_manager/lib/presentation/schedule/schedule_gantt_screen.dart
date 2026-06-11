import 'package:flutter/material.dart';

import '../../data/models/schedule.dart';
import '../../data/services/schedule_service.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/error_screen.dart';

class ScheduleGanttScreen extends StatefulWidget {
  final String constructionUid;

  const ScheduleGanttScreen({super.key, required this.constructionUid});

  @override
  State<ScheduleGanttScreen> createState() => _ScheduleGanttScreenState();
}

class _ScheduleGanttScreenState extends State<ScheduleGanttScreen> {
  final _service = ScheduleService();
  List<_GanttRow> _rows = [];
  bool _isLoading = true;
  DateTime? _minDate;
  late DateTime _today;
  late int _totalDays;

  static const double _dayWidth = 14.0;
  static const double _rowHeight = 36.0;
  static const double _headerHeight = 28.0;
  static const double _nameWidth = 160.0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await _service.getSchedules(widget.constructionUid);
      _buildRows(items);
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _buildRows(List<Schedule> items) {
    final parsed = <_GanttRow>[];
    DateTime? minD;
    DateTime? maxD;

    for (final item in items) {
      final d = _parseDate(item.deadline);
      if (d == null) continue;
      final s = item.startDate != null ? _parseDate(item.startDate!) : null;
      final f = item.finishDate != null ? _parseDate(item.finishDate!) : null;

      parsed.add(_GanttRow(
        title: item.title,
        startDate: s,
        deadline: d,
        state: item.state,
        finishDate: f,
      ));

      if (s != null && (minD == null || s.isBefore(minD))) minD = s;
      if (minD == null || d.isBefore(minD)) minD = d;
      if (maxD == null || d.isAfter(maxD)) maxD = d;
    }

    parsed.sort((a, b) => a.deadline.compareTo(b.deadline));

    if (parsed.isEmpty) {
      _rows = [];
      _totalDays = 30;
      return;
    }

    final todayBefore = _today.isBefore(minD!);
    final todayAfter = _today.isAfter(maxD!);

    final start = todayBefore
        ? DateTime(_today.year, _today.month, _today.day - 15)
        : DateTime(minD.year, minD.month, minD.day - 15);

    final end = todayAfter
        ? DateTime(_today.year, _today.month, _today.day + 15)
        : DateTime(maxD.year, maxD.month, maxD.day + 15);

    _minDate = start;
    _totalDays = end.difference(start).inDays;
    if (_totalDays < 30) _totalDays = 30;
    _rows = parsed;
  }

  DateTime? _parseDate(String date) {
    try {
      final parts = date.split('/');
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text('${s.schedule} — Гант')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rows.isEmpty
              ? Center(child: Text('Нет данных для диаграммы', style: theme.textTheme.bodyLarge))
              : _buildChart(theme),
    );
  }

  Widget _buildChart(ThemeData theme) {
    final contentWidth = _totalDays * _dayWidth + _nameWidth + 40;

    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasWidth = contentWidth.clamp(constraints.maxWidth, double.infinity);

        return Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: canvasWidth,
                height: constraints.maxHeight,
                child: CustomPaint(
                  painter: _GanttPainter(
                    rows: _rows,
                    minDate: _minDate!,
                    totalDays: _totalDays,
                    today: _today,
                    dayWidth: _dayWidth,
                    rowHeight: _rowHeight,
                    headerHeight: _headerHeight,
                    nameWidth: _nameWidth,
                    stateColor: _stateColor,
                    theme: theme,
                  ),
                  size: Size(canvasWidth, constraints.maxHeight),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                child: SizedBox(
                  width: _nameWidth,
                  child: CustomPaint(
                    painter: _NameOverlayPainter(
                      rows: _rows,
                      headerHeight: _headerHeight,
                      rowHeight: _rowHeight,
                      theme: theme,
                    ),
                    size: Size(_nameWidth, constraints.maxHeight),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GanttRow {
  final String title;
  final DateTime? startDate;
  final DateTime deadline;
  final String state;
  final DateTime? finishDate;

  const _GanttRow({
    required this.title,
    required this.deadline,
    required this.state,
    this.startDate,
    this.finishDate,
  });
}

class _GanttPainter extends CustomPainter {
  final List<_GanttRow> rows;
  final DateTime minDate;
  final int totalDays;
  final DateTime today;
  final double dayWidth;
  final double rowHeight;
  final double headerHeight;
  final double nameWidth;
  final Color Function(String) stateColor;
  final ThemeData theme;

  _GanttPainter({
    required this.rows,
    required this.minDate,
    required this.totalDays,
    required this.today,
    required this.dayWidth,
    required this.rowHeight,
    required this.headerHeight,
    required this.nameWidth,
    required this.stateColor,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawHeader(canvas, size);
    _drawGrid(canvas, size);
    _drawBars(canvas);
    _drawTodayLine(canvas);
  }

  double _dateToX(DateTime d) {
    final offset = d.difference(minDate).inDays;
    return nameWidth + offset * dayWidth;
  }

  void _drawHeader(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = theme.colorScheme.surfaceContainerHighest;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, headerHeight), bgPaint);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final textStyle = TextStyle(
      fontSize: 10,
      color: theme.colorScheme.onSurfaceVariant,
    );

    // draw date labels and vertical grid lines for actual data range
    for (int i = 0; i <= totalDays; i++) {
      final x = nameWidth + i * dayWidth;
      final date = minDate.add(Duration(days: i));
      if (date.day == 1 || i == 0) {
        final label = '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
        textPainter.text = TextSpan(text: label, style: textStyle);
        textPainter.layout();
        textPainter.paint(canvas, Offset(x + 2, 6));
      }

      if (date.weekday == 1 || date.day == 1) {
        _drawVerticalGridLine(canvas, x, size.height);
      }
    }

    // continue grid lines to the right edge of the canvas
    final linePaint = Paint()
      ..color = theme.colorScheme.outlineVariant.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;
    int i = totalDays + 1;
    while (true) {
      final x = nameWidth + i * dayWidth;
      if (x > size.width) break;
      final date = minDate.add(Duration(days: i));
      if (date.day == 1) {
        final label = '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
        textPainter.text = TextSpan(text: label, style: textStyle);
        textPainter.layout();
        textPainter.paint(canvas, Offset(x + 2, 6));
      }
      if (date.weekday == 1 || date.day == 1) {
        canvas.drawLine(Offset(x, headerHeight), Offset(x, size.height), linePaint);
      }
      i++;
    }
  }

  void _drawVerticalGridLine(Canvas canvas, double x, double canvasHeight) {
    final linePaint = Paint()
      ..color = theme.colorScheme.outlineVariant.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;
    canvas.drawLine(Offset(x, headerHeight), Offset(x, canvasHeight), linePaint);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = theme.colorScheme.outlineVariant.withValues(alpha: 0.12)
      ..strokeWidth = 0.5;
    for (int i = 0; i < rows.length; i++) {
      final y = headerHeight + (i + 1) * rowHeight;
      canvas.drawLine(Offset(nameWidth, y), Offset(size.width, y), linePaint);
    }
  }

  void _drawBars(Canvas canvas) {
    for (int i = 0; i < rows.length; i++) {
      final row = rows[i];
      final y = headerHeight + i * rowHeight + (rowHeight - 18) / 2;
      final color = stateColor(row.state);
      final startDate = row.startDate ??
          (row.state == 'SOLVED' ? (row.finishDate ?? row.deadline) : row.deadline);
      final startX = _dateToX(startDate);
      final endX = _dateToX(row.deadline);
      final barWidth = (endX - startX).abs().clamp(4, double.infinity).toDouble();

      if (row.state == 'SOLVED') {
        final barPaint = Paint()..color = color;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(startX, y, barWidth, 18),
            const Radius.circular(3),
          ),
          barPaint,
        );
        final checkPaint = Paint()
          ..color = Colors.white
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
        final path = Path()
          ..moveTo(startX + barWidth / 2 - 9, y + 9)
          ..lineTo(startX + barWidth / 2 - 3, y + 14)
          ..lineTo(startX + barWidth / 2 + 10, y + 4);
        canvas.drawPath(path, checkPaint);
      } else if (row.state == 'LATE') {
        final barPaint = Paint()..color = color;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(startX, y, barWidth, 18),
            const Radius.circular(3),
          ),
          barPaint,
        );
        final strokePaint = Paint()
          ..color = Colors.white
          ..strokeWidth = 2;
        canvas.drawLine(Offset(startX + 2, y + 9), Offset(endX - 2, y + 9), strokePaint);
      } else {
        final barPaint = Paint()..color = color;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(startX, y, barWidth, 18),
            const Radius.circular(3),
          ),
          barPaint,
        );
      }
    }
  }

  void _drawTodayLine(Canvas canvas) {
    final x = _dateToX(today);
    final linePaint = Paint()
      ..color = theme.colorScheme.primary
      ..strokeWidth = 2;
    final contentBottom = headerHeight + rows.length * rowHeight + 10;
    canvas.drawLine(Offset(x, headerHeight), Offset(x, contentBottom), linePaint);

    final labelPaint = Paint()..color = theme.colorScheme.primary;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x - 14, contentBottom + 2, 28, 16),
        const Radius.circular(3),
      ),
      labelPaint,
    );

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: 'сегодня',
      style: TextStyle(fontSize: 9, color: theme.colorScheme.onPrimary),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, contentBottom + 3),
    );
  }

  @override
  bool shouldRepaint(_GanttPainter oldDelegate) => true;
}

class _NameOverlayPainter extends CustomPainter {
  final List<_GanttRow> rows;
  final double headerHeight;
  final double rowHeight;
  final ThemeData theme;

  _NameOverlayPainter({
    required this.rows,
    required this.headerHeight,
    required this.rowHeight,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final headerBgPaint = Paint()..color = theme.colorScheme.surfaceContainerHighest;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, headerHeight), headerBgPaint);

    final nameBgPaint = Paint()..color = theme.colorScheme.surface;
    canvas.drawRect(
      Rect.fromLTWH(0, headerHeight, size.width, rows.length * rowHeight),
      nameBgPaint,
    );

    final borderPaint = Paint()
      ..color = theme.colorScheme.outlineVariant
      ..strokeWidth = 1;
    canvas.drawLine(Offset(size.width - 0.5, 0), Offset(size.width - 0.5, size.height), borderPaint);

    final headerTextPainter = TextPainter(textDirection: TextDirection.ltr);
    headerTextPainter.text = TextSpan(
      text: 'Компонент',
      style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant),
    );
    headerTextPainter.layout();
    headerTextPainter.paint(canvas, Offset(4, (headerHeight - headerTextPainter.height) / 2));

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < rows.length; i++) {
      final y = headerHeight + i * rowHeight + (rowHeight - 14) / 2;
      textPainter.text = TextSpan(
        text: rows[i].title,
        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface),
      );
      textPainter.layout(maxWidth: size.width - 8);
      textPainter.paint(canvas, Offset(4, y));
    }
  }

  @override
  bool shouldRepaint(_NameOverlayPainter oldDelegate) => true;
}

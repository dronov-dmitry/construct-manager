import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../core/enums/construction_stage.dart';
import '../../core/theme/status_colors.dart';
import '../../data/models/construction.dart';
import '../../data/models/user.dart';
import '../../data/services/construction_service.dart';
import '../../data/services/csv_service.dart';
import '../../data/services/user_service.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/error_screen.dart';
import '../../widgets/status_badge.dart';
import '../shell/app_drawer.dart';

class ConstructionViewScreen extends StatefulWidget {
  final String constructionUid;

  const ConstructionViewScreen({super.key, required this.constructionUid});

  @override
  State<ConstructionViewScreen> createState() => _ConstructionViewScreenState();
}

class _ConstructionViewScreenState extends State<ConstructionViewScreen> {
  final _constructionService = ConstructionService();
  final _userService = UserService();
  Construction? _construction;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final c = await _constructionService.getConstruction(widget.constructionUid);
      setState(() => _construction = c);
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _advanceStage(String newStage) async {
    try {
      await _constructionService.advanceStage(widget.constructionUid, newStage);
      _load();
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    }
  }

  Future<void> _delete() async {
    final s = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.confirm_delete),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(s.confirm)),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await _constructionService.deleteConstruction(widget.constructionUid);
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) context.pop();
          });
        }
      } catch (e, st) {
        if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    if (_isLoading) return const Scaffold(drawer: AppDrawer(), body: Center(child: CircularProgressIndicator()));
    if (_construction == null) return Scaffold(drawer: const AppDrawer(), body: Center(child: Text(s.error)));

    final c = _construction!;
    final stage = ConstructionStage.fromApi(c.stage);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(c.title),
        actions: [
          if (stage == ConstructionStage.preparation)
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'exec') _advanceStage('В_ИСПОЛНЕНИИ');
                if (v == 'cancel') _advanceStage('ОТМЕНЕНО');
                if (v == 'delete') _delete();
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'exec', child: Text(s.exec)),
                PopupMenuItem(value: 'cancel', child: Text(s.cancel)),
                PopupMenuItem(value: 'delete', child: Text(s.delete)),
              ],
            ),
          if (stage == ConstructionStage.inProgress)
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'finish') _advanceStage('ЗАВЕРШЕНО');
                if (v == 'cancel') _advanceStage('ОТМЕНЕНО');
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'finish', child: Text(s.finished)),
                PopupMenuItem(value: 'cancel', child: Text(s.cancel)),
              ],
            ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'export') _exportCsv();
              if (v == 'import') _importCsv();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'export', child: Row(
                children: [
                  Icon(Icons.file_download_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('Export CSV'),
                ],
              )),
              const PopupMenuItem(value: 'import', child: Row(
                children: [
                  Icon(Icons.file_upload_outlined, size: 18),
                  SizedBox(width: 8),
                  Text('Import CSV'),
                ],
              )),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildInfoCard(c),
            const SizedBox(height: 8),
            _buildNavCard(Icons.info_outline, s.information, () async {
              await context.push('/constructions/${widget.constructionUid}/info');
              if (mounted) _load();
            }),
            const SizedBox(height: 8),
            _buildNavCard(Icons.attach_money, s.budget, () => WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) context.push('/constructions/${widget.constructionUid}/budgets');
            })),
            const SizedBox(height: 8),
            _buildNavCard(Icons.calendar_today, s.schedule, () => WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) context.push('/constructions/${widget.constructionUid}/schedules');
            })),
            const SizedBox(height: 8),
            _buildNavCard(Icons.group, s.responsibles, _editResponsibles),
            const SizedBox(height: 8),
            _buildNavCard(Icons.photo_library, s.photos, () => WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) context.push('/constructions/${widget.constructionUid}/photos');
            })),
            const SizedBox(height: 8),
            _buildNavCard(Icons.map, s.map, () => WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) context.push('/constructions/${widget.constructionUid}/map');
            })),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Construction c) {
    final stage = ConstructionStage.fromApi(c.stage);
    final brightness = Theme.of(context).brightness;
    return Card(
      color: StatusColors.getStageBackgroundColor(stage, brightness: brightness),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(c.title, style: Theme.of(context).textTheme.titleLarge)),
                StatusBadge(stage: stage),
              ],
            ),
            const SizedBox(height: 8),
            _infoRow(Icons.location_on, c.address),
            _infoRow(Icons.category, c.type),
            _buildResponsiblesRow(c),
            if (c.budget != null)
              _infoRow(Icons.attach_money, c.budget!.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiblesRow(Construction c) {
    final iconColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
    final names = c.responsibles.map((u) => u.name).join(', ');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.group, size: 16, color: iconColor),
          const SizedBox(width: 8),
          Expanded(child: Text(names.isEmpty ? '—' : names)),
        ],
      ),
    );
  }

  Future<void> _editResponsibles() async {
    final c = _construction;
    if (c == null) return;

    List<User> allUsers;
    try {
      allUsers = await _userService.getAllUsers();
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
      return;
    }

    final selected = List<User>.from(c.responsibles);

    if (!mounted) return;
    final result = await showDialog<List<User>>(
      context: context,
      builder: (ctx) => _ResponsiblesEditDialog(
        allUsers: allUsers,
        selected: selected,
      ),
    );

    if (result == null || result.isEmpty == c.responsibles.isEmpty && _listsEqual(result, c.responsibles)) return;

    try {
      await _constructionService.updateResponsibles(widget.constructionUid, result);
      _load();
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    }
  }

  bool _listsEqual(List<User> a, List<User> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].uid != b[i].uid) return false;
    }
    return true;
  }

  Future<void> _exportCsv() async {
    try {
      final csvService = CsvService();
      final csvContent = await csvService.exportToCsv(widget.constructionUid);

      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Сохранить CSV',
        fileName: 'project_${widget.constructionUid}.csv',
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (result == null) return;

      await File(result).writeAsString(csvContent);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CSV экспортирован')),
        );
      }
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    }
  }

  Future<void> _importCsv() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Выбрать CSV файл',
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (result == null || result.files.isEmpty) return;

      final file = File(result.files.single.path!);
      final csvContent = await file.readAsString();

      final csvService = CsvService();
      final count = await csvService.importFromCsv(csvContent);

      _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Импортировано $count записей')),
        );
      }
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    }
  }

  Widget _infoRow(IconData icon, String text) {
    final iconColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildNavCard(IconData icon, String title, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _ResponsiblesEditDialog extends StatefulWidget {
  final List<User> allUsers;
  final List<User> selected;

  const _ResponsiblesEditDialog({required this.allUsers, required this.selected});

  @override
  State<_ResponsiblesEditDialog> createState() => _ResponsiblesEditDialogState();
}

class _ResponsiblesEditDialogState extends State<_ResponsiblesEditDialog> {
  late List<User> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<User>.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    final available = widget.allUsers
        .where((u) => !_selected.any((s) => s.uid == u.uid))
        .toList();

    return AlertDialog(
      title: const Text('Ответственные'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (available.isNotEmpty)
              DropdownButtonFormField<String>(
                key: ValueKey('add_resp_${available.length}_${_selected.length}'),
                decoration: const InputDecoration(
                  labelText: 'Добавить ответственного',
                  prefixIcon: Icon(Icons.person_add),
                  border: OutlineInputBorder(),
                ),
                items: available.map((u) => DropdownMenuItem(
                  value: u.uid,
                  child: Text('${u.name} (${u.email})'),
                )).toList(),
                onChanged: (uid) {
                  if (uid == null) return;
                  final user = widget.allUsers.firstWhere((u) => u.uid == uid);
                  setState(() => _selected.add(user));
                },
              ),
            const SizedBox(height: 12),
            if (_selected.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: Text('Нет выбранных ответственных')),
              )
            else
              Column(
                children: _selected.map((u) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(u.name),
                  subtitle: Text(u.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () => setState(() => _selected.remove(u)),
                  ),
                )).toList(),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_selected),
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}

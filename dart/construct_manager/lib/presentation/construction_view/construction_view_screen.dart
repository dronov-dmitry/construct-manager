import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/enums/construction_stage.dart';
import '../../core/theme/status_colors.dart';
import '../../data/models/construction.dart';
import '../../data/services/construction_service.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/status_badge.dart';

class ConstructionViewScreen extends StatefulWidget {
  final String constructionUid;

  const ConstructionViewScreen({super.key, required this.constructionUid});

  @override
  State<ConstructionViewScreen> createState() => _ConstructionViewScreenState();
}

class _ConstructionViewScreenState extends State<ConstructionViewScreen> {
  final _service = ConstructionService();
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
      final c = await _service.getConstruction(widget.constructionUid);
      setState(() => _construction = c);
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _advanceStage(String newStage) async {
    try {
      await _service.advanceStage(widget.constructionUid, newStage);
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
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
        await _service.deleteConstruction(widget.constructionUid);
        if (mounted) context.pop();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_construction == null) return Scaffold(body: Center(child: Text(s.error)));

    final c = _construction!;
    final stage = ConstructionStage.fromApi(c.stage);

    return Scaffold(
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
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildInfoCard(c),
            const SizedBox(height: 8),
            _buildNavCard(Icons.info_outline, s.information, () => context.push('/constructions/${widget.constructionUid}/info')),
            const SizedBox(height: 8),
            _buildNavCard(Icons.attach_money, s.budget, () => context.push('/constructions/${widget.constructionUid}/budgets')),
            const SizedBox(height: 8),
            _buildNavCard(Icons.calendar_today, s.schedule, () => context.push('/constructions/${widget.constructionUid}/schedules')),
            const SizedBox(height: 8),
            _buildNavCard(Icons.assignment, s.responsibility, () => context.push('/constructions/${widget.constructionUid}/responsibilities')),
            const SizedBox(height: 8),
            _buildNavCard(Icons.photo_library, s.photos, () => context.push('/constructions/${widget.constructionUid}/photos')),
            const SizedBox(height: 8),
            _buildNavCard(Icons.map, s.map, () => context.push('/constructions/${widget.constructionUid}/map')),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Construction c) {
    final stage = ConstructionStage.fromApi(c.stage);
    return Card(
      color: StatusColors.getStageBackgroundColor(stage),
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
            if (c.responsibles.isNotEmpty)
              _infoRow(Icons.group, c.responsibles.map((u) => u.name).join(', ')),
            if (c.budget != null)
              _infoRow(Icons.attach_money, c.budget!.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/enums/construction_stage.dart';
import '../../core/network/supabase_client.dart';
import '../../core/theme/status_colors.dart';
import '../../data/models/construction.dart';
import '../../data/services/construction_service.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/error_screen.dart';
import '../shell/app_drawer.dart';

class ConstructionListScreen extends StatefulWidget {
  const ConstructionListScreen({super.key});

  @override
  State<ConstructionListScreen> createState() => _ConstructionListScreenState();
}

class _ConstructionListScreenState extends State<ConstructionListScreen> {
  final _constructionService = ConstructionService();
  List<Construction> _constructions = [];
  ConstructionStage? _selectedStage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConstructions();
  }

  Future<void> _loadConstructions() async {
    setState(() => _isLoading = true);
    try {
      final userId = SupabaseClientManager.instance.client.auth.currentUser?.id;
      if (userId == null) return;
      final constructions = await _constructionService.getConstructions();
      setState(() => _constructions = constructions);
    } catch (e, st) {
      if (mounted) ErrorReportDialog.show(context, error: e, stack: st);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Construction> get _filteredConstructions {
    if (_selectedStage == null) return _constructions;
    return _constructions.where((c) => c.stage == _selectedStage!.apiValue).toList();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.my_projects),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadConstructions,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await context.push('/constructions/new');
            _loadConstructions();
          });
        },
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _buildStageChip(null, 'All'),
                _buildStageChip(ConstructionStage.preparation, s.stage_preparation),
                _buildStageChip(ConstructionStage.inProgress, s.stage_in_progress),
                _buildStageChip(ConstructionStage.finished, s.stage_finished),
                _buildStageChip(ConstructionStage.cancelled, s.stage_cancelled),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredConstructions.isEmpty
                    ? Center(child: Text(s.no_projects))
                    : RefreshIndicator(
                        onRefresh: _loadConstructions,
                        child: ListView.builder(
                          itemCount: _filteredConstructions.length,
                          itemBuilder: (context, index) {
                            return _buildConstructionCard(_filteredConstructions[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageChip(ConstructionStage? stage, String label) {
    final isSelected = _selectedStage == stage;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedStage = selected ? stage : null);
        },
      ),
    );
  }

  Widget _buildConstructionCard(Construction construction) {
    final stage = ConstructionStage.fromApi(construction.stage);
    final bgColor = StatusColors.getStageBackgroundColor(
      stage,
      brightness: Theme.of(context).brightness,
    );
    final badgeColor = StatusColors.getStageBadgeColor(stage);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: bgColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (construction.constructionUid.isEmpty) return;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) context.push('/constructions/${construction.constructionUid}');
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      construction.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      stage.name,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(construction.address, style: Theme.of(context).textTheme.bodySmall),
              if (construction.budget != null) ...[
                const SizedBox(height: 4),
                Text('${AppLocalizations.of(context)!.budget}: ${construction.budget}'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

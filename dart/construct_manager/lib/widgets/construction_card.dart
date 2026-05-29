import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../core/enums/construction_stage.dart';
import '../core/theme/status_colors.dart';
import '../data/models/construction.dart';
import 'status_badge.dart';

class ConstructionCard extends StatelessWidget {
  final Construction construction;
  final VoidCallback onTap;

  const ConstructionCard({super.key, required this.construction, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final stage = ConstructionStage.fromApi(construction.stage);
    final bgColor = StatusColors.getStageBackgroundColor(stage);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: bgColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  StatusBadge(stage: stage),
                ],
              ),
              const SizedBox(height: 4),
              Text(construction.address, style: Theme.of(context).textTheme.bodySmall),
              if (construction.budget != null) ...[
                const SizedBox(height: 4),
                Text('${AppLocalizations.of(context)!.budget}: \$${construction.budget!.toStringAsFixed(2)}'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../core/enums/construction_stage.dart';
import '../core/theme/status_colors.dart';

class StatusBadge extends StatelessWidget {
  final ConstructionStage stage;

  const StatusBadge({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    final color = StatusColors.getStageBadgeColor(stage);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        stage.name,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

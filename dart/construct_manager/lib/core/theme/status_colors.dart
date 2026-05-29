import 'package:flutter/material.dart';
import '../enums/construction_stage.dart';

class StatusColors {
  static Color getStageBackgroundColor(ConstructionStage stage) {
    switch (stage) {
      case ConstructionStage.preparation:
        return Colors.amber.shade50;
      case ConstructionStage.inProgress:
        return Colors.green.shade50;
      case ConstructionStage.finished:
        return Colors.green;
      case ConstructionStage.cancelled:
        return Colors.red.shade50;
    }
  }

  static Color getStageBadgeColor(ConstructionStage stage) {
    switch (stage) {
      case ConstructionStage.preparation:
        return Colors.orange;
      case ConstructionStage.inProgress:
        return Colors.green;
      case ConstructionStage.finished:
        return Colors.green.shade800;
      case ConstructionStage.cancelled:
        return Colors.red;
    }
  }

  static Color getStageBadgeTextColor(ConstructionStage stage) {
    switch (stage) {
      case ConstructionStage.preparation:
      case ConstructionStage.inProgress:
      case ConstructionStage.cancelled:
        return Colors.white;
      case ConstructionStage.finished:
        return Colors.white;
    }
  }
}

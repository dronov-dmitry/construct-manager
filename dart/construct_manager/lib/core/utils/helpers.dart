import '../enums/construction_stage.dart';

class StageHelper {
  static ConstructionStage fromApi(String? stage) {
    if (stage == null) return ConstructionStage.preparation;
    return ConstructionStage.fromApi(stage);
  }
}

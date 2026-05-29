enum ConstructionStage {
  preparation,
  inProgress,
  cancelled,
  finished;

  String get apiValue {
    switch (this) {
      case ConstructionStage.preparation:
        return 'ПОДГОТОВКА';
      case ConstructionStage.inProgress:
        return 'В_ИСПОЛНЕНИИ';
      case ConstructionStage.cancelled:
        return 'ОТМЕНЕНО';
      case ConstructionStage.finished:
        return 'ЗАВЕРШЕНО';
    }
  }

  static ConstructionStage fromApi(String value) {
    switch (value) {
      case 'ПОДГОТОВКА':
        return ConstructionStage.preparation;
      case 'В_ИСПОЛНЕНИИ':
        return ConstructionStage.inProgress;
      case 'ОТМЕНЕНО':
        return ConstructionStage.cancelled;
      case 'ЗАВЕРШЕНО':
        return ConstructionStage.finished;
      default:
        return ConstructionStage.preparation;
    }
  }
}

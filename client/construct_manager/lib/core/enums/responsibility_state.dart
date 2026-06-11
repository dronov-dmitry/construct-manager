enum ResponsibilityState {
  open,
  solved;

  String get apiValue {
    switch (this) {
      case ResponsibilityState.open:
        return 'OPEN';
      case ResponsibilityState.solved:
        return 'SOLVED';
    }
  }

  static ResponsibilityState fromApi(String value) {
    switch (value) {
      case 'OPEN':
        return ResponsibilityState.open;
      case 'SOLVED':
        return ResponsibilityState.solved;
      default:
        return ResponsibilityState.open;
    }
  }
}

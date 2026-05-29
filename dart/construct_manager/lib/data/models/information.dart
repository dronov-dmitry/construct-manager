import 'user.dart';

class Information {
  String title;
  String address;
  String type;
  String stage;
  List<User> responsibles;

  Information({
    this.title = '',
    this.address = '',
    this.type = '',
    this.stage = 'ПОДГОТОВКА',
    List<User>? responsibles,
  }) : responsibles = responsibles ?? [];
}

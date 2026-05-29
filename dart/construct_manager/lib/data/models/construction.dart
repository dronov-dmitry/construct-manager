import 'user.dart';

class Construction {
  String title;
  String address;
  String type;
  String stage;
  List<User> responsibles;
  String constructionUid;
  String ownerUid;
  String mapAddress;
  String information;
  DateTime? createdAt;
  double? budget;

  Construction({
    this.title = '',
    this.address = '',
    this.type = '',
    this.stage = 'ПОДГОТОВКА',
    List<User>? responsibles,
    this.constructionUid = '',
    this.ownerUid = '',
    this.mapAddress = '',
    this.information = '',
    this.createdAt,
    this.budget,
  }) : responsibles = responsibles ?? [];

  factory Construction.fromJson(Map<String, dynamic> json) {
    return Construction(
      title: json['title'] as String? ?? '',
      address: json['address'] as String? ?? '',
      type: json['type'] as String? ?? '',
      stage: json['stage'] as String? ?? 'ПОДГОТОВКА',
      responsibles: (json['responsibles'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      constructionUid: json['uid'] as String? ?? '',
      ownerUid: json['owner_uid'] as String? ?? '',
      mapAddress: json['map_address'] as String? ?? '',
      information: json['information'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      budget: (json['budget'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'address': address,
      'type': type,
      'stage': stage,
      'responsibles': responsibles.map((e) => e.toJson()).toList(),
      'uid': constructionUid,
      'owner_uid': ownerUid,
      'map_address': mapAddress,
      'information': information,
      'created_at': createdAt?.toIso8601String(),
      'budget': budget,
    };
  }
}

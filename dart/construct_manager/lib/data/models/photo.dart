class Photo {
  final String constructionUid;
  final String url;
  final String description;
  String uid;
  final String createdAt;

  Photo({
    this.constructionUid = '',
    this.url = '',
    this.description = '',
    this.uid = '',
    this.createdAt = '',
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      constructionUid: json['construction_uid'] as String? ?? '',
      url: json['url'] as String? ?? '',
      description: json['description'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'construction_uid': constructionUid,
      'url': url,
      'description': description,
      'uid': uid,
      'created_at': createdAt,
    };
  }
}

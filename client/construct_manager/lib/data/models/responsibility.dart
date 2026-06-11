class Responsibility {
  String constructionUid;
  String title;
  String desc;
  String deadline;
  String state;
  String responsibleEmail;
  String responsabilityUid;

  Responsibility({
    this.constructionUid = '',
    this.title = '',
    this.desc = '',
    this.deadline = '',
    this.state = 'OPEN',
    this.responsibleEmail = '',
    this.responsabilityUid = '',
  });

  factory Responsibility.fromJson(Map<String, dynamic> json) {
    return Responsibility(
      constructionUid: json['construction_uid'] as String? ?? '',
      title: json['title'] as String? ?? '',
      desc: json['description'] as String? ?? '',
      deadline: json['deadline'] as String? ?? '',
      state: json['state'] as String? ?? 'OPEN',
      responsibleEmail: json['responsible_email'] as String? ?? '',
      responsabilityUid: json['uid'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'construction_uid': constructionUid,
      'title': title,
      'description': desc,
      'deadline': deadline,
      'state': state,
      'responsible_email': responsibleEmail,
      'uid': responsabilityUid,
    };
  }
}

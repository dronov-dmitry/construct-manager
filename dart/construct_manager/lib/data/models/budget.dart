class Budget {
  String constructionUid;
  String title;
  String desc;
  double value;
  String budgetUid;

  Budget({
    this.constructionUid = '',
    this.title = '',
    this.desc = '',
    this.value = 0,
    this.budgetUid = '',
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      constructionUid: json['construction_uid'] as String? ?? '',
      title: json['title'] as String? ?? '',
      desc: json['description'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0,
      budgetUid: json['uid'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'construction_uid': constructionUid,
      'title': title,
      'description': desc,
      'value': value,
      'uid': budgetUid,
    };
  }
}

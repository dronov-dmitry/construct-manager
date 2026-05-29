class Schedule {
  String constructionUid;
  String title;
  String deadline;
  String state;
  String? finishDate;
  String scheduleUid;

  Schedule({
    this.constructionUid = '',
    this.title = '',
    this.deadline = '',
    this.state = '',
    this.finishDate,
    this.scheduleUid = '',
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      constructionUid: json['construction_uid'] as String? ?? '',
      title: json['title'] as String? ?? '',
      deadline: json['deadline'] as String? ?? '',
      state: json['state'] as String? ?? '',
      finishDate: json['finish_date'] as String?,
      scheduleUid: json['uid'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'construction_uid': constructionUid,
      'title': title,
      'deadline': deadline,
      'state': state,
      'finish_date': finishDate,
      'uid': scheduleUid,
    };
  }
}

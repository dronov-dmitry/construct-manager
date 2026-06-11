class Delay {
  String constructionUid;
  String scheduleUid;
  String title;
  String reason;
  bool isExcusable;
  bool isCompensable;
  bool isConcurrent;
  bool isCritical;
  int days;
  String additionalInfo;
  String? delayUid;

  Delay({
    this.constructionUid = '',
    this.scheduleUid = '',
    this.title = '',
    this.reason = '',
    this.isExcusable = false,
    this.isCompensable = false,
    this.isConcurrent = false,
    this.isCritical = false,
    this.days = 0,
    this.additionalInfo = '',
    this.delayUid,
  });

  factory Delay.fromJson(Map<String, dynamic> json) {
    return Delay(
      constructionUid: json['construction_uid'] as String? ?? '',
      scheduleUid: json['schedule_uid'] as String? ?? '',
      title: json['title'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      isExcusable: json['is_excusable'] as bool? ?? false,
      isCompensable: json['is_compensable'] as bool? ?? false,
      isConcurrent: json['is_concurrent'] as bool? ?? false,
      isCritical: json['is_critical'] as bool? ?? false,
      days: json['days'] as int? ?? 0,
      additionalInfo: json['additional_info'] as String? ?? '',
      delayUid: json['uid'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'construction_uid': constructionUid,
      'schedule_uid': scheduleUid,
      'title': title,
      'reason': reason,
      'is_excusable': isExcusable,
      'is_compensable': isCompensable,
      'is_concurrent': isConcurrent,
      'is_critical': isCritical,
      'days': days,
      'additional_info': additionalInfo,
      'uid': delayUid,
    };
  }
}

class ChildReferralTabResponceModel {
  String? child_referral_guid;
  String? childenrolledguid;
  String? cgmguid;
  String? date_of_referral;
  String? schedule_date;
  int? name;
  int? creche_id;
  String? responces;
  int? is_uploaded;
  int? is_edited;
  int? is_deleted;
  int? visit_count;
  String? created_at;
  String? created_by;
  String? update_at;
  String? updated_by;

  ChildReferralTabResponceModel(
      {this.child_referral_guid,
      this.childenrolledguid,
      this.cgmguid,
      this.date_of_referral,
      this.schedule_date,
      this.name,
      this.creche_id,
      this.responces,
      this.visit_count,
      this.is_edited,
      this.is_deleted,
      this.created_at,
      this.created_by,
      this.update_at,
      this.updated_by,
      this.is_uploaded});

  factory ChildReferralTabResponceModel.fromJson(Map<String, dynamic> json) =>
      ChildReferralTabResponceModel(
        child_referral_guid: json["child_referral_guid"],
        childenrolledguid: json["childenrolledguid"],
        cgmguid: json["cgmguid"],
        date_of_referral: json["date_of_referral"],
        name: json["name"],
        creche_id: json['creche_id'],
        schedule_date: json['schedule_date'],
        visit_count: json['visit_count'],
        responces: json["responces"],
        is_edited: json["is_edited"],
        is_deleted: json["is_deleted"],
        created_at: json["created_at"],
        created_by: json["created_by"],
        update_at: json["update_at"],
        updated_by: json["updated_by"],
        is_uploaded: json["is_uploaded"],
      );

  Map<String, dynamic> toJson() => {
        "child_referral_guid": child_referral_guid,
        "childenrolledguid": childenrolledguid,
        "cgmguid": cgmguid,
        "date_of_referral": date_of_referral,
        "schedule_date": schedule_date,
        "name": name,
        "creche_id": creche_id,
        "responces": responces,
        "visit_count": visit_count,
        "is_edited": is_edited,
        "is_deleted": is_deleted,
        "created_at": created_at,
        "created_by": created_by,
        "update_at": update_at,
        "updated_by": updated_by,
        "is_uploaded": is_uploaded,
      };
}

class ChildFollowUpTabResponceModel {
  String? child_followup_guid;
  String? childenrolledguid;
  String? child_referral_guid;
  String? followup_visit_date;
  String? schedule_date;
  int? name;
  int? creche_id;
  String? responces;
  int? is_uploaded;
  int? is_edited;
  int? is_deleted;
  String? created_at;
  String? created_by;
  String? update_at;
  String? updated_by;

  ChildFollowUpTabResponceModel(
      {
        this.child_followup_guid,
      this.childenrolledguid,
      this.child_referral_guid,
      this.followup_visit_date,
      this.schedule_date,
      this.name,
      this.creche_id,
      this.responces,
      this.is_edited,
      this.is_deleted,
      this.created_at,
      this.created_by,
      this.update_at,
      this.updated_by,
      this.is_uploaded});

  factory ChildFollowUpTabResponceModel.fromJson(Map<String, dynamic> json) =>
      ChildFollowUpTabResponceModel(
        child_followup_guid: json["child_followup_guid"],
        childenrolledguid: json["childenrolledguid"],
        child_referral_guid: json["child_referral_guid"],
        followup_visit_date: json["followup_visit_date"],
        schedule_date: json["schedule_date"],
        name: json["name"],
        creche_id: json['creche_id'],
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
        "child_followup_guid": child_followup_guid,
        "childenrolledguid": childenrolledguid,
        "child_referral_guid": child_referral_guid,
        "followup_visit_date": followup_visit_date,
        "schedule_date": schedule_date,
        "name": name,
        "creche_id": creche_id,
        "responces": responces,
        "is_edited": is_edited,
        "is_deleted": is_deleted,
        "created_at": created_at,
        "created_by": created_by,
        "update_at": update_at,
        "updated_by": updated_by,
        "is_uploaded": is_uploaded,
      };
}


class EnrolledExitChildResponceModel {
  String? ChildEnrollGUID;
  int?	name;
  int?	HHname;
  String?  CHHGUID;
  String? responces;
  int? creche_id;
  String? date_of_exit;
  int? is_uploaded;
  int? is_edited;
  int? is_deleted;
  String? created_at;
  String? created_by;
  String? update_at;
  String? updated_by;
  int? reason_for_exit;

  EnrolledExitChildResponceModel({
    this.ChildEnrollGUID,
    this.name,
    this.HHname,
    this.CHHGUID,
    this.responces,
    this.creche_id,
    this.date_of_exit,
    this.is_edited,
    this.is_deleted,
    this.created_at,
    this.created_by,
    this.update_at,
    this.updated_by,
    this.is_uploaded,
    this.reason_for_exit
  });

  factory EnrolledExitChildResponceModel.fromJson(Map<String, dynamic> json) => EnrolledExitChildResponceModel(
    ChildEnrollGUID: json["ChildEnrollGUID"],
    name: json["name"],
    HHname: json["HHname"],
    CHHGUID: json["CHHGUID"],
    responces: json["responces"],
    creche_id: json["creche_id"],
    date_of_exit: json["date_of_exit"],
    is_edited: json["is_edited"],
    is_deleted: json["is_deleted"],
    created_at: json["created_at"],
    created_by: json["created_by"],
    update_at: json["update_at"],
    updated_by: json["updated_by"],
    is_uploaded: json["is_uploaded"],
    reason_for_exit: json["reason_for_exit"],

  );

  Map<String, dynamic> toJson() => {
    "ChildEnrollGUID": ChildEnrollGUID,
    "name": name,
    "HHname": HHname,
    "CHHGUID":CHHGUID,
    "responces": responces,
    "is_edited": is_edited,
    "date_of_exit": date_of_exit,
    "creche_id": creche_id,
    "is_deleted": is_deleted,
    "created_at": created_at,
    "created_by": created_by,
    "update_at": update_at,
    "updated_by": updated_by,
    "is_uploaded": is_uploaded,
    "reason_for_exit": reason_for_exit,
  };
}
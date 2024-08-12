
class HouseHoldTabResponceMosdel {
  String? HHGUID;
  int?	name;
  String?  date_of_visit;
  String? responces;
  int? creche_id;
  int? is_uploaded;
  int? is_edited;
  int? is_deleted;
  String? created_at;
  String? created_by;
  String? update_at;
  String? updated_by;

  HouseHoldTabResponceMosdel({
    this.HHGUID,
    this.name,
    this.date_of_visit,
    this.responces,
    this.creche_id,
    this.is_edited,
    this.is_deleted,
    this.created_at,
    this.created_by,
    this.update_at,
    this.updated_by,
    this.is_uploaded
  });

  factory HouseHoldTabResponceMosdel.fromJson(Map<String, dynamic> json) => HouseHoldTabResponceMosdel(
    HHGUID: json["HHGUID"],
    name: json["name"],
    date_of_visit: json["date_of_visit"],
    responces: json["responces"],
    creche_id: json["creche_id"],
    is_edited: json["is_edited"],
    is_deleted: json["is_deleted"],
    created_at: json["created_at"],
    created_by: json["created_by"],
    update_at: json["update_at"],
    updated_by: json["updated_by"],
    is_uploaded: json["is_uploaded"],

  );

  Map<String, dynamic> toJson() => {
    "HHGUID": HHGUID,
    "name": name,
    "date_of_visit":date_of_visit,
    "responces": responces,
    "creche_id": creche_id,
    "is_edited": is_edited,
    "is_deleted": is_deleted,
    "created_at": created_at,
    "created_by": created_by,
    "update_at": update_at,
    "updated_by": updated_by,
    "is_uploaded": is_uploaded,
  };
}
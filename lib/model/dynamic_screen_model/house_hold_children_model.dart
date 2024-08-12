
class HouseHoldChildrenModel {
  String? HHGUID;
  String? CHHGUID;
  String? responces;
  int? is_uploaded;
  int? name;
  int? parent;
  int? is_edited;
  int? is_deleted;
  int? creche_id;
  String? created_at;
  String? created_by;
  String? update_at;
  String? updated_by;

  HouseHoldChildrenModel({
    this.HHGUID,
    this.CHHGUID,
    this.responces,
    this.is_uploaded,
    this.is_edited,
    this.is_deleted,
    this.creche_id,
    this.created_at,
    this.created_by,
    this.update_at,
    this.updated_by,
    this.name,
    this.parent
  });

  factory HouseHoldChildrenModel.fromJson(Map<String, dynamic> json) => HouseHoldChildrenModel(
    HHGUID: json["HHGUID"],
    CHHGUID: json["CHHGUID"],
    responces: json["responces"],
    is_uploaded: json["is_uploaded"],
    is_edited: json["is_edited"],
    is_deleted: json["is_deleted"],
    creche_id: json["creche_id"],
    created_at: json["created_at"],
    created_by: json["created_by"],
    update_at: json["update_at"],
    updated_by: json["updated_by"],
    name: json["name"],
    parent: json["parent"],

  );

  Map<String, dynamic> toJson() => {
    "HHGUID": HHGUID,
    "CHHGUID": CHHGUID,
    "responces": responces,
    "is_uploaded": is_uploaded,
    "is_edited": is_edited,
    "is_deleted": is_deleted,
    "created_at": created_at,
    "created_by": created_by,
    "creche_id": creche_id,
    "update_at": update_at,
    "updated_by": updated_by,
    "name": name,
    "parent": parent,
  };
}
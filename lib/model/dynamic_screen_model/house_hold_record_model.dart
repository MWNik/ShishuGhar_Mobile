
class HouseHoldRecordModel {
  String? HHGUID;
  int?	id;
  int? state_id;
  int?  district_id;
  int? block_id;
  int? gp_id;
  int? village_id;
  int? is_uploaded;
  int? is_verified;
  String? verification_status;
  int? is_edited;
  int? is_deleted;
  String? created_at;
  String? created_by;
  String? update_at;
  String? updated_by;

  HouseHoldRecordModel({
    this.HHGUID,
    this.id,
    this.state_id,
    this.district_id,
    this.block_id,
    this.gp_id,
    this.village_id,
    this.is_edited,
    this.is_deleted,
    this.created_at,
    this.created_by,
    this.update_at,
    this.updated_by
  });

  factory HouseHoldRecordModel.fromJson(Map<String, dynamic> json) => HouseHoldRecordModel(
    HHGUID: json["HHGUID"],
    id: json["id"],
    state_id: json["state_id"],
    district_id: json["district_id"],
    block_id: json["block_id"],
    gp_id: json["gp_id"],
    village_id: json["village_id"],
    is_edited: json["is_edited"],
    is_deleted: json["is_deleted"],
    created_at: json["created_at"],
    created_by: json["created_by"],
    update_at: json["update_at"],
    updated_by: json["updated_by"],

  );

  Map<String, dynamic> toJson() => {
    "HHGUID": HHGUID,
    "id": id,
    "state_id": state_id,
    "district_id":district_id,
    "block_id": block_id,
    "gp_id": gp_id,
    "village_id": village_id,
    "is_edited": is_edited,
    "is_deleted": is_deleted,
    "created_at": created_at,
    "created_by": created_by,
    "update_at": update_at,
    "updated_by": updated_by,
  };
}
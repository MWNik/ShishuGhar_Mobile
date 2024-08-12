class ChildGrowthMetaResponseModel {
  int? name;
  String? cgmguid;
    String? responces;
    String? measurement_date;
  int? is_uploaded;
  int? is_edited;
  int? is_deleted;
  String? created_at;
  String? created_by;
  String? update_at;
  String? updated_by;
  int? creche_id;

  ChildGrowthMetaResponseModel(
      {
      this.name,
      this.cgmguid,
      this.responces,
      this.measurement_date,
      this.is_edited,
      this.is_deleted,
      this.created_at,
      this.created_by,
      this.update_at,
      this.updated_by,
      this.is_uploaded,
      this.creche_id});

  factory ChildGrowthMetaResponseModel.fromJson(Map<String, dynamic> json) =>
      ChildGrowthMetaResponseModel(
        name: json["name"],
        cgmguid: json["cgmguid"],
        responces: json["responces"],
        measurement_date: json["measurement_date"],
        is_edited: json["is_edited"],
        is_deleted: json["is_deleted"],
        created_at: json["created_at"],
        created_by: json["created_by"],
        update_at: json["update_at"],
        updated_by: json["updated_by"],
        is_uploaded: json["is_uploaded"],
        creche_id: json["creche_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "cgmguid": cgmguid,
        "responces": responces,
        "measurement_date": measurement_date,
        "is_edited": is_edited,
        "is_deleted": is_deleted,
        "created_at": created_at,
        "created_by": created_by,
        "update_at": update_at,
        "updated_by": updated_by,
        "is_uploaded": is_uploaded,
        "creche_id": creche_id,
      };
}

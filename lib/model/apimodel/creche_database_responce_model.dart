
class CresheDatabaseResponceModel {
  int? name;
  String? responces;
  int? is_uploaded;
  int? is_edited;
  int? is_deleted;
  String? created_at;
  String? created_by;
  String? update_at;
  String? updated_by;

  CresheDatabaseResponceModel(
      {this.name,
      this.responces,
      this.is_edited,
      this.is_deleted,
      this.created_at,
      this.created_by,
      this.update_at,
      this.updated_by,
      this.is_uploaded});

  factory CresheDatabaseResponceModel.fromJson(Map<String, dynamic> json) =>
      CresheDatabaseResponceModel(
        name: json["name"],
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
        "name": name,
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

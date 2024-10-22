class StockResponseModel {
  String? sguid;
  int? year;
  int? month;
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
  int? item_id;

  StockResponseModel(
      {this.sguid,
      this.name,
      this.creche_id,
      this.responces,
      this.is_edited,
      this.is_deleted,
      this.created_at,
      this.created_by,
      this.update_at,
      this.updated_by,
      this.is_uploaded,
      this.month,
      this.year,
      this.item_id,
      });

  factory StockResponseModel.fromJson(Map<String, dynamic> json) =>
      StockResponseModel(
        sguid: json["sguid"],
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
        month: json["month"],
        year: json["year"],
        item_id: json["item_id"],
      );

  Map<String, dynamic> toJson() => {
        "sguid": sguid,
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
        "month": month,
        "year": year,
        "item_id": item_id,
      };
}

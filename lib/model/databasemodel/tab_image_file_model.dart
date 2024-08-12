class ImageFileTabResponceModel {
  String? img_guid;
  String? field_name;
  String? doctype;
  String? doctype_guid;
  String? child_doctype_guid;
  String? image_name;
  int? is_edited;
  int? name;
  String? created_at;
  String? created_by;
  String? update_at;
  String? updated_by;
  int? is_uploaded;

  ImageFileTabResponceModel(
      {this.img_guid,
      this.field_name,
      this.name,
      this.doctype,
      this.doctype_guid,
      this.child_doctype_guid,
      this.image_name,
      this.is_edited,
      this.created_at,
      this.created_by,
      this.update_at,
      this.updated_by,
      this.is_uploaded});

  factory ImageFileTabResponceModel.fromJson(Map<String, dynamic> json) =>
      ImageFileTabResponceModel(
        img_guid: json["img_guid"],
        field_name: json["field_name"],
        doctype: json["doctype"],
        doctype_guid: json["doctype_guid"],
        child_doctype_guid: json["child_doctype_guid"],
        image_name: json['image_name'],
        name: json['name'],
        is_edited: json["is_edited"],
        created_at: json["created_at"],
        created_by: json["created_by"],
        update_at: json["update_at"],
        updated_by: json["updated_by"],
        is_uploaded: json["is_uploaded"],
      );

  Map<String, dynamic> toJson() => {
        "img_guid": img_guid,
        "field_name": field_name,
        "doctype": doctype,
        "doctype_guid": doctype_guid,
        "child_doctype_guid": child_doctype_guid,
        "image_name": image_name,
        "name": name,
        "is_edited": is_edited,
        "created_at": created_at,
        "created_by": created_by,
        "update_at": update_at,
        "updated_by": updated_by,
        "is_uploaded": is_uploaded,
      };
}

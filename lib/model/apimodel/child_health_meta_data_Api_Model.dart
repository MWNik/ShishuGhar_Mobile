
import 'house_hold_field_item_model_api.dart';

class ChildHelthMetaFieldsModel {
  TabHousehold_Form? tabChild_Health_Meta;

  ChildHelthMetaFieldsModel({
    this.tabChild_Health_Meta,
  });

  factory ChildHelthMetaFieldsModel.fromJson(Map<String, dynamic> json) =>
      ChildHelthMetaFieldsModel(
        tabChild_Health_Meta: TabHousehold_Form.fromJson(json['Child Health']),
      );

  Map<String, dynamic> toJson() => {
        "Child Health": tabChild_Health_Meta,
      };
}

class TabHousehold_Form {
  String? name;
  String? doctype;
  String? modified;
  List<HouseHoldFielItemdModel>? fields;

  TabHousehold_Form({
    this.name,
    this.doctype,
    this.fields,
    this.modified,
  });

  factory TabHousehold_Form.fromJson(Map<String, dynamic> json) =>
      TabHousehold_Form(
        name: json.containsKey("name") ? json["name"] : null,
        doctype: json.containsKey("doctype") ? json["doctype"] : null,
        modified: json.containsKey("modified") ? json["modified"] : null,
        fields: json["fields"] == null
            ? []
            : List<HouseHoldFielItemdModel>.from(json["fields"]!
                .map((x) => HouseHoldFielItemdModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "doctype": doctype,
        "modified": modified,
        "fields": fields == null
            ? []
            : List<dynamic>.from(fields!.map((x) => x.toJson())),
      };
}

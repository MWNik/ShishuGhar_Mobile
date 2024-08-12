
import '../apimodel/house_hold_field_item_model_api.dart';

class ChildExitMetaFieldsModel {
  TabHousehold_Form? tabChild_Exit_Meta;

  ChildExitMetaFieldsModel({
    this.tabChild_Exit_Meta,
  });

  factory ChildExitMetaFieldsModel.fromJson(Map<String, dynamic> json) =>
      ChildExitMetaFieldsModel(
        tabChild_Exit_Meta: TabHousehold_Form.fromJson(json['tabChild Exit']),
      );

  Map<String, dynamic> toJson() => {
        "tabChild Exit": tabChild_Exit_Meta,
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

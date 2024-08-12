

import 'house_hold_field_item_model_api.dart';

class HouseHoldFieldModel {
  TabHousehold_Form? tabHousehold_Form;
  TabHousehold_Form? tabHousehold_Child_Form;

  HouseHoldFieldModel({
    this.tabHousehold_Form,
    this.tabHousehold_Child_Form,
  });

  factory HouseHoldFieldModel.fromJson(Map<String, dynamic> json) => HouseHoldFieldModel(
    tabHousehold_Form: TabHousehold_Form.fromJson(json['tabHousehold Form']),
    tabHousehold_Child_Form: TabHousehold_Form.fromJson(json['tabHousehold Child Form']),
  );

  Map<String, dynamic> toJson() => {
    "tabHousehold Form": tabHousehold_Form,
    "tabHousehold Child Form": tabHousehold_Child_Form,
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
        name: json.containsKey("name") ?  json["name"]:null,
        doctype: json.containsKey("doctype") ?  json["doctype"]:null,
        modified: json.containsKey("modified") ?  json["modified"]:null,
        fields: json["fields"] == null
            ? []
            : List<HouseHoldFielItemdModel>.from(
            json["fields"]!.map((x) => HouseHoldFielItemdModel.fromJson(x))),
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

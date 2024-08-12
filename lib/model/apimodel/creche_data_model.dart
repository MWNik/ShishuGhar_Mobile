

import 'house_hold_field_item_model_api.dart';

class CrecheFieldModel {
  TabHousehold_Form? tabCreche;
  TabHousehold_Form? tabCreche_caregiver;

  CrecheFieldModel({
    this.tabCreche,
    this.tabCreche_caregiver,
  });

  factory CrecheFieldModel.fromJson(Map<String, dynamic> json) => CrecheFieldModel(
    tabCreche: TabHousehold_Form.fromJson(json['tabCreche']),
    tabCreche_caregiver: TabHousehold_Form.fromJson(json['tabCreche Caregiver']),
  );

  Map<String, dynamic> toJson() => {
    "tabCreche": tabCreche,
    "tabCreche Caregiver": tabCreche_caregiver,
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
        doctype: json.containsKey("name") ?  json["doctype"]:null,
        modified: json.containsKey("modified") ?  json["modified"]:null,
        fields: json["fields"] == null
            ? []
            : List<HouseHoldFielItemdModel>.from(
            json["fields"]!.map((x) => HouseHoldFielItemdModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "idx": doctype,
    "modified": modified,
    "fields": fields == null
        ? []
        : List<dynamic>.from(fields!.map((x) => x.toJson())),
  };
}

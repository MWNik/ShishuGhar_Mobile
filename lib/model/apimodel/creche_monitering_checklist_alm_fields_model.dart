import 'house_hold_field_item_model_api.dart';

class CmcALMMetaFieldsModel {
  TabHousehold_Form? tabCreche_Monitoring_CheckList_ALM;

  CmcALMMetaFieldsModel({
    this.tabCreche_Monitoring_CheckList_ALM,
  });

  factory CmcALMMetaFieldsModel.fromJson(Map<String, dynamic> json) =>
      CmcALMMetaFieldsModel(
        tabCreche_Monitoring_CheckList_ALM: TabHousehold_Form.fromJson(
            json['tabCreche Monitoring Checklist ALM']),
      );

  Map<String, dynamic> toJson() => {
        "tabCreche Monitoring Checklist ALM":
            tabCreche_Monitoring_CheckList_ALM,
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

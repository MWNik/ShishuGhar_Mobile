import 'house_hold_field_item_model_api.dart';

class ChildGrowthMetaFieldsModel {
  TabHousehold_Form? tabChild_Growth_Meta;
  TabHousehold_Form? tabAnthropromatic_Data;

  ChildGrowthMetaFieldsModel({
    this.tabChild_Growth_Meta,
    this.tabAnthropromatic_Data,
  });

  factory ChildGrowthMetaFieldsModel.fromJson(Map<String, dynamic> json) =>
      ChildGrowthMetaFieldsModel(
          tabChild_Growth_Meta: TabHousehold_Form.fromJson(json['tabChild Growth Monitoring']),
     tabAnthropromatic_Data: TabHousehold_Form.fromJson(json['tabAnthropromatic Data'])
      );

  Map<String, dynamic> toJson() =>
      {
        "tabChild Growth Monitoring": tabChild_Growth_Meta,
        "tabAnthropromatic Data": tabAnthropromatic_Data
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

import 'house_hold_field_item_model_api.dart';

class VillageProfileMetaFieldsModel {
  TabHousehold_Form? tab_village;
  TabHousehold_Form? tab_demographic_detail;
  TabHousehold_Form? tab_caste_child;

  VillageProfileMetaFieldsModel(
      {this.tab_village, this.tab_demographic_detail, this.tab_caste_child});

  factory VillageProfileMetaFieldsModel.fromJson(Map<String, dynamic> json) =>
      VillageProfileMetaFieldsModel(
        tab_village: TabHousehold_Form.fromJson(json['tabVillage']),
        tab_demographic_detail:
            TabHousehold_Form.fromJson(json['tabDemographic Details']),
        tab_caste_child:
            TabHousehold_Form.fromJson(json['tabCaste child table']),
      );

  Map<String, dynamic> toJson() => {
        "tabVillage": tab_village,
        "tabDemographic Details": tab_demographic_detail,
        "tabCaste child table": tab_caste_child,
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

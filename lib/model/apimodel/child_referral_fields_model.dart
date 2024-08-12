import 'house_hold_field_item_model_api.dart';

class ChildReferralMetaFieldsModel {
  TabHousehold_Form? tabChild_referral_Meta;
  TabHousehold_Form? tabDiagnosis_child_table;
  TabHousehold_Form? tabReferral_child_table;
  TabHousehold_Form? tabTreatment_child_table;
  TabHousehold_Form? tabTreatment_NRC_child_table;

  ChildReferralMetaFieldsModel({
    this.tabChild_referral_Meta,
    this.tabDiagnosis_child_table,
    this.tabReferral_child_table,
    this.tabTreatment_child_table,
    this.tabTreatment_NRC_child_table,
  });

  factory ChildReferralMetaFieldsModel.fromJson(Map<String, dynamic> json) =>
      ChildReferralMetaFieldsModel(
        tabChild_referral_Meta: TabHousehold_Form.fromJson(json['tabChild Referral']),
        tabDiagnosis_child_table: TabHousehold_Form.fromJson(json['tabDiagnosis child table']),
        tabReferral_child_table: TabHousehold_Form.fromJson(json['tabReferral child table']),
        tabTreatment_child_table: TabHousehold_Form.fromJson(json['tabTreatment child table']),
        tabTreatment_NRC_child_table: TabHousehold_Form.fromJson(json['tabTreatment NRC child table']),
      );

  Map<String, dynamic> toJson() => {
        "tabChild Referral": tabChild_referral_Meta,
        "tabDiagnosis child table": tabDiagnosis_child_table,
        "tabReferral child table": tabReferral_child_table,
        "tabTreatment child table": tabTreatment_child_table,
        "tabTreatment NRC child table": tabTreatment_NRC_child_table,
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

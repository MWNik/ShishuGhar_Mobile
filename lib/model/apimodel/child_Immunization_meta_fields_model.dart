import 'house_hold_field_item_model_api.dart';

class ChildImmunizationMetaFieldsModel {
  TabHousehold_Form? tabChild_Immunization_Meta;
  TabHousehold_Form? tabChild_Vaccine_Details;

  ChildImmunizationMetaFieldsModel(
      {this.tabChild_Immunization_Meta, this.tabChild_Vaccine_Details});

  factory ChildImmunizationMetaFieldsModel.fromJson(
          Map<String, dynamic> json) =>
      ChildImmunizationMetaFieldsModel(
        tabChild_Immunization_Meta:
            TabHousehold_Form.fromJson(json['tabChild Immunization']),
        tabChild_Vaccine_Details:
            TabHousehold_Form.fromJson(json['tabVaccine Details']),
      );

  Map<String, dynamic> toJson() => {
        "tabChild Immunization": tabChild_Immunization_Meta,
        "tabVaccine Details": tabChild_Vaccine_Details,
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

import 'house_hold_field_item_model_api.dart';

class CheckInFieldsMetaModel {
  TabHousehold_Form? tab_checkin_meta;
  TabHousehold_Form? tab_visit_purpose;

  CheckInFieldsMetaModel({
    this.tab_checkin_meta,
    this.tab_visit_purpose
  });

  factory CheckInFieldsMetaModel.fromJson(Map<String, dynamic> json) =>
      CheckInFieldsMetaModel(
        tab_checkin_meta:
            TabHousehold_Form.fromJson(json['tabCreche Check In']),
        tab_visit_purpose: TabHousehold_Form.fromJson(json['tabVisit Purpose child table'])
      );

  Map<String, dynamic> toJson() => {
        "tabCreche Check In": tab_checkin_meta,
        'tabVisit Purpose child table': tab_visit_purpose
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

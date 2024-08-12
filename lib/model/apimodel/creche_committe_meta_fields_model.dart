import 'house_hold_field_item_model_api.dart';

class CrecheCommitteFieldsMetaModel {
  TabHousehold_Form? tabChild_creche_committe_Meta;
  TabHousehold_Form? tabAttendees_child_table;

  CrecheCommitteFieldsMetaModel({
    this.tabChild_creche_committe_Meta,
    this.tabAttendees_child_table,
  });

  factory CrecheCommitteFieldsMetaModel.fromJson(Map<String, dynamic> json) =>
      CrecheCommitteFieldsMetaModel(
        tabChild_creche_committe_Meta:
            TabHousehold_Form.fromJson(json['tabCreche Committee Meeting']),
        tabAttendees_child_table:
            TabHousehold_Form.fromJson(json['tabAttendees child table']),
      );

  Map<String, dynamic> toJson() => {
        "tabCreche Committee Meeting": tabChild_creche_committe_Meta,
        "tabAttendees child table": tabAttendees_child_table,
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

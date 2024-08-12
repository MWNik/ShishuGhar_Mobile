import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';

class EnrolledChildrenFieldModel {
  TabChildHHMeta_Form? tabChild_HH_Meta_Form;
  TabChildHHMeta_Form? tabEntitlement_child_table;
  TabChildHHMeta_Form? tabSpecially_abled_child_table;

  EnrolledChildrenFieldModel({
    this.tabChild_HH_Meta_Form,
    this.tabEntitlement_child_table,
    this.tabSpecially_abled_child_table,
  });

  factory EnrolledChildrenFieldModel.fromJson(Map<String, dynamic> json) =>
      EnrolledChildrenFieldModel(
          tabChild_HH_Meta_Form: json['tabChild Profile'] == null
              ? null
              : TabChildHHMeta_Form.fromJson(json['tabChild Profile']),
          tabEntitlement_child_table: json['tabEntitlement child table'] == null
      ? null
          : TabChildHHMeta_Form.fromJson(json['tabEntitlement child table']),
          tabSpecially_abled_child_table: json['tabSpecially abled child table'] == null
      ? null
          : TabChildHHMeta_Form.fromJson(json['tabSpecially abled child table'])
      );

  Map<String, dynamic> toJson() => {
        "tabChild Profile": tabChild_HH_Meta_Form?.toJson(),
        "tabEntitlement child table": tabEntitlement_child_table?.toJson(),
        "tabSpecially abled child table": tabSpecially_abled_child_table?.toJson(),
      };
}

class TabChildHHMeta_Form {
  String? name;
  String? doctype;
  String? modified;
  List<HouseHoldFielItemdModel>? fields;

  TabChildHHMeta_Form({
    this.name,
    this.doctype,
    this.fields,
    this.modified,
  });

  factory TabChildHHMeta_Form.fromJson(Map<String, dynamic> json) =>
      TabChildHHMeta_Form(
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

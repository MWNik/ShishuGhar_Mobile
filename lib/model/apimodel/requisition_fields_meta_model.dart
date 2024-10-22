import 'house_hold_field_item_model_api.dart';

class RequisitionFieldsMetaModel {
  TabHousehold_Form? tab_requisition_meta;
  TabHousehold_Form? tab_requisition_child_table;

  RequisitionFieldsMetaModel(
      {this.tab_requisition_meta, this.tab_requisition_child_table});

  factory RequisitionFieldsMetaModel.fromJson(Map<String, dynamic> json) =>
      RequisitionFieldsMetaModel(
        tab_requisition_meta:
            TabHousehold_Form.fromJson(json['tabCreche Requisition']),
        tab_requisition_child_table:
            TabHousehold_Form.fromJson(json['tabRequisition Child table']),
      );

  Map<String, dynamic> toJson() => {
        "tabCreche Requisition": tab_requisition_meta,
        "tabRequisition Child table": tab_requisition_child_table
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

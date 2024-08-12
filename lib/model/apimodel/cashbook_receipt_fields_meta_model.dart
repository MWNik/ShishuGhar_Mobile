import 'house_hold_field_item_model_api.dart';

class CashBookReceiptFieldsMetaModel {
  TabHousehold_Form? tab_cashbook_receipt;

  CashBookReceiptFieldsMetaModel({
    this.tab_cashbook_receipt,
  });

  factory CashBookReceiptFieldsMetaModel.fromJson(Map<String, dynamic> json) =>
      CashBookReceiptFieldsMetaModel(
        tab_cashbook_receipt:
            TabHousehold_Form.fromJson(json['tabCashbook Receipt']),
      );

  Map<String, dynamic> toJson() => {
        "tabCashbook Receipt": tab_cashbook_receipt,
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

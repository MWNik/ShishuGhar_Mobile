import 'house_hold_field_item_model_api.dart';

class CashBookExpensesFieldsMetaModel {
  TabHousehold_Form? tab_cashbook_expenses;

  CashBookExpensesFieldsMetaModel({
    this.tab_cashbook_expenses,
  });

  factory CashBookExpensesFieldsMetaModel.fromJson(Map<String, dynamic> json) =>
      CashBookExpensesFieldsMetaModel(
        tab_cashbook_expenses: TabHousehold_Form.fromJson(json['tabCashbook']),
      );

  Map<String, dynamic> toJson() => {
        "tabCashbook": tab_cashbook_expenses,
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

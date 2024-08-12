// To parse this JSON data, do
//
//     final formLogicApiModel = formLogicApiModelFromJson(jsonString);

import 'dart:convert';

FormLogicApiModel formLogicApiModelFromJson(String str) => FormLogicApiModel.fromJson(json.decode(str));

String formLogicApiModelToJson(FormLogicApiModel data) => json.encode(data.toJson());

class FormLogicApiModel {
  List<TabFormsLogic> tabFormsLogic;

  FormLogicApiModel({
    required this.tabFormsLogic,
  });

  factory FormLogicApiModel.fromJson(Map<String, dynamic> json) => FormLogicApiModel(
    tabFormsLogic: List<TabFormsLogic>.from(json["tabForms Logic"].map((x) => TabFormsLogic.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "tabForms Logic": List<dynamic>.from(tabFormsLogic.map((x) => x.toJson())),
  };
}

class TabFormsLogic {
  String doc;
  String parentControl;
  String type_of_logic_id;
  String dependentControls;
  String algorithmExpression;

  TabFormsLogic({
    required this.doc,
    required this.parentControl,
    required this.type_of_logic_id,
    required this.dependentControls,
    required this.algorithmExpression,
  });

  factory TabFormsLogic.fromJson(Map<String, dynamic> json) => TabFormsLogic(
    doc: json["doc"],
    parentControl: json["parent_control"],
    type_of_logic_id: json["type_of_logic_id"],
    dependentControls: json["dependent_controls"],
    algorithmExpression: json["algorithm_expression"],
  );

  Map<String, dynamic> toJson() => {
    "doc": doc,
    "parent_control": parentControl,
    "type_of_logic_id": type_of_logic_id,
    "dependent_controls": dependentControls,
    "algorithm_expression": algorithmExpression,
  };
}

import 'package:shishughar/model/apimodel/house_hold_field_item_model_api.dart';

class EnrolledExitChildrenFieldModel {
  TabChildHHMeta_Form? tabChild_Enrollment_and_Exit;

  EnrolledExitChildrenFieldModel({
    this.tabChild_Enrollment_and_Exit,
  });

  factory EnrolledExitChildrenFieldModel.fromJson(Map<String, dynamic> json) =>
      EnrolledExitChildrenFieldModel(
          tabChild_Enrollment_and_Exit: json['tabChild Enrollment and Exit'] == null
              ? null
              : TabChildHHMeta_Form.fromJson(json['tabChild Enrollment and Exit'])
      );

  Map<String, dynamic> toJson() => {
        "tabChild Enrollment and Exit": tabChild_Enrollment_and_Exit?.toJson(),
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

import 'house_hold_field_item_model_api.dart';

class ChildAttendanceFieldModel {
  TabHousehold_Form? tabChild_Attendance;
  TabHousehold_Form? tabChild_Attendance_List;

  ChildAttendanceFieldModel({
    this.tabChild_Attendance,
    this.tabChild_Attendance_List,
  });

  factory ChildAttendanceFieldModel.fromJson(Map<String, dynamic> json) =>
      ChildAttendanceFieldModel(
          tabChild_Attendance:
              TabHousehold_Form.fromJson(json['tabChild Attendance']),
          tabChild_Attendance_List:
              TabHousehold_Form.fromJson(json['tabChild Attendance List']));

  Map<String, dynamic> toJson() => {
        "tabChild Attendance": tabChild_Attendance,
        "tabChild Attendance List": tabChild_Attendance_List
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

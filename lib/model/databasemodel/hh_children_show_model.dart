// To parse this JSON data, do
//
//     final hhChildrenShowData = hhChildrenShowDataFromJson(jsonString);

import 'dart:convert';

HhChildrenShowData hhChildrenShowDataFromJson(String str) => HhChildrenShowData.fromJson(json.decode(str));

String hhChildrenShowDataToJson(HhChildrenShowData data) => json.encode(data.toJson());

class HhChildrenShowData {
  String? childName;
  String? genderId;
  String? relationshipWithChild;
  String? isDobAvailable;
  String? childDob;
  String? childAge;
  String? hhguid;
  String? hhcguid;

  HhChildrenShowData({
    this.childName,
    this.genderId,
    this.relationshipWithChild,
    this.isDobAvailable,
    this.childDob,
    this.childAge,
    this.hhguid,
    this.hhcguid,
  });

  factory HhChildrenShowData.fromJson(Map<String, dynamic> json) => HhChildrenShowData(
    childName: json["child_name"],
    genderId: json["gender_id"],
    relationshipWithChild: json["relationship_with_child"],
    isDobAvailable: json["is_dob_available"],
    childDob: json["child_dob"],
    childAge: json["child_age"],
    hhguid: json["hhguid"],
    hhcguid: json["hhcguid"],
  );

  Map<String, dynamic> toJson() => {
    "child_name": childName,
    "gender_id": genderId,
    "relationship_with_child": relationshipWithChild,
    "is_dob_available": isDobAvailable,
    "child_dob": childDob,
    "child_age": childAge,
    "hhguid": hhguid,
    "hhcguid": hhcguid,
  };
}


class ChildForAttendenceModel {
  String? childattenguid;
  int?  attendance;
  int?  name;
  int?  child_profile_id;
  String? date_of_attendance;
  String? childenrolledguid;
  String? name_of_child;



  ChildForAttendenceModel({
    this.childattenguid,
    this.name,
    this.child_profile_id,
    this.attendance,
    this.date_of_attendance,
    this.childenrolledguid,
    this.name_of_child,
  });

  factory ChildForAttendenceModel.fromJson(Map<String, dynamic> json) => ChildForAttendenceModel(
    childattenguid: json["childattenguid"],
    date_of_attendance: json["date_of_attendance"],
    attendance: json["attendance"],
    name: json["name"],
    childenrolledguid: json["childenrolledguid"],
    name_of_child: json["name_of_child"],
    child_profile_id: json["child_profile_id"],

  );

  Map<String, dynamic> toJson() => {
    "childattenguid": childattenguid,
    "date_of_attendance": date_of_attendance,
    "childenrolledguid": childenrolledguid,
    "attendance": attendance,
    "name": name,
    "name_of_child": name_of_child,
    "child_profile_id": child_profile_id,
  };
}
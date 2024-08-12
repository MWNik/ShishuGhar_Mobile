class TabVerificationStatusModel {
  int? name;
  String? value;

  TabVerificationStatusModel({
    this.name,
    this.value,
  });

  factory TabVerificationStatusModel.fromJson(Map<String, dynamic> json) =>
      TabVerificationStatusModel(
        name: json["name"],
        value: json["verfication_status_name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "verfication_status_name": value,
      };
}

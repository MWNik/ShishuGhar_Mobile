class TabGenderModel {
  int? name;
  String? value;

  TabGenderModel({
    this.name,
    this.value,
  });

  factory TabGenderModel.fromJson(Map<String, dynamic> json) => TabGenderModel(
        name: json["name"],
        value: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "gender": value,
      };
}

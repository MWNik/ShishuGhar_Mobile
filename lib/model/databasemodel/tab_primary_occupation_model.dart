class TabPrimaryOccupationModel {
  int? name;
  String? value;

  TabPrimaryOccupationModel({
    this.name,
    this.value,
  });

  factory TabPrimaryOccupationModel.fromJson(Map<String, dynamic> json) =>
      TabPrimaryOccupationModel(
        name: json["name"],
        value: json["primary_occupation"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "primary_occupation": value,
      };
}

class OptionsModel {
  String? name;
  String? values;
  String? flag;

  OptionsModel({
    this.name,
    this.values,
    this.flag,
  });

  factory OptionsModel.fromJson(Map<String, dynamic> json) => OptionsModel(
        name: json["name"],
        values: json["values"],
    flag: json["flag"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "values": values,
        "flag": flag,
      };
}

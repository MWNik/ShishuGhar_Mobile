
class ResponceJsonModel {
  String? name;
  String? value;

  ResponceJsonModel({
    this.name,
    this.value,
  });

  factory ResponceJsonModel.fromJson(Map<String, dynamic> json) => ResponceJsonModel(
    name: json["name"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
  };
}
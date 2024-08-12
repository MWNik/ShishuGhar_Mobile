
class TabWeightToHeightGirlsModel{
  int? name;
  num? length;
  num? height;
  num? green;
  num? red;
  num? yellow_max;
  num? yellow_min;

  TabWeightToHeightGirlsModel({
    this.name,
    this.length,
    this.height,
    this.green,
    this.red,
    this.yellow_max,
    this.yellow_min,
  });

  factory TabWeightToHeightGirlsModel.fromJson(Map<String, dynamic> json) => TabWeightToHeightGirlsModel(
    name: json["name"],
    length: json["length"],
    height: json["height"],
    green: json["green"],
    red: json["red"],
    yellow_max: json["yellow_max"],
    yellow_min: json["yellow_min"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "length": length,
    "height": height,
    "green": green,
    "red": red,
    "yellow_max": yellow_max,
    "yellow_min": yellow_min,
  };
}
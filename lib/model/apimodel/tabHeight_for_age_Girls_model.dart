
class TabHeightforageGirlsModel{
  int? name;
  num? age_in_months;
  num? green;
  num? red;
  num? yellow_max;
  num? yellow_min;

  TabHeightforageGirlsModel({
    this.name,
    this.age_in_months,
    this.green,
    this.red,
    this.yellow_max,
    this.yellow_min,
  });

  factory TabHeightforageGirlsModel.fromJson(Map<String, dynamic> json) => TabHeightforageGirlsModel(
    name: json["name"],
    age_in_months: json["age_in_months"],
    green: json["green"],
    red: json["red"],
    yellow_max: json["yellow_max"],
    yellow_min: json["yellow_min"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "age_in_months": age_in_months,
    "green": green,
    "red": red,
    "yellow_max": yellow_max,
    "yellow_min": yellow_min,
  };
}
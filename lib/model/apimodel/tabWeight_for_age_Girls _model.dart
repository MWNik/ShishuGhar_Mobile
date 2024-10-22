
class TabWeightforageGirlsModel{
  int? name;
  num? age_in_days;
  num? green;
  num? red;
  num? yellow_max;
  num? yellow_min;

  TabWeightforageGirlsModel({
    this.name,
    this.age_in_days,
    this.green,
    this.red,
    this.yellow_max,
    this.yellow_min,
  });

  factory TabWeightforageGirlsModel.fromJson(Map<String, dynamic> json) => TabWeightforageGirlsModel(
    name: json["name"],
    age_in_days: json["age_in_days"],
    green: json["green"],
    red: json["red"],
    yellow_max: json["yellow_max"],
    yellow_min: json["yellow_min"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "age_in_days": age_in_days,
    "green": green,
    "red": red,
    "yellow_max": yellow_max,
    "yellow_min": yellow_min,
  };
}
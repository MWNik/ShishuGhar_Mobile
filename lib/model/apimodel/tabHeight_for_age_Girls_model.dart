
class TabHeightforageGirlsModel{
  int? name;
  num? age_in_days;
  num? green;
  num? red;
  num? yellow_max;
  num? yellow_min;
  num? l;
  num? m;
  num? s;
  num? sd4neg;
  num? sd3neg;
  num? sd2neg;
  num? sd1neg;
  num? sd0;
  num? sd1;
  num? sd2;
  num? sd3;
  num? sd4;

  TabHeightforageGirlsModel({
    this.name,
    this.age_in_days,
    this.green,
    this.red,
    this.yellow_max,
    this.yellow_min,
    this.l,
    this.m,
    this.s,
    this.sd4neg,
    this.sd3neg,
    this.sd2neg,
    this.sd1neg,
    this.sd0,
    this.sd1,
    this.sd2,
    this.sd3,
    this.sd4
  });

  factory TabHeightforageGirlsModel.fromJson(Map<String, dynamic> json) => TabHeightforageGirlsModel(
    name: json["name"],
    age_in_days: json["age_in_days"],
    green: json["green"],
    red: json["red"],
    yellow_max: json["yellow_max"],
    yellow_min: json["yellow_min"],
    l: json["l"],
    m: json["m"],
    s: json["s"],
    sd4neg: json["sd4neg"],
    sd3neg: json["sd3neg"],
    sd2neg: json["sd2neg"],
    sd1neg: json["sd1neg"],
    sd0: json["sd0"],
    sd1: json["sd1"],
    sd2: json["sd2"],
    sd3: json["sd3"],
    sd4: json["sd4"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "age_in_days": age_in_days,
    "green": green,
    "red": red,
    "yellow_max": yellow_max,
    "yellow_min": yellow_min,
    "l": l,
    "m": m,
    "s": s,
    "sd4neg": sd4neg,
    "sd3neg": sd3neg,
    "sd2neg": sd2neg,
    "sd1neg": sd1neg,
    "sd0": sd0,
    "sd1": sd1,
    "sd2": sd2,
    "sd3": sd3,
    "sd4": sd4,
  };
}
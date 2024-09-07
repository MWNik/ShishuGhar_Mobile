class MonthYearModel {
  int? month;
  int? Year;

  MonthYearModel({
    this.month,
    this.Year,
  });

  factory MonthYearModel.fromJson(Map<String, dynamic> json) => MonthYearModel(
        month: json["month"],
        Year: json["Year"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "Year": Year,
      };
}

class MonthYearModel {
  int? month;
  int? Year;
  int? is_edited;
  int? is_uploaded;

  MonthYearModel({
    this.month,
    this.Year,
    this.is_edited,
    this.is_uploaded
  });

  factory MonthYearModel.fromJson(Map<String, dynamic> json) => MonthYearModel(
        month: json["month"],
        Year: json["Year"],
        is_edited: json["is_edited"],
        is_uploaded: json["is_uploaded"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "Year": Year,
        "is_edited": is_edited,
        "is_uploaded":is_uploaded
      };

      // Override the equality operator.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthYearModel &&
        other.month == month &&
        other.Year == Year;
  }

  // Override the hashCode.
  @override
  int get hashCode => month.hashCode ^ Year.hashCode;
}

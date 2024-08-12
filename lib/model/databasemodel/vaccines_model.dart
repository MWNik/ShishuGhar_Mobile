
class VaccineModel {
  int? name;
  String? vaccine;
  int? days;
  String? site_for_vaccinations;
  String? categories;

  VaccineModel({
    this.name,
    this.vaccine,
    this.days,
    this.site_for_vaccinations,
    this.categories,
  });

  factory VaccineModel.fromJson(Map<String, dynamic> json) => VaccineModel(
    name: json["name"],
    vaccine: json["vaccine"],
    days: json["days"],
    site_for_vaccinations: json["site_for_vaccinations"],
    categories: json["categories"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "vaccine": vaccine,
    "days": days,
    "site_for_vaccinations": site_for_vaccinations,
    "categories": categories,
  };
}
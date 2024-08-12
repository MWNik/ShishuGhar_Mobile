class TabPartnerModel {
  int? name;
  String? partnerCode;
  String? value;

  TabPartnerModel({
    this.name,
    this.partnerCode,
    this.value,
  });

  factory TabPartnerModel.fromJson(Map<String, dynamic> json) =>
      TabPartnerModel(
        name: json["name"],
        partnerCode: json["partner_code"],
        value: json["partner_name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "partner_code": partnerCode,
        "partner_name": value,
      };
}

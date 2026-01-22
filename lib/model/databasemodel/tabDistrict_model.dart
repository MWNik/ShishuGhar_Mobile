class TabDistrict {
  int? name;
  String? stateId;
  String? districtCode;
  String? value;
  String? district_od;
  String? district_hi;
  String? district_kn;

  TabDistrict({
    this.name,
    this.stateId,
    this.districtCode,
    this.value,
    this.district_od,
    this.district_hi,
    this.district_kn,
  });

  factory TabDistrict.fromJson(Map<String, dynamic> json) => TabDistrict(
        name: json["name"],
        stateId: json["state_id"],
        districtCode: json["district_code"],
        value: json["value"],
    district_od: json["district_od"],
    district_hi: json["district_hi"],
    district_kn: json["district_kn"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "state_id": stateId,
        "district_code": districtCode,
        "value": value,
        "district_od": district_od,
        "district_hi": district_hi,
        "district_kn": district_kn,
      };
}

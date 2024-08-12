class TabGramPanchayat {
  int? name;
  String? stateId;
  String? districtId;
  String? blockId;
  String? value;
  String? gp_od;
  String? gp_hi;
  dynamic gpCode;

  TabGramPanchayat({
    this.name,
    this.stateId,
    this.districtId,
    this.blockId,
    this.value,
    this.gpCode,
     this.gp_od,
     this.gp_hi,
  });

  factory TabGramPanchayat.fromJson(Map<String, dynamic> json) =>
      TabGramPanchayat(
        name: json["name"],
        stateId: json["state_id"],
        districtId: json["district_id"],
        blockId: json["block_id"],
        value: json["value"],
        gpCode: json["gp_code"],
        gp_od: json["gp_od"],
        gp_hi: json["gp_hi"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "state_id": stateId,
        "district_id": districtId,
        "block_id": blockId,
        "value": value,
        "gp_code": gpCode,
        "gp_od": gp_od,
        "gp_hi": gp_hi,
      };
}

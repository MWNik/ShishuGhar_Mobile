class TabVillage {
  int? name;
  String? stateId;
  String? districtId;
  String? blockId;
  String? gpId;
  String? villageCode;
  String? value;
  String? village_od;
  String? village_hi;

  TabVillage({
    this.name,
    this.stateId,
    this.districtId,
    this.blockId,
    this.gpId,
    this.villageCode,
    this.value,
    this.village_od,
    this.village_hi,
  });

  factory TabVillage.fromJson(Map<String, dynamic> json) => TabVillage(
        name: json["name"],
        stateId: json["state_id"],
        districtId: json["district_id"],
        blockId: json["block_id"],
        gpId: json["gp_id"],
        villageCode: json["village_code"],
        value: json["value"],
    village_od: json["village_od"],
    village_hi: json["village_hi"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "state_id": stateId,
        "district_id": districtId,
        "block_id": blockId,
        "gp_id": gpId,
        "village_code": villageCode,
        "value": value,
        "village_od": village_od,
        "village_hi": village_hi,
      };
}

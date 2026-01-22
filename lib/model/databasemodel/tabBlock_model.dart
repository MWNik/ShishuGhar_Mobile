class TabBlock {
  int? name;
  String? stateId;
  String? districtId;
  String? blockCode;
  String? value;
  String? block_od;
  String? block_hi;
  String? block_kn;

  TabBlock({
    this.name,
    this.stateId,
    this.districtId,
    this.blockCode,
    this.value,
    this.block_od,
    this.block_hi,
    this.block_kn,
  });

  factory TabBlock.fromJson(Map<String, dynamic> json) => TabBlock(
        name: json["name"],
        stateId: json["state_id"],
        districtId: json["district_id"],
        blockCode: json["block_code"],
        value: json["value"],
    block_od: json["block_od"],
    block_hi: json["block_hi"],
    block_kn: json["block_kn"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "state_id": stateId,
        "district_id": districtId,
        "block_code": blockCode,
        "value": value,
        "block_od": block_od,
        "block_hi": block_hi,
        "block_kn": block_kn,
      };
}

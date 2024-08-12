class Mapping {
  int? name;
  int? idx;
  String? stateId;
  String? districtId;
  String? blockId;
  String? parent;
  String? parentfield;
  String? parenttype;
  String? doctype;

  Mapping({
    this.name,
    this.idx,
    this.stateId,
    this.districtId,
    this.blockId,
    this.parent,
    this.parentfield,
    this.parenttype,
    this.doctype,
  });

  factory Mapping.fromJson(Map<String, dynamic> json) => Mapping(
    name: json["name"],
    idx: json["idx"],
    stateId: json["state_id"],
    districtId: json["district_id"],
    blockId: json["block_id"],
    parent: json["parent"],
    parentfield: json["parentfield"],
    parenttype: json["parenttype"],
    doctype: json["doctype"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "idx": idx,
    "state_id": stateId,
    "district_id": districtId,
    "block_id": blockId,
    "parent": parent,
    "parentfield": parentfield,
    "parenttype": parenttype,
    "doctype": doctype,
  };
}
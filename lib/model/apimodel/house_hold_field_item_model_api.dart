
class HouseHoldFielItemdModel {
  String? name;
  int? idx;
  String? fieldtype;
  String? fieldname;
  int? reqd;
  String? label;
  String? options;
  String? parent;
  int? hidden;
  int? length;
  String? depends_on;
  String? read_only_depends_on;
  String? mandatory_depends_on;
  String? multiselectlink;
  int? ismultiselect;

  HouseHoldFielItemdModel({
    this.name,
    this.idx,
    this.fieldtype,
    this.fieldname,
    this.reqd,
    this.label,
    this.options,
    this.parent,
    this.hidden,
    this.length,
    this.depends_on,
    this.mandatory_depends_on,
    this.read_only_depends_on,
    this.ismultiselect,
    this.multiselectlink,
  });

  factory HouseHoldFielItemdModel.fromJson(Map<String, dynamic> json) => HouseHoldFielItemdModel(
    name: json.containsKey("name") ?  json["name"]:null,
    idx: json.containsKey("idx") ? json["idx"]:null,
    fieldtype: json.containsKey("fieldtype") ?  json["fieldtype"]:null,
    fieldname: json.containsKey("fieldname") ?  json["fieldname"]:null,
    reqd: json.containsKey("reqd") ?  json["reqd"]:null,
    label: json.containsKey("label") ?  json["label"]:null,
    options: json.containsKey("options") ?  json["options"]:null,
    parent: json.containsKey("parent") ?  json["parent"]:null,
    hidden: json.containsKey("hidden") ?  json["hidden"]:null,
    length: json.containsKey("length") ?  json["length"]:null,
    depends_on: json.containsKey("depends_on") ?  json["depends_on"]:null,
    mandatory_depends_on: json.containsKey("mandatory_depends_on") ?  json["mandatory_depends_on"]:null,
    read_only_depends_on: json.containsKey("read_only_depends_on") ?  json["read_only_depends_on"]:null,
    ismultiselect: json.containsKey("ismultiselect") ?  json["ismultiselect"]:null,
    multiselectlink: json.containsKey("multiselectlink") ?  json["multiselectlink"]:null,
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "idx": idx,
    "fieldtype": fieldtype,
    "fieldname": fieldname,
    "reqd": reqd,
    "label": label,
    "options": options,
    "parent": parent,
    "hidden": hidden,
    "length": length,
    "depends_on": depends_on,
    "mandatory_depends_on": mandatory_depends_on,
    "read_only_depends_on": read_only_depends_on,
    "multiselectlink": multiselectlink,
    "ismultiselect": ismultiselect,
  };


}


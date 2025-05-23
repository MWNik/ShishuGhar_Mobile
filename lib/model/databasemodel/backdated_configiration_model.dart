
class BackdatedConfigirationModel {

  int? name;
  String? supervisor_id;
  String? doctype;
  int? back_dated_data_entry_allowed;
  int? partner_id;
  int? data_edit_allowed;
  String? unique_id;
  String? creation;
  String? module;
  String? type;
  String? date;

  BackdatedConfigirationModel({
    this.name,
    this.supervisor_id,
    this.doctype,
    this.back_dated_data_entry_allowed,
    this.partner_id,
    this.data_edit_allowed,
    this.unique_id,
    this.creation,
    this.module,
    this.type,
    this.date,
  });

  factory BackdatedConfigirationModel.fromJson(Map<String, dynamic> json) => BackdatedConfigirationModel(
    name: json["name"],
    supervisor_id: json["supervisor_id"],
    doctype: json["doctype"],
    back_dated_data_entry_allowed: json["back_dated_data_entry_allowed"],
    partner_id: json["partner_id"],
    data_edit_allowed: json["data_edit_allowed"],
    unique_id: json["unique_id"],
    creation: json["creation"],
    module: json["module"],
    type: json["type"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "supervisor_id": supervisor_id,
    "doctype": doctype,
    "back_dated_data_entry_allowed": back_dated_data_entry_allowed,
    "partner_id": partner_id,
    "data_edit_allowed": data_edit_allowed,
    "unique_id": unique_id,
    "creation": creation,
    "module": module,
    "type": type,
    "date": date,
  };
}
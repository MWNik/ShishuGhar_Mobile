class MasterStockModel {
  int? name;
  String? stock;
  String? odia;
  String? hindi;
  int? is_active;
  int? seq_id;

  MasterStockModel({
    this.name,
    this.hindi,
    this.is_active,
    this.odia,
    this.seq_id,
    this.stock
  });

  factory MasterStockModel.fromJson(Map<String, dynamic> json) => MasterStockModel(
    name: json["name"],
    stock: json["stock"],
    odia: json["odia"],
    hindi: json["hindi"],
    is_active: json["is_active"],
    seq_id: json['seq_id']
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "stock": stock,
    "odia": odia,
    "hindi": hindi,
    "is_active": is_active,
    "seq_id": seq_id
  };
}
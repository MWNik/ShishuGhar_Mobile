class MasterStockModel {
  int? name;
  String? stock;
  String? odia;
  String? hindi;
  String? kannada;
  int? is_active;
  int? seq_id;

  MasterStockModel({
    this.name,
    this.hindi,
    this.is_active,
    this.odia,
    this.kannada,
    this.seq_id,
    this.stock
  });

  factory MasterStockModel.fromJson(Map<String, dynamic> json) => MasterStockModel(
    name: json["name"],
    stock: json["stock"],
    odia: json["odia"],
    hindi: json["hindi"],
      kannada: json["kannada"],
    is_active: json["is_active"],
    seq_id: json['seq_id']
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "stock": stock,
    "odia": odia,
    "hindi": hindi,
    "kannada": kannada,
    "is_active": is_active,
    "seq_id": seq_id
  };
}
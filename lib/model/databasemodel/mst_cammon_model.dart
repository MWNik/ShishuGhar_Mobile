class MstCommonOtherModel {
  int? name;
  String? flag;
  String? value;
  int? seq_id;
  String? hindi;
  String? oidya;
  String? kannada;

  MstCommonOtherModel({
    this.name,
    this.flag,
    this.value,
    this.seq_id,
    this.hindi,
    this.oidya,
    this.kannada,
  });

  factory MstCommonOtherModel.fromJson(Map<String, dynamic> json) =>
      MstCommonOtherModel(
        name: json["name"],
        flag: json["flag"],
        value: json["value"],
        seq_id: json["seq_id"],
        hindi: json["hindi"],
        oidya: json["oidya"],
        kannada: json["kannada"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "flag": flag,
    "value": value,
    "seq_id": seq_id,
    "hindi": hindi,
    "oidya": oidya,
    "kannada": kannada,
  };
}

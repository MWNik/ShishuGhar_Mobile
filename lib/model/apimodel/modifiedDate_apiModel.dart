
import 'dart:convert';

ModifiedApiModel modifiedApiModelFromJson(String str) =>
    ModifiedApiModel.fromJson(json.decode(str));

String modifiedApiModelToJson(ModifiedApiModel data) =>
    json.encode(data.toJson());

class ModifiedApiModel {
  List<DocType>? docType;

  ModifiedApiModel({
    this.docType,
  });

  factory ModifiedApiModel.fromJson(Map<String, dynamic> json) =>
      ModifiedApiModel(
        docType: json["DocType"] == null
            ? []
            : List<DocType>.from(
                json["DocType"]!.map((x) => DocType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "DocType": docType == null
            ? []
            : List<dynamic>.from(docType!.map((x) => x.toJson())),
      };
}

class DocType {
  String? name;
  DateTime? modified;

  DocType({
    this.name,
    this.modified,
  });

  factory DocType.fromJson(Map<String, dynamic> json) => DocType(
        name: json["name"],
        modified:
            json["modified"] == null ? null : DateTime.parse(json["modified"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "modified": modified?.toIso8601String(),
      };
}

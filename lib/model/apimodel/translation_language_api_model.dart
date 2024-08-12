// To parse this JSON data, do
//
//     final translationModel = translationModelFromJson(jsonString);

import 'dart:convert';

TranslationModel translationModelFromJson(String str) =>
    TranslationModel.fromJson(json.decode(str));

String translationModelToJson(TranslationModel data) =>
    json.encode(data.toJson());

class TranslationModel {
  List<Translation>? translation;

  TranslationModel({
    this.translation,
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) =>
      TranslationModel(
        translation: json["Translation"] == null
            ? []
            : List<Translation>.from(
                json["Translation"]!.map((x) => Translation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Translation": translation == null
            ? []
            : List<dynamic>.from(translation!.map((x) => x.toJson())),
      };
}

class Translation {
  String? name;
  String? english;
  String? hindi;
  String? odia;

  Translation({
    this.name,
    this.english,
    this.hindi,
    this.odia,
  });

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        name: json["name"],
        english: json["english"],
        hindi: json["hindi"],
        odia: json["odia"],
      );

  Map<String, dynamic> toJson() => {
        "value_name": name,
        "value_en": english,
        "value_hi": hindi,
        "value_od": odia,
      };
}

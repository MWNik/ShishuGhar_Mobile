// To parse this JSON data, do
//
//     final formLogicApiModel = formLogicApiModelFromJson(jsonString);

import 'dart:convert';

import '../databasemodel/backdated_configiration_model.dart';

BackdatedConfigirationModelApiModel formLogicApiModelFromJson(String str) => BackdatedConfigirationModelApiModel.fromJson(json.decode(str));

String formLogicApiModelToJson(BackdatedConfigirationModelApiModel data) => json.encode(data.toJson());

class BackdatedConfigirationModelApiModel {
  List<BackdatedConfigirationModel> backdatedConfigirationModel;

  BackdatedConfigirationModelApiModel({
    required this.backdatedConfigirationModel,
  });

  factory BackdatedConfigirationModelApiModel.fromJson(Map<String, dynamic> json) => BackdatedConfigirationModelApiModel(
    backdatedConfigirationModel: List<BackdatedConfigirationModel>.from(json["Data"].map((x) => BackdatedConfigirationModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Data": List<dynamic>.from(backdatedConfigirationModel.map((x) => x.toJson())),
  };
}


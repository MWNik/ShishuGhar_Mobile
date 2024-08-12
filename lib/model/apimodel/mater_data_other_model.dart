// To parse this JSON data, do
//
//     final mstCommonModel = mstCommonModelFromJson(jsonString);

import 'dart:convert';

import 'package:shishughar/model/databasemodel/mst_cammon_model.dart';

MstCommonModel mstCommonModelFromJson(String str) => MstCommonModel.fromJson(json.decode(str));

String mstCommonModelToJson(MstCommonModel data) => json.encode(data.toJson());

class MstCommonModel {
  List<MstCommonOtherModel>? tabCommon;

  MstCommonModel({
    this.tabCommon,
  });

  factory MstCommonModel.fromJson(Map<String, dynamic> json) => MstCommonModel(
    tabCommon: json["tabCommon"] == null ? [] : List<MstCommonOtherModel>.from(json["tabCommon"]!.map((x) => MstCommonOtherModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "tabCommon": tabCommon == null ? [] : List<dynamic>.from(tabCommon!.map((x) => x.toJson())),
  };
}

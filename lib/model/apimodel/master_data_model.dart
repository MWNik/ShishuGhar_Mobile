// To parse this JSON data, do
//
//     final masterDataModel = masterDataModelFromJson(jsonString);

import 'dart:convert';

import 'package:shishughar/model/apimodel/supervisor_model.dart';
import 'package:shishughar/model/apimodel/tabHeight_for_age_Boys_model.dart';
import 'package:shishughar/model/apimodel/tabHeight_for_age_Girls_model.dart';
import 'package:shishughar/model/apimodel/tabWeight_for_age_Boys%20_model.dart';
import 'package:shishughar/model/apimodel/tabWeight_for_age_Girls%20_model.dart';
import 'package:shishughar/model/apimodel/tabWeight_to_Height_Boys_model.dart';
import 'package:shishughar/model/apimodel/tabWeight_to_Height_Girls_model.dart';
import 'package:shishughar/model/databasemodel/tabBlock_model.dart';
import 'package:shishughar/model/databasemodel/tabDistrict_model.dart';
import 'package:shishughar/model/databasemodel/tabGramPanchayat_model.dart';
import 'package:shishughar/model/databasemodel/tabVillage_model.dart';
import 'package:shishughar/model/databasemodel/tab_gender_model.dart';
import 'package:shishughar/model/databasemodel/tab_partner_model.dart';
import 'package:shishughar/model/databasemodel/tab_primary_occupation_model.dart';
import 'package:shishughar/model/databasemodel/tab_verification_status_model.dart';
import 'package:shishughar/model/databasemodel/tabstate_model.dart';
import 'package:shishughar/model/databasemodel/vaccines_model.dart';

import '../databasemodel/tab_social_category_model.dart';

MasterDataModel masterDataModelFromJson(String str) => MasterDataModel.fromJson(json.decode(str));

String masterDataModelToJson(MasterDataModel data) => json.encode(data.toJson());

class MasterDataModel {
  List<TabState>? tabState;
  List<TabDistrict>? tabDistrict;
  List<TabBlock>? tabBlock;
  List<TabGramPanchayat>? tabGramPanchayat;
  List<TabVillage>? tabVillage;
  List<TabGenderModel>? tabGender;
  List<TabPartnerModel>? tabPartner;
  List<TabPrimaryOccupationModel>? tabPrimaryOccupation;
  List<TabVerificationStatusModel>? tabVerificationStatus;
  List<TabSocialCategoryModel>? tabSocialCategory;
  List<SupervisorModel>? tabSuperVisor;
  List<TabHeightforageBoysModel>? tabHeightforAgeBoys;
  List<TabHeightforageGirlsModel>? tabHeightforAgeGirls;
  List<TabWeightforageBoysModel>? tabWeightforAgeBoys;
  List<TabWeightforageGirlsModel>? tabWeightforAgeGirls;
  List<TabWeightToHeightBoysModel>? tabWeightToHeightBoys;
  List<TabWeightToHeightGirlsModel>? tabWeightToHeightGirls;
  List<VaccineModel>? tabVaccines;

  MasterDataModel({
    this.tabState,
    this.tabDistrict,
    this.tabBlock,
    this.tabGramPanchayat,
    this.tabVillage,
    this.tabGender,
    this.tabPartner,
    this.tabPrimaryOccupation,
    this.tabVerificationStatus,
    this.tabSocialCategory,
    this.tabSuperVisor,
    this.tabHeightforAgeBoys,
    this.tabHeightforAgeGirls,
    this.tabWeightforAgeBoys,
    this.tabWeightforAgeGirls,
    this.tabWeightToHeightBoys,
    this.tabWeightToHeightGirls,
    this.tabVaccines,
  });

  factory MasterDataModel.fromJson(Map<String, dynamic> json) => MasterDataModel(
    tabState: json["tabState"] == null ? [] : List<TabState>.from(json["tabState"]!.map((x) => TabState.fromJson(x))),
    tabDistrict: json["tabDistrict"] == null ? [] : List<TabDistrict>.from(json["tabDistrict"]!.map((x) => TabDistrict.fromJson(x))),
    tabBlock: json["tabBlock"] == null ? [] : List<TabBlock>.from(json["tabBlock"]!.map((x) => TabBlock.fromJson(x))),
    tabGramPanchayat: json["tabGram Panchayat"] == null ? [] : List<TabGramPanchayat>.from(json["tabGram Panchayat"]!.map((x) => TabGramPanchayat.fromJson(x))),
    tabVillage: json["tabVillage"] == null ? [] : List<TabVillage>.from(json["tabVillage"]!.map((x) => TabVillage.fromJson(x))),
    tabGender: json["tabGender"] == null ? [] : List<TabGenderModel>.from(json["tabGender"]!.map((x) => TabGenderModel.fromJson(x))),
    tabPartner: json["tabPartner"] == null ? [] : List<TabPartnerModel>.from(json["tabPartner"]!.map((x) => TabPartnerModel.fromJson(x))),
    tabPrimaryOccupation: json["tabPrimary Occupation"] == null ? [] : List<TabPrimaryOccupationModel>.from(json["tabPrimary Occupation"]!.map((x) => TabPrimaryOccupationModel.fromJson(x))),
    tabVerificationStatus: json["tabVerification Status"] == null ? [] : List<TabVerificationStatusModel>.from(json["tabVerification Status"]!.map((x) => TabVerificationStatusModel.fromJson(x))),
    tabSocialCategory: json["tabSocial Category"] == null ? [] : List<TabSocialCategoryModel>.from(json["tabSocial Category"]!.map((x) => TabSocialCategoryModel.fromJson(x))),
    tabSuperVisor: json["User"] == null ? [] : List<SupervisorModel>.from(json["User"]!.map((x) => SupervisorModel.fromJson(x))),

      tabHeightforAgeBoys: json["tabHeight for age Boys"] == null ? [] : List<TabHeightforageBoysModel>.from(json["tabHeight for age Boys"]!.map((x) => TabHeightforageBoysModel.fromJson(x))),
    tabHeightforAgeGirls: json["tabHeight for age Girls"] == null ? [] : List<TabHeightforageGirlsModel>.from(json["tabHeight for age Girls"]!.map((x) => TabHeightforageGirlsModel.fromJson(x))),
    tabWeightforAgeBoys: json["tabWeight for age Boys"] == null ? [] : List<TabWeightforageBoysModel>.from(json["tabWeight for age Boys"]!.map((x) => TabWeightforageBoysModel.fromJson(x))),
    tabWeightforAgeGirls: json["tabWeight for age Girls"] == null ? [] : List<TabWeightforageGirlsModel>.from(json["tabWeight for age Girls"]!.map((x) => TabWeightforageGirlsModel.fromJson(x))),
    tabWeightToHeightBoys: json["tabWeight to Height Boys"] == null ? [] : List<TabWeightToHeightBoysModel>.from(json["tabWeight to Height Boys"]!.map((x) => TabWeightToHeightBoysModel.fromJson(x))),
    tabWeightToHeightGirls: json["tabWeight to Height Girls"] == null ? [] : List<TabWeightToHeightGirlsModel>.from(json["tabWeight to Height Girls"]!.map((x) => TabWeightToHeightGirlsModel.fromJson(x))),

    tabVaccines: json["tabVaccines"] == null ? [] : List<VaccineModel>.from(json["tabVaccines"]!.map((x) => VaccineModel.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "tabState": tabState == null ? [] : List<dynamic>.from(tabState!.map((x) => x.toJson())),
    "tabDistrict": tabDistrict == null ? [] : List<dynamic>.from(tabDistrict!.map((x) => x.toJson())),
    "tabBlock": tabBlock == null ? [] : List<dynamic>.from(tabBlock!.map((x) => x.toJson())),
    "tabGram Panchayat": tabGramPanchayat == null ? [] : List<dynamic>.from(tabGramPanchayat!.map((x) => x.toJson())),
    "tabVillage": tabVillage == null ? [] : List<dynamic>.from(tabVillage!.map((x) => x.toJson())),
    "tabGender": tabGender == null ? [] : List<dynamic>.from(tabGender!.map((x) => x.toJson())),
    "tabPartner": tabPartner == null ? [] : List<dynamic>.from(tabPartner!.map((x) => x.toJson())),
    "tabPrimary Occupation": tabPrimaryOccupation == null ? [] : List<dynamic>.from(tabPrimaryOccupation!.map((x) => x.toJson())),
    "tabVerification Status": tabVerificationStatus == null ? [] : List<dynamic>.from(tabVerificationStatus!.map((x) => x.toJson())),
    "tabSocial Category": tabSocialCategory == null ? [] : List<dynamic>.from(tabSocialCategory!.map((x) => x.toJson())),
    "User": tabSuperVisor == null ? [] : List<dynamic>.from(tabSuperVisor!.map((x) => x.toJson())),

    "tabHeight for age Boys": tabHeightforAgeBoys == null ? [] : List<dynamic>.from(tabHeightforAgeBoys!.map((x) => x.toJson())),
    "tabHeight for age Girls": tabHeightforAgeGirls == null ? [] : List<dynamic>.from(tabHeightforAgeGirls!.map((x) => x.toJson())),
    "tabWeight for age Girls": tabWeightforAgeGirls == null ? [] : List<dynamic>.from(tabWeightforAgeGirls!.map((x) => x.toJson())),
    "tabWeight for age Boys": tabWeightforAgeBoys == null ? [] : List<dynamic>.from(tabWeightforAgeBoys!.map((x) => x.toJson())),
    "tabWeight to Height Boys": tabWeightToHeightBoys == null ? [] : List<dynamic>.from(tabWeightToHeightBoys!.map((x) => x.toJson())),
    "tabWeight to Height Girls": tabWeightToHeightGirls == null ? [] : List<dynamic>.from(tabWeightToHeightGirls!.map((x) => x.toJson())),

    "tabVaccines": tabVaccines == null ? [] : List<dynamic>.from(tabVaccines!.map((x) => x.toJson())),

  };
}











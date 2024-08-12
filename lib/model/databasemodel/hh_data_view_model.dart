// To parse this JSON data, do
//
//     final hhShowDataModel = hhShowDataModelFromJson(jsonString);

import 'dart:convert';

HhShowDataModel hhShowDataModelFromJson(String str) => HhShowDataModel.fromJson(json.decode(str));

String hhShowDataModelToJson(HhShowDataModel data) => json.encode(data.toJson());

class HhShowDataModel {
  String? partnerId;
  String? dateOfVisit;
  String? stateId;
  String? districtId;
  String? blockId;
  String? gpId;
  String? villageId;
  String? respondentGenderId;
  String? respondentName;
  String? respondentAge;
  String? hosueholdHeadName;
  String? socialCategoryId;
  String? primaryOccupationId;
  String? children3Years;
  String? children3To6Years;
  String? children6To18Years;
  String? adultsAbove18Years;
  String? isAnyoneOfYourFamilyAMigrantWorker;
  String? doesAnyoneFromYourFamilyMigrateEveryYear;
  String? doYouTakeYourChildrenAlongWithYou;
  String? hhguid;

  HhShowDataModel({
    this.partnerId,
    this.dateOfVisit,
    this.stateId,
    this.districtId,
    this.blockId,
    this.gpId,
    this.villageId,
    this.respondentGenderId,
    this.respondentName,
    this.respondentAge,
    this.hosueholdHeadName,
    this.socialCategoryId,
    this.primaryOccupationId,
    this.children3Years,
    this.children3To6Years,
    this.children6To18Years,
    this.adultsAbove18Years,
    this.isAnyoneOfYourFamilyAMigrantWorker,
    this.doesAnyoneFromYourFamilyMigrateEveryYear,
    this.doYouTakeYourChildrenAlongWithYou,
    this.hhguid,
  });

  factory HhShowDataModel.fromJson(Map<String, dynamic> json) => HhShowDataModel(
    partnerId: json["partner_id"],
    dateOfVisit: json["date_of_visit"],
    stateId: json["state_id"],
    districtId: json["district_id"],
    blockId: json["block_id"],
    gpId: json["gp_id"],
    villageId: json["village_id"],
    respondentGenderId: json["respondent_gender_id"],
    respondentName: json["respondent_name"],
    respondentAge: json["respondent_age"],
    hosueholdHeadName: json["hosuehold_head_name"],
    socialCategoryId: json["social_category_id"],
    primaryOccupationId: json["primary_occupation_id"],
    children3Years: json["children___3_years"],
    children3To6Years: json["children_3_to__6_years"],
    children6To18Years: json["children_6_to_18_years"],
    adultsAbove18Years: json["adults_above_18_years"],
    isAnyoneOfYourFamilyAMigrantWorker: json["is_anyone_of_your_family_a_migrant_worker"],
    doesAnyoneFromYourFamilyMigrateEveryYear: json["does_anyone_from_your_family_migrate_every_year"],
    doYouTakeYourChildrenAlongWithYou: json["do_you_take_your_children_along_with_you"],
    hhguid: json["hhguid"],
  );

  Map<String, dynamic> toJson() => {
    "partner_id": partnerId,
    "date_of_visit": dateOfVisit,
    "state_id": stateId,
    "district_id": districtId,
    "block_id": blockId,
    "gp_id": gpId,
    "village_id": villageId,
    "respondent_gender_id": respondentGenderId,
    "respondent_name": respondentName,
    "respondent_age": respondentAge,
    "hosuehold_head_name": hosueholdHeadName,
    "social_category_id": socialCategoryId,
    "primary_occupation_id": primaryOccupationId,
    "children___3_years": children3Years,
    "children_3_to__6_years": children3To6Years,
    "children_6_to_18_years": children6To18Years,
    "adults_above_18_years": adultsAbove18Years,
    "is_anyone_of_your_family_a_migrant_worker": isAnyoneOfYourFamilyAMigrantWorker,
    "does_anyone_from_your_family_migrate_every_year": doesAnyoneFromYourFamilyMigrateEveryYear,
    "do_you_take_your_children_along_with_you": doYouTakeYourChildrenAlongWithYou,
    "hhguid": hhguid,
  };
}

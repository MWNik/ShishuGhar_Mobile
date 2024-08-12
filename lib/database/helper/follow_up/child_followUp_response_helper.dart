import 'dart:convert';

import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';


import '../../../model/databasemodel/child_followUp_response_model.dart';
import '../../database_helper.dart';

class ChildFollowUpTabResponseHelper {
  Future<void> inserts(ChildFollowUpTabResponceModel items) async {
    await DatabaseHelper.database!.insert(
        'child_followup_responce', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("object");
  }

  Future<List<ChildFollowUpTabResponceModel>> getChildFollowUpResponcewithGuid(
      String child_followUp_guid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_followup_responce where child_followup_guid=?',
        [child_followUp_guid]);
    List<ChildFollowUpTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildFollowUpTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildFollowUpTabResponceModel>> callFollowUpsByEnrolledChildGuild(
      String childenrolledguid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_followup_responce where childenrolledguid=?',
        [childenrolledguid]);
    List<ChildFollowUpTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildFollowUpTabResponceModel.fromJson(itemMap));
    });

    return items;
  }


  Future<List<ChildFollowUpTabResponceModel>> childFollowUpByChild(
      String? crecheIdName) async {
    var query = 'Select * from  child_followup_responce  where creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query, [crecheIdName]);

    List<ChildFollowUpTabResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildFollowUpTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildFollowUpTabResponceModel>>
  getChildFollowUpForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from child_followup_responce where is_edited=1');
    List<ChildFollowUpTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildFollowUpTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildFollowUpTabResponceModel>> getScduledEnrollGuid(
      String enrollGuid,String child_referral_guid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_followup_responce where childenrolledguid=? and responces  is NULL and child_referral_guid=?',
        [enrollGuid,child_referral_guid]);
    List<ChildFollowUpTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildFollowUpTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<Map<String, dynamic>>> allChildSchduledFollowp() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
      'select fowp.*,ecr.responces as enrResponces from child_followup_responce fowp left join (select * from enrollred_exit_child_responce) as  ecr on ecr.ChildEnrollGUID=fowp.childenrolledguid where   fowp.responces  is NULL and  ecr.date_of_exit is null ',
    );


    return result;
  }

  Future<List<ChildFollowUpTabResponceModel>> checkReffralCounts(
      String enrollGuid,String child_referral_guid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select followps.* from child_followup_responce followps LEFT join child_referral_responce as rfr on rfr.child_referral_guid=followps.child_referral_guid where followps.childenrolledguid=? and followps.child_referral_guid=? and rfr.responces NOTNULL AND length(RTRIM(LTRIM(rfr.responces))) > 0 order by followps.schedule_date asc ',

        [enrollGuid,child_referral_guid]);
    List<ChildFollowUpTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildFollowUpTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildFollowUpTabResponceModel>> callCompletedFolllwups(
      String enrollGuid,String child_referral_guid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select fowp.*,ecr.responces as enrResponces from child_followup_responce fowp left join (select * from enrollred_exit_child_responce where date_of_exit is null) as  ecr on ecr.ChildEnrollGUID=fowp.childenrolledguid where   fowp.responces  is NULL ',
        [enrollGuid,child_referral_guid]);
    List<ChildFollowUpTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildFollowUpTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<Map<String, dynamic>>> callCompletedFolllwupsAllChild(
      ) async {

    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select fowp.*,ecr.responces as enrResponces from child_followup_responce fowp left join (select * from enrollred_exit_child_responce where date_of_exit is null) as  ecr on ecr.ChildEnrollGUID=fowp.childenrolledguid where   fowp.responces  NOTNULL ',
       );

    return result;
  }



  Future<List<ChildFollowUpTabResponceModel>> callCompletedReffralForChild(
     String  childenrolledguid) async {

    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
      'select * from child_followup_responce where childenrolledguid =? and   responces  NOTNULL',
    [childenrolledguid]);

    List<ChildFollowUpTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildFollowUpTabResponceModel.fromJson(itemMap));
    });

    return items;
  }


  Future<List<ChildFollowUpTabResponceModel>> callSchudledReffralForChild(
      String  childenrolledguid) async {

    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_followup_responce where childenrolledguid =? and   responces  is NULL',
        [childenrolledguid]);

    List<ChildFollowUpTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildFollowUpTabResponceModel.fromJson(itemMap));
    });

    return items;
  }



  Future<List<ChildFollowUpTabResponceModel>> getFollowUpesponsebyReffreral(
      String child_referral_guid,String enrollGuid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_followup_responce where child_referral_guid=? and childenrolledguid=? and responces NOTNULL ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC',
        [child_referral_guid,enrollGuid]);
    List<ChildFollowUpTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildFollowUpTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];
    var ceGuid = hhData['child_followup_guid'];

    await DatabaseHelper.database!.rawQuery(
        'UPDATE child_followup_responce SET name = ?  ,  is_uploaded=1 , is_edited=0 where child_followup_guid=?',
        [cename, ceGuid]);
  }

  Future<void> insertUpdate(String child_followUp_guid, String enrolChildGuid,
      int? name, String responces,String? schedule_date, String userId, int creche_id
      , String child_referral_guid , String followup_visit_date) async {
    var item = ChildFollowUpTabResponceModel(
        child_followup_guid : child_followUp_guid,
        creche_id: creche_id,
        childenrolledguid: enrolChildGuid,
        child_referral_guid: child_referral_guid,
        followup_visit_date: followup_visit_date,
        responces: responces,
        schedule_date: schedule_date,
        is_uploaded: 0,
        is_edited: 1,
        is_deleted: 0,
        name: name,
        created_by: userId,
        created_at: Validate().currentDateTime());
    await DatabaseHelper.database!.insert(
        'child_followup_responce', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> childDownloadFollowUpData(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> growth =
    List<Map<String, dynamic>>.from(item['Data']);
    print(growth);
    growth.forEach((element) async {
      var growthData = element['Child Follow up'];


      var items = ChildFollowUpTabResponceModel(
        child_followup_guid: growthData['child_followup_guid'],
        childenrolledguid: growthData['childenrolledguid'],
        child_referral_guid: growthData['child_referral_guid'],
        followup_visit_date: growthData['followup_visit_date'],
        schedule_date: growthData['schedule_date'],
        name: growthData['name'],
        is_uploaded: 1,
        is_edited: 0,
        is_deleted: 0,
        creche_id: Global.stringToInt(growthData['creche_id'].toString()),
        update_at: growthData['app_updated_on'],
        updated_by: growthData['app_updated_by'],
        created_at: growthData['appcreated_on'],
        created_by: growthData['appcreated_by'],
        responces: await jsonEncode(Validate().keyesFromResponce(growthData)),
      );
      await inserts(items);
    });
  }


  Future<void> autoCreateFollowRecord(String followup_visit_date,String  child_referral_guid,
      String childenrolledguid,int creche_id,String createdBy) async {

    // List<Map<String, dynamic>> result = await DatabaseHelper.database!
    //     .rawQuery('select * from child_followup_responce where followup_visit_date=? and childenrolledguid=? and child_referral_guid=?',
    //     [followup_visit_date,childenrolledguid,child_referral_guid]);
    // if(result.length==0){
    var item=ChildFollowUpTabResponceModel(
        child_followup_guid: Validate().randomGuid(),
        childenrolledguid: childenrolledguid,
        child_referral_guid: child_referral_guid,
        followup_visit_date: followup_visit_date,
        is_uploaded: 0,
        is_edited: 0,
        is_deleted: 0,
        creche_id: creche_id,
        created_at: Validate().currentDateTime(),
        created_by: createdBy);
    await inserts(item);
    // }


  }

  Future<void> deleteFollowUpBYReffreral(String child_referral_guid ,String childenrolledguid) async {
    await DatabaseHelper.database!.delete('child_followup_responce',
      where: 'child_referral_guid = ? AND childenrolledguid = ?',
      whereArgs: [child_referral_guid, childenrolledguid],);
  }


}

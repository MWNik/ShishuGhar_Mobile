import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';


import '../../../model/dynamic_screen_model/child_referral_response_model.dart';
import '../../database_helper.dart';
import '../follow_up/child_followUp_response_helper.dart';

class ChildReferralTabResponseHelper {
  Future<void> inserts(ChildReferralTabResponceModel items) async {
    print(items.child_referral_guid);
    await DatabaseHelper.database!.insert(
        'child_referral_responce', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("object");
  }

  Future<List<ChildReferralTabResponceModel>> getChildReferralResponcewithGuid(
      String child_referral_guid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_referral_responce where child_referral_guid=?',
        [child_referral_guid]);
    List<ChildReferralTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildReferralTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildReferralTabResponceModel>> callReffralByEnrolldChild(
      String childenrolledguid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_referral_responce where childenrolledguid=?',
        [childenrolledguid]);
    List<ChildReferralTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildReferralTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildReferralTabResponceModel>> childReffralChildByCreche(
      String? crecheIdName) async {
    var query = 'Select * from  child_referral_responce  where creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [crecheIdName]);

    List<ChildReferralTabResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildReferralTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildReferralTabResponceModel>> callAllReffrals() async {
    var query = 'Select * from  child_referral_responce ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query);

    List<ChildReferralTabResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildReferralTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildReferralTabResponceModel>> callAllReffralsWithoutExit() async {
    var query = 'Select efr.* from  child_referral_responce efr left join enrollred_exit_child_responce as excr on efr.childenrolledguid=excr.ChildEnrollGUID where excr.date_of_exit IS NULL ORDER BY CASE  WHEN efr.update_at IS NOT NULL AND length(RTRIM(LTRIM(efr.update_at))) > 0 THEN efr.update_at ELSE efr.created_at END DESC';

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query);

    List<ChildReferralTabResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildReferralTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

    Future<List<Map<String, dynamic>>> callChildReffrals() async {
    var query = 'select efr.*,ecr.responces as enrolledResponce from child_referral_responce  efr left join enrollred_exit_child_responce as ecr on efr.childenrolledguid=ecr.ChildEnrollGUID where ecr.date_of_exit is null ORDER BY CASE  WHEN efr.update_at IS NOT NULL AND length(RTRIM(LTRIM(efr.update_at))) > 0 THEN efr.update_at ELSE efr.created_at END DESC';

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query);


    return result;
  }

  Future<List<Map<String, dynamic>>> callChildReffralsForSchudle() async {
    var query = 'select efr.*,ecr.responces as enrolledResponce from child_referral_responce  efr left join enrollred_exit_child_responce as ecr on efr.childenrolledguid=ecr.ChildEnrollGUID where efr.visit_count>0 ORDER BY CASE  WHEN efr.update_at IS NOT NULL AND length(RTRIM(LTRIM(efr.update_at))) > 0 THEN efr.update_at ELSE efr.created_at END DESC';

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query);


    return result;
  }



  Future<List<Map<String, dynamic>>> callChildReffralsByEnrolledGUID(String childenrolledguid) async {
    var query = 'select efr.*,ecr.responces as enrolledResponce from child_referral_responce  efr left join enrollred_exit_child_responce as ecr on efr.childenrolledguid=ecr.ChildEnrollGUID where childenrolledguid=? ORDER BY CASE  WHEN efr.update_at IS NOT NULL AND length(RTRIM(LTRIM(efr.update_at))) > 0 THEN efr.update_at ELSE efr.created_at END DESC';

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query,[childenrolledguid]);


    return result;
  }

  Future<List<ChildReferralTabResponceModel>>
      getChildReferralForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from child_referral_responce where is_edited=1');
    List<ChildReferralTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildReferralTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];
    var ceGuid = hhData['child_referral_guid'];
    await DatabaseHelper.database!.rawQuery(
        'UPDATE child_referral_responce SET name = ?  ,  is_uploaded=1 , is_edited=0 where child_referral_guid=?',
        [cename, ceGuid]);
  }

  Future<void> updateVisitFollowUps(String itemResponce,String child_referral_guid,visitCount) async {
    await DatabaseHelper.database!.rawQuery(
        'UPDATE child_referral_responce SET responces = ?  ,  visit_count=? , is_edited=1 where child_referral_guid=?',
        [itemResponce,visitCount, child_referral_guid]);
  }

  Future<void> insertUpdate(String child_referral_guid, String enrolChildGuid,String date_of_referral,
      int? name,int? crecheId, int? visitCount, String? schedule_date,String responces, String userId, String cgmguid) async {
    var item = ChildReferralTabResponceModel(
        child_referral_guid: child_referral_guid,
        childenrolledguid: enrolChildGuid,
        cgmguid: cgmguid,
        date_of_referral: date_of_referral,
         creche_id: crecheId,
         responces: responces,
        is_uploaded: 0,
        is_edited: 1,
        is_deleted: 0,
        visit_count: visitCount,
        schedule_date: schedule_date,
        name: name,
        created_by: userId,
        created_at: Validate().currentDateTime());
    await DatabaseHelper.database!.insert(
        'child_referral_responce', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> childDownloadReferralData(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> growth =
        List<Map<String, dynamic>>.from(item['Data']);
    print(growth);
    growth.forEach((element) async {
      var growthData = element['Child Referral'];


      var items = ChildReferralTabResponceModel(
        child_referral_guid: growthData['child_referral_guid'],
        childenrolledguid: growthData['childenrolledguid'],
        cgmguid: growthData['cgmguid'],
        name: growthData['name'],
        visit_count: growthData['visit_count'],
        date_of_referral: growthData['date_of_referral'],
        schedule_date: growthData['schedule_date'],
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
      if(Global.stringToInt(growthData['visit_count'].toString())>0){
        await callCheckNextFollowUp(growthData['child_referral_guid'],
            growthData['childenrolledguid'],
            Global.stringToInt(growthData['visit_count'].toString()),
            Global.stringToInt(growthData['creche_id'].toString()),
            growthData['appcreated_by'],growthData['child_status'],growthData['discharge_date'],growthData['visit_date']);
      }

    });
  }
  Future callCheckNextFollowUp(String child_referral_guid,String enrolChildGuid,
      int visit_count,int creche_id,String userName,String child_status,
      String? discharge_date,String? visit_date) async {
    var folloUps = await ChildFollowUpTabResponseHelper()
        .checkReffralCounts(enrolChildGuid, child_referral_guid);
    var alredyGenrated = await ChildFollowUpTabResponseHelper()
        .getScduledEnrollGuid(enrolChildGuid, child_referral_guid);

    if (alredyGenrated.length==0) {
      if(folloUps.length==0){
        DateTime? folloupDate;
        if (!(child_status == '1' || child_status == '2') &&
            !Global.validString(discharge_date)) {
          folloupDate = Validate().stringToDate(visit_date!);
        } else if (Global.validString(discharge_date)) {
          folloupDate = Validate().stringToDate(discharge_date!);
        }
        if(folloupDate!=null){
          if (visit_count == 3) {
            folloupDate = folloupDate.add(Duration(days: 7));
          }
          else {
            folloupDate = folloupDate.add(Duration(days: 15));
          }
          await ChildFollowUpTabResponseHelper().autoCreateFollowRecord(
              '${DateFormat('yyyy-MM-dd').format(folloupDate)}',
              child_referral_guid,
              enrolChildGuid,
              creche_id,
              userName);
        }


      }else if (visit_count != folloUps.length) {
        DateTime? folloupDate;
        if (visit_count == 3) {
          folloupDate = DateTime.parse(folloUps.last.schedule_date!)
              .add(Duration(days: 7));
        }
        else {
          folloupDate = DateTime.parse(folloUps.last.schedule_date!)
              .add(Duration(days: 15));
        }
        await ChildFollowUpTabResponseHelper().autoCreateFollowRecord(
            '${DateFormat('yyyy-MM-dd').format(folloupDate)}',
            child_referral_guid,
            enrolChildGuid,
            creche_id,
            userName);
      }
    }
  }

  Future<List<Map<String, dynamic>>>
  getChildlistingforFollowUp() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select efr.*,ecr.responces as enrolledResponce from child_referral_responce  efr left join enrollred_exit_child_responce as ecr on efr.childenrolledguid=ecr.ChildEnrollGUID ORDER BY CASE  WHEN efr.update_at IS NOT NULL AND length(RTRIM(LTRIM(efr.update_at))) > 0 THEN efr.update_at ELSE efr.created_at END DESC');
    ///avaliblae disscharge date
    // result=
    //     result.where((element) => Global.validString(
    //     Global.getItemValues(element['responces'], 'discharge_date')))
    //         .toList();

    return result;

     }

  Future<List<ChildReferralTabResponceModel>>
                callReffralByGUID(String childenrolledguid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_referral_responce where childenrolledguid=?',[childenrolledguid]);
    List<ChildReferralTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildReferralTabResponceModel.fromJson(itemMap));
    });
    return items;

  }
}

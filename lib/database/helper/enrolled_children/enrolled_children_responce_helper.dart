import 'dart:convert';

import 'package:shishughar/database/database_helper.dart';
import 'package:shishughar/model/dynamic_screen_model/house_hold_tab_responce_model.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:sqflite/sqflite.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../model/dynamic_screen_model/enrolled_children_responce_model.dart';
import '../../../utils/validate.dart';
import '../anthromentory/child_growth_response_helper.dart';
import '../child_attendence/child_attendence_helper.dart';
import '../child_event/child_event_response_helper.dart';
import '../child_exit/child_exit_response_Helper.dart';
import '../child_health/child_health_response_helper.dart';
import '../child_immunization/child_immunization_response_helper.dart';
import '../child_reffrel/child_refferal_response_helper.dart';
import '../follow_up/child_followUp_response_helper.dart';
import '../image_file_tab_responce_helper.dart';

class EnrolledChilrenResponceHelper {
  Future<void> inserts(EnrolledChildrenResponceModel items) async {
    await DatabaseHelper.database!.insert(
        'enrollred_chilren_responce', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertUpdate( String chhGuid,String HHGUID,
      int? name, String responces,   String? created_at,
  String? created_by, String? update_at, String? updated_by) async {
    var item = EnrolledChildrenResponceModel(
        CHHGUID: chhGuid,
        HHGUID: HHGUID,
        responces: responces,
        is_uploaded: 0,
        is_edited: 1,
        is_deleted: 0,
        name: name,
        created_by: created_by,
        created_at: created_at,
        update_at: update_at,
        updated_by: updated_by
    );
    await DatabaseHelper.database!.insert(
        'enrollred_chilren_responce', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<EnrolledChildrenResponceModel>> callChildrenResponce(
      String CHHGUID,String HHGUID) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from enrollred_chilren_responce where CHHGUID=? and HHGUID=?',
        [CHHGUID,HHGUID]);
    List<EnrolledChildrenResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(EnrolledChildrenResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<EnrolledChildrenResponceModel>> exitedChildInfo(String chhGuid,String date_of_exit) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery('SELECT * FROM enrollred_chilren_responce WHERE date_of_exit = ? and CHHGUID = ?',[date_of_exit,chhGuid]);
    List<EnrolledChildrenResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(EnrolledChildrenResponceModel.fromJson(itemMap));
    });

    return items;
  }


  Future<List<HouseHoldTabResponceMosdel>> callChildrenForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from enrollred_chilren_responce where is_edited=1');
    List<HouseHoldTabResponceMosdel> items = [];

    result.forEach((itemMap) {
      items.add(HouseHoldTabResponceMosdel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<HouseHoldTabResponceMosdel>> getCrecheUploadeItems() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from enrollred_chilren_responce where is_edited=0 and is_uploaded=1');
    List<HouseHoldTabResponceMosdel> items = [];

    result.forEach((itemMap) {
      items.add(HouseHoldTabResponceMosdel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<EnrolledChildrenResponceModel>> getEnrollChildren(
      int type) async {
    var query = 'SELECT * FROM enrollred_chilren_responce';
    if (type == 1) {
      query =
          'select * from house_hold_children where CHHGUID not in (select ens.CHHGUID from enrollred_chilren_responce ens INNER  join house_hold_children as hhChildren on ens.CHHGUID=hhChildren.CHHGUID)';
    }

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query);
    List<EnrolledChildrenResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(EnrolledChildrenResponceModel.fromJson(itemMap));
    });


    return items;
  }

  Future<List<Map<String, dynamic>>> callEnrollChildren(int creche_id) async {
    var query =
        'Select * from (select * from enrollred_chilren_responce WHERE CHHGUID in(Select CHHGUID from house_hold_children) and creche_id=? and date_of_exit isnull) ens left join (select hhRes.HHGUID,hhRes.responces as hhResponce,chre.CHHGUID from house_hold_responce hhRes INNER join house_hold_children as  chre on hhRes.HHGUID=chre.HHGUID) as hhs on hhs.CHHGUID=ens.CHHGUID ORDER BY CASE  WHEN ens.update_at IS NOT NULL AND length(RTRIM(LTRIM(ens.update_at))) > 0 THEN ens.update_at ELSE ens.created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query,[creche_id]);


    return result;
  }

  Future<List<Map<String, dynamic>>> callEnrollChildrenAll() async {
    var query =
        'Select * from (select * from enrollred_exit_child_responce WHERE CHHGUID in(Select CHHGUID from house_hold_children) and date_of_exit isnull ) ens left join (select hhRes.HHGUID,hhRes.responces as hhResponce,chre.CHHGUID from house_hold_responce hhRes INNER join house_hold_children as  chre on hhRes.HHGUID=chre.HHGUID) as hhs on hhs.CHHGUID=ens.CHHGUID ORDER BY CASE  WHEN ens.update_at IS NOT NULL AND length(RTRIM(LTRIM(ens.update_at))) > 0 THEN ens.update_at ELSE ens.created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query);


    return result;
  }

  Future<List<EnrolledChildrenResponceModel>> enrolledChildByCreche(int crecheIdName) async {
    var query =
        'Select * from  enrollred_chilren_responce where creche_id=? and date_of_exit ISNULL ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query,[crecheIdName]);


    List<EnrolledChildrenResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(EnrolledChildrenResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<EnrolledChildrenResponceModel>> enrolledChildByEnrolledGUID(List<String>  filterItems,int creche_id) async {
    String questionMarks = List.filled(filterItems.length, '?').join(',');
    List<dynamic> parameters = List.from(filterItems)..add(creche_id);
    var query =
        'Select * from  enrollred_chilren_responce where ChildEnrollGUID IN ($questionMarks) and creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query,parameters);


    List<EnrolledChildrenResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(EnrolledChildrenResponceModel.fromJson(itemMap));
    });


    return items;
  }


  Future<List<EnrolledChildrenResponceModel>> enrolledChildByCrecheByAttendeGUID(String childattenguid,int crech_id) async {
    var query = 'select * from enrollred_chilren_responce  where ChildEnrollGUID in (select childenrolledguid  from child_attendence where childattenguid=?) and creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query,[childattenguid,crech_id]);


    List<EnrolledChildrenResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(EnrolledChildrenResponceModel.fromJson(itemMap));
    });

    return items;
  }


  Future<List<EnrolledChildrenResponceModel>> enrolledChildByCrecheForAttendence(String dateOfAttendence,int crech_id) async {
    var query =
        'Select * from  enrollred_chilren_responce ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';
    DateTime startDate = DateTime.parse(dateOfAttendence);
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query);

    result = result
        .where((element) {
      DateTime date_of_enrollment = DateTime.parse(element['date_of_enrollment']);
      return (Global.getItemValues(element['responces'], 'creche_id') == crech_id.toString() &&(date_of_enrollment.isAfter(startDate) || date_of_enrollment.isBefore(startDate)));
    }).toList();

    List<EnrolledChildrenResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(EnrolledChildrenResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<Map<String, dynamic>>> getNotEnrollChildren(String villageId) async {
    var query =
        'select chs.*,hh.responces as hhResponce from house_hold_children chs INNER join house_hold_responce as hh on hh. HHGUID=chs.HHGUID where chs.CHHGUID not in (select ens.CHHGUID from enrollred_chilren_responce ens INNER  join house_hold_children as hhChildren on ens.CHHGUID=hhChildren.CHHGUID  where ens.date_of_exit isnull) ORDER BY CASE  WHEN chs.update_at IS NOT NULL AND length(RTRIM(LTRIM(chs.update_at))) > 0 THEN chs.update_at ELSE chs.created_at END DESC';
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query);
    result = result
        .where((element) =>
            // Global.getItemValues(
            //         element['hhResponce'], 'verification_status') ==
            //     "4"
            //     &&
               (Global.getItemValues(element['hhResponce'], 'village_id') ==
                villageId.toString()
            )
    )
        .toList();
    return result;
  }

  Future<Map<String, dynamic>> getHHDataINMAP(String hhGuid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from enrollred_chilren_responce where HHGUID=? limit 1',
        [hhGuid]);
    if (result.length > 0) {
      return result[0];
    }
    return {};
  }

  Future<List<EnrolledChildrenResponceModel>> callEnrolledChildByHHGUID(String CHHGUID) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from enrollred_chilren_responce where CHHGUID=?',
        [CHHGUID]);
    List<EnrolledChildrenResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(EnrolledChildrenResponceModel.fromJson(itemMap));
    });
    return items;
  }

  Future<void> updateUploadedChildProfileItem(Map<String, dynamic> item) async {
    var cProfileItm = item['data'];
    var name = cProfileItm['name'];
    var chhguid = cProfileItm['chhguid'];
    var hhguid = cProfileItm['hhguid'];
    var itemChildEnRoll=await callChildrenResponce(chhguid,hhguid);
    if(itemChildEnRoll.length>0){
      var chilResItem = jsonDecode(itemChildEnRoll.first.responces!);
      chilResItem['child_id']=cProfileItm['child_id'];
      chilResItem['name']=name;
      var itemRespJso = jsonEncode(chilResItem);

      await DatabaseHelper.database!.rawQuery(
          'UPDATE enrollred_chilren_responce SET name = ? ,responces=?, is_uploaded=1 , is_edited=0 where CHHGUID=? AND HHGUID=?',
          [name,itemRespJso, chhguid,hhguid]);


    }




  }

  Future<void> childProfileData(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> hhData =
        List<Map<String, dynamic>>.from(item['Data']);
    hhData.forEach((element) async {
        var name = element['name'];
        var chhguid = Global.validToString(element['chhguid']);
        var hhguid = Global.validToString(element['hhguid']);
        var appCreatedOn = element['appcreated_on'];
        var appcreated_by = element['appcreated_by'];
        var app_updated_by = element['app_updated_by'];
        var app_updated_on = element['app_updated_on'];
        var finalHHData = Validate().keyesFromResponce(element);
        var hhDtaResponce = jsonEncode(finalHHData);

        var item = EnrolledChildrenResponceModel(
            responces: hhDtaResponce,
            is_uploaded: 1,
            is_edited: 0,
            is_deleted: 0,
            name: name,
            CHHGUID: chhguid,
            HHGUID: hhguid,
            update_at: app_updated_on,
            updated_by: app_updated_by,
            created_by: appcreated_by,
            created_at: appCreatedOn);
        await inserts(item);
    });
  }

  int filterDataForEnrolledChild(Map<String, dynamic> element){
    int age=0;
    var cAge=Global.getItemValues(element['responces'], 'child_age');
    var cDob=Global.getItemValues(element['responces'], 'child_dob');
    var dateOfVisit=Global.getItemValues(element['hhResponce'], 'date_of_visit');
    if(Global.validString(cAge)){
      if(Global.validString(cDob)){
        var date=Validate().stringToDate(cDob);
        age=Validate().calculateAgeInMonths(date);
      }else if(Global.validString(dateOfVisit)){
        var date=Validate().stringToDate(dateOfVisit);
        int daysToSubtract = Validate().calculateDaysInMonths(date,Global.stringToInt(cAge));
        print("age   $daysToSubtract");
        var dateTime=date.subtract(Duration(days: daysToSubtract));
        age=Validate().calculateAgeInMonths(dateTime);
      }
    }
  print("age ${Global.getItemValues(element['responces'], 'child_name')}  $age");
    return age;

  }

  Future<List<Map<String, dynamic>>> callEnrollChildrenforReferral(
      List<String> enrollGuides) async {
    String questionMarks = List.filled(enrollGuides.length, '?').join(',');
    List<dynamic> parameters = [...enrollGuides];
    var query =
        'select cfr.*,enr.responces as enrolledResponce from enrollred_chilren_responce enr left join child_referral_responce as cfr on enr.ChildEnrollGUID=cfr.childenrolledguid where enr.ChildEnrollGUID in($questionMarks)';

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query, parameters);


    return result;
     }

  Future<List<EnrolledChildrenResponceModel>> callEnrollChildrenforByMultiEnrollGuid(
      List<String> enrollGuides) async {
    String questionMarks = List.filled(enrollGuides.length, '?').join(',');
    List<dynamic> parameters = [...enrollGuides];
    var query =
        'select * from enrollred_chilren_responce where ChildEnrollGUID in($questionMarks)';

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query, parameters);
    List<EnrolledChildrenResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(EnrolledChildrenResponceModel.fromJson(itemMap));
    });

    return items;
  }
}

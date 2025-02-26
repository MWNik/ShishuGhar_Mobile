import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/database/database_helper.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:sqflite/sqflite.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../model/dynamic_screen_model/enrolled_child_exit_responce_model.dart';
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

class EnrolledExitChilrenResponceHelper {
  Future<void> inserts(EnrolledExitChildResponceModel items) async {
    await DatabaseHelper.database!.insert(
        'enrollred_exit_child_responce', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteDraftRecord(EnrolledExitChildResponceModel record) async {
    try {
      await DatabaseHelper.database!.delete('enrollred_exit_child_responce',
          where:
              'is_edited = ? AND name IS NULL AND ChildEnrollGUID = ? AND CHHGUID = ?',
          whereArgs: [2, record.ChildEnrollGUID, record.CHHGUID]);
      await DatabaseHelper.database!.delete('enrollred_chilren_responce',
          where: 'is_edited = ? AND name IS NULL AND CHHGUID = ?',
          whereArgs: [2, record.CHHGUID]);
    } catch (e) {
      debugPrint("Error deleting drfat record : $e");
    }
  }

  Future<void> insertUpdate(
      String childEnrolledGUID,
      String chhGuid,
      int HHname,
      int? name,
      int crecheId,
      String responces,
      String? created_at,
      String? created_by,
      String? update_at,
      String? updated_by,
      String? date_of_exit) async {
    var item = EnrolledExitChildResponceModel(
        ChildEnrollGUID: childEnrolledGUID,
        CHHGUID: chhGuid,
        HHname: HHname,
        responces: responces,
        is_uploaded: 0,
        is_edited: 1,
        is_deleted: 0,
        name: name,
        creche_id: crecheId,
        created_by: created_by,
        created_at: created_at,
        update_at: update_at,
        updated_by: updated_by,
        date_of_exit: date_of_exit);
    await DatabaseHelper.database!.insert(
        'enrollred_exit_child_responce', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<EnrolledExitChildResponceModel>> callChildrenResponce(
      String childEnrollGUID) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from enrollred_exit_child_responce where ChildEnrollGUID=?',
        [childEnrollGUID]);
    List<EnrolledExitChildResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(EnrolledExitChildResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateEditFlag(String CHHGUID, int creche_id) async {
    try {
      await DatabaseHelper.database!.rawUpdate(
          'Update enrollred_exit_child_responce set is_edited = ? where creche_id=? and CHHGUID=?',
          [1, creche_id, CHHGUID]);
    } catch (e) {
      print("Error update table: $e");
    }
  }

  Future<String?> maxDateOfExit(String CHHGUID) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'SELECT MAX(date_of_exit) as date_of_exit FROM enrollred_exit_child_responce WHERE CHHGUID = ?',
        [CHHGUID]);

    if (result.isNotEmpty) {
      return result.first['date_of_exit'] as String?;
    } else {
      return null;
    }
  }

  Future<String?> getRecordByCHHGUID(String CHHGUID) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'SELECT * FROM enrollred_exit_child_responce WHERE CHHGUID = ? AND date_of_exit NOTNULL',
        [CHHGUID]);

    if (result.isNotEmpty) {
      return result.first['date_of_exit'] as String?;
    } else {
      return null;
    }
  }

  Future<List<EnrolledExitChildResponceModel>> exitedChildInfo(
      String chhGuid, String date_of_exit) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'SELECT * FROM enrollred_exit_child_responce WHERE date_of_exit = ? and CHHGUID = ?',
        [date_of_exit, chhGuid]);
    List<EnrolledExitChildResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(EnrolledExitChildResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<EnrolledExitChildResponceModel>> callChildrenForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from enrollred_exit_child_responce where is_edited=1');
    List<EnrolledExitChildResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(EnrolledExitChildResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<EnrolledExitChildResponceModel>>
      callChildrenForUploadDarftEdited() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from enrollred_exit_child_responce where is_edited=1 or is_edited=2');
    List<EnrolledExitChildResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(EnrolledExitChildResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<EnrolledExitChildResponceModel>>
      callChildrenForUploadOnly() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from enrollred_exit_child_responce where is_edited=1 and name is null');
    List<EnrolledExitChildResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(EnrolledExitChildResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<EnrolledExitChildResponceModel>> getCrecheUploadeItems() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from enrollred_exit_child_responce where is_edited=0 and is_uploaded=1');
    List<EnrolledExitChildResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(EnrolledExitChildResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<EnrolledExitChildResponceModel>> getEnrollChildren(
      int type) async {
    var query = 'SELECT * FROM enrollred_exit_child_responce';
    if (type == 1) {
      query =
          'select * from house_hold_children where CHHGUID not in (select ens.CHHGUID from enrollred_exit_child_responce ens INNER  join house_hold_children as hhChildren on ens.CHHGUID=hhChildren.CHHGUID)';
    }

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query);
    List<EnrolledExitChildResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(EnrolledExitChildResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<Map<String, dynamic>>> callEnrollChildren(int creche_id) async {
    var query =
        'Select * from (select * from enrollred_exit_child_responce WHERE CHHGUID in(Select CHHGUID from house_hold_children) and creche_id=? and (date_of_exit isnull or length(RTRIM(LTRIM(date_of_exit))) == 0)) ens left join (select hhRes.HHGUID,hhRes.responces as hhResponce,chre.CHHGUID from house_hold_responce hhRes INNER join house_hold_children as  chre on hhRes.HHGUID=chre.HHGUID) as hhs on hhs.CHHGUID=ens.CHHGUID  ORDER BY LOWER( SUBSTR(ens.responces, INSTR(ens.responces, ?) + LENGTH(?))) Asc';

    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery(query, [creche_id, 'child_name":"', 'child_name":"']);

    return result;
  }

  Future<List<Map<String, dynamic>>> callEnrollChildrenAll() async {
    var query =
        'Select * from (select * from enrollred_exit_child_responce WHERE CHHGUID in(Select CHHGUID from house_hold_children) and date_of_exit isnull ) ens left join (select hhRes.HHGUID,hhRes.responces as hhResponce,chre.CHHGUID from house_hold_responce hhRes INNER join house_hold_children as  chre on hhRes.HHGUID=chre.HHGUID) as hhs on hhs.CHHGUID=ens.CHHGUID ORDER BY LOWER(SUBSTR(ens.responces, INSTR(ens.responces, ?) + LENGTH(?))) asc';

    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery(query, ['child_name":"', 'child_name":"']);

    return result;
  }

  Future<List<EnrolledExitChildResponceModel>> enrolledChildByCreche(
      int crecheIdName) async {
    var query =
        'Select * from  enrollred_exit_child_responce where creche_id=? and (date_of_exit isnull or length(RTRIM(LTRIM(date_of_exit))) == 0) ORDER BY LOWER(SUBSTR(responces, INSTR(responces, ?) + LENGTH(?))) asc';

    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery(query, [crecheIdName, 'child_name":"', 'child_name":"']);

    List<EnrolledExitChildResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(EnrolledExitChildResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<EnrolledExitChildResponceModel>> enrolledChildByEnrolledGUID(
      List<String> filterItems, int creche_id) async {
    String questionMarks = List.filled(filterItems.length, '?').join(',');
    List<dynamic> parameters = List.from(filterItems)
      ..add(creche_id)
      ..add('child_name":"')
      ..add('child_name":"');
    var query =
        'Select * from  enrollred_exit_child_responce where ChildEnrollGUID IN ($questionMarks) and creche_id=? ORDER BY LOWER(SUBSTR(responces, INSTR(responces, ?) + LENGTH(?))) asc';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, parameters);

    List<EnrolledExitChildResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(EnrolledExitChildResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<EnrolledExitChildResponceModel>> enrolledChildByCHHGUID(
      String CHHGUID) async {
    var query =
        'select * from enrollred_exit_child_responce where CHHGUID=? AND (date_of_exit isnull or length(RTRIM(LTRIM(date_of_exit))) == 0)';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [CHHGUID]);

    List<EnrolledExitChildResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(EnrolledExitChildResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<EnrolledExitChildResponceModel>>
      enrolledChildByCrecheByAttendeGUID(
          String childattenguid, int crech_id) async {
    var query =
        'select * from enrollred_exit_child_responce  where ChildEnrollGUID in (select childenrolledguid  from child_attendence where childattenguid=?) and creche_id=? ORDER BY LOWER(SUBSTR(responces, INSTR(responces, ?) + LENGTH(?))) asc';

    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        query, [childattenguid, crech_id, 'child_name":"', 'child_name":"']);

    List<EnrolledExitChildResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(EnrolledExitChildResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<EnrolledExitChildResponceModel>>
      enrolledChildByCrecheForAttendence(
          String dateOfAttendence, int crech_id) async {
    var query =
        'Select * from  enrollred_exit_child_responce ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';
    DateTime startDate = DateTime.parse(dateOfAttendence);
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query);

    result = result.where((element) {
      DateTime date_of_enrollment =
          DateTime.parse(element['date_of_enrollment']);
      return (Global.getItemValues(element['responces'], 'creche_id') ==
              crech_id.toString() &&
          (date_of_enrollment.isAfter(startDate) ||
              date_of_enrollment.isBefore(startDate)));
    }).toList();

    List<EnrolledExitChildResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(EnrolledExitChildResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<Map<String, dynamic>>> getNotEnrollChildren(
      String villageId,int creche_id) async {
    var query =
         // 'select chs.*,hh.responces as hhResponce from house_hold_children chs INNER join house_hold_responce as hh on hh. HHGUID=chs.HHGUID where SUBSTR( hh.responces,  INSTR( hh.responces, ?) + LENGTH(?), INSTR(SUBSTR( hh.responces, INSTR( hh.responces, ?) + LENGTH(?)), ?) - 1 ) !=? and chs.CHHGUID  not in (select ens.CHHGUID from enrollred_exit_child_responce ens INNER  join house_hold_children as hhChildren on ens.CHHGUID=hhChildren.CHHGUID  where (ens.date_of_exit isnull or length(RTRIM(LTRIM(ens.date_of_exit))) == 0)) ORDER BY LOWER( SUBSTR(chs.responces, INSTR(chs.responces, ?) + LENGTH(?) ) ) asc';   for showing without exited
        'select chs.*,hh.responces as hhResponce from house_hold_children chs INNER join house_hold_responce as hh on hh. HHGUID=chs.HHGUID where hh.creche_id =? and SUBSTR( hh.responces,  INSTR( hh.responces, ?) + LENGTH(?), INSTR(SUBSTR( hh.responces, INSTR( hh.responces, ?) + LENGTH(?)), ?) - 1 ) !=? and chs.CHHGUID  not in (select ens.CHHGUID from enrollred_exit_child_responce ens INNER  join house_hold_children as hhChildren on ens.CHHGUID=hhChildren.CHHGUID  ) ORDER BY LOWER( SUBSTR(chs.responces, INSTR(chs.responces, ?) + LENGTH(?) ) ) asc';
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [
          creche_id,
      '"verification_status":"',
      '"verification_status":"',
      '"verification_status":"',
      '"verification_status":"',
      '"',
      '1',
      'child_name":"',
      'child_name":"'

    ]);
    // result = result
    //     .where((element) =>
    //         // Global.getItemValues(
    //         //         element['hhResponce'], 'verification_status') ==
    //         //     "4"
    //         //     &&
    //
    //         (Global.getItemValues(element['hhResponce'], 'village_id') ==
    //             villageId.toString()))
    //     .toList();
    return result;
  }

  Future<List<Map<String, dynamic>>> getNotEnrollChildrenExited(
      String villageId,int creche_id) async {
    var query =
        'select child.*,hh.responces as hhResponce from house_hold_children child left join house_hold_responce as hh on child.HHGUID=hh.HHGUID where child.CHHGUID in(select CHHGUID from enrollred_exit_child_responce where date_of_exit  NOTNULL  and child.CHHGUID not in(select CHHGUID from enrollred_exit_child_responce  where  (date_of_exit isnull or length(RTRIM(LTRIM(date_of_exit))) == 0)) GROUP by CHHGUID)  and  hh.creche_id=? ORDER BY LOWER( SUBSTR(child.responces, INSTR(child.responces, ?) + LENGTH(?) ) ) asc';
    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query, [
      creche_id,
      'child_name":"',
      'child_name":"',
    ]);
    // result = result
    //     .where((element) =>
    //
    // (Global.getItemValues(element['hhResponce'], 'village_id') ==
    //     villageId.toString()))
    //     .toList();
    return result;
  }

  Future<Map<String, dynamic>> getHHDataINMAP(String hhGuid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from enrollred_exit_child_responce where HHGUID=? limit 1',
        [hhGuid]);
    if (result.length > 0) {
      return result[0];
    }
    return {};
  }

  Future<List<EnrolledExitChildResponceModel>> callEnrolledChildByHHGUID(
      String CHHGUID) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from enrollred_exit_child_responce where CHHGUID=?',
        [CHHGUID]);
    List<EnrolledExitChildResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(EnrolledExitChildResponceModel.fromJson(itemMap));
    });
    return items;
  }

  Future<void> updateUploadedChildProfileItem(Map<String, dynamic> item) async {
    var cProfileItm = item['data'];
    var name = cProfileItm['name'];
    var ChildEnrollGUID = cProfileItm['childenrollguid'];
    var update_at = cProfileItm['app_updated_on'];
    var updated_by = cProfileItm['app_updated_by'];
    var itemChildEnRoll = await callChildrenResponce(ChildEnrollGUID);
    if (itemChildEnRoll.length > 0) {
      var chilResItem = jsonDecode(itemChildEnRoll.first.responces!);
      chilResItem['child_id'] = cProfileItm['child_id'];
      chilResItem['name'] = name;
      var itemRespJso = jsonEncode(chilResItem);

      await DatabaseHelper.database!.rawQuery(
          'UPDATE enrollred_exit_child_responce SET name = ?,responces = ?  , is_uploaded=1 , is_edited=0,update_at=?,updated_by=? where ChildEnrollGUID=?',
          [name, itemRespJso, update_at, updated_by, ChildEnrollGUID]);

      var eventItem = await ChildEventTabResponceHelper()
          .callEventsEnrolledChildGUID(ChildEnrollGUID);
      if (eventItem.length > 0) {
        eventItem.forEach((element) async {
          // if (Global.stringToInt(
          //         Global.getItemValues(element.responces, 'child_id')) ==
          //     0) {
            var itemMap = jsonDecode(element.responces!);
            itemMap['child_id'] = name;
            var itemResp = jsonEncode(itemMap);
            await DatabaseHelper.database!.rawQuery(
                'UPDATE child_event_responce SET responces = ?  where child_event_guid=?',
                [itemResp, element.child_event_guid]);
          // }
        });
      }

      var healthItems = await ChildHealthTabResponceHelper()
          .callHealthByEnrolledChildGuid(ChildEnrollGUID);
      if (healthItems.length > 0) {
        healthItems.forEach((element) async {
          // if (Global.stringToInt(
          //         Global.getItemValues(element.responces, 'child_id')) ==
          //     0) {
            var itemMap = jsonDecode(element.responces!);
            itemMap['child_id'] = name;
            var itemResp = jsonEncode(itemMap);
            await DatabaseHelper.database!.rawQuery(
                'UPDATE child_health_responce SET responces = ?  where child_health_guid=?',
                [itemResp, element.child_health_guid]);
          // }
        });
      }

      var immunizationItems = await ChildImmunizationResponseHelper()
          .callImmunizationByChilEnrollGUID(ChildEnrollGUID);
      if (immunizationItems.length > 0) {
        immunizationItems.forEach((element) async {
          // if (Global.stringToInt(
          //         Global.getItemValues(element.responces, 'child_id')) ==
          //     0) {
            var itemMap = jsonDecode(element.responces!);
            itemMap['child_id'] = name;
            var itemResp = jsonEncode(itemMap);
            await DatabaseHelper.database!.rawQuery(
                'UPDATE child_immunization_responce SET responces = ?  where child_immunization_guid=?',
                [itemResp, element.child_immunization_guid]);
          // }
        });
      }

      var reffralItems = await ChildReferralTabResponseHelper()
          .callReffralByEnrolldChild(ChildEnrollGUID);
      if (reffralItems.length > 0) {
        reffralItems.forEach((element) async {
          // if (Global.stringToInt(
          //         Global.getItemValues(element.responces, 'child_id')) ==
          //     0) {
            var itemMap = jsonDecode(element.responces!);
            itemMap['child_id'] = name;
            var itemResp = jsonEncode(itemMap);
            await DatabaseHelper.database!.rawQuery(
                'UPDATE child_referral_responce SET responces = ?  where child_referral_guid=?',
                [itemResp, element.child_referral_guid]);
          // }
        });
      }

      var childFollloups = await ChildFollowUpTabResponseHelper()
          .callFollowUpsByEnrolledChildGuild(ChildEnrollGUID);
      if (childFollloups.length > 0) {
        childFollloups.forEach((element) async {
          // if (Global.stringToInt(
          //         Global.getItemValues(element.responces, 'child_id')) ==
          //     0) {
            var itemMap = jsonDecode(element.responces!);
            itemMap['child_id'] = name;
            var itemResp = jsonEncode(itemMap);
            await DatabaseHelper.database!.rawQuery(
                'UPDATE child_followup_responce SET responces = ?  where child_followup_guid=?',
                [itemResp, element.child_followup_guid]);
          // }
        });
      }

      var childExists = await ChildExitResponceHelper()
          .getChildExitsByEnrolledChildGuid(ChildEnrollGUID);
      if (childExists.length > 0) {
        childExists.forEach((element) async {
          // if (Global.stringToInt(
          //         Global.getItemValues(element.responces, 'child_id')) ==
          //     0) {
            var itemMap = jsonDecode(element.responces!);
            itemMap['child_id'] = name;
            var itemResp = jsonEncode(itemMap);
            await DatabaseHelper.database!.rawQuery(
                'UPDATE child_exit_responce SET responces = ?  where child_exit_guid=?',
                [itemResp, element.child_exit_guid]);
          // }
        });
      }

      var childAttendences = await ChildAttendenceHelper()
          .callChildAttendecsByEnrollGUID(ChildEnrollGUID);
      if (childAttendences.length > 0) {
        childAttendences.forEach((element) async {
          // if (Global.validToInt(element.child_profile_id) == 0) {
            await DatabaseHelper.database!.rawQuery(
                'UPDATE child_attendence SET child_profile_id = ?  where childenrolledguid=?',
                [name, element.childenrolledguid]);
          // }
        });
      }

      var childImage = await ImageFileTabHelper()
          .getImageByDoctypeIdAndImbeNotNull(
              ChildEnrollGUID, CustomText.ChildProfile);
      if (childImage.length > 0) {
        childImage.forEach((element) async {
          // if (Global.validToInt(element.name) == 0) {
            await DatabaseHelper.database!.rawQuery(
                'UPDATE tab_image_file SET name = ?  where doctype_guid=? and doctype=?',
                [name, element.doctype_guid, CustomText.ChildProfile]);
          // }
        });
      }

      var chilGwothMonitoring =
          await ChildGrowthResponseHelper().allAnthormentry();
      if (chilGwothMonitoring.length > 0) {
        chilGwothMonitoring.forEach((element) async {
          if (element.responces != null) {
            Map<String, dynamic> responseData = jsonDecode(element.responces!);
            var childs = responseData['anthropromatic_details'];
            if (childs != null) {
              List<Map<String, dynamic>> children =
                  List<Map<String, dynamic>>.from(
                      responseData['anthropromatic_details']);
              Map<String, dynamic> childItem = {};
              children.forEach((cEle) {
                // if (cEle['childenrollguid'] == ChildEnrollGUID &&
                //     Global.stringToInt(cEle['child_id'].toString()) == 0) {
                  if (cEle['childenrollguid'] == ChildEnrollGUID ) {
                  childItem = cEle;
                  childItem['child_id'] = name;
                }
              });
              if (childItem.isNotEmpty) {
                children.removeWhere(
                    (element) => element['childenrollguid'] == ChildEnrollGUID);
                children.add(childItem);
                responseData['anthropromatic_details'] = children;

                print('antroUpdate $responseData');
                var itemResp = jsonEncode(responseData);
                await DatabaseHelper.database!.rawQuery(
                    'UPDATE child_anthormentry_responce SET responces = ?  where cgmguid=?',
                    [itemResp, element.cgmguid]);
              }
            }
          }
        });
      }
    }
  }

  Future<void> childProfileData(Map<String, dynamic> item) async {
    try {
      List<Map<String, dynamic>> hhData =
          List<Map<String, dynamic>>.from(item['Data']);
      print(hhData.length);

      // List to collect all EnrolledExitChildResponceModel items
      List<EnrolledExitChildResponceModel> itemsList = [];

      // Process each data and add to the items list
      for (var element in hhData) {
        var enrollExitData = element['Child Enrollment and Exit'];
        var name = enrollExitData['name'];
        var childenrollguid =
            Global.validToString(enrollExitData['childenrollguid']);
        var hhcguid = Global.validToString(enrollExitData['hhcguid']);
        var appCreatedOn = enrollExitData['appcreated_on'];
        var appcreated_by = enrollExitData['appcreated_by'];
        var app_updated_by = enrollExitData['app_updated_by'];
        var app_updated_on = enrollExitData['app_updated_on'];
        var creche_id =
            Global.stringToInt(enrollExitData['creche_id'].toString());
        var date_of_exit = enrollExitData['date_of_exit'];
        var hh_child_id =
            Global.stringToInt(enrollExitData['child_id'].toString());
        var finalHHData = Validate().keyesFromResponce(enrollExitData);
        var hhDtaResponce = jsonEncode(finalHHData);

        // Create EnrolledExitChildResponceModel instance
        var item = EnrolledExitChildResponceModel(
          responces: hhDtaResponce,
          is_uploaded: 1,
          is_edited: 0,
          is_deleted: 0,
          name: name,
          HHname: hh_child_id,
          creche_id: creche_id,
          date_of_exit: date_of_exit,
          ChildEnrollGUID: childenrollguid,
          CHHGUID: hhcguid,
          update_at: app_updated_on,
          updated_by: app_updated_by,
          created_by: appcreated_by,
          created_at: appCreatedOn,
        );

        // Add the item to the list
        itemsList.add(item);
      }

      // If the list has more than 500 items, split it into batches
      if (itemsList.length > 500) {
        for (int i = 0; i < itemsList.length; i += 500) {
          var batchItems = itemsList.sublist(
              i, (i + 500) > itemsList.length ? itemsList.length : (i + 500));

          // Insert the batch
          await _insertBatch(batchItems);
        }
      } else {
        // If the list has 500 or fewer items, insert them all at once
        await _insertBatch(itemsList);
      }

      print("Data insertion successful!");
    } catch (e) {
      debugPrint("childProfileData() : $e");
    }
  }

// Helper function to insert a batch of items
  Future<void> _insertBatch(
      List<EnrolledExitChildResponceModel> batchItems) async {
    await DatabaseHelper.database!.transaction((txn) async {
      var batch = txn.batch();

      for (var item in batchItems) {
        batch.insert(
          'enrollred_exit_child_responce', // Change to your actual table name
          item.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Commit the batch insert
      await batch.commit(noResult: true);
    });
  }

  // Future<void> childProfileData(Map<String, dynamic> item) async {
  //   List<Map<String, dynamic>> hhData =
  //       List<Map<String, dynamic>>.from(item['Data']);
  //   print(hhData.length);
  //   hhData.forEach((element) async {
  //     var enrollExitData = element['Child Enrollment and Exit'];
  //     var name = enrollExitData['name'];
  //     var childenrollguid =
  //         Global.validToString(enrollExitData['childenrollguid']);
  //     var hhcguid = Global.validToString(enrollExitData['hhcguid']);
  //     var appCreatedOn = enrollExitData['appcreated_on'];
  //     var appcreated_by = enrollExitData['appcreated_by'];
  //     var app_updated_by = enrollExitData['app_updated_by'];
  //     var app_updated_on = enrollExitData['app_updated_on'];
  //     var creche_id =
  //         Global.stringToInt(enrollExitData['creche_id'].toString());
  //     var date_of_exit = enrollExitData['date_of_exit'];
  //     var hh_child_id =
  //         Global.stringToInt(enrollExitData['child_id'].toString());
  //     var finalHHData = Validate().keyesFromResponce(enrollExitData);
  //     var hhDtaResponce = jsonEncode(finalHHData);

  //     var item = EnrolledExitChildResponceModel(
  //         responces: hhDtaResponce,
  //         is_uploaded: 1,
  //         is_edited: 0,
  //         is_deleted: 0,
  //         name: name,
  //         HHname: hh_child_id,
  //         creche_id: creche_id,
  //         date_of_exit: date_of_exit,
  //         ChildEnrollGUID: childenrollguid,
  //         CHHGUID: hhcguid,
  //         update_at: app_updated_on,
  //         updated_by: app_updated_by,
  //         created_by: appcreated_by,
  //         created_at: appCreatedOn);
  //     await inserts(item);
  //   });
  // }

  int filterDataForEnrolledChild(Map<String, dynamic> element) {
    int age = 0;
    var cAge = Global.getItemValues(element['responces'], 'child_age');
    var cDob = Global.getItemValues(element['responces'], 'child_dob');
    var dateOfVisit =
        Global.getItemValues(element['hhResponce'], 'date_of_visit');
    if (Global.validString(cAge)) {
      if (Global.validString(cDob)) {
        var date = Validate().stringToDate(cDob);
        age = Validate().calculateAgeInMonths(date);
      } else if (Global.validString(dateOfVisit)) {
        var date = Validate().stringToDate(dateOfVisit);
        int daysToSubtract =
            Validate().calculateDaysInMonths(date, Global.stringToInt(cAge));
        print("age   $daysToSubtract");
        var dateTime = date.subtract(Duration(days: daysToSubtract));
        age = Validate().calculateAgeInMonths(dateTime);
      }
    }
    print(
        "age ${Global.getItemValues(element['responces'], 'child_name')}  $age");
    return age;
  }

  Future<List<Map<String, dynamic>>> callEnrollChildrenforReferral(
      List<String> enrollGuides) async {
    String questionMarks = List.filled(enrollGuides.length, '?').join(',');
    List<dynamic> parameters = [...enrollGuides];
    var query =
        'select cfr.*,enr.responces as enrolledResponce from enrollred_exit_child_responce enr left join child_referral_responce as cfr on enr.ChildEnrollGUID=cfr.childenrolledguid where enr.ChildEnrollGUID in($questionMarks)';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, parameters);

    return result;
  }

  Future<List<EnrolledExitChildResponceModel>>
      callEnrollChildrenforByMultiEnrollGuid(List<String> enrollGuides) async {
    String questionMarks = List.filled(enrollGuides.length, '?').join(',');
    List<dynamic> parameters = [...enrollGuides];
    var query =
        'select * from enrollred_exit_child_responce where ChildEnrollGUID in($questionMarks)';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, parameters);
    List<EnrolledExitChildResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(EnrolledExitChildResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<Map<String, dynamic>>> enrolledChildByCrecheWithProfile(
      int crecheIdName) async {
    var query =
        'Select exr.*,ecr.responces as pResponces from  enrollred_exit_child_responce exr left join enrollred_chilren_responce as ecr on ecr.CHHGUID=exr.CHHGUID where exr.creche_id=? and (exr.date_of_exit isnull or length(RTRIM(LTRIM(exr.date_of_exit))) == 0) ORDER BY LOWER(SUBSTR(exr.responces, INSTR(exr.responces, ?) + LENGTH(?))) asc';

    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery(query, [crecheIdName, 'child_name":"', 'child_name":"']);

    return result;
  }

  Future<void> isUpdateEdit(String EnrolledChilGUID, String responces) async {
    var res = jsonDecode(responces);

    var result = await callChildrenResponce(EnrolledChilGUID);

    if (result.length > 0) {
      var response = jsonDecode(result[0].responces!);

      response['gender_id'] = res['gender_id'];

      var resp = jsonEncode(response);
      print("success");

      await DatabaseHelper.database!.rawQuery(
          'update enrollred_exit_child_responce set responces=? , is_edited=1 where ChildEnrollGUID=? ',
          [resp, EnrolledChilGUID]);
    }
  }

  Future<List<EnrolledExitChildResponceModel>>
      enrolledChildByCrecheWithDateOfExit(
          int crecheIdName, String attendeceDate) async {
    var query =
        'SELECT *FROM enrollred_exit_child_responce WHERE creche_id = ? AND (date_of_exit >= ? OR date_of_exit IS NULL or length(RTRIM(LTRIM(date_of_exit))) == 0) and is_edited !=2 ORDER BY LOWER(SUBSTR(responces, INSTR(responces, ?) + LENGTH(?))) asc';

    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        query, [crecheIdName, attendeceDate, 'child_name":"', 'child_name":"']);

    List<EnrolledExitChildResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(EnrolledExitChildResponceModel.fromJson(itemMap));
    });

    return items;
  }
}

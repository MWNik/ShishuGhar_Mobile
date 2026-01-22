import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/dynamic_screen_model/creche_Monitering_checkList_sm_response_model.dart';
import '../../../model/dynamic_screen_model/creche_monitering_checklist_CC_response_model.dart';
import '../../database_helper.dart';
import '../image_file_tab_responce_helper.dart';

class CmcSMTabResponseHelper {
  Future<void> inserts(CmcSMResponseModel items) async {
    print(items.smguid);
    await DatabaseHelper.database!.insert(
        'tabCreche_Monitering_Checklist_SM_response', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("object");
  }

  Future<void> deleteDraftRecords(CmcSMResponseModel record) async {
    try {
      await DatabaseHelper.database!.delete(
          'tabCreche_Monitering_Checklist_SM_response',
          where: 'is_edited = ? AND name IS NULL AND smguid = ?',
          whereArgs: [2, record.smguid]);
    } catch (e) {
      debugPrint("Error deleting drfat records : $e");
    }
  }

  Future<List<CmcSMResponseModel>> getCrecheCommittieResponcewithGuid(
      String almguid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_Checklist_SM_response where smguid=?',
        [almguid]);
    List<CmcSMResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CmcSMResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcSMResponseModel>> childALMChild(int? crecheIdName) async {
    var query =
        'Select * from  tabCreche_Monitering_Checklist_SM_response  where creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [crecheIdName]);

    List<CmcSMResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(CmcSMResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcSMResponseModel>> callCrechMonitoringSM() async {
    var query =
        'Select * from  tabCreche_Monitering_Checklist_SM_response ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query);

    List<CmcSMResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(CmcSMResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcSMResponseModel>> getSMForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_Checklist_SM_response where is_edited=1 ');
    List<CmcSMResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CmcSMResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcSMResponseModel>> getCcForDarft() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_Checklist_SM_response where is_edited=2 ');
    List<CmcSMResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CmcSMResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcSMResponseModel>> getCcForUploadEditDarft() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_Checklist_SM_response where is_edited=1 or is_edited=2');
    List<CmcSMResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CmcSMResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];
    var ceGuid = hhData['smguid'];
    await DatabaseHelper.database!.rawQuery(
        'UPDATE tabCreche_Monitering_Checklist_SM_response SET name = ?  ,  is_uploaded=1 , is_edited=0 where smguid=?',
        [cename, ceGuid]);

    var childImage = await ImageFileTabHelper()
        .getImageByDoctypeIdAndImbeNotNull(ceGuid, 'Safety Indicators');
    if (childImage.length > 0) {
      childImage.forEach((element) async {
        if (Global.validToInt(element.name) == 0) {
          await DatabaseHelper.database!.rawQuery(
              'UPDATE tab_image_file SET name = ?  where doctype_guid=? and doctype=?',
              [cename, element.doctype_guid, 'Safety Indicators']);
        }
      });
    }
  }

  Future<void> insertUpdate(String smguid, int? name, String responces,
      String userId, int creche_id) async {
    var item = CmcSMResponseModel(
        smguid: smguid,
        creche_id: creche_id,
        // childenrolledguid: enrolChildGuid,
        responces: responces,
        is_uploaded: 0,
        is_edited: 1,
        is_deleted: 0,
        name: name,
        created_by: userId,
        created_at: Validate().currentDateTime());
    await DatabaseHelper.database!.insert(
        'tabCreche_Monitering_Checklist_SM_response', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> crecheSMDownloadData(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> growth =
        List<Map<String, dynamic>>.from(item['Data']);
    print(growth);
    growth.forEach((element) async {
      // var growthData = element['Creche Monitoring Checklist CC'];

      var items = CmcSMResponseModel(
        smguid: element['smguid'],
        name: element['name'],
        is_uploaded: 1,
        is_edited: 0,
        is_deleted: 0,
        creche_id: Global.stringToInt(element['creche_id']),
        update_at: element['modified'],
        updated_by: element['modified_by'],
        created_at: element['creation'],
        created_by: element['owner'],
        responces: jsonEncode((Validate().keyesFromResponce(element))),
      );
      print("success");
      await inserts(items);
    });
  }
}

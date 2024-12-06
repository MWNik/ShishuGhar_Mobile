import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/dynamic_screen_model/creche_monitering_checkList_cbm_response_model.dart';
import '../../database_helper.dart';

class CmcCBMTabResponseHelper {
  Future<void> inserts(CmcCBMResponseModel items) async {
    print(items.cbmguid);
    await DatabaseHelper.database!.insert(
        'tabCreche_Monitering_Checklist_CBM_response', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("object");
  }

  Future<void> deleteDraftRecords(CmcCBMResponseModel record) async {
    try {
      await DatabaseHelper.database!.delete(
          'tabCreche_Monitering_Checklist_CBM_response',
          where: 'is_edited = ? AND name IS NULL AND cmguid = ?',
          whereArgs: [2, record.cbmguid]);
    } catch (e) {
      debugPrint("Error deleting drfat records : $e");
    }
  }

  Future<List<CmcCBMResponseModel>> getCrecheCommittieResponcewithGuid(
      String cbmguid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_Checklist_CBM_response where cbmguid=?',
        [cbmguid]);
    List<CmcCBMResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CmcCBMResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcCBMResponseModel>> childCBMChild(int? crecheIdName) async {
    var query =
        'Select * from  tabCreche_Monitering_Checklist_CBM_response  where creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [crecheIdName]);

    List<CmcCBMResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(CmcCBMResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcCBMResponseModel>> callAllCrecheMonitoring() async {
    var query =
        'Select * from  tabCreche_Monitering_Checklist_CBM_response ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query);

    List<CmcCBMResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(CmcCBMResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcCBMResponseModel>> getCBMForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_Checklist_CBM_response where is_edited=1');
    List<CmcCBMResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CmcCBMResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcCBMResponseModel>> getCBMForUploadDarft() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_Checklist_CBM_response where is_edited=1 or is_edited=2');
    List<CmcCBMResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CmcCBMResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];
    var ceGuid = hhData['cbmguid'];

    await DatabaseHelper.database!.rawQuery(
        'UPDATE tabCreche_Monitering_Checklist_CBM_response SET name = ?  ,  is_uploaded=1 , is_edited=0 where cbmguid=?',
        [cename, ceGuid]);
  }

  Future<void> insertUpdate(String child_referral_guid, int? name,
      String responces, String userId, int creche_id) async {
    var item = CmcCBMResponseModel(
        cbmguid: child_referral_guid,
        creche_id: creche_id,
        responces: responces,
        is_uploaded: 0,
        is_edited: 1,
        is_deleted: 0,
        name: name,
        created_by: userId,
        created_at: Validate().currentDateTime());
    await DatabaseHelper.database!.insert(
        'tabCreche_Monitering_Checklist_CBM_response', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> crecheCBMDownloadData(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> growth =
        List<Map<String, dynamic>>.from(item['Data']);
    print(growth);
    growth.forEach((element) async {
      var growthData = element['Creche Monitoring Checklist CBM'];

      var items = CmcCBMResponseModel(
        cbmguid: growthData['cbmguid'],
        name: growthData['name'],
        is_uploaded: 1,
        is_edited: 0,
        is_deleted: 0,
        creche_id: Global.stringToInt(growthData['creche_id']),
        update_at: growthData['modified'],
        updated_by: growthData['modified_by'],
        created_at: growthData['creation'],
        created_by: growthData['owner'],
        responces: jsonEncode((Validate().keyesFromResponce(growthData))),
      );
      print("success");
      await inserts(items);
    });
  }
}

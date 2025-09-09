import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/dynamic_screen_model/creche_Monitering_checkList_ALM_response_model.dart';
import '../../database_helper.dart';

class CmcALMTabResponseHelper {
  Future<void> inserts(CmcALMResponseModel items) async {
    print(items.almguid);
    await DatabaseHelper.database!.insert(
        'tabCreche_Monitering_Checklist_ALM_response', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("object");
  }

  Future<void> deleteDraftRecords(CmcALMResponseModel record) async {
    try{
      await DatabaseHelper.database!.delete(
        'tabCreche_Monitering_Checklist_ALM_response',
        where: 'is_edited = ? AND name IS NULL AND almguid = ?',
        whereArgs: [2,record.almguid]
      );
    } catch (e) {
      debugPrint("Error deleting draft record : $e");
    }
  }

  Future<List<CmcALMResponseModel>> getCrecheCommittieResponcewithGuid(
      String almguid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_Checklist_ALM_response where almguid=?',
        [almguid]);
    List<CmcALMResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CmcALMResponseModel.fromJson(itemMap));
    });

    return items;
  }


  Future<List<CmcALMResponseModel>> childALMChild(int? crecheIdName) async {
    var query =
        'Select * from  tabCreche_Monitering_Checklist_ALM_response  where creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [crecheIdName]);

    List<CmcALMResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(CmcALMResponseModel.fromJson(itemMap));
    });

    return items;
  }


  Future<List<CmcALMResponseModel>> callCrecheMonotoring() async {
    var query =
        'Select * from  tabCreche_Monitering_Checklist_ALM_response ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query);

    List<CmcALMResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(CmcALMResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcALMResponseModel>> getAlmForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_Checklist_ALM_response where is_edited=1');
    List<CmcALMResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CmcALMResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcALMResponseModel>> getAlmForDraft() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_Checklist_ALM_response where is_edited=2');
    List<CmcALMResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CmcALMResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcALMResponseModel>> getAlmForUploadDarftEdited() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_Checklist_ALM_response where is_edited=1 or is_edited=2');
    List<CmcALMResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CmcALMResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];
    var ceGuid = hhData['almguid'];
    await DatabaseHelper.database!.rawQuery(
        'UPDATE tabCreche_Monitering_Checklist_ALM_response SET name = ?  ,  is_uploaded=1 , is_edited=0 where almguid=?',
        [cename, ceGuid]);
  }

  Future<void> insertUpdate(String child_referral_guid, int? name,
      String responces, String userId, int creche_id) async {
    var item = CmcALMResponseModel(
        almguid: child_referral_guid,
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
        'tabCreche_Monitering_Checklist_ALM_response', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> crecheALMDownloadData(
      Map<String, dynamic> item) async {
    List<Map<String, dynamic>> growth =
        List<Map<String, dynamic>>.from(item['Data']);
    print(growth);
    growth.forEach((element) async {
      var growthData = element['Creche Monitoring Checklist ALM'];

      var items = CmcALMResponseModel(
        almguid: growthData['almguid'],
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

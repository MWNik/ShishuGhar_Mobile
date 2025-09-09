import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/dynamic_screen_model/creche_monitering_checklist_CC_response_model.dart';
import '../../database_helper.dart';

class CmcCCTabResponseHelper {
  Future<void> inserts(CmcCCResponseModel items) async {
    print(items.cmc_cc_guid);
    await DatabaseHelper.database!.insert(
        'tabCreche_Monitering_Checklist_CC_response', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("object");
  }

  Future<void> deleteDraftRecords(CmcCCResponseModel record) async {
    try {
      await DatabaseHelper.database!.delete(
          'tabCreche_Monitering_Checklist_CC_response',
          where: 'is_edited = ? AND name IS NULL AND cmc_cc_guid = ?',
          whereArgs: [2, record.cmc_cc_guid]);
    } catch (e) {
      debugPrint("Error deleting drfat records : $e");
    }
  }

  Future<List<CmcCCResponseModel>> getCrecheCommittieResponcewithGuid(
      String almguid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_Checklist_CC_response where cmc_cc_guid=?',
        [almguid]);
    List<CmcCCResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CmcCCResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcCCResponseModel>> childALMChild(int? crecheIdName) async {
    var query =
        'Select * from  tabCreche_Monitering_Checklist_CC_response  where creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [crecheIdName]);

    List<CmcCCResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(CmcCCResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcCCResponseModel>> callCrechMonitoringCC() async {
    var query =
        'Select * from  tabCreche_Monitering_Checklist_CC_response ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query);

    List<CmcCCResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(CmcCCResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcCCResponseModel>> getCcForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_Checklist_CC_response where is_edited=1 ');
    List<CmcCCResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CmcCCResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcCCResponseModel>> getCcForDarft() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_Checklist_CC_response where is_edited=2 ');
    List<CmcCCResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CmcCCResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CmcCCResponseModel>> getCcForUploadEditDarft() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_Checklist_CC_response where is_edited=1 or is_edited=2');
    List<CmcCCResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CmcCCResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];
    var ceGuid = hhData['cmc_cc_guid'];
    await DatabaseHelper.database!.rawQuery(
        'UPDATE tabCreche_Monitering_Checklist_CC_response SET name = ?  ,  is_uploaded=1 , is_edited=0 where cmc_cc_guid=?',
        [cename, ceGuid]);
  }

  Future<void> insertUpdate(String cmc_cc_guid, int? name, String responces,
      String userId, int creche_id) async {
    var item = CmcCCResponseModel(
        cmc_cc_guid: cmc_cc_guid,
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
        'tabCreche_Monitering_Checklist_CC_response', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> crecheALMDownloadData(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> growth =
        List<Map<String, dynamic>>.from(item['Data']);
    print(growth);
    growth.forEach((element) async {
      // var growthData = element['Creche Monitoring Checklist CC'];

      var items = CmcCCResponseModel(
        cmc_cc_guid: element['cmc_cc_guid'],
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

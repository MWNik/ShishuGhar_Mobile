import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shishughar/database/database_helper.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';
import '../../../model/dynamic_screen_model/creche_monitor_response_model.dart';
import '../../../utils/globle_method.dart';

// TableName
const String _table = "tab_creche_monitoring_response";

typedef ListOfMap = List<Map<String, dynamic>>;

class CrecheMonitorResponseHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  /// Insert Response to DB
  Future<void> insertResponse(CrecheMonitorResponseModel item) async {
    try {
      await DatabaseHelper.database!.insert(
        _table,
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint("insertCrecheMonitorResponse() : $e");
    }
  }

  //
  Future<void> insertUpdate(int crecheId, String cmgUid, int? name,
      String response, String? created_on, String? created_by, String? updated_by, String? updated_on) async {
    try {
      final item = CrecheMonitorResponseModel(
        creche_id: crecheId,
        cmguid: cmgUid,
        responces: response,
        is_uploaded: 0,
        is_edited: 1,
        is_deleted: 0,
        name: name,
        created_by: created_by,
        created_at: created_on,
        update_at: updated_on,
        updated_by: updated_by,
      );

      await DatabaseHelper.database!.insert(_table, item.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print(e.toString());
    }
  }

  /// Get Creche Monitor Response With CmgUid
  Future<List<CrecheMonitorResponseModel>> getCrecheResponseWithCmgUid(
      String cmgUid) async {
    try {
      final ListOfMap queryResult = await DatabaseHelper.database!
          .query(_table, where: 'cmguid = ?', whereArgs: [cmgUid]);

      return queryResult
          .map((e) => CrecheMonitorResponseModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("getCrecheResponseWithCmgUid() : $e");
      return [];
    }
  }

  /// Get Creche Monitor Response with CrecheId
  // Future<List<CrecheMonitorResponseModel>> getCrecheResponseWithCrecheId(
  //     String? crecheId) async {
  //   try {
  //     final ListOfMap queryResult = await DatabaseHelper.database!
  //         .query(_table, where: 'creche_id = ?', whereArgs: [Global.stringToInt(crecheId)]);
  //
  //     return queryResult
  //         .map((e) => CrecheMonitorResponseModel.fromJson(e))
  //         .toList();
  //   } catch (e) {
  //     debugPrint("getCrecheResponseWithCrecheId() : $e");
  //     return [];
  //   }
  // }

  Future<List<CrecheMonitorResponseModel>> getCrecheResponseWithCrecheId( String? crecheId) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_creche_monitoring_response where creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC'
        ,[Global.stringToInt(crecheId)]);
    List<CrecheMonitorResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CrecheMonitorResponseModel.fromJson(itemMap));
    });

    return items;
  }

  // Future<List<CrecheMonitorResponseModel>> callCrecheMonitoringResponse() async {
  //   try {
  //     final ListOfMap queryResult = await DatabaseHelper.database!
  //         .query(_table);
  //
  //     return queryResult
  //         .map((e) => CrecheMonitorResponseModel.fromJson(e))
  //         .toList();
  //   } catch (e) {
  //     debugPrint("getCrecheResponseWithCrecheId() : $e");
  //     return [];
  //   }
  // }
  Future<List<CrecheMonitorResponseModel>> callCrecheMonitoringResponse() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_creche_monitoring_response ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC'
       );
    List<CrecheMonitorResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CrecheMonitorResponseModel.fromJson(itemMap));
    });

    return items;
  }



  /// Get Creche Monitor Response for Upload
  Future<List<CrecheMonitorResponseModel>> getCrecheResponseForUpload() async {
    try {
      final ListOfMap queryResult = await DatabaseHelper.database!
          .rawQuery('SELECT * FROM $_table WHERE is_edited = 1');

      return queryResult
          .map((e) => CrecheMonitorResponseModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("getCrecheResponseForUpload() : $e");
      return [];
    }
  }

  Future<List<CrecheMonitorResponseModel>> getVillageProfileforUploadDarftEdit() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from tab_creche_monitoring_response where is_edited=1 or is_edited=2');
    List<CrecheMonitorResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CrecheMonitorResponseModel.fromJson(itemMap));
    });

    return items;
  }

  /// Update Uploaded Item
  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    print(item);

    var mainKey = item['data'];
    var name = mainKey['name'];
    var cmgUid = mainKey['cmguid'];

    await DatabaseHelper.database!.rawQuery(
        'UPDATE $_table SET name = ?  ,  is_uploaded = 1 , is_edited = 0 WHERE cmguid = ?',
        [name, cmgUid]);
  }

  /// Download Checklist Data
  Future<void> downloadChecklistData(Map<String, dynamic> item) async {
    try {
      ListOfMap data = ListOfMap.from(item['Data']);

      data.forEach((element) async {
        final checkListData = element['Creche Monitoring Checklist'];

        final items = CrecheMonitorResponseModel(
          cmguid: checkListData['cmguid'],
          name: checkListData['name'],
          is_uploaded: 1,
          is_edited: 0,
          is_deleted: 0,
          creche_id: Global.stringToInt(checkListData['creche_id'].toString()),
          update_at: checkListData['app_updated_on'],
          updated_by: checkListData['app_updated_by'],
          created_at: checkListData['appcreated_on'],
          created_by: checkListData['appcreated_by'],
          responces: jsonEncode(Validate().keyesFromResponce(checkListData)),
        );

        await insertResponse(items);
      });
    } catch (e) {
      debugPrint("downloadChecklistData() : $e");
    }
  }
}


import 'dart:convert';

import 'package:shishughar/database/database_helper.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/apimodel/caregiver_responce_model.dart';


class CrecheCareGiverHelper {
  Future<void> inserts(CareGiverResponceModel items) async {
    await DatabaseHelper.database!.insert(
        'tab_caregiver_response', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertWhole(List<CareGiverResponceModel> careGiversList) async {
    await DatabaseHelper.database!.transaction((txn) async{
      var batch = txn.batch();
      for (var item in careGiversList) {
        batch.insert('tab_caregiver_response',item.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }



  Future<List<CareGiverResponceModel>> getCareGiverResponce(int parentName) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_caregiver_response where parent=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC',[parentName]);
    List<CareGiverResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(CareGiverResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CareGiverResponceModel>> geCareGiverResponceItem(int parentName,String CGGuid) async {
   List<Map<String, dynamic>> result=[];
   //  if(Global.validString(name)){
   //    result= await DatabaseHelper.database!.rawQuery(
   //        'select * from tab_caregiver_response where name=? and parent=?',[name,parentName]);
   // }else {
      result=await DatabaseHelper.database!.rawQuery(
          'select * from tab_caregiver_response where CGGUID=? and parent=?',[CGGuid,parentName]);
    // }
    List<CareGiverResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(CareGiverResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> insertupdate(CareGiverResponceModel item,int parentName,String CGGUID,String? name) async {
    // if(Global.validString(name)){
    //   await DatabaseHelper.database!
    //       .rawQuery('UPDATE tab_caregiver_response SET CGGUID = ? ,responces = ?  , created_at=? , created_by=? , update_at=? , updated_by=? , is_uploaded=0 , is_edited=1 where name=? and parent=?',
    //       [CGGUID,item.responces,item.created_at,
    //     item.created_by,item.update_at,item.updated_by,name,parentName]);
    // }else{
    //   item.is_uploaded=0;
    //   item.is_edited=1;
      await inserts(item);
    // }

  }

  Future<List<CareGiverResponceModel>> callCareGiverUpload(int parent) async {
    // List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
    //     'select * from tab_caregiver_response where is_edited=1 and is_uploaded=0 and  parent=  ?',[parent]);

    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_caregiver_response where  parent=  ?',[parent]);

    List<CareGiverResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(CareGiverResponceModel.fromJson(itemMap));
    });

    return items;
  }

}

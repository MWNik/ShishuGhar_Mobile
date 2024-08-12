import 'dart:convert';

import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';


import '../../../model/databasemodel/child_exit_response_model.dart';
import '../../database_helper.dart';

class ChildExitResponceHelper {
  Future<void> inserts(ChildExitTabResponceModel items) async {
    print(items.child_exit_guid);
    await DatabaseHelper.database!.insert('child_exit_responce', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("object");
  }

  Future<List<ChildExitTabResponceModel>> getChildEventResponcewithGuid(
      String ceGuid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_exit_responce where child_exit_guid=?', [ceGuid]);
    List<ChildExitTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildExitTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildExitTabResponceModel>> getChildExitsByEnrolledChildGuid(
      String childenrolledguid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_exit_responce where childenrolledguid=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC', [childenrolledguid]);
    List<ChildExitTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildExitTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildExitTabResponceModel>> childEventsBycreche(
      int? crecheIdName,
      ) async {
    var query = 'Select * from  child_exit_responce  where creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query, [crecheIdName]);

    List<ChildExitTabResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildExitTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<Map<String, dynamic>>> childExtedlistingByCreche(
      int? crecheIdName,
      ) async {
    var query = 'select cer.*,ecr.responces as ecrResponce from child_exit_responce cer left join enrollred_chilren_responce as ecr on cer.childenrolledguid =ecr.ChildEnrollGUID where cer.creche_id =? ORDER BY CASE  WHEN cer.update_at IS NOT NULL AND length(RTRIM(LTRIM(cer.update_at))) > 0 THEN cer.update_at ELSE cer.created_at END DESC';

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query, [crecheIdName]);


    return result;
  }

  Future<List<ChildExitTabResponceModel>> childEventsByChild(
      String? crecheIdName, String? childenrolledguid) async {
    var query =
        'Select * from  child_exit_responce  where creche_id=? and childenrolledguid=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery(query, [crecheIdName, childenrolledguid]);

    List<ChildExitTabResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildExitTabResponceModel.fromJson(itemMap));
    });

    return items;
  }



  Future<List<ChildExitTabResponceModel>>
      getEditedChildExitForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from child_exit_responce where is_edited=1');
    List<ChildExitTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildExitTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];
    var child_exit_guid = hhData['child_exit_guid'];

    await DatabaseHelper.database!.rawQuery(
        'UPDATE child_exit_responce SET name = ? , is_uploaded=1 , is_edited=0 where child_exit_guid=?',
        [cename, child_exit_guid]);
  }

  Future<void> childExitDownloadData(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> growth =
        List<Map<String, dynamic>>.from(item['Data']);
    print(growth);
    growth.forEach((element) async {
      var growthData = element['Child Exit'];

      var name = growthData['name'];
      var creche_id = growthData['creche_id'];
      var child_event_guid = growthData['child_exit_guid'];
      var childenrolledguid = growthData['childenrolledguid'];
      var appCreatedOn = growthData['appcreated_on'];
      var appcreated_by = growthData['appcreated_by'];
      var app_updated_by = growthData['app_updated_by'];
      var app_updated_on = growthData['app_updated_on'];
      var finalHHData = Validate().keyesFromResponce(growthData);
      var hhDtaResponce = jsonEncode(finalHHData);

      var items = ChildExitTabResponceModel(
        child_exit_guid: child_event_guid,
        childenrolledguid: childenrolledguid,
        name: name,
        is_uploaded: 1,
        is_edited: 0,
        is_deleted: 0,
        creche_id: Global.stringToInt(creche_id),
        update_at: app_updated_on,
        updated_by: app_updated_by,
        created_at: appCreatedOn,
        created_by: appcreated_by,
        responces: hhDtaResponce,
      );
      await inserts(items);
    });
  }

  Future<List<ChildExitTabResponceModel>> childExitsByChildId(
      String? childenrolledguid) async {
    var query = 'Select * from  child_exit_responce  where childenrolledguid=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    dynamic result =
    await DatabaseHelper.database!.rawQuery(query, [childenrolledguid]);

    List<ChildExitTabResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildExitTabResponceModel.fromJson(itemMap));
    });

    return items;
  }


  Future<List<Map<String, dynamic>>> exitedChildHistoryByEnrollChildGUID(
      String? childenrolledguid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select ecr.*,cr.responces as crResponces from enrollred_exit_child_responce ecr left join tab_creche_response as cr on ecr.creche_id=cr.name where ecr.CHHGUID=(select CHHGUID from enrollred_exit_child_responce where ChildEnrollGUID=?) and ecr.date_of_exit NOTNULL',[childenrolledguid]);


    return result;
  }
  Future<List<Map<String, dynamic>>> exitedChildHistoryByEnrollChildGUIDREPLICA(
      String? childenrolledguid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select ecr.*,cr.responces as crResponces from enrollred_exit_child_responce ecr left join tab_creche_response as cr on ecr.creche_id=cr.name where ecr.ChildEnrollGUID=? and ecr.date_of_exit NOTNULL',[childenrolledguid]);


    return result;
  }

  Future<List<Map<String, dynamic>>> childExtedlistingByCrechenew(
      int? crecheIdName,
      ) async {
    var query = 'select * from enrollred_exit_child_responce  where creche_id =? and date_of_exit NOTNULL ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query, [crecheIdName]);


    return result;
  }
}

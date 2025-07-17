import 'dart:convert';

import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/databasemodel/child_event_tab_response_model.dart';
import '../../database_helper.dart';

class ChildEventTabResponceHelper {
  Future<void> inserts(ChildEventTabResponceModel items) async {
    print(items.child_event_guid);
    await DatabaseHelper.database!.insert(
        'child_event_responce', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("object");
  }

  Future<List<ChildEventTabResponceModel>> getChildEventResponcewithGuid(
      String ceGuid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_event_responce where child_event_guid=?',
        [ceGuid]);
    List<ChildEventTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildEventTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildEventTabResponceModel>> callEventsEnrolledChildGUID(
      String childenrolledguid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_event_responce where childenrolledguid=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC',
        [childenrolledguid]);
    List<ChildEventTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildEventTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildEventTabResponceModel>> childEventsByChild(
      String? crecheIdName, String? childenrolledguid) async {
    var query =
        'Select * from  child_event_responce  where creche_id=? and childenrolledguid=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery(query, [crecheIdName, childenrolledguid]);

    List<ChildEventTabResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildEventTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildEventTabResponceModel>>
      getEditedChildEventsForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from child_event_responce where is_edited=1');
    List<ChildEventTabResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildEventTabResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];
    var child_event_guid = hhData['child_event_guid'];

    await DatabaseHelper.database!.rawQuery(
        'UPDATE child_event_responce SET name = ?  , is_uploaded=1 , is_edited=0 where child_event_guid=?',
        [cename, child_event_guid]);
  }

  Future<void> downloadDataItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    if (hhData != null) {
      List<Map<String, dynamic>> children =
          List<Map<String, dynamic>>.from(hhData['children']);
      hhData.remove('children');
      var hhguid = hhData['hhguid'];
      var name = hhData['name'];
      var finalHHData = Validate().keyesFromResponce(hhData);
      var hhDtaResponce = jsonEncode(finalHHData);
      await DatabaseHelper.database!.rawQuery(
          'UPDATE house_hold_responce SET name = ? ,responces = ? , is_uploaded=1 , is_edited=0 where HHGUID=?',
          [name, hhDtaResponce, hhguid]);
      // await DatabaseHelper.database!
      //     .rawQuery('UPDATE house_hold_responce SET name = ? , is_uploaded=1 , is_edited=0 where HHGUID=?', [name,hhguid]);
      children.forEach((element) async {
        var chName = element['name'];
        var chCGUIF = element['hhcguid'];
        var finalCHHData = Validate().keyesFromResponce(element);
        var cHHDtaResponce = jsonEncode(finalCHHData);
        // await DatabaseHelper.database!
        //     .rawQuery('UPDATE house_hold_children SET name = ? ,responces = ? ,parent = ? , is_uploaded=1 , is_edited=0 where CHHGUID=?', [chName,cHHDtaResponce,name,chCGUIF]);
        await DatabaseHelper.database!.rawQuery(
            'UPDATE house_hold_children SET name = ?  ,parent = ? , is_uploaded=1 , is_edited=0 where CHHGUID=?',
            [chName, name, chCGUIF]);
      });
    }
  }

  Future<void> childEventMetaData(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> growth =
        List<Map<String, dynamic>>.from(item['Data']);

    // List to hold child event data models
    List<ChildEventTabResponceModel> eventItems = [];

    // Prepare data
    for (var element in growth) {
      var growthData = element['Child Event'];

      var name = growthData['name'];
      var crecheId = growthData['creche_id'];
      var childEventGuid = growthData['child_event_guid'];
      var childEnrolledGuid = growthData['childenrolledguid'];
      var appCreatedOn = growthData['appcreated_on'];
      var appCreatedBy = growthData['appcreated_by'];
      var appUpdatedBy = growthData['app_updated_by'];
      var appUpdatedOn = growthData['app_updated_on'];
      var finalHHData = Validate().keyesFromResponce(growthData);
      var hhDataResponse = jsonEncode(finalHHData);

      // Add the event data model to the list
      eventItems.add(
        ChildEventTabResponceModel(
          child_event_guid: childEventGuid,
          childenrolledguid: childEnrolledGuid,
          name: name,
          is_uploaded: 1,
          is_edited: 0,
          is_deleted: 0,
          creche_id: Global.stringToInt(crecheId),
          update_at: appUpdatedOn,
          updated_by: appUpdatedBy,
          created_at: appCreatedOn,
          created_by: appCreatedBy,
          responces: hhDataResponse,
        ),
      );
    }

    // Commit data in a transaction using batch
    await DatabaseHelper.database!.transaction((txn) async {
      var batch = txn.batch();

      // Add all event items to the batch
      for (var item in eventItems) {
        batch.insert(
          'child_event_responce',
          item.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Commit the batch
      await batch.commit(noResult: true);
    });

    print('Child Event data successfully inserted.');
  }

  // Future<void> childEventMetaData(Map<String, dynamic> item) async {
  //   List<Map<String, dynamic>> growth =
  //   List<Map<String, dynamic>>.from(item['Data']);
  //   print(growth);
  //   growth.forEach((element) async {
  //     var growthData = element['Child Event'];

  //     var name = growthData['name'];
  //     var creche_id = growthData['creche_id'];
  //     var child_event_guid = growthData['child_event_guid'];
  //     var childenrolledguid = growthData['childenrolledguid'];
  //     var appCreatedOn = growthData['appcreated_on'];
  //     var appcreated_by = growthData['appcreated_by'];
  //     var app_updated_by = growthData['app_updated_by'];
  //     var app_updated_on = growthData['app_updated_on'];
  //     var finalHHData = Validate().keyesFromResponce(growthData);
  //     var hhDtaResponce = jsonEncode(finalHHData);

  //     var items = ChildEventTabResponceModel(
  //       child_event_guid: child_event_guid,
  //       childenrolledguid: childenrolledguid,
  //       name: name,
  //       is_uploaded: 1,
  //       is_edited: 0,
  //       is_deleted: 0,
  //       creche_id: Global.stringToInt(creche_id),
  //       update_at: app_updated_on,
  //       updated_by: app_updated_by,
  //       created_at: appCreatedOn,
  //       created_by: appcreated_by,
  //       responces: hhDtaResponce,
  //     );
  //     await inserts(items);
  //   });
  // }
}

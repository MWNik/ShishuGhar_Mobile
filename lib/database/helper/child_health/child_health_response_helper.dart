import 'dart:convert';

import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/databasemodel/child_health_respose_model.dart';
import '../../database_helper.dart';

class ChildHealthTabResponceHelper {
  Future<void> inserts(ChildHealthResponceModel items) async {
    print(items.child_health_guid);
    await DatabaseHelper.database!.insert(
        'child_health_responce', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("object");
  }



  Future<List<ChildHealthResponceModel>> getChildEventResponcewithGuid(
      String child_health_guid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_health_responce where child_health_guid=?',
        [child_health_guid]);
    List<ChildHealthResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildHealthResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildHealthResponceModel>> callHealthByEnrolledChildGuid(
      String child_health_guid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_health_responce where childenrolledguid=?',
        [child_health_guid]);
    List<ChildHealthResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildHealthResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildHealthResponceModel>> childEventByChild(
      String? crecheIdName,String childenrolledguid) async {
    var query = 'Select * from  child_health_responce  where creche_id=? and childenrolledguid=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [crecheIdName,childenrolledguid]);

    List<ChildHealthResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildHealthResponceModel.fromJson(itemMap));
    });

    return items;
  }




  Future<List<ChildHealthResponceModel>> getChildHealthForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from child_health_responce where is_edited=1');
    List<ChildHealthResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildHealthResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];
    var ceGuid = hhData['child_health_guid'];

    await DatabaseHelper.database!.rawQuery(
        'UPDATE child_health_responce SET name = ?  ,  is_uploaded=1 , is_edited=0 where child_health_guid=?',
        [cename, ceGuid]);
  }
Future<void> childDownloadHealthData(Map<String, dynamic> item) async {
  List<Map<String, dynamic>> growth = List<Map<String, dynamic>>.from(item['Data']);

  // List to hold child health data models
  List<ChildHealthResponceModel> healthItems = [];

  // Prepare data
  for (var element in growth) {
    var growthData = element['Child Health'];

    var name = growthData['name'];
    var crecheId = growthData['creche_id'];
    var childHealthGuid = growthData['child_health_guid'];
    var childEnrolledGuid = growthData['childenrolledguid'];
    var appCreatedOn = growthData['appcreated_on'];
    var appCreatedBy = growthData['appcreated_by'];
    var appUpdatedBy = growthData['app_updated_by'];
    var appUpdatedOn = growthData['app_updated_on'];
    var finalHHData = Validate().keyesFromResponce(growthData);
    var hhDataResponse = jsonEncode(finalHHData);

    // Add the health data model to the list
    healthItems.add(
      ChildHealthResponceModel(
        child_health_guid: childHealthGuid,
        childenrolledguid: childEnrolledGuid,
        name: name,
        is_uploaded: 1,
        is_edited: 0,
        is_deleted: 0,
        creche_id: Global.stringToInt(crecheId.toString()),
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

    // Add all health items to the batch
    for (var item in healthItems) {
      batch.insert(
        'child_health_responce',  // Table name where the data will be inserted
        item.toJson(),  // Convert model to JSON format for insertion
        conflictAlgorithm: ConflictAlgorithm.replace,  // Handle conflicts
      );
    }

    // Commit the batch
    await batch.commit(noResult: true);
  });

  print('Child Health data successfully inserted.');
}

  // Future<void> childDownloadHealthData(Map<String, dynamic> item) async {
  //   List<Map<String, dynamic>> growth =
  //   List<Map<String, dynamic>>.from(item['Data']);
  //   print(growth);
  //   growth.forEach((element) async {
  //     var growthData = element['Child Health'];

  //     var name = growthData['name'];
  //     var creche_id = growthData['creche_id'];
  //     var child_health_guid = growthData['child_health_guid'];
  //     var childenrolledguid = growthData['childenrolledguid'];
  //     var appCreatedOn = growthData['appcreated_on'];
  //     var appcreated_by = growthData['appcreated_by'];
  //     var app_updated_by = growthData['app_updated_by'];
  //     var app_updated_on = growthData['app_updated_on'];
  //     var finalHHData = Validate().keyesFromResponce(growthData);
  //     var hhDtaResponce = jsonEncode(finalHHData);

  //     var items = ChildHealthResponceModel(
  //       child_health_guid: child_health_guid,
  //       childenrolledguid: childenrolledguid,
  //       name: name,
  //       is_uploaded: 1,
  //       is_edited: 0,
  //       is_deleted: 0,
  //       creche_id: Global.stringToInt(creche_id.toString()),
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

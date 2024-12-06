import 'dart:convert';

import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/databasemodel/child_health_respose_model.dart';

import '../../../model/dynamic_screen_model/child_grievances_response_model.dart';
import '../../database_helper.dart';

class ChildGrievancesTabResponceHelper {
  Future<void> inserts(ChildGrievancesResponceModel items) async {
    print(items.grievance_guid);
    await DatabaseHelper.database!.insert(
        'grievances_responce', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("object");
  }

  Future<List<ChildHealthResponceModel>> getChildEventResponcewithGuid(
      String child_grievences_guid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from grievances_responce where grievance_guid=?',
        [child_grievences_guid]);
    List<ChildHealthResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildHealthResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildGrievancesResponceModel>> childGravienceByCreche(
      String? crecheIdName) async {
    var query = 'Select * from  grievances_responce  where creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query,
            [Global.stringToInt(crecheIdName)]);

    List<ChildGrievancesResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildGrievancesResponceModel.fromJson(itemMap));
    });

    return items;
  }


  Future<List<ChildGrievancesResponceModel>> getAllChildGrievance() async {
    var query = 'Select * from  grievances_responce ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query);

    List<ChildGrievancesResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildGrievancesResponceModel.fromJson(itemMap));
    });

    return items;
  }


  Future<List<ChildGrievancesResponceModel>>
      getChildGrievanceForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from grievances_responce where is_edited=1');
    List<ChildGrievancesResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildGrievancesResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildGrievancesResponceModel>>
  getChildGrievanceForUploadDarft() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from grievances_responce where is_edited=1 or is_edited=2');
    List<ChildGrievancesResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildGrievancesResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];
    var ceGuid = hhData['grievance_guid'];
    // var chGuid = hhData['childenrolledguid'];

    // await DatabaseHelper.database!.rawQuery(
    //     'UPDATE grievances_responce SET name = ?  ,  is_uploaded=1 , is_edited=0 where grievance_guid=? and childenrolledguid=?',
    //     [cename, ceGuid, chGuid]);
    await DatabaseHelper.database!.rawQuery(
        'UPDATE grievances_responce SET name = ?  ,  is_uploaded=1 , is_edited=0 where grievance_guid=?',
        [cename, ceGuid]);
  }

  Future<void> childDownloadGrievanceData(Map<String, dynamic> item) async {
  List<Map<String, dynamic>> growth =
      List<Map<String, dynamic>>.from(item['Data']);
  print(growth);

  // List to collect ChildGrievancesResponceModel items
  List<ChildGrievancesResponceModel> itemsList = [];

  // Process data and add to list
  for (var element in growth) {
    var growthData = element['Grievance'];
    var name = growthData['name'];
    var creche_id = growthData['creche_id'];
    var child_grievance_guid = growthData['grievance_guid'];
    var appCreatedOn = growthData['appcreated_on'];
    var appcreated_by = growthData['appcreated_by'];
    var app_updated_by = growthData['app_updated_by'];
    var app_updated_on = growthData['app_updated_on'];
    var finalHHData = Validate().keyesFromResponce(growthData);
    var hhDtaResponce = jsonEncode(finalHHData);

    // Create model and add to items list
    var item = ChildGrievancesResponceModel(
      grievance_guid: child_grievance_guid,
      name: name,
      is_uploaded: 1,
      is_edited: 0,
      is_deleted: 0,
      creche_id: Global.stringToInt(creche_id.toString()),
      update_at: app_updated_on,
      updated_by: app_updated_by,
      created_at: appCreatedOn,
      created_by: appcreated_by,
      responces: hhDtaResponce,
    );

    itemsList.add(item);
  }

  // If the list has more than 500 items, split it into batches
  if (itemsList.length > 500) {
    for (int i = 0; i < itemsList.length; i += 500) {
      var batchItems = itemsList.sublist(i, (i + 500) > itemsList.length ? itemsList.length : (i + 500));

      // Insert the batch
      await _insertBatch(batchItems);
    }
  } else {
    // If the list has 500 or fewer items, insert them all at once
    await _insertBatch(itemsList);
  }
}

// Helper function to insert a batch of items
Future<void> _insertBatch(List<ChildGrievancesResponceModel> batchItems) async {
  await DatabaseHelper.database!.transaction((txn) async {
    var batch = txn.batch();

    for (var item in batchItems) {
      batch.insert(
        'grievances_responce',
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Commit the batch insert
    await batch.commit(noResult: true);
  });
}


  // Future<void> childDownloadGrievanceData(Map<String, dynamic> item) async {
  //   List<Map<String, dynamic>> growth =
  //       List<Map<String, dynamic>>.from(item['Data']);
  //   print(growth);
  //   growth.forEach((element) async {
  //     var growthData = element['Grievance'];
  //     var name = growthData['name'];
  //     // var chGuid = growthData['childenrolledguid'];
  //     var creche_id = growthData['creche_id'];
  //     var child_grievance_guid = growthData['grievance_guid'];
  //     var appCreatedOn = growthData['appcreated_on'];
  //     var appcreated_by = growthData['appcreated_by'];
  //     var app_updated_by = growthData['app_updated_by'];
  //     var app_updated_on = growthData['app_updated_on'];
  //     var finalHHData = Validate().keyesFromResponce(growthData);
  //     var hhDtaResponce = jsonEncode(finalHHData);

  //     var items = ChildGrievancesResponceModel(
  //       grievance_guid: child_grievance_guid,
  //       name: name,
  //       // childenrolledguid: chGuid,
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

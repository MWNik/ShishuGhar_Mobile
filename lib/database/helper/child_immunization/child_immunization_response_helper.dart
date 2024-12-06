import 'dart:convert';

import 'package:shishughar/database/database_helper.dart';
import 'package:shishughar/model/dynamic_screen_model/child_immunization_response_model.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';

import '../../../utils/globle_method.dart';

class ChildImmunizationResponseHelper {
  Future<void> inserts(ChildImmunizationResponceModel items) async {
    await DatabaseHelper.database!.insert(
        'child_immunization_responce', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ChildImmunizationResponceModel>> getChildEventResponcewithGuid(
      String child_immunization_guid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_immunization_responce where child_immunization_guid=?',
        [child_immunization_guid]);
    List<ChildImmunizationResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildImmunizationResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildImmunizationResponceModel>> childEventByChild(
      String? crecheIdName, String? childenrolledguid) async {
    var query =
        'Select * from  child_immunization_responce  where creche_id=? and childenrolledguid=?';

    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery(query, [crecheIdName, childenrolledguid]);

    List<ChildImmunizationResponceModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildImmunizationResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['Data'];
    var cename = hhData['name'];
    var child_immunization_guid = hhData['child_immunization_guid'];

    await DatabaseHelper.database!.rawQuery(
        'UPDATE child_immunization_responce SET name = ?   , is_uploaded=1 , is_edited=0 where child_immunization_guid=?',
        [cename, child_immunization_guid]);
  }

  Future<void> childImmunizationDownloadData(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> growth =
        List<Map<String, dynamic>>.from(item['Data']);

    print(growth);

    // List to collect ChildImmunizationResponceModel items
    List<ChildImmunizationResponceModel> itemsList = [];

    // Process data and add to list
    for (var element in growth) {
      var growthData = element['Child Immunization'];
      var vaccineDetails = element['vaccine_details'];
      growthData.remove(vaccineDetails);

      var name = growthData['name'];
      var creche_id = growthData['creche_id'];
      var childenrolledguid = growthData['childenrolledguid'];
      var child_immunization_guid = growthData['child_immunization_guid'];
      var appCreatedOn = growthData['appcreated_on'];
      var appcreated_by = growthData['appcreated_by'];
      var app_updated_by = growthData['app_updated_by'];
      var app_updated_on = growthData['app_updated_on'];
      var finalHHData = Validate().keyesFromResponce(growthData);
      var hhDtaResponce = jsonEncode(finalHHData);

      // Create model and add to items list
      var item = ChildImmunizationResponceModel(
        child_immunization_guid: child_immunization_guid,
        childenrolledguid: childenrolledguid,
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
        var batchItems = itemsList.sublist(
            i, (i + 500) > itemsList.length ? itemsList.length : (i + 500));

        // Insert the batch
        await _insertBatch(batchItems);
      }
    } else {
      // If the list has 500 or fewer items, insert them all at once
      await _insertBatch(itemsList);
    }
  }

// Helper function to insert a batch of items
  Future<void> _insertBatch(
      List<ChildImmunizationResponceModel> batchItems) async {
    await DatabaseHelper.database!.transaction((txn) async {
      var batch = txn.batch();

      for (var item in batchItems) {
        batch.insert(
          'child_immunization_responce',
          item.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Commit the batch insert
      await batch.commit(noResult: true);
    });
  }

  // Future<void> childImmunizationDownloadData(Map<String, dynamic> item) async {
  //   List<Map<String, dynamic>> growth =
  //   List<Map<String, dynamic>>.from(item['Data']);
  //   print(growth);
  //   growth.forEach((element) async {
  //     var growthData = element['Child Immunization'];
  //     var vaccineDetails = element['vaccine_details'];
  //     growthData.remove(vaccineDetails);

  //     var name = growthData['name'];
  //     var creche_id = growthData['creche_id'];
  //     var childenrolledguid = growthData['childenrolledguid'];
  //     var child_immunization_guid = growthData['child_immunization_guid'];
  //     var appCreatedOn = growthData['appcreated_on'];
  //     var appcreated_by = growthData['appcreated_by'];
  //     var app_updated_by = growthData['app_updated_by'];
  //     var app_updated_on = growthData['app_updated_on'];
  //     var finalHHData = Validate().keyesFromResponce(growthData);
  //     var hhDtaResponce = jsonEncode(finalHHData);

  //     var items = ChildImmunizationResponceModel(
  //       child_immunization_guid: child_immunization_guid,
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

  Future<List<ChildImmunizationResponceModel>>
      getChildImmunizationForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_immunization_responce where is_edited=1');
    List<ChildImmunizationResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildImmunizationResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildImmunizationResponceModel>> callImmunizationByChilEnrollGUID(
      String childenrolledguid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_immunization_responce where childenrolledguid=?',
        [childenrolledguid]);
    List<ChildImmunizationResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildImmunizationResponceModel.fromJson(itemMap));
    });

    return items;
  }
}

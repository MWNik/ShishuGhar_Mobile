import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shishughar/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../model/dynamic_screen_model/cashbook_response_expences_model.dart';
import '../../../../utils/globle_method.dart';
import '../../../../utils/validate.dart';

class CashBookResponseExpencesHelper {
  Future<void> inserts(CashbookExpencesResponseModel items) async {
    print(items.cashbook_guid);
    await DatabaseHelper.database!.insert(
        'tab_cashbook_expences_response', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CashbookExpencesResponseModel>>
      getCashbookExpencesResponcewithGuid(
    String ceGuid,
  ) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_cashbook_expences_response where cashbook_guid=?',
        [ceGuid]);
    List<CashbookExpencesResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CashbookExpencesResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CashbookExpencesResponseModel>> cashbookExpencesByCreche(
      String? crecheIdName) async {
    var query =
        'Select * from  tab_cashbook_expences_response  where creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [crecheIdName]);

    List<CashbookExpencesResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(CashbookExpencesResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CashbookExpencesResponseModel>>
      getEditedCashBookForExpenceUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_cashbook_expences_response where is_edited=1');
    List<CashbookExpencesResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CashbookExpencesResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];
    var child_event_guid = hhData['cashbook_guid'];

    await DatabaseHelper.database!.rawQuery(
        'UPDATE tab_cashbook_expences_response SET name = ?  , is_uploaded=1 , is_edited=0 where cashbook_guid=?',
        [cename, child_event_guid]);
  }

  Future<void> childCashbookMetaData(Map<String, dynamic> item) async {
    try {
      List<Map<String, dynamic>> growth =
          List<Map<String, dynamic>>.from(item['Data']);

      // List to collect all CashbookExpencesResponseModel items
      List<CashbookExpencesResponseModel> itemsList = [];

      // Process each growth data and add to the items list
      for (var growthData in growth) {
        var name = growthData['name'];
        var creche_id = growthData['creche_id'];
        var cashbook_guid = growthData['cashbook_guid'];
        var appCreatedOn = growthData['appcreated_on'];
        var appcreated_by = growthData['appcreated_by'];
        var app_updated_by = growthData['app_updated_by'];
        var app_updated_on = growthData['app_updated_on'];
        var finalHHData = Validate().keyesFromResponce(growthData);
        var hhDtaResponce = jsonEncode(finalHHData);

        // Create CashbookExpencesResponseModel instance
        var items = CashbookExpencesResponseModel(
          cashbook_guid: cashbook_guid,
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

        // Add the item to the list
        itemsList.add(items);
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

      print("Data insertion successful!");
    } catch (e) {
      debugPrint("childCashbookMetaData() : $e");
    }
  }

// Helper function to insert a batch of items
  Future<void> _insertBatch(
      List<CashbookExpencesResponseModel> batchItems) async {
    await DatabaseHelper.database!.transaction((txn) async {
      var batch = txn.batch();

      for (var item in batchItems) {
        batch.insert(
          'tab_cashbook_expences_response', // Change to your actual table name
          item.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Commit the batch insert
      await batch.commit(noResult: true);
    });
  }

  // Future<void> childCashbookMetaData(Map<String, dynamic> item) async {
  //   List<Map<String, dynamic>> growth =
  //       List<Map<String, dynamic>>.from(item['Data']);
  //   print(growth);
  //   growth.forEach((growthData) async {
  //     // var growthData = element['Cashbook'];

  //     var name = growthData['name'];
  //     var creche_id = growthData['creche_id'];
  //     var cashbook_guid = growthData['cashbook_guid'];

  //     var appCreatedOn = growthData['appcreated_on'];
  //     var appcreated_by = growthData['appcreated_by'];
  //     var app_updated_by = growthData['app_updated_by'];
  //     var app_updated_on = growthData['app_updated_on'];
  //     var finalHHData = Validate().keyesFromResponce(growthData);
  //     var hhDtaResponce = jsonEncode(finalHHData);

  //     var items = CashbookExpencesResponseModel(
  //       cashbook_guid: cashbook_guid,
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

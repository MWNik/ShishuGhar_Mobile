import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shishughar/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../model/dynamic_screen_model/cashbook_receipt_response_model.dart';
import '../../../../utils/globle_method.dart';
import '../../../../utils/validate.dart';

class CashBookReceiptResponseHelper {
  Future<void> inserts(CashbookReceiptResponseModel items) async {
    await DatabaseHelper.database!.insert(
        'tab_cashbook_receipt_response', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CashbookReceiptResponseModel>> getChildEventResponcewithGuid(
    int name,
  ) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_cashbook_receipt_response where name=?',
        [name]);
    List<CashbookReceiptResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CashbookReceiptResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CashbookReceiptResponseModel>> cashbookByCreche(
      String? crecheIdName) async {
    var query =
        'Select * from  tab_cashbook_receipt_response  where creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [crecheIdName]);

    List<CashbookReceiptResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(CashbookReceiptResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CashbookReceiptResponseModel>>
      getEditedCashBookReceiptForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_cashbook_receipt_response where is_edited=1');
    List<CashbookReceiptResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CashbookReceiptResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];

    await DatabaseHelper.database!.rawQuery(
        'UPDATE tab_cashbook_receipt_response  set is_uploaded=1 , is_edited=0 where name=?',
        [cename]);
  }

  Future<void> childCashbookMetaData(Map<String, dynamic> item) async {
  try {
    List<Map<String, dynamic>> growth = List<Map<String, dynamic>>.from(item['Data']);
    
    // List to collect all CashbookReceiptResponseModel items
    List<CashbookReceiptResponseModel> itemsList = [];

    // Process each growth data and add to the items list
    for (var growthData in growth) {
      var name = growthData['name'];
      var creche_id = growthData['creche_id'];
      var appCreatedOn = growthData['appcreated_on'];
      var appcreated_by = growthData['appcreated_by'];
      var app_updated_by = growthData['app_updated_by'];
      var app_updated_on = growthData['app_updated_on'];
      var finalHHData = Validate().keyesFromResponce(growthData);
      var hhDtaResponce = jsonEncode(finalHHData);

      // Create CashbookReceiptResponseModel instance
      var items = CashbookReceiptResponseModel(
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
        var batchItems = itemsList.sublist(i, (i + 500) > itemsList.length ? itemsList.length : (i + 500));

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
Future<void> _insertBatch(List<CashbookReceiptResponseModel> batchItems) async {
  await DatabaseHelper.database!.transaction((txn) async {
    var batch = txn.batch();

    for (var item in batchItems) {
      batch.insert(
        'tab_cashbook_receipt_response', // Change to your actual table name
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
  //     // var growthData = element['Cashbook Receipt'];

  //     var name = growthData['name'];
  //     var creche_id = growthData['creche_id'];

  //     var appCreatedOn = growthData['appcreated_on'];
  //     var appcreated_by = growthData['appcreated_by'];
  //     var app_updated_by = growthData['app_updated_by'];
  //     var app_updated_on = growthData['app_updated_on'];
  //     var finalHHData = Validate().keyesFromResponce(growthData);
  //     var hhDtaResponce = jsonEncode(finalHHData);

  //     var items = CashbookReceiptResponseModel(
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

  Future<void> updateStatus(
      String? response, int name) async {
    await DatabaseHelper.database!.rawQuery(
        'UPDATE tab_cashbook_receipt_response SET responces=? , is_edited = 1, is_uploaded =0 where name=?',
        [response, name]);
  }
}

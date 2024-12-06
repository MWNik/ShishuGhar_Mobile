import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shishughar/model/dynamic_screen_model/requisition_response_model.dart';
import 'package:shishughar/model/dynamic_screen_model/village_profile_response_model.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';

import '../../database_helper.dart';

class RequisitionResponseHelper {
  Future<void> inserts(RequisitionResponseModel items) async {
    await DatabaseHelper.database!.insert(
        'tabCreche_requisition_response', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("object");
  }

  Future<List<RequisitionResponseModel>> getrequisitionByName(int vName) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_requisition_response where name=?', [vName]);
    List<RequisitionResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(RequisitionResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<RequisitionResponseModel>> getAllrequisitiionRecords() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
      'select * from tabCreche_requisition_response',
    );
    List<RequisitionResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(RequisitionResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<RequisitionResponseModel>> getRequisitonsForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_requisition_response where is_edited=1');
    List<RequisitionResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(RequisitionResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<RequisitionResponseModel>> getRequisitonsByGuid(
      String RGuid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_requisition_response where rguid=?', [RGuid]);
    List<RequisitionResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(RequisitionResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<RequisitionResponseModel>> getRequisitonsByName(int name) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_requisition_response where name=?', [name]);
    List<RequisitionResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(RequisitionResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<RequisitionResponseModel>> getRequisitonsByCreche(
      int creche_id) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_requisition_response where creche_id=?',
        [creche_id]);
    List<RequisitionResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(RequisitionResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<RequisitionResponseModel>> getRequestedStockbyCreche(
      int creche_id) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select tr.* from tabCreche_requisition_response tr where not exists (select 1 from tabCreche_stock_response ts where ts.month = tr.month and ts.year = tr.year) and tr.creche_id = ?',
        [creche_id]);
    List<RequisitionResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(RequisitionResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<RequisitionResponseModel>> getRequisitionByYearnMonth(
      int creche_id, int month, int year) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_requisition_response where creche_id =? and month=? and year=?',
        [creche_id, month, year]);
    List<RequisitionResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(RequisitionResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<RequisitionResponseModel>> getRequisitonsByMonth(
      int creche_id) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_requisition_response where creche_id =?',
        [creche_id]);
    List<RequisitionResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(RequisitionResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];
    var guid = hhData['rguid'];
    await DatabaseHelper.database!.rawQuery(
        'UPDATE tabCreche_requisition_response SET  name=?, is_uploaded=1 , is_edited=0 where  rguid = ?',
        [cename, guid]);
  }

  Future<void> RequisitionDataDownload(Map<String, dynamic> item) async {
    try {
      List<Map<String, dynamic>> growth =
          List<Map<String, dynamic>>.from(item['Data']);
      print(growth.length);

      // List to collect all RequisitionResponseModel items
      List<RequisitionResponseModel> itemsList = [];

      // Process each data and add to the items list
      for (var element in growth) {
        var growthData = element['Creche Requisition'];

        // Create RequisitionResponseModel instance
        var item = RequisitionResponseModel(
          rguid: growthData['rguid'],
          creche_id: Global.stringToInt(growthData['creche_id']),
          name: growthData['name'],
          is_uploaded: 1,
          is_edited: 0,
          is_deleted: 0,
          update_at: growthData['app_updated_on'],
          updated_by: growthData['app_updated_by'],
          created_at: growthData['appcreated_on'],
          created_by: growthData['appcreated_by'],
          item_id: Global.stringToInt(growthData['requistion_item'].toString()),
          responces: jsonEncode(Validate().keyesFromResponce(growthData)),
          month: Global.stringToInt(growthData['month'].toString()),
          year: Global.stringToInt(growthData['year'].toString()),
        );

        // Add the item to the list
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

      print("Data insertion successful!");
    } catch (e) {
      debugPrint("RequisitionDataDownload() : $e");
    }
  }

// Helper function to insert a batch of items
  Future<void> _insertBatch(List<RequisitionResponseModel> batchItems) async {
    await DatabaseHelper.database!.transaction((txn) async {
      var batch = txn.batch();

      for (var item in batchItems) {
        batch.insert(
          'tabCreche_requisition_response', // Change to your actual table name
          item.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Commit the batch insert
      await batch.commit(noResult: true);
    });
  }

  // Future<void> RequisitionDataDownload(Map<String, dynamic> item) async {
  //   List<Map<String, dynamic>> growth =
  //       List<Map<String, dynamic>>.from(item['Data']);
  //   print(growth);
  //   growth.forEach((element) async {
  //     var growthData = element['Creche Requisition'];

  //     var items = RequisitionResponseModel(
  //         rguid: growthData['rguid'],
  //         creche_id: Global.stringToInt(growthData['creche_id']),
  //         name: growthData['name'],
  //         is_uploaded: 1,
  //         is_edited: 0,
  //         is_deleted: 0,
  //         update_at: growthData['app_updated_on'],
  //         updated_by: growthData['app_updated_by'],
  //         created_at: growthData['appcreated_on'],
  //         created_by: growthData['appcreated_by'],
  //         item_id: Global.stringToInt(growthData['requistion_item'].toString()),
  //         responces: await jsonEncode(Validate().keyesFromResponce(growthData)),
  //         month: Global.stringToInt(growthData['month'].toString()),
  //         year: Global.stringToInt(growthData['year'].toString()));
  //     await inserts(items);
  //   });
  // }
}

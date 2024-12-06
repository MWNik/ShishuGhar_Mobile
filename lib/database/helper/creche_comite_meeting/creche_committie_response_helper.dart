import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../model/databasemodel/creche_committie_response_model.dart';
import '../../database_helper.dart';
import '../image_file_tab_responce_helper.dart';

class CrecheCommittieResponnseHelper {
  Future<void> inserts(CrecheCommittieResponseModel items) async {
    print(items.ccguid);
    await DatabaseHelper.database!.insert(
        'creche_committie_responce', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("object");
  }

  Future<List<CrecheCommittieResponseModel>> getCrecheCommittieResponcewithGuid(
      String ccGuid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from creche_committie_responce where ccguid=?', [ccGuid]);
    List<CrecheCommittieResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CrecheCommittieResponseModel.fromJson(itemMap));
    });

    return items;
  }

  // Future<List<CrecheCommittieResponseModel>>
  //     getChildlistingforFollowUp() async {
  //   List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
  //       'select * from creche_committie_responce where child_referral_guid is not null');
  //   List<CrecheCommittieResponseModel> items = [];

  //   result.forEach((itemMap) {
  //     items.add(CrecheCommittieResponseModel.fromJson(itemMap));
  //   });

  //   return items;
  // }

  Future<List<CrecheCommittieResponseModel>> childEventByChild(
      String? crecheIdName) async {
    var query =
        'Select * from  creche_committie_responce  where creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [crecheIdName]);

    List<CrecheCommittieResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(CrecheCommittieResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CrecheCommittieResponseModel>>
      getCrecheCommittieForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from creche_committie_responce where is_edited=1');
    List<CrecheCommittieResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CrecheCommittieResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];
    var ceGuid = hhData['ccguid'];
    // var chGuid = hhData['childenrolledguid'];

    // await DatabaseHelper.database!.rawQuery(
    //     'UPDATE child_grievances_responce SET name = ?  ,  is_uploaded=1 , is_edited=0 where grievance_guid=? and childenrolledguid=?',
    //     [cename, ceGuid, chGuid]);
    await DatabaseHelper.database!.rawQuery(
        'UPDATE creche_committie_responce SET name = ?  ,  is_uploaded=1 , is_edited=0 where ccguid=?',
        [cename, ceGuid]);

    var childImage = await ImageFileTabHelper()
        .getImageByDoctypeIdAndImbeNotNull(
            ceGuid, CustomText.creche_committee_meeting);
    if (childImage.length > 0) {
      childImage.forEach((element) async {
        if (Global.validToInt(element.name) == 0) {
          await DatabaseHelper.database!.rawQuery(
              'UPDATE tab_image_file SET name = ?  where doctype_guid=? and doctype=?',
              [
                Global.stringToInt(cename.toString()),
                element.doctype_guid,
                CustomText.creche_committee_meeting
              ]);
        }
      });
    }
  }

  Future<void> insertUpdate(String child_referral_guid, String enrolChildGuid,
      int? name, String responces, String userId) async {
    var item = CrecheCommittieResponseModel(
        ccguid: child_referral_guid,
        // childenrolledguid: enrolChildGuid,
        responces: responces,
        is_uploaded: 0,
        is_edited: 1,
        is_deleted: 0,
        name: name,
        created_by: userId,
        created_at: Validate().currentDateTime());
    await DatabaseHelper.database!.insert(
        'creche_committie_responce', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> crecheCommitteeMeetingDownloadData(
      Map<String, dynamic> item) async {
    try {
      List<Map<String, dynamic>> growth =
          List<Map<String, dynamic>>.from(item['Data']);

      // List to collect all CrecheCommittieResponseModel items
      List<CrecheCommittieResponseModel> itemsList = [];

      // Process each element and add to the items list
      for (var element in growth) {
        var growthData = element['Creche Committee Meeting'];

        var items = CrecheCommittieResponseModel(
          ccguid: growthData['ccguid'],
          name: growthData['name'],
          is_uploaded: 1,
          is_edited: 0,
          is_deleted: 0,
          creche_id: Global.stringToInt(growthData['creche_id'].toString()),
          update_at: growthData['modified'],
          updated_by: growthData['modified_by'],
          created_at: growthData['appcreated_on'],
          created_by: growthData['appcreated_by'],
          responces: jsonEncode(Validate().keyesFromResponce(growthData)),
        );

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
      debugPrint("crecheCommitteeMeetingDownloadData() : $e");
    }
  }

// Helper function to insert a batch of items
  Future<void> _insertBatch(
      List<CrecheCommittieResponseModel> batchItems) async {
    await DatabaseHelper.database!.transaction((txn) async {
      var batch = txn.batch();

      for (var item in batchItems) {
        batch.insert(
          'creche_committie_responce', // Change the table name to your actual table name
          item.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Commit the batch insert
      await batch.commit(noResult: true);
    });
  }

  // Future<void> crecheCommitteeMeetingDownloadData(
  //     Map<String, dynamic> item) async {
  //   List<Map<String, dynamic>> growth =
  //       List<Map<String, dynamic>>.from(item['Data']);
  //   print(growth);
  //   growth.forEach((element) async {
  //     var growthData = element['Creche Committee Meeting'];

  //     var items = CrecheCommittieResponseModel(
  //       ccguid: growthData['ccguid'],
  //       name: growthData['name'],
  //       is_uploaded: 1,
  //       is_edited: 0,
  //       is_deleted: 0,
  //       creche_id: Global.stringToInt(growthData['creche_id']),
  //       update_at: growthData['modified'],
  //       updated_by: growthData['modified_by'],
  //       created_at: growthData['appcreated_on'],
  //       created_by: growthData['appcreated_by'],
  //       responces: jsonEncode((Validate().keyesFromResponce(growthData))),
  //     );
  //     print("success");
  //     await inserts(items);
  //   });
  // }
}

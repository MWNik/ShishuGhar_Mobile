import 'dart:convert';

import 'package:shishughar/model/dynamic_screen_model/village_profile_response_model.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';

import '../../database_helper.dart';

class VillageProfileResponseHelper {
  Future<void> inserts(VillageProfileResponseModel items) async {
    await DatabaseHelper.database!.insert('tabVillage_response', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("object");
  }

  Future<List<VillageProfileResponseModel>> getVillageProfilebyName(
      int vName) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from tabVillage_response where name=?', [vName]);
    List<VillageProfileResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(VillageProfileResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<VillageProfileResponseModel>>
      getAllVillageProfilerecords() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
      'select * from tabVillage_response',
    );
    List<VillageProfileResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(VillageProfileResponseModel.fromJson(itemMap));
    });

    return items;
  }



  Future<List<VillageProfileResponseModel>> getVillageProfileforUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from tabVillage_response where is_edited=1');
    List<VillageProfileResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(VillageProfileResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];
    await DatabaseHelper.database!.rawQuery(
        'UPDATE tabVillage_response SET   is_uploaded=1 , is_edited=0 where name=?',
        [cename]);
  }


  Future<void> villageProfileDataDownload(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> growth =
        List<Map<String, dynamic>>.from(item['Data']);
    print(growth);
    growth.forEach((element) async {
      var growthData = element['Village'];

      var items = VillageProfileResponseModel(
        village_code: growthData['village_code'],
        village_name: growthData['village_name'],
        name: growthData['name'],
        is_uploaded: 1,
        is_edited: 0,
        is_deleted: 0,
        update_at: growthData['app_updated_on'],
        updated_by: growthData['app_updated_by'],
        created_at: growthData['appcreated_on'],
        created_by: growthData['appcreated_by'],
        responces: await jsonEncode(Validate().keyesFromResponce(growthData)),
      );
      await inserts(items);
    });
  }


}

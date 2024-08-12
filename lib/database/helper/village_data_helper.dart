

import 'package:shishughar/model/databasemodel/tabVillage_model.dart';

import '../database_helper.dart';

class VillageDataHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<TabVillage>> getTabVillageList() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('tabVillage',orderBy: 'value ASC');

    List<TabVillage> tabVillageList = [];

    for (var element in result) {
      TabVillage state = TabVillage.fromJson(element);
      tabVillageList.add(state);
    }
    return tabVillageList;
  }

  Future<List<TabVillage>> getVillageListByVillageId(List<int>villageId) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery('Select * from tabVillage where name in (${villageId.join(', ')}) order By value ASC');

    List<TabVillage> tabVillageList = [];

    for (var element in result) {
      TabVillage state = TabVillage.fromJson(element);
      tabVillageList.add(state);
    }
    return tabVillageList;
  }

  Future<void> insertMasterVillage(
      List<TabVillage> villageList) async {
    await DatabaseHelper.database!.delete('tabVillage');
    if (villageList.isNotEmpty) {
      for (var element in villageList) {
        await DatabaseHelper.database!.insert('tabVillage', element.toJson());
      }
    }
  }

}

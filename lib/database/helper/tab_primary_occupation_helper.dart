

import 'package:shishughar/model/databasemodel/tabVillage_model.dart';
import 'package:shishughar/model/databasemodel/tab_primary_occupation_model.dart';
import 'package:shishughar/model/databasemodel/tab_social_category_model.dart';

import '../database_helper.dart';

class TabPrimariOcuptionHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<TabVillage>> getTabVillageList(String lan) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('tabPrimaryOccupation');

    List<TabVillage> tabVillageList = [];

    for (var element in result) {
      TabVillage state = TabVillage.fromJson(element);
      tabVillageList.add(state);
    }
    return tabVillageList;
  }

  Future<void> inserts(
      List<TabPrimaryOccupationModel> items) async {
    await DatabaseHelper.database!.delete('tabPrimaryOccupation');
    if (items.isNotEmpty) {
      for (var element in items) {
        await DatabaseHelper.database!.insert('tabPrimaryOccupation', element.toJson());
      }
    }
  }

}

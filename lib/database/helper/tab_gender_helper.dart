

import 'package:shishughar/model/databasemodel/tabVillage_model.dart';
import 'package:shishughar/model/databasemodel/tab_gender_model.dart';
import '../database_helper.dart';

class TabGenderHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<TabVillage>> getTabVillageList(String lan) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('tabGender',orderBy: 'value ASC');

    List<TabVillage> tabVillageList = [];

    for (var element in result) {
      TabVillage state = TabVillage.fromJson(element);
      tabVillageList.add(state);
    }
    return tabVillageList;
  }

  Future<void> insertGender(
      List<TabGenderModel> items) async {
    await DatabaseHelper.database!.delete('tabGender');
    if (items.isNotEmpty) {
      for (var element in items) {
        await DatabaseHelper.database!.insert('tabGender', element.toJson());
      }
    }
  }

}

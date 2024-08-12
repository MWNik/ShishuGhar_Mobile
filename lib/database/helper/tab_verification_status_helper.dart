

import 'package:shishughar/model/databasemodel/tabVillage_model.dart';
import 'package:shishughar/model/databasemodel/tab_verification_status_model.dart';

import '../database_helper.dart';

class TabVerificationStatusHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<TabVillage>> getTabVillageList(String lan) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('tabVerificationStatus');

    List<TabVillage> tabVillageList = [];

    for (var element in result) {
      TabVillage state = TabVillage.fromJson(element);
      tabVillageList.add(state);
    }
    return tabVillageList;
  }

  Future<void> inserts(
      List<TabVerificationStatusModel> items) async {
    await DatabaseHelper.database!.delete('tabVerificationStatus');
    if (items.isNotEmpty) {
      for (var element in items) {
        await DatabaseHelper.database!.insert('tabVerificationStatus', element.toJson());
      }
    }
  }

}

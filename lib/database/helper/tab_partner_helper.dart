

import 'package:shishughar/model/databasemodel/tabVillage_model.dart';
import 'package:shishughar/model/databasemodel/tab_partner_model.dart';

import '../database_helper.dart';

class TabPartnerHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<TabVillage>> getTabVillageList(String lan) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('tabPartner');

    List<TabVillage> tabVillageList = [];

    for (var element in result) {
      TabVillage state = TabVillage.fromJson(element);
      tabVillageList.add(state);
    }
    return tabVillageList;
  }

  Future<void> inserts(
      List<TabPartnerModel> items) async {
    await DatabaseHelper.database!.delete('tabPartner');
    if (items.isNotEmpty) {
      for (var element in items) {
        await DatabaseHelper.database!.insert('tabPartner', element.toJson());
      }
    }
  }

}




import 'package:shishughar/model/databasemodel/tabGramPanchayat_model.dart';

import '../database_helper.dart';

class GramPanchayatDataHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<TabGramPanchayat>> getTabGramPanchayatList() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('tabGramPanchayat',orderBy: 'value ASC');

    List<TabGramPanchayat> tabGramPanchayatList = [];

    for (var element in result) {
      TabGramPanchayat gramPanchayat = TabGramPanchayat.fromJson(element);
      tabGramPanchayatList.add(gramPanchayat);
    }
    return tabGramPanchayatList;
  }

  Future<List<TabGramPanchayat>> getGramPanchayatListByPanchayatId(List<int>gpId) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery('Select * from tabGramPanchayat where name in(${gpId.join(', ')}) order By value ASC');

    List<TabGramPanchayat> tabGramPanchayatList = [];

    for (var element in result) {
      TabGramPanchayat gramPanchayat = TabGramPanchayat.fromJson(element);
      tabGramPanchayatList.add(gramPanchayat);
    }
    return tabGramPanchayatList;
  }

  Future<void> insertMasterGramPanchayat(
      List<TabGramPanchayat> gramPanchayatList) async {
    await DatabaseHelper.database!.delete('tabGramPanchayat');
    if (gramPanchayatList.isNotEmpty) {
      for (var element in gramPanchayatList) {
        await DatabaseHelper.database!.insert('tabGramPanchayat', element.toJson());
      }
    }
  }

}

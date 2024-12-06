import 'package:flutter/material.dart';
import 'package:shishughar/model/databasemodel/tabGramPanchayat_model.dart';

import '../database_helper.dart';

class GramPanchayatDataHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<TabGramPanchayat>> getTabGramPanchayatList() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .query('tabGramPanchayat', orderBy: 'value ASC');

    List<TabGramPanchayat> tabGramPanchayatList = [];

    for (var element in result) {
      TabGramPanchayat gramPanchayat = TabGramPanchayat.fromJson(element);
      tabGramPanchayatList.add(gramPanchayat);
    }
    return tabGramPanchayatList;
  }

  Future<List<TabGramPanchayat>> getGramPanchayatListByPanchayatId(
      List<int> gpId) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'Select * from tabGramPanchayat where name in(${gpId.join(', ')}) order By value ASC');

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
      try {
        await DatabaseHelper.database!.transaction((txn) async {
          var batch = txn.batch();
          for (var element in gramPanchayatList) {
            batch.insert('tabGramPanchayat', element.toJson());
          }
          await batch.commit(noResult: true);
        });
      } catch (e) {
        debugPrint("Error inserting master gp -> ${e.toString()}");
      }
      // for (var element in gramPanchayatList) {
      //   await DatabaseHelper.database!.insert('tabGramPanchayat', element.toJson());
      // }
    }
  }
}

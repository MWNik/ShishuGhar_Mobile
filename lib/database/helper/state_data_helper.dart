import 'package:flutter/material.dart';
import 'package:shishughar/model/databasemodel/tabstate_model.dart';

import '../database_helper.dart';

class StateDataHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<TabState>> getTabStateList() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('tabState',orderBy: 'value ASC');

    List<TabState> tabStateList = [];

    for (var element in result) {
      TabState state = TabState.fromJson(element);
      tabStateList.add(state);
    }
    return tabStateList;
  }

  Future<List<TabState>> getStateListByStateId(List<int>stateId) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery('SELECT * FROM tabState where name in (${stateId.join(', ')}) order By value ASC');

    List<TabState> tabStateList = [];

    for (var element in result) {
      TabState state = TabState.fromJson(element);
      tabStateList.add(state);
    }
    return tabStateList;
  }

  Future<void> insertMasterStates(
      List<TabState> stateList) async {
    databaseHelper.openDb();
    await DatabaseHelper.database!.delete('tabState');
    if (stateList.isNotEmpty) {
      try {
  await DatabaseHelper.database!.transaction((txn) async {
    for(var element in stateList) {
      await txn.insert('tabState', element.toJson());
    }
  });
} on Exception catch (e) {
  // TODO
  debugPrint("Error inserting state records -> $e");
}
      // for (var element in stateList) {
      //   await DatabaseHelper.database!.insert('tabState', element.toJson());
      // }
    }
  }

}

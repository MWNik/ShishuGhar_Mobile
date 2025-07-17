

import 'package:flutter/material.dart';
import '../../model/apimodel/supervisor_model.dart';
import '../database_helper.dart';

class MstSuperVisorHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<SupervisorModel>> getSuperVisors(String lan) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('mst_supervisor_item',orderBy: 'value ASC');

    List<SupervisorModel> supervisors = [];

    for (var element in result) {
      SupervisorModel state = SupervisorModel.fromJson(element);
      supervisors.add(state);
    }
    return supervisors;
  }

  Future<void> inserts(
      List<SupervisorModel> items) async {
    await DatabaseHelper.database!.delete('mst_supervisor_item');
    if (items.isNotEmpty) {
      try{
        await DatabaseHelper.database!.transaction((txn) async {
          var batch = txn.batch();
          for(var element in items) {
            batch.insert('mst_supervisor_item', element.toJson());
          }
          await batch.commit(noResult: true);
        });
      }catch(e){
        debugPrint("Error inserting mst_supervisor_item data -> ${e.toString()}");
      }
      // for (var element in items) {
      //   // element.name=0;
      //   await DatabaseHelper.database!.insert('mst_supervisor_item', element.toJson());
      // }
    }
  }

}

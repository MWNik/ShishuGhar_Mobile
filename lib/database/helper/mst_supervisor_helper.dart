

import 'package:shishughar/model/databasemodel/tabVillage_model.dart';
import 'package:shishughar/model/databasemodel/tab_gender_model.dart';
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
      for (var element in items) {
        // element.name=0;
        await DatabaseHelper.database!.insert('mst_supervisor_item', element.toJson());
      }
    }
  }

}

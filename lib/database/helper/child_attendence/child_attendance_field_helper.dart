import 'package:shishughar/database/database_helper.dart';

import '../../../model/apimodel/house_hold_field_item_model_api.dart';

class ChildAttendanceFieldHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<void> insertChildAttendanceField(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    databaseHelper.openDb();
    if (houseFieldItem.isNotEmpty) {
      await DatabaseHelper.database!.transaction((txn) async{
        for(var element in houseFieldItem){
          await txn.insert('tabChildAttendance', element.toJson());
        }
      });
      // for (var element in houseFieldItem) {
      //   await DatabaseHelper.database!
      //       .insert('tabChildAttendance', element.toJson());
      // }
    }
  }


  Future<List<HouseHoldFielItemdModel>> getChildAttendanceFileds() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery('select * from tabChildAttendance where  hidden=0 ORDER by idx asc');

    List<HouseHoldFielItemdModel> childAttendanceFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      childAttendanceFieldItem.add(state);
    }
    return childAttendanceFieldItem;
  }
}

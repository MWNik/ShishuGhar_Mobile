import 'package:shishughar/database/database_helper.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';

class ChildExitMetaFieldsHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<void> insertChildExitMeta(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    if (houseFieldItem.isNotEmpty) {
      await DatabaseHelper.database!.transaction((txn) async {
        for(var element in houseFieldItem){
          await txn.insert('tab_child_exit', element.toJson());
        }
      });
      // for (var element in houseFieldItem) {
      //   await DatabaseHelper.database!
      //       .insert('tab_child_exit', element.toJson());
      // }
    }
  }

  Future<List<HouseHoldFielItemdModel>> getChildExitMetaFields() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_child_exit where  hidden=0 ORDER by idx asc');

    List<HouseHoldFielItemdModel> childExitFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      childExitFieldItem.add(state);
    }
    return childExitFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> getChildExitMetaFieldsbyScreenType(
      String screen_type) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_child_exit where  parent=? and  fieldname !=? and fieldname!= ? and hidden=0 ORDER by idx asc',
        [screen_type,'creche_name','age_at_enrollment_in_months']);

    List<HouseHoldFielItemdModel> childExitFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      childExitFieldItem.add(state);
    }
    return childExitFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> getChildExitMetaFieldsbyScreenTypeForView(
      String screen_type) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_child_exit where  parent=? and hidden=0 ORDER by idx asc',
        [screen_type]);

    List<HouseHoldFielItemdModel> childExitFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      childExitFieldItem.add(state);
    }
    return childExitFieldItem;
  }
}

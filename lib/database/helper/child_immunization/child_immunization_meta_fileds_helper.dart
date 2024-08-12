import 'package:shishughar/database/database_helper.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';

class ChildImmunizationMetaFieldsHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<void> insertChildImmunizationMeta(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    databaseHelper.openDb();
    if (houseFieldItem.isNotEmpty) {
      for (var element in houseFieldItem) {
        await DatabaseHelper.database!
            .insert('tab_child_immunization', element.toJson());
      }
    }
  }

  Future<List<HouseHoldFielItemdModel>> getChildImmunizationMetaFields() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_child_immunization where  hidden=0 ORDER by idx asc');

    List<HouseHoldFielItemdModel> childAttendanceFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      childAttendanceFieldItem.add(state);
    }
    return childAttendanceFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>>
      getChildImmunizationMetaFieldsbyScreenType(String screen_type) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_child_immunization where   hidden=0 and fieldname != ? ORDER by idx asc',['vaccine_id']);

    List<HouseHoldFielItemdModel> childAttendanceFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      childAttendanceFieldItem.add(state);
    }
    return childAttendanceFieldItem;
  }



}

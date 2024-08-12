import 'package:shishughar/database/database_helper.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';

class ChildHealthMetaFieldsHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<void> insertChildHealthMeta(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    databaseHelper.openDb();
    if (houseFieldItem.isNotEmpty) {
      for (var element in houseFieldItem) {
        await DatabaseHelper.database!
            .insert('tab_child_health', element.toJson());
      }
    }
  }

  Future<List<HouseHoldFielItemdModel>> getChildEventMetaFields() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_child_health where  hidden=0 ORDER by idx asc');

    List<HouseHoldFielItemdModel> childAttendanceFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      childAttendanceFieldItem.add(state);
    }
    return childAttendanceFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> getChildEventMetaFieldsbyScreenType(
      String screen_type) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_child_health where  parent=? and hidden=0 ORDER by idx asc',
        [screen_type]);

    List<HouseHoldFielItemdModel> childAttendanceFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      childAttendanceFieldItem.add(state);
    }
    return childAttendanceFieldItem;
  }
}

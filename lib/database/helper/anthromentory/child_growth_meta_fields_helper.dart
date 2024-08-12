import 'package:shishughar/database/database_helper.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';

class ChildGrowthMetaFieldsHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<void> insertChildGrowthMeta(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    databaseHelper.openDb();
    if (houseFieldItem.isNotEmpty) {
      for (var element in houseFieldItem) {
        await DatabaseHelper.database!
            .insert('tabChildGrowthMeta', element.toJson());
      }
    }
  }

  Future<List<HouseHoldFielItemdModel>> getChildGrowthMetaFields() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabChildGrowthMeta where  hidden=0 ORDER by idx asc');

    List<HouseHoldFielItemdModel> childAttendanceFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      childAttendanceFieldItem.add(state);
    }
    return childAttendanceFieldItem;
  }
}

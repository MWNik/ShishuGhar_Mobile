import 'package:shishughar/database/database_helper.dart';
import '../../../../model/apimodel/house_hold_field_item_model_api.dart';

class ChildFollowUpFieldsHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<void> insertChildFollowUpMeta(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    if (houseFieldItem.isNotEmpty) {
      for (var element in houseFieldItem) {
        await DatabaseHelper.database!
            .insert('tab_child_followup', element.toJson());
      }
    }
  }

  Future<List<HouseHoldFielItemdModel>> getChildFollowUpMetaFields() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_child_followup where  hidden=0 ORDER by idx asc');

    List<HouseHoldFielItemdModel> childFollowUpFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      childFollowUpFieldItem.add(state);
    }
    return childFollowUpFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> getChildFollowUpMetaFieldsbyScreenType(
      String screen_type) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_child_followup where  parent=? and fieldname != ? and hidden=0 ORDER by idx asc',
        [screen_type, 'status']);

    List<HouseHoldFielItemdModel> childFollowUpFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      childFollowUpFieldItem.add(state);
    }
    return childFollowUpFieldItem;
  }
}

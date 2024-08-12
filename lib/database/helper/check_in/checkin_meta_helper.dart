import 'package:shishughar/database/database_helper.dart';
import '../../../../model/apimodel/house_hold_field_item_model_api.dart';

class CheckInMetaHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<void> insertCheckin(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    if (houseFieldItem.isNotEmpty) {
      for (var element in houseFieldItem) {
        await DatabaseHelper.database!
            .insert('tab_checkin_meta', element.toJson());
      }
    }
  }

  Future<List<HouseHoldFielItemdModel>> getCheckinFields() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_checkin_meta where  hidden=0 ORDER by idx asc');

    List<HouseHoldFielItemdModel> CrecheCommitteFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      CrecheCommitteFieldItem.add(state);
    }
    return CrecheCommitteFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> callMultiSelectTabItem() async {
    String query =
        'select * from tab_checkin_meta where parent in (select options from tab_checkin_meta where fieldtype =?)';
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, ['Table MultiSelect']);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }


  Future<List<HouseHoldFielItemdModel>> getCheckinbyParent(
      String screen_type) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_checkin_meta where  parent=? and hidden=0 ORDER by idx asc',
        [screen_type]);

    List<HouseHoldFielItemdModel> CrecheCommitteFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      CrecheCommitteFieldItem.add(state);
    }
    return CrecheCommitteFieldItem;
  }
}



import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../database_helper.dart';

class EnrolledExitChildrenFieldHelper {


  Future<List<HouseHoldFielItemdModel>> callEnrolledExitMeta() async {
    String query =
        'select * from tab_enrolled_exit_meta WHERE idx BETWEEN (select idx from tab_enrolled_exit_meta where fieldname=?) AND (select idx from tab_enrolled_exit_meta where fieldname=?) and hidden=0 ORDER by idx asc';
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, ['child_enrollment_tab','child_exit_section']);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> callExitEnrolled() async {
    String query =
        'select * from tab_enrolled_exit_meta WHERE  hidden=0 ORDER by idx asc';
    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> callMultiSelectTabItem() async {
    String query =
        'select * from tab_enrolled_exit_meta where parent in (select options from tab_enrolled_exit_meta where fieldtype =?)';
    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query, ['Table MultiSelect']);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<void> insertsEnrolledExitField(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    if (houseFieldItem.isNotEmpty) {
      for (var element in houseFieldItem) {
        await DatabaseHelper.database!
            .insert('tab_enrolled_exit_meta', element.toJson());
      }
    }
  }

}

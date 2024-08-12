import 'package:shishughar/database/database_helper.dart';
import '../../../../model/apimodel/house_hold_field_item_model_api.dart';

class CrecheMoniteringCheckListCCFieldsHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<void> insertcmcCCMeta(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    if (houseFieldItem.isNotEmpty) {
      for (var element in houseFieldItem) {
        await DatabaseHelper.database!
            .insert('tabCreche_Monitering_CheckList_CC', element.toJson());
      }
    }
  }

  Future<List<HouseHoldFielItemdModel>> getcmcCCMetaFields() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_CheckList_CC where  hidden=0 ORDER by idx asc');

    List<HouseHoldFielItemdModel> CrecheCommitteFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      CrecheCommitteFieldItem.add(state);
    }
    return CrecheCommitteFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> callMultiSelectTabItem() async {
    String query =
        'select * from tabCreche_Monitering_CheckList_CC where parent in (select options from tabCreche_Monitering_CheckList_CC where fieldtype =?)';
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, ['Table MultiSelect']);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> getcmcCCMetaFieldsbyScreenType(
      String screen_type) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_CheckList_CC where  parent=? and fieldname != ? and hidden=0 ORDER by idx asc',
        [screen_type, 'status']);

    List<HouseHoldFielItemdModel> CrecheCommitteFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      CrecheCommitteFieldItem.add(state);
    }
    return CrecheCommitteFieldItem;
  }
}

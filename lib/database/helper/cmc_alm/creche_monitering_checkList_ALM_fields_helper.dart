import 'package:shishughar/database/database_helper.dart';
import '../../../../model/apimodel/house_hold_field_item_model_api.dart';

class CrecheMoniteringCheckListALMFieldsHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<void> insertcmcALMMeta(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    if (houseFieldItem.isNotEmpty) {
      await DatabaseHelper.database!.transaction((txn) async{
        for(var element in houseFieldItem) {
          await txn.insert('tabCreche_Monitering_CheckList_ALM', element.toJson());
        }
      });
      // for (var element in houseFieldItem) {
      //   await DatabaseHelper.database!
      //       .insert('tabCreche_Monitering_CheckList_ALM', element.toJson());
      // }
    }
  }

  Future<List<HouseHoldFielItemdModel>> getcmcALMMetaFields() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_CheckList_ALM where  hidden=0 ORDER by idx asc');

    List<HouseHoldFielItemdModel> CrecheCommitteFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      CrecheCommitteFieldItem.add(state);
    }
    return CrecheCommitteFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> callMultiSelectTabItem() async {
    String query =
        'select * from tabCreche_Monitering_CheckList_ALM where parent in (select options from tabCreche_Monitering_CheckList_ALM where fieldtype =?)';
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, ['Table MultiSelect']);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> getcmcALMMetaFieldsbyScreenType(
      String screen_type) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_Monitering_CheckList_ALM where  parent=? and fieldname != ? and hidden=0 ORDER by idx asc',
        [screen_type, 'status']);

    List<HouseHoldFielItemdModel> CrecheCommitteFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      CrecheCommitteFieldItem.add(state);
    }
    return CrecheCommitteFieldItem;
  }
}

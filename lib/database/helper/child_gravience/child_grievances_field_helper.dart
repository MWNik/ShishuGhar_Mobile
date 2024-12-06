import 'package:shishughar/database/database_helper.dart';
import '../../../../model/apimodel/house_hold_field_item_model_api.dart';

class ChildGrievancesMetaFieldsHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<void> insertChildGrievancesMeta(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    if (houseFieldItem.isNotEmpty) {
      await DatabaseHelper.database!.transaction((txn) async{
        for(var element in houseFieldItem){
          await txn.insert('tab_child_grievances', element.toJson());
        }
      });
      // for (var element in houseFieldItem) {
      //   await DatabaseHelper.database!
      //       .insert('tab_child_grievances', element.toJson());
      // }
    }
  }

  Future<List<HouseHoldFielItemdModel>> getChildGrievancesMetaFields() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_child_grievances where  hidden=0 ORDER by idx asc');

    List<HouseHoldFielItemdModel> childGrievancesFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      childGrievancesFieldItem.add(state);
    }
    return childGrievancesFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>>
      getChildGrievancesMetaFieldsbyScreenType(String screen_type) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_child_grievances where  parent=? and fieldname != ? and hidden=0 ORDER by idx asc',
        [screen_type,'status']);

    List<HouseHoldFielItemdModel> childGrievancesFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      childGrievancesFieldItem.add(state);
    }
    return childGrievancesFieldItem;
  }
}

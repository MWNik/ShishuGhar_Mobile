
import '../../model/apimodel/house_hold_field_item_model_api.dart';
import '../database_helper.dart';

class CrecheFieldHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<HouseHoldFielItemdModel>> getCrecheFieldList(String lan) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('tabCrechefield');

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> getCrecheFieldsForm(String parents) async {
    String query= 'select * from tabCrechefield where parent=? and hidden=0 ORDER by idx asc';
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(query,[parents]);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<void> insertCrecheField(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    if (houseFieldItem.isNotEmpty) {
      await DatabaseHelper.database!.transaction((txn) async{
        for(var element in houseFieldItem){
          await txn.insert('tabCrechefield', element.toJson());
        }
      });
      // for (var element in houseFieldItem) {
      //   // if(element.fieldtype.contains(other))
      //   await DatabaseHelper.database!.insert('tabCrechefield', element.toJson());
      // }
    }
  }

  Future<List<HouseHoldFielItemdModel>> getCrecheHiddenField(
      String parents) async {
    String query =
        'select * from tabCrechefield where parent=? and hidden=1 ORDER by idx asc';
    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query, [parents]);

    List<HouseHoldFielItemdModel> crecheFielItems = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      crecheFielItems.add(state);
    }
    return crecheFielItems;
  }

}

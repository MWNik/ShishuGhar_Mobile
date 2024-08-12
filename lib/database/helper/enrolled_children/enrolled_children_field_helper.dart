

import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../database_helper.dart';

class EnrolledChildrenFieldHelper {

  Future<List<HouseHoldFielItemdModel>> getHouseHoldFieldList(
      String lan) async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.query('tabchildprofilefield');

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> getChildHHFieldsForm(
      String parents) async {
    String query =
        'select * from tabchildprofilefield where parent=? and hidden=0  and idx>= (Select idx from tabchildprofilefield where fieldname=?)ORDER by idx asc';
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [parents,'child_details_tab']);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> callMultiSelectTabItem() async {
    String query =
        'select * from tabchildprofilefield where parent in (select options from tabchildprofilefield where fieldtype =?)';
    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query, ['Table MultiSelect']);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<void> insertsChildrenEnrolledField(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    if (houseFieldItem.isNotEmpty) {
      for (var element in houseFieldItem) {
        await DatabaseHelper.database!
            .insert('tabchildprofilefield', element.toJson());
      }
    }
  }

  Future<List<HouseHoldFielItemdModel>> getChildDetailFieldsForm() async {
    String query =
        'SELECT * FROM tabchildprofilefield WHERE parent= ? and idx BETWEEN 7 AND 14';
    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query,['Child Profile']);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }
}

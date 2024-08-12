import 'package:shishughar/database/database_helper.dart';
import '../../../../model/apimodel/house_hold_field_item_model_api.dart';

class CashbookExpencesMetaFieldsHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<void> insertCashBookMeta(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    if (houseFieldItem.isNotEmpty) {
      for (var element in houseFieldItem) {
        await DatabaseHelper.database!
            .insert('tab_cashbook_expences_fields', element.toJson());
      }
    }
  }

  Future<void> insertCashBookReceipt(
      List<HouseHoldFielItemdModel> receiptItem) async {
    if (receiptItem.isNotEmpty) {
      for (var element in receiptItem) {
        await DatabaseHelper.database!
            .insert('tab_cashbook_receipts_fields', element.toJson());
      }
    }
  }

  Future<List<HouseHoldFielItemdModel>> getCashbookMetaFields() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_cashbook_expences_fields where  hidden=0 ORDER by idx asc');

    List<HouseHoldFielItemdModel> CrecheCommitteFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      CrecheCommitteFieldItem.add(state);
    }
    return CrecheCommitteFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> callMultiSelectTabItem() async {
    String query =
        'select * from tab_cashbook_expences_fields where parent in (select options from tab_cashbook_expences_fields where fieldtype =?)';
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, ['Table MultiSelect']);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> getCashbookMetaFieldsbyScreenType(
      String screen_type) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_cashbook_expences_fields where  parent=? and hidden=0 ORDER by idx asc',
        [screen_type]);

    List<HouseHoldFielItemdModel> CrecheCommitteFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      CrecheCommitteFieldItem.add(state);
    }
    return CrecheCommitteFieldItem;
  }
}

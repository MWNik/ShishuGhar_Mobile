import 'package:shishughar/database/database_helper.dart';
import '../../../../model/apimodel/house_hold_field_item_model_api.dart';

class CashbookRceiptMetaFieldsHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

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
        'select * from tab_cashbook_receipts_fields where  hidden=0 ORDER by idx asc');

    List<HouseHoldFielItemdModel> CrecheCommitteFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      CrecheCommitteFieldItem.add(state);
    }
    return CrecheCommitteFieldItem;
  }


  Future<List<HouseHoldFielItemdModel>> getCashbookMetaFieldsbyScreenType(
      String screen_type) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_cashbook_receipts_fields where  parent=? and hidden=0 ORDER by idx asc',
        [screen_type]);

    List<HouseHoldFielItemdModel> CrecheCommitteFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      CrecheCommitteFieldItem.add(state);
    }
    return CrecheCommitteFieldItem;
  }
}

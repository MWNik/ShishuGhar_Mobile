import 'package:shishughar/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../model/dynamic_screen_model/user_manual_responses_model.dart';

class UserManualFieldsHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<void> insertUserManualMeta(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    databaseHelper.openDb();
    if (houseFieldItem.isNotEmpty) {
      for (var element in houseFieldItem) {
        await DatabaseHelper.database!
            .insert('tabUserManualFields', element.toJson());
      }
    }
  }

  Future<List<UserManualResponsesModel>> getResponsebylang(String lang) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_user_manual_responses where  language=?', [lang]);
    List<UserManualResponsesModel> userMaualData = [];
    for (var element in result) {
      UserManualResponsesModel state =
          UserManualResponsesModel.fromJson(element);
      userMaualData.add(state);
    }
    return userMaualData;
  }

  Future<void> inserts(List<UserManualResponsesModel> items) async {
    await DatabaseHelper.database!.delete('tab_user_manual_responses');

    if (items.isNotEmpty) {
      for (UserManualResponsesModel element in items) {
        await DatabaseHelper.database!.insert(
            'tab_user_manual_responses', element.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }

    print("object");
  }

  Future<void> userManualDownloadData(Map<String, dynamic> item) async {
    try {
      List<dynamic> data = item['Data'];
      List<UserManualResponsesModel> manuals = [];
      for (var element in data) {
        if (element is List &&
            element.isNotEmpty &&
            element[0] is Map<String, dynamic>) {
          UserManualResponsesModel items =
              UserManualResponsesModel.fromJson(element[0]);
          manuals.add(items);
        }
      }
      await inserts(
          manuals); // Assuming inserts is an async method to save data
    } catch (e) {
      print('Error parsing data: $e');
    }
  }
}

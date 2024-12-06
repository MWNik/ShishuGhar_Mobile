import 'package:flutter/foundation.dart';
import 'package:shishughar/model/databasemodel/tabstate_model.dart';

import '../../model/apimodel/house_hold_field_item_model_api.dart';
import '../database_helper.dart';

class HouseHoldFieldHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<HouseHoldFielItemdModel>> getHouseHoldFieldList(
      String lan) async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.query('tabhouseholdfield');

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> getHouseHoldFieldsForm(
      String parents) async {
    String query =
        'select * from tabhouseholdfield where parent=?  and fieldname != ? and fieldname != ? and hidden=0 ORDER by idx asc';
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery(query, [parents, 'verification_status', 'hhid']);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> getHouseHoldFieldsFormTab(
      String parents, String breakPoinnt) async {
    String query =
        'select * from  tabhouseholdfield where fieldtype=? and hidden=0  and parent=? ORDER by idx asc';
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [breakPoinnt, parents]);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<void> insertHouseHoldField(
      List<HouseHoldFielItemdModel> houseFieldItem) async {
    databaseHelper.openDb();
    if (houseFieldItem.isNotEmpty) {
      await DatabaseHelper.database!.transaction(
        (txn) async {
          try {
            for (var element in houseFieldItem) {
              await txn.insert('tabhouseholdfield', element.toJson());
            }
          } catch (e) {
            debugPrint("Error inserting field Data: $e");
          }
        },
      );
      // for (var element in houseFieldItem) {
      //   // if(element.fieldtype.contains(other))
      //   await DatabaseHelper.database!
      //       .insert('tabhouseholdfield', element.toJson());
      // }
    }
  }

  Future<List<HouseHoldFielItemdModel>> getHouseHoldFieldsHiddenField(
      String parents) async {
    String query =
        'select * from tabhouseholdfield where parent=? and hidden=1 ORDER by idx asc';
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [parents]);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> callHHScreenLogic(
      List<String> fieldnames) async {
    String questionMarks = List.filled(fieldnames.length, '?').join(',');
    List<dynamic> parameters = [...fieldnames];
    String query =
        'SELECT * FROM tabhouseholdfield WHERE   fieldname in ($questionMarks) and ((depends_on IS NOT NULL AND LENGTH(depends_on) > 0) OR (mandatory_depends_on IS NOT NULL AND LENGTH(mandatory_depends_on) > 0)OR(read_only_depends_on IS NOT NULL AND LENGTH(read_only_depends_on) > 0))';
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, parameters);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<List<HouseHoldFielItemdModel>> callTabItem(String fieldnames) async {
    String query = 'select * from tabhouseholdfield where fieldname=?';
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [fieldnames]);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }
}

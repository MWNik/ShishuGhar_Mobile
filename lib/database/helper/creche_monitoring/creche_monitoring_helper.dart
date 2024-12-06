import 'package:flutter/material.dart';
import 'package:shishughar/database/database_helper.dart';
import '../../../model/apimodel/house_hold_field_item_model_api.dart';

// TableName
const _table = 'tabCrecheMonitorMeta';

typedef ListOfMap = List<Map<String, dynamic>>;

class CrecheMonitoringFieldHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  /// Insert Monitor Fields
  Future<void> insertCrecheMonitorFields(
      List<HouseHoldFielItemdModel> items) async {
    try {
      if (items.isEmpty) return;

      await DatabaseHelper.database!.transaction((txn) async {
        for (var element in items) {
          await txn.insert(_table, element.toJson());
        }
      });

      // for (final item in items) {
      //   await DatabaseHelper.database!.insert(_table, item.toJson());
      // }
    } catch (e) {
      debugPrint("insertCrecheMonitorFields() : $e");
    }
  }

  /// Fetch Meta Fields
  Future<List<HouseHoldFielItemdModel>> getCrecheMonitorMetaFields() async {
    try {
      final ListOfMap queryResult = await DatabaseHelper.database!
          .rawQuery('SELECT * FROM $_table WHERE hidden = 0 ORDER BY idx ASC');

      return queryResult
          .map((e) => HouseHoldFielItemdModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("getCrecheMonitorMetaFields() : $e");
      return [];
    }
  }

  /// Fetch Meta Fields by Parent
  Future<List<HouseHoldFielItemdModel>> getCrecheMonitorMetaFieldsByParent(
      String parent) async {
    try {
      final ListOfMap queryResult = await DatabaseHelper.database!.rawQuery(
          'SELECT * FROM $_table WHERE parent = ? and hidden=0 ORDER BY idx asc',
          [parent]);

      return queryResult
          .map((e) => HouseHoldFielItemdModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint("getCrecheMonitorMetaFieldsBy() : $e");
      return [];
    }
  }
}

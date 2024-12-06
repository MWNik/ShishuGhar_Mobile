import 'package:flutter/material.dart';
import 'package:shishughar/model/databasemodel/tabBlock_model.dart';

import '../database_helper.dart';

class BlockDataHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<TabBlock>> getTabBlockList() async {
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.query('tabBlock', orderBy: 'value ASC');

    List<TabBlock> tabBlockList = [];

    for (var element in result) {
      TabBlock state = TabBlock.fromJson(element);
      tabBlockList.add(state);
    }
    return tabBlockList;
  }

  Future<List<TabBlock>> getBlockListByBlockId(List<int> blockId) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'Select * from tabBlock where name in (${blockId.join(', ')}) order By value ASC');

    List<TabBlock> tabBlockList = [];

    for (var element in result) {
      TabBlock state = TabBlock.fromJson(element);
      tabBlockList.add(state);
    }
    return tabBlockList;
  }

  Future<void> insertMasterBlock(List<TabBlock> blockList) async {
    await DatabaseHelper.database!.delete('tabBlock');
    if (blockList.isNotEmpty) {
      try {
        await DatabaseHelper.database!.transaction((txn) async {
          for (var element in blockList) {
            await txn.insert('tabBlock', element.toJson());
          }
        });
      } catch (e) {
        debugPrint("Error inserting master block ${e.toString()}");
      }
      // for (var element in blockList) {
      //   await DatabaseHelper.database!.insert('tabBlock', element.toJson());
      // }
    }
  }
}

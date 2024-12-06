import 'package:flutter/material.dart';
import 'package:shishughar/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/apimodel/master_stock_model.dart';

class MasterStockHelper {
  DatabaseHelper database = DatabaseHelper();


  Future insert(List<MasterStockModel> masterStockmodel) async {
    await DatabaseHelper.database!.delete('tabMaster_Stock');
    if (masterStockmodel.isNotEmpty) {
      try{
        await DatabaseHelper.database!.transaction((txn) async{
          var batch = txn.batch();
          for (var item in masterStockmodel) {
            batch.insert('tabMaster_Stock', item.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);
          }
          await batch.commit(noResult: true);
        });
      }catch(e){
        debugPrint("Error inserting tabMaster_Stock data -> ${e.toString()}");
      }
      // for (var element in masterStockmodel) {
      //   await DatabaseHelper.database!.insert('tabMaster_Stock', element.toJson(),
      //       conflictAlgorithm: ConflictAlgorithm.replace);
      // }
    }
  }
}
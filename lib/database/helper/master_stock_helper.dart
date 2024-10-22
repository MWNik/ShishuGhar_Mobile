import 'package:shishughar/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/apimodel/master_stock_model.dart';

class MasterStockHelper {
  DatabaseHelper database = DatabaseHelper();


  Future insert(List<MasterStockModel> masterStockmodel) async {
    await DatabaseHelper.database!.delete('tabMaster_Stock');
    if (masterStockmodel.isNotEmpty) {
      for (var element in masterStockmodel) {
        await DatabaseHelper.database!.insert('tabMaster_Stock', element.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }
}
import 'package:shishughar/model/databasemodel/mst_cammon_model.dart';
import 'package:sqflite/sqflite.dart';


import '../database_helper.dart';

class MstCommonHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<void> insert(MstCommonOtherModel items) async {
    await DatabaseHelper.database!.insert(
        'mstCommon', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MstCommonOtherModel>> getMstCommonList(String lan) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('mstCommon');

    List<MstCommonOtherModel> mstCommonList = [];

    for (var element in result) {
      MstCommonOtherModel mstCommon = MstCommonOtherModel.fromJson(element);
      mstCommonList.add(mstCommon);
    }
    return mstCommonList;
  }

  Future<void> insertMstCommonData(List<MstCommonOtherModel> mstCommonList) async {
    databaseHelper.openDb();
    await DatabaseHelper.database!.delete('mstCommon');
    if (mstCommonList.isNotEmpty) {
      for (var element in mstCommonList) {
        await DatabaseHelper.database!.insert('mstCommon', element.toJson());
      }
    }
  }

  Future<List<MstCommonOtherModel>> getCommonDataByFlag(String tableName) async {
    var tabName = 'tab$tableName'.replaceAll(" ", "");

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.query(tabName,orderBy: 'value ASC');

    List<MstCommonOtherModel> optionsModel = [];

    for (var element in result) {
      print(element);
      var item = new MstCommonOtherModel(
          name: element['name'],
          flag: 'tab$tableName',
          value: element['value'].toString());
      optionsModel.add(item);
      print("it ${item.name}");
    }

    return optionsModel;
  }
}

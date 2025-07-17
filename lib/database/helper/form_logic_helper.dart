
import '../../model/apimodel/form_logic_api_model.dart';
import '../database_helper.dart';



class FormLogicDataHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<TabFormsLogic>> getformLogicList() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('tabformsLogic');

    List<TabFormsLogic> formLogicList = [];

    for (var element in result) {
      TabFormsLogic formLogic = TabFormsLogic.fromJson(element);
      formLogicList.add(formLogic);
    }
    return formLogicList;
  }

  Future<void> insertFormLogic(
      List<TabFormsLogic> formLogicList) async {
    await DatabaseHelper.database!.delete('tabformsLogic');
    if (formLogicList.isNotEmpty) {
      await DatabaseHelper.database!.transaction((txn) async{
        var batch = txn.batch();

        for (var element in formLogicList) {
          batch.insert('tabformsLogic', element.toJson());
        }
        await batch.commit(noResult: true);
      });
      // for (var element in formLogicList) {
      //   await DatabaseHelper.database!
      //       .insert('tabformsLogic', element.toJson());
      // }
    }
  }

  Future<List<TabFormsLogic>> callFormLogic(String doc) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabformsLogic where doc=?', [doc]);

    List<TabFormsLogic> formLogicList = [];

    for (var element in result) {
      TabFormsLogic formLogic = TabFormsLogic.fromJson(element);
      formLogicList.add(formLogic);
    }
    return formLogicList;
  }
}

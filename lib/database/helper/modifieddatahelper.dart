import 'package:shishughar/database/database_helper.dart';
import 'package:shishughar/model/apimodel/modifiedDate_apiModel.dart';

class ModifiedDataHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<List<DocType>> getModifiedData() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query(
      'modified_data',
    );

    List<DocType> DocTypeList = [];

    for (var element in result) {
      DocType modifieddata = DocType.fromJson(element);
      DocTypeList.add(modifieddata);

    }
    return DocTypeList;
  }

  Future<void> insertModifiedData(List<DocType> docTypeList) async {
    await DatabaseHelper.database!.delete('modified_data');
    if (docTypeList.isNotEmpty) {
      for (var element in docTypeList) {
        await DatabaseHelper.database!
            .insert('modified_data', element.toJson());
      }
    }
  }
}

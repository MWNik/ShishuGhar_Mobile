



import '../../model/apimodel/mapping_login_model.dart';
import '../database_helper.dart';

class MappingLoginDataHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<Mapping>> getMappingDataList(String lan) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('mapping');

    List<Mapping> mappingList = [];

    for (var element in result) {
      Mapping mapping = Mapping.fromJson(element);
      mappingList.add(mapping);
    }
    return mappingList;
  }

  Future<void> insertMappingLoginData(
      List<Mapping> mappingList) async {
    databaseHelper.openDb();
    await DatabaseHelper.database!.delete('mapping');
    if (mappingList.isNotEmpty) {
      for (var element in mappingList) {
        await DatabaseHelper.database!.insert('mapping', element.toJson());
      }
    }
  }

}

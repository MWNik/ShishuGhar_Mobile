
import 'package:shishughar/model/databasemodel/auth_model.dart';
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';



class AuthLoginDataHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<AuthModel>> getAuthDataList() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('tabUser');

    List<AuthModel> authList = [];

    for (var element in result) {
      AuthModel auth = AuthModel.fromJson(element);
      authList.add(auth);
    }
    return authList;
  }

  // Future<void> insertAuthLoginData(
  //     List<Auth> authList) async {
  //   databaseHelper.openDb();
  //   await DatabaseHelper.database!.delete('tabUser');
  //   if (authList.isNotEmpty) {
  //     for (var element in authList) {
  //       await DatabaseHelper.database!.insert('tabUser', element.toJson());
  //     }
  //   }
  // }

  Future insert(AuthModel userModel) async {
    await databaseHelper.openDb();
    await DatabaseHelper.database!.delete('tabUser');
    return await DatabaseHelper.database!.insert(
        'tabUser', userModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

}

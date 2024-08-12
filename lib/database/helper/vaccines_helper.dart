
import 'package:shishughar/model/databasemodel/auth_model.dart';
import 'package:shishughar/model/databasemodel/vaccines_model.dart';
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';



class VaccinesDataHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<VaccineModel>> callAllVaccines() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('tabVaccines');

    List<VaccineModel> vaccines = [];

    for (var element in result) {
      VaccineModel auth = VaccineModel.fromJson(element);
      vaccines.add(auth);
    }
    return vaccines;
  }


  Future insert(List<VaccineModel> vaccineModels) async {
    await DatabaseHelper.database!.delete('tabVaccines');
    if (vaccineModels.isNotEmpty) {
      for (var element in vaccineModels) {
        await DatabaseHelper.database!.insert('tabVaccines', element.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }


  Future<List<VaccineModel>> callVaccinesByDays(int days) async {
    String sql = "select * from tabVaccines WHERE days<=? ORDER by days asc";
    List<Map<String, dynamic>> result=
    await DatabaseHelper.database!.rawQuery(sql,[days]);

    List<VaccineModel> vaccines = [];

    for (var element in result) {
      VaccineModel vaccine = VaccineModel.fromJson(element);
      vaccines.add(vaccine);
    }
    return vaccines;
  }

  Future<List<VaccineModel>> callVaccinesByDaysUpcommin(int days) async {
    String sql = "select * from tabVaccines WHERE days >? ORDER by days asc";
    List<Map<String, dynamic>> result=
    await DatabaseHelper.database!.rawQuery(sql,[days]);

    List<VaccineModel> vaccines = [];

    for (var element in result) {
      VaccineModel vaccine = VaccineModel.fromJson(element);
      vaccines.add(vaccine);
    }
    return vaccines;
  }


  Future<List<VaccineModel>> callImmunizationExpendTitle(int childAgeInDays) async {
    List<Map<String, dynamic>> result = await
    DatabaseHelper.database!.rawQuery(
        'SELECT * FROM tabVaccines where days<? GROUP BY categories ORDER by days asc',[childAgeInDays]);

    List<VaccineModel> childAttendanceFieldItem = [];

    for (var element in result) {
      VaccineModel state = VaccineModel.fromJson(element);
      childAttendanceFieldItem.add(state);
    }
    return childAttendanceFieldItem;
  }

}

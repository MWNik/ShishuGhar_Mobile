import 'package:shishughar/model/databasemodel/auth_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/apimodel/tabHeight_for_age_Boys_model.dart';
import '../../model/apimodel/tabHeight_for_age_Girls_model.dart';
import '../../model/apimodel/tabWeight_for_age_Boys _model.dart';
import '../../model/apimodel/tabWeight_for_age_Girls _model.dart';
import '../../model/apimodel/tabWeight_to_Height_Boys_model.dart';
import '../../model/apimodel/tabWeight_to_Height_Girls_model.dart';
import '../database_helper.dart';

class HeightWeightBoysGirlsHelper {

  Future<List<TabHeightforageBoysModel>> callHeightForAgeBoys() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .query('tabHeightforAgeBoys');

    List<TabHeightforageBoysModel> tabHeightforageBoys = [];

    for (var element in result) {
      TabHeightforageBoysModel item =
          TabHeightforageBoysModel.fromJson(element);
      tabHeightforageBoys.add(item);
    }
    return tabHeightforageBoys;
  }

  Future<List<TabHeightforageGirlsModel>> callHeightForAgeGirls() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .query('tabHeightforAgeGirls');

    List<TabHeightforageGirlsModel> tabHeightforAgeGirls = [];

    for (var element in result) {
      TabHeightforageGirlsModel item =
          TabHeightforageGirlsModel.fromJson(element);
      tabHeightforAgeGirls.add(item);
    }
    return tabHeightforAgeGirls;
  }

  Future<List<TabWeightforageBoysModel>> callWeightforAgeBoys() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .query('tabWeightforAgeBoys');

    List<TabWeightforageBoysModel> tabWeightforAgeBoys = [];

    for (var element in result) {
      TabWeightforageBoysModel item =
          TabWeightforageBoysModel.fromJson(element);
      tabWeightforAgeBoys.add(item);
    }
    return tabWeightforAgeBoys;
  }

  Future<List<TabWeightforageBoysModel>> callWeightforAgeBoysIn(List<int> items) async {
    String itemDays=List.filled(items.length, '?').join(',');
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('SELECT * FROM tabWeightforAgeBoys WHERE  (age_in_days % 30 = 0 or age_in_days in ($itemDays)) and age_in_days > (3*12*30)',
       );

    List<TabWeightforageBoysModel> tabWeightforAgeBoys = [];

    for (var element in result) {
      TabWeightforageBoysModel item =
          TabWeightforageBoysModel.fromJson(element);
      tabWeightforAgeBoys.add(item);
    }
    return tabWeightforAgeBoys;
  }

  Future<List<TabWeightforageGirlsModel>> callWeightforAgeGirls() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .query('tabWeightforAgeGirls');

    List<TabWeightforageGirlsModel> tabWeightforAgeGirls = [];

    for (var element in result) {
      TabWeightforageGirlsModel item =
          TabWeightforageGirlsModel.fromJson(element);
      tabWeightforAgeGirls.add(item);
    }
    return tabWeightforAgeGirls;
  }

  Future<List<TabWeightforageGirlsModel>> callWeightforAgeGirlsIn(List<int> items) async {
    String itemDays=List.filled(items.length, '?').join(',');
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('SELECT * FROM tabWeightforAgeGirls WHERE  (age_in_days % 30 = 0 or age_in_days in ($itemDays)) and age_in_days > (3*12*30)',
    );

    List<TabWeightforageGirlsModel> tabWeightforAgeGirls = [];

    for (var element in result) {
      TabWeightforageGirlsModel item =
      TabWeightforageGirlsModel.fromJson(element);
      tabWeightforAgeGirls.add(item);
    }
    return tabWeightforAgeGirls;
  }

  Future<List<TabWeightToHeightBoysModel>> callWeightToHeightBoys() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .query('tabWeightToHeightBoys');

    List<TabWeightToHeightBoysModel> tabWeightToHeightBoys = [];

    for (var element in result) {
      TabWeightToHeightBoysModel item =
          TabWeightToHeightBoysModel.fromJson(element);
      tabWeightToHeightBoys.add(item);
    }
    return tabWeightToHeightBoys;
  }

  Future<List<TabWeightToHeightGirlsModel>> callWeightToHeightGirls() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .query('tabWeightToHeightGirls');

    List<TabWeightToHeightGirlsModel> tabWeightToHeightGirls = [];

    for (var element in result) {
      TabWeightToHeightGirlsModel item =
          TabWeightToHeightGirlsModel.fromJson(element);
      tabWeightToHeightGirls.add(item);
    }
    return tabWeightToHeightGirls;
  }

  Future<void> insertHeightForAgeBoys(
      List<TabHeightforageBoysModel> heightforageBoys) async {
    await DatabaseHelper.database!.delete('tabHeightforAgeBoys');
    if (heightforageBoys.isNotEmpty) {
      for (var element in heightforageBoys) {
        await DatabaseHelper.database!
            .insert('tabHeightforAgeBoys', element.toJson());
      }
    }
  }

  Future<void> insertHeightForAgeGirls(
      List<TabHeightforageGirlsModel> heightforageGirls) async {
    await DatabaseHelper.database!.delete('tabHeightforAgeGirls');
    if (heightforageGirls.isNotEmpty) {
      for (var element in heightforageGirls) {
        await DatabaseHelper.database!
            .insert('tabHeightforAgeGirls', element.toJson());
      }
    }
  }

  Future<void> insertWeightToHeightBoys(
      List<TabWeightToHeightBoysModel> weightHeightBoys) async {
    await DatabaseHelper.database!.delete('tabWeightToHeightBoys');
    if (weightHeightBoys.isNotEmpty) {
      for (var element in weightHeightBoys) {
        await DatabaseHelper.database!
            .insert('tabWeightToHeightBoys', element.toJson());
      }
    }
  }

  Future<void> insertWeightToHeightGirls(
      List<TabWeightToHeightGirlsModel> weightHeightGirls) async {
    await DatabaseHelper.database!.delete('tabWeightToHeightGirls');
    if (weightHeightGirls.isNotEmpty) {
      for (var element in weightHeightGirls) {
        await DatabaseHelper.database!
            .insert('tabWeightToHeightGirls', element.toJson());
      }
    }
  }

  Future<void> insertWeightForAgeBoys(
      List<TabWeightforageBoysModel> weightForAgeBoys) async {
    await DatabaseHelper.database!.delete('tabWeightforAgeBoys');
    if (weightForAgeBoys.isNotEmpty) {
      for (var element in weightForAgeBoys) {
        await DatabaseHelper.database!
            .insert('tabWeightforAgeBoys', element.toJson());
      }
    }
  }

  Future<void> insertWeightForAgeGirls(
      List<TabWeightforageGirlsModel> weightHeightGirls) async {
    await DatabaseHelper.database!.delete('tabWeightforAgeGirls');
    if (weightHeightGirls.isNotEmpty) {
      for (var element in weightHeightGirls) {
        await DatabaseHelper.database!
            .insert('tabWeightforAgeGirls', element.toJson());
      }
    }
  }
}

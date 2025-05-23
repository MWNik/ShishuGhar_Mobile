import 'package:flutter/material.dart';
import 'package:shishughar/utils/validate.dart';
import '../../model/databasemodel/backdated_configiration_model.dart';
import '../database_helper.dart';

class BackdatedConfigirationHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();


  Future<void> insertBackdatedConfigirationModel(List<BackdatedConfigirationModel> items) async {
    await DatabaseHelper.database!.delete('backdated_configiration');
    if (items.isNotEmpty) {
      try {
        await DatabaseHelper.database!.transaction((txn) async {
          for (var element in items) {
            await txn.insert('backdated_configiration', element.toJson());
            debugPrint("inserting backdated configiration");
          }
        });
      } catch (e) {
        debugPrint("Error inserting master block ${e.toString()}");
      }
    }
  }


  // Future<BackdatedConfigirationModel?> excuteBackdatedConfigirationModel(String module) async {
  //   List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
  //       'select * from backdated_configiration where module=?',
  //       [module]);
  //   if(result.length>0){
  //    return  BackdatedConfigirationModel.fromJson(result.first);
  //   }else return null;
  //
  // }

  Future<BackdatedConfigirationModel?> excuteBackdatedConfigirationModel(String module) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'SELECT config.name,config.module, config.unique_id,COALESCE(sup.back_dated_data_entry_allowed, config.back_dated_data_entry_allowed) AS back_dated_data_entry_allowed, COALESCE(sup.data_edit_allowed, config.data_edit_allowed) AS data_edit_allowed FROM backdated_configiration AS config LEFT JOIN (SELECT *  FROM backdated_configiration  WHERE strftime(?, date) >= ?  AND type = ?) AS sup ON sup.unique_id = config.unique_id WHERE config.type = ? and config.module =?',
        ['%Y-%m-%d',Validate().currentDate(),'Supervisor','Master',module]);
    if(result.length>0){
     return  BackdatedConfigirationModel.fromJson(result.first);
    }else return null;

  }

}

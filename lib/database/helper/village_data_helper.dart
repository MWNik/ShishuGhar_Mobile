import 'package:flutter/material.dart';
import 'package:shishughar/model/databasemodel/tabVillage_model.dart';
import 'package:shishughar/utils/globle_method.dart';

import '../../model/apimodel/creche_database_responce_model.dart';
import '../database_helper.dart';

class VillageDataHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<TabVillage>> getTabVillageList() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query(
        'tabVillage', orderBy: 'value ASC');

    List<TabVillage> tabVillageList = [];

    for (var element in result) {
      TabVillage state = TabVillage.fromJson(element);
      tabVillageList.add(state);
    }
    return tabVillageList;
  }


  Future<List<TabVillage>> villageById(int villageId) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabVillage where name=?', [villageId]);

    List<TabVillage> tabVillageList = [];

    for (var element in result) {
      TabVillage state = TabVillage.fromJson(element);
      tabVillageList.add(state);
    }
    return tabVillageList;
  }

  Future<List<TabVillage>> getVillageListByVillageId(List<int>villageId) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'Select * from tabVillage where name in (${villageId.join(
            ', ')}) order By value ASC');

    List<TabVillage> tabVillageList = [];

    for (var element in result) {
      TabVillage state = TabVillage.fromJson(element);
      tabVillageList.add(state);
    }
    return tabVillageList;
  }


  Future<String?> getVillageByCreche(String crecheIdes) async {
    String sqlQuery = '''
select * from tabVillage where name in (SELECT SUBSTR( responces,
 INSTR(responces, 'village_id":"') + LENGTH('village_id":"'), 
 INSTR(SUBSTR(responces, INSTR(responces, 'village_id":"') + LENGTH('village_id":"'))
 , '","') - 1 ) AS village_id FROM tab_creche_response
 where name  in (?)) GROUP by name
''';
    String? villages = null;
    try {
      List<Map<String, dynamic>> result = await DatabaseHelper.database!
          .rawQuery
        (sqlQuery,
          [
            crecheIdes
          ]);


      for (var element in result) {
        if (Global.validString(villages)) {
          villages = '$villages,${element['name']}';
        } else
          villages = '${element['name']}';
      }
    } catch (e) {
      print(e);
    }
    return villages;
  }

  // Future<String?> getVillageByCrecheWithCrecheList(String crecheIdes,List<CresheDatabaseResponceModel> creches) async {
  //   String? villages = null;
  //   print('creches $crecheIdes');
  //     for (var item in creches) {
  //       if(crecheIdes.contains('${item.name}')){
  //         var villageId=Global.getItemValues(item.responces, 'village_id');
  //         if (Global.validString(villages)) {
  //           if(!villages!.contains(villageId)){
  //             villages = '$villages,${villageId}';
  //           }
  //         } else villages = '${villageId}';
  //       }
  //     }
  //     print('villages $villages');
  //   return villages;
  // }
  Future<String?> getVillageByCrecheWithCrecheList(
  String crecheIdes,
      List<CresheDatabaseResponceModel> creches) async {

    String? villages;
    print('crecheIds $crecheIdes');
    var crecheIdItems=Global.splitData(crecheIdes, ',');
    for (int i = 0; i < creches.length; i++) {
      if(crecheIdItems.contains(creches[i].name.toString())){
        var villageId = Global.getItemValues(creches[i].responces, 'village_id');

        if (Global.validString(villageId)) {
          if (Global.validString(villages)) {
            var selectedVillag =Global.splitData(villages, ',');
            if (!selectedVillag.contains(villageId)) {
              villages = '$villages,$villageId';
            }
          } else  {
            villages = villageId;
          }}
      }
    }
    // for (var item in creches) {
    //   if (crecheIdItems.contains(item.name.toString())) {
    //     var villageId = Global.getItemValues(item.responces, 'village_id');
    //
    //     if (Global.validString(villageId)) {
    //       if (Global.validString(villages)) {
    //         if (!villages!.split(',').contains(villageId)) {
    //           villages = '$villages,$villageId';
    //         }
    //       } else  {
    //         villages = villageId;
    //       }
    //     }
    //   }
    // }

    print('villages $villages');
    return villages;
  }

  Future<void> insertMasterVillage(List<TabVillage> villageList) async {
    await DatabaseHelper.database!.delete('tabVillage');
    if (villageList.isNotEmpty) {
      try {
        await DatabaseHelper.database!.transaction((txn) async {
          var batch = txn.batch();
          for (var element in villageList) {
            batch.insert('tabVillage', element.toJson());
          }
          await batch.commit(noResult: true);
        });
      } catch (e) {
        debugPrint("Error inserting master District ${e.toString()}");
      }
      // for (var element in villageList) {
      //   await DatabaseHelper.database!.insert('tabVillage', element.toJson());
      // }
    }
  }

}

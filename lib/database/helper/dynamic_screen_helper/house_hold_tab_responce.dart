import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/database/helper/enrolled_exit_child/enrolled_exit_child_responce_helper.dart';
import 'package:shishughar/model/dynamic_screen_model/enrolled_child_exit_responce_model.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/dynamic_screen_model/house_hold_children_model.dart';
import '../../../model/dynamic_screen_model/house_hold_tab_responce_model.dart';
import '../../database_helper.dart';
import '../enrolled_children/enrolled_children_responce_helper.dart';

class HouseHoldTabResponceHelper {
  Future<void> inserts(HouseHoldTabResponceMosdel items) async {
    await DatabaseHelper.database!.insert('house_hold_responce', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertsChild(HouseHoldChildrenModel items) async {
    await DatabaseHelper.database!.insert('house_hold_children', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteDraftRecords(HouseHoldTabResponceMosdel record) async {
    try {
      await DatabaseHelper.database!.delete('house_hold_responce',
          where: 'HHGUID = ? AND name IS NULL', whereArgs: [record.HHGUID]);
    } catch (e) {
      debugPrint("Error deleting draft record : $e");
    }
  }

  Future<void> insertUpdate(String hhGuid, String? dateOfVisit, int? name,
      int? creche_id, String responces, String userId) async {
    var item = HouseHoldTabResponceMosdel(
        HHGUID: hhGuid,
        date_of_visit: dateOfVisit,
        responces: responces,
        is_uploaded: 0,
        is_edited: 1,
        is_deleted: 0,
        name: name,
        created_by: userId,
        creche_id: creche_id,
        created_at: Validate().currentDateTime());
    await DatabaseHelper.database!.insert('house_hold_responce', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<HouseHoldTabResponceMosdel>> getHouseHoldResponce(
      String hhGuid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from house_hold_responce where HHGUID=?', [hhGuid]);
    List<HouseHoldTabResponceMosdel> items = [];

    result.forEach((itemMap) {
      items.add(HouseHoldTabResponceMosdel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<HouseHoldTabResponceMosdel>> getHouseHoldResponceByCHHGUID(
      String CHHGUID) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from house_hold_responce where HHGUID=(select HHGUID from house_hold_children where CHHGUID=?)',
        [CHHGUID]);
    List<HouseHoldTabResponceMosdel> items = [];

    result.forEach((itemMap) {
      items.add(HouseHoldTabResponceMosdel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<HouseHoldTabResponceMosdel>> getHouseHoldItems() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from house_hold_responce where is_edited=1');
    List<HouseHoldTabResponceMosdel> items = [];

    result.forEach((itemMap) {
      items.add(HouseHoldTabResponceMosdel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<HouseHoldTabResponceMosdel>>
      getHouseHoldItemsEditOrDarft() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from house_hold_responce where is_edited=1 or is_edited=2');
    List<HouseHoldTabResponceMosdel> items = [];

    result.forEach((itemMap) {
      items.add(HouseHoldTabResponceMosdel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<HouseHoldTabResponceMosdel>>
      getHouseHoldItemsOnlyForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from house_hold_responce where is_edited=1 and name is null');
    List<HouseHoldTabResponceMosdel> items = [];

    result.forEach((itemMap) {
      items.add(HouseHoldTabResponceMosdel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<HouseHoldTabResponceMosdel>> getHouseHoldUploadeItems() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from house_hold_responce where is_edited=0 and is_uploaded=1');
    List<HouseHoldTabResponceMosdel> items = [];

    result.forEach((itemMap) {
      items.add(HouseHoldTabResponceMosdel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<HouseHoldTabResponceMosdel>> getHouseHoldItemsMap() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'SELECT hhData.*, COALESCE(child.child_count, 0) AS children_count FROM house_hold_responce AS hhData LEFT JOIN(SELECT HHGUID, COUNT(*) AS child_count FROM house_hold_children GROUP BY HHGUID) AS child ON hhData.HHGUID = child.HHGUID ORDER BY CASE  WHEN hhData.update_at IS NOT NULL AND length(RTRIM(LTRIM(hhData.update_at))) > 0 THEN hhData.update_at ELSE hhData.created_at END DESC');
    List<HouseHoldTabResponceMosdel> items = [];
    result.forEach((itemMap) {
      items.add(HouseHoldTabResponceMosdel.fromJson(itemMap));
    });
    return items;
  }

  Future<List<HouseHoldTabResponceMosdel>> getHouseHoldItemsMapByCreche(
      int creche_id) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'SELECT hhData.*, COALESCE(child.child_count, 0) AS children_count FROM house_hold_responce AS hhData LEFT JOIN(SELECT HHGUID, COUNT(*) AS child_count FROM house_hold_children GROUP BY HHGUID) AS child ON hhData.HHGUID = child.HHGUID where hhData.creche_id=? ORDER BY LOWER( SUBSTR(hhData.responces, INSTR(hhData.responces, ?) + LENGTH(?) ) ) asc',
        [creche_id, 'respondent_name":"', 'respondent_name":"']);
    List<HouseHoldTabResponceMosdel> items = [];
    result.forEach((itemMap) {
      items.add(HouseHoldTabResponceMosdel.fromJson(itemMap));
    });
    return items;
  }

  Future<Map<String, dynamic>> getHHDataINMAP(String hhGuid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from house_hold_responce where HHGUID=? limit 1', [hhGuid]);
    if (result.length > 0) {
      return result[0];
    }
    return {};
  }

  Future<Map<String, dynamic>> callHouHoldByChildGuid(String CHHGUID) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from house_hold_responce WHERE HHGUID=(select HHGUID from house_hold_children WHERE CHHGUID=?)',
        [CHHGUID]);
    if (result.length > 0) {
      return result[0];
    }
    return {};
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    if (hhData != null) {
      List<Map<String, dynamic>> children =
          List<Map<String, dynamic>>.from(hhData['children']);
      hhData.remove('children');
      var hhguid = hhData['hhguid'];
      var name = hhData['name'];
      var verificationStatus = hhData['verification_status'];
      var responcesFromData = await getHHDataINMAP(hhguid);
      var responcesFromRespo = jsonDecode(responcesFromData['responces']);
      if (responcesFromRespo.isNotEmpty) {
        responcesFromRespo['verification_status'] =
            verificationStatus.toString();
      }
      responcesFromRespo['hhid'] = hhData['hhid'];
      var hhDtaResponce = jsonEncode(responcesFromRespo);
      await DatabaseHelper.database!.rawQuery(
          'UPDATE house_hold_responce SET name = ? ,responces = ? , is_uploaded=1 , is_edited=0 where HHGUID=?',
          [name, hhDtaResponce, hhguid]);
      children.forEach((element) async {
        var chName = element['name'];
        var chCGUIF = element['hhcguid'];
        await DatabaseHelper.database!.rawQuery(
            'UPDATE house_hold_children SET name = ?  ,parent = ? , is_uploaded=1 , is_edited=0 where CHHGUID=?',
            [chName, name, chCGUIF]);

        var enItem = await EnrolledExitChilrenResponceHelper()
            .callEnrolledChildByHHGUID(chCGUIF);
        if (enItem.length > 0) {
          for (int i = 0; i < enItem.length; i++) {
            var enChRe = jsonDecode(enItem[i].responces!);
            enChRe['hh_child_id'] = chName;
            var enChReData = jsonEncode(enChRe);
            await DatabaseHelper.database!.rawQuery(
                'UPDATE enrollred_exit_child_responce SET responces = ?  ,HHname = ?  where ChildEnrollGUID=?',
                [enChReData, chName, enItem[i].ChildEnrollGUID]);
          }
        }
      });
    }
  }

  Future<void> updateVerficationUpload(List<Map<String, dynamic>> items) async {
    items.forEach((element) async {
      await DatabaseHelper.database!.rawQuery(
          'UPDATE house_hold_responce SET is_uploaded=1 , is_edited=0 where name=?',
          [element['name']]);
    });
  }

  Future<void> updateResponce(String responces, String hhGuid) async {
    await DatabaseHelper.database!.rawQuery(
        'UPDATE house_hold_responce SET responces=?  where HHGUID=?',
        [responces, hhGuid]);
  }

  Future<void> updateResponceWithAddUpload(
      String responces, String hhGuid) async {
    await DatabaseHelper.database!.rawQuery(
        'UPDATE house_hold_responce SET responces=? ,is_edited=1 where HHGUID=?',
        [responces, hhGuid]);
  }

  Future<void> downloadDataItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    if (hhData != null) {
      List<Map<String, dynamic>> children =
          List<Map<String, dynamic>>.from(hhData['children']);
      hhData.remove('children');
      var hhguid = hhData['hhguid'];
      var name = hhData['name'];
      var finalHHData = Validate().keyesFromResponce(hhData);
      var hhDtaResponce = jsonEncode(finalHHData);
      await DatabaseHelper.database!.rawQuery(
          'UPDATE house_hold_responce SET name = ? ,responces = ? , is_uploaded=1 , is_edited=0 where HHGUID=?',
          [name, hhDtaResponce, hhguid]);
      // await DatabaseHelper.database!
      //     .rawQuery('UPDATE house_hold_responce SET name = ? , is_uploaded=1 , is_edited=0 where HHGUID=?', [name,hhguid]);
      children.forEach((element) async {
        var chName = element['name'];
        var chCGUIF = element['hhcguid'];
        var finalCHHData = Validate().keyesFromResponce(element);
        var cHHDtaResponce = jsonEncode(finalCHHData);
        // await DatabaseHelper.database!
        //     .rawQuery('UPDATE house_hold_children SET name = ? ,responces = ? ,parent = ? , is_uploaded=1 , is_edited=0 where CHHGUID=?', [chName,cHHDtaResponce,name,chCGUIF]);
        await DatabaseHelper.database!.rawQuery(
            'UPDATE house_hold_children SET name = ?  ,parent = ? , is_uploaded=1 , is_edited=0 where CHHGUID=?',
            [chName, name, chCGUIF]);
      });
    }
  }

  Future<void> updateUploadedHHDataItem(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> hhData =
        List<Map<String, dynamic>>.from(item['Household Form']);
    hhData.forEach((element) async {
      var name = element['name'];
      var verificationStatus = element['verification_status'];
      var hhguid = element['hhguid'];
      var responcesFromData = await getHHDataINMAP(hhguid);
      var responcesFromRespo = jsonDecode(responcesFromData['responces']);
      if (responcesFromRespo.isNotEmpty) {
        print('Satish test $verificationStatus');
        responcesFromRespo['verification_status'] =
            verificationStatus.toString();
        responcesFromRespo['name'] = name;

        var hhDtaResponce = jsonEncode(responcesFromRespo);
        await DatabaseHelper.database!.rawQuery(
            'UPDATE house_hold_responce SET name = ? ,responces = ? , is_uploaded=1 , is_edited=0 where HHGUID=?',
            [name, hhDtaResponce, hhguid]);
      }
    });
  }

  // Future<void> downloadUpdateData(Map<String, dynamic> item) async {
  //   List<Map<String, dynamic>> hhData =
  //       List<Map<String, dynamic>>.from(item['Data']);
  //   hhData.forEach((element) async {
  //     var hhData = element['Household Form'];
  //     if (hhData != null) {
  //       List<Map<String, dynamic>> children =
  //           List<Map<String, dynamic>>.from(hhData['children']);
  //       hhData.remove('children');
  //       var hhguid = hhData['hhguid'];
  //       var name = hhData['name'];
  //       var appCreatedby = hhData['app_created_by'];
  //       var appCreatedOn = hhData['app_created_on'];
  //       var appUpdatedby = hhData['app_updated_by'];
  //       var appUpdatedOn = hhData['app_updated_on'];
  //       var dateOfVisit = hhData['date_of_visit'];
  //       var creche_id = hhData['creche_id'];
  //       var finalHHData = Validate().keyesFromResponce(hhData);
  //       var hhDtaResponce = jsonEncode(finalHHData);

  //       var item = HouseHoldTabResponceMosdel(
  //           HHGUID: hhguid,
  //           date_of_visit: dateOfVisit,
  //           responces: hhDtaResponce,
  //           is_uploaded: 1,
  //           is_edited: 0,
  //           is_deleted: 0,
  //           name: name,
  //           update_at: appUpdatedOn,
  //           updated_by: appUpdatedby,
  //           created_by: appCreatedby,
  //           creche_id: Global.stringToIntNull(creche_id.toString()),
  //           created_at: appCreatedOn);
  //       await inserts(item);

  //       children.forEach((element) async {
  //         var chName = element['name'];
  //         var chGUID = element['hhguid'];
  //         var chCGUID = element['hhcguid'];
  //         var chappCreatedOn = element['appcreated_on'];
  //         var chappCreatedBy = element['appcreated_by'];
  //         var chappUpdatedOn = element['appupdated_on'];
  //         var chappUpdatedby = element['appupdated_on'];
  //         var finalCHHData = Validate().keyesFromResponce(element);
  //         var cHHDtaResponce = jsonEncode(finalCHHData);

  //         var item = HouseHoldChildrenModel(
  //             HHGUID: chGUID,
  //             CHHGUID: chCGUID,
  //             responces: cHHDtaResponce,
  //             is_uploaded: 1,
  //             is_edited: 0,
  //             is_deleted: 0,
  //             name: chName,
  //             parent: name,
  //             update_at: chappUpdatedOn,
  //             updated_by: chappUpdatedby,
  //             created_by: chappCreatedBy,
  //             created_at: chappCreatedOn);
  //         await insertsChild(item);
  //       });
  //     }
  //   });
  // }

  Future<void> downloadUpdateData(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> hhData =
        List<Map<String, dynamic>>.from(item['Data']);

    // Lists to collect household and child data
    List<HouseHoldTabResponceMosdel> householdList = [];
    List<HouseHoldChildrenModel> childrenList = [];

    // Process household data
    for (var element in hhData) {
      var hhData = element['Household Form'];
      if (hhData != null) {
        List<Map<String, dynamic>> children =
            List<Map<String, dynamic>>.from(hhData['children']);
        hhData.remove('children');

        var hhguid = hhData['hhguid'];
        var name = hhData['name'];
        var appCreatedby = hhData['app_created_by'];
        var appCreatedOn = hhData['app_created_on'];
        var appUpdatedby = hhData['app_updated_by'];
        var appUpdatedOn = hhData['app_updated_on'];
        var dateOfVisit = hhData['date_of_visit'];
        var creche_id = hhData['creche_id'];
        var finalHHData = Validate().keyesFromResponce(hhData);
        var hhDtaResponce = jsonEncode(finalHHData);

        // Create household model
        var householdItem = HouseHoldTabResponceMosdel(
          HHGUID: hhguid,
          date_of_visit: dateOfVisit,
          responces: hhDtaResponce,
          is_uploaded: 1,
          is_edited: 0,
          is_deleted: 0,
          name: name,
          update_at: appUpdatedOn,
          updated_by: appUpdatedby,
          created_by: appCreatedby,
          creche_id: Global.stringToIntNull(creche_id.toString()),
          created_at: appCreatedOn,
        );

        // Add to household list
        householdList.add(householdItem);

        // Process child data
        for (var childElement in children) {
          var chName = childElement['name'];
          var chGUID = childElement['hhguid'];
          var chCGUID = childElement['hhcguid'];
          var chappCreatedOn = childElement['appcreated_on'];
          var chappCreatedBy = childElement['appcreated_by'];
          var chappUpdatedOn = childElement['appupdated_on'];
          var chappUpdatedby = childElement['appupdated_by'];
          var finalCHHData = Validate().keyesFromResponce(childElement);
          var cHHDtaResponce = jsonEncode(finalCHHData);

          // Create child model
          var childItem = HouseHoldChildrenModel(
            HHGUID: chGUID,
            CHHGUID: chCGUID,
            responces: cHHDtaResponce,
            is_uploaded: 1,
            is_edited: 0,
            is_deleted: 0,
            name: chName,
            parent: name,
            update_at: chappUpdatedOn,
            updated_by: chappUpdatedby,
            created_by: chappCreatedBy,
            created_at: chappCreatedOn,
          );

          // Add to child list
          childrenList.add(childItem);
        }
      }
    }

    try {
      // Perform batch insert for households and children
      await DatabaseHelper.database!.transaction((txn) async {
        // Insert household data in batches of 500
        for (int i = 0; i < householdList.length; i += 500) {
          var batchHousehold = txn.batch();
          var batchItems = householdList.sublist(
              i,
              (i + 500) > householdList.length
                  ? householdList.length
                  : (i + 500));

          for (var household in batchItems) {
            batchHousehold.insert(
              'house_hold_responce',
              household.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }

          // Commit batch for household data
          await batchHousehold.commit(noResult: true);
        }

        // Insert child data in batches of 500
        for (int i = 0; i < childrenList.length; i += 500) {
          var batchChildren = txn.batch();
          var batchChildItems = childrenList.sublist(
              i,
              (i + 500) > childrenList.length
                  ? childrenList.length
                  : (i + 500));

          for (var child in batchChildItems) {
            batchChildren.insert(
              'house_hold_children',
              child.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }

          // Commit batch for child data
          await batchChildren.commit(noResult: true);
        }
      });
    } catch (e) {
      debugPrint("Error inserting HH data: $e");
    }
  }
}

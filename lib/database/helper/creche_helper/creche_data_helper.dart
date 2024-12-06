import 'dart:convert';

import 'package:shishughar/database/database_helper.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:sqflite/sqflite.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../model/apimodel/caregiver_responce_model.dart';
import '../../../model/apimodel/creche_database_responce_model.dart';
import '../../../utils/validate.dart';
import '../image_file_tab_responce_helper.dart';
import 'creche_care_giver_helper.dart';

class CrecheDataHelper {
  Future<void> inserts(CresheDatabaseResponceModel items) async {
    await DatabaseHelper.database!.insert('tab_creche_response', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertWhole(List<CresheDatabaseResponceModel> crecheList,
      List<CareGiverResponceModel> careGiversList) async {
    await DatabaseHelper.database!.transaction((txn) async {
      var batch = txn.batch();
      for (var element in crecheList) {
        batch.insert('tab_creche_response', element.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
    await CrecheCareGiverHelper().insertWhole(careGiversList);
  }

  Future<void> downloadCrecheData(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> hhData =
        List<Map<String, dynamic>>.from(item['Data']);
    await DatabaseHelper.database!.delete('tab_creche_response');
    await DatabaseHelper.database!.delete('tab_caregiver_response');
    List<CresheDatabaseResponceModel> crecheList = [];
    List<CareGiverResponceModel> careGiversList = [];
    hhData.forEach((element) async {
      var hhData = element['Creche'];
      if (hhData != null) {
        List<Map<String, dynamic>> careGiver =
            List<Map<String, dynamic>>.from(hhData['creche_caregiver_table']);
        hhData.remove('creche_caregiver_table');
        var name = hhData['name'];
        var appCreatedby = hhData['app_created_by'];
        var appCreatedOn = hhData['app_created_on'];
        var appUpdatedby = hhData['app_updated_by'];
        var appUpdatedOn = hhData['app_updated_on'];
        var finalHHData = Validate().keyesFromResponce(hhData);
        var hhDtaResponce = jsonEncode(finalHHData);

        var item = CresheDatabaseResponceModel(
            responces: hhDtaResponce,
            is_uploaded: 1,
            is_edited: 0,
            is_deleted: 0,
            name: name,
            update_at: appUpdatedOn,
            updated_by: appUpdatedby,
            created_by: appCreatedby,
            created_at: appCreatedOn);
        // await inserts(item);
        crecheList.add(item);
        careGiver.forEach((element) async {
          var chName = element['name'];
          var chappCreatedOn = element['appcreated_on'];
          var chappCreatedBy = element['appcreated_by'];
          var chappUpdatedOn = element['app_updated_on'];
          var chappUpdatedby = element['app_updated_by'];
          var cgGUID = Global.validToString(element['cgguid'].toString());
          var finalCHHData = Validate().keyesFromResponce(element);
          var cHHDtaResponce = jsonEncode(finalCHHData);

          var item = CareGiverResponceModel(
              CGGUID: cgGUID,
              responces: cHHDtaResponce,
              is_uploaded: 1,
              is_edited: 0,
              is_deleted: 0,
              name: chName,
              parent: name,
              update_at: chappUpdatedOn,
              updated_by: chappUpdatedby,
              created_by: chappCreatedBy,
              created_at: chappCreatedOn);
          // await CrecheCareGiverHelper().inserts(item);
          careGiversList.add(item);
        });

        await insertWhole(crecheList, careGiversList);
      }
    });
  }

  Future<void> updateDownloadeData(Map<String, dynamic> item) async {
    var hhData = item['data'];
    if (hhData != null) {
      List<Map<String, dynamic>> careGiver =
          List<Map<String, dynamic>>.from(hhData['creche_caregiver_table']);
      hhData.remove('creche_caregiver_table');
      var name = hhData['name'];

      await DatabaseHelper.database!.rawQuery(
          'UPDATE tab_creche_response SET  is_uploaded=1 , is_edited=0 where name=?',
          [name]);

      careGiver.forEach((element) async {
        var chName = element['name'];
        var cgGUID = Global.validToString(element['cgguid'].toString());

        await DatabaseHelper.database!.rawQuery(
            'UPDATE tab_caregiver_response SET name = ?  , is_uploaded=1 , is_edited=0 where CGGUID=?',
            [chName, cgGUID]);
      });

      var childImage = await ImageFileTabHelper()
          .getImageByDoctypeIdAndImbeNotNull(
              name.toString(), CustomText.Creches);
      if (childImage.length > 0) {
        childImage.forEach((element) async {
          if (Global.validToInt(element.name) == 0) {
            await DatabaseHelper.database!.rawQuery(
                'UPDATE tab_image_file SET name = ?  where doctype_guid=? and doctype=?',
                [name, element.doctype_guid, CustomText.Creches]);
          }
        });
      }
    }
  }

  Future<List<CresheDatabaseResponceModel>> getCrecheResponce() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        // 'select * from tab_creche_response ORDER BY CASE  WHEN update_at IS NOT NULL AND update_at <> '' THEN update_at ELSE created_at END DESC'
        'select * from tab_creche_response');
    List<CresheDatabaseResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(CresheDatabaseResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<Map<String, dynamic>>> callCrechEnrolledByChildGUID(
      String ChildEnrollGUID) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select ecr.*,cr.responces as crResponces from enrollred_exit_child_responce ecr left join tab_creche_response as cr on ecr.creche_id=cr.name where ecr.ChildEnrollGUID=? and ecr.date_of_exit isnull',
        [ChildEnrollGUID]);

    return result;
  }

  Future<void> callCrecheIsEdited(int name) async {
    await DatabaseHelper.database!.rawQuery(
        'UPDATE tab_creche_response SET  is_uploaded=0 , is_edited=1 where name=?',
        [name]);
  }

  Future<List<CresheDatabaseResponceModel>> callCrecheForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from tab_creche_response where is_edited=1');
    List<CresheDatabaseResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(CresheDatabaseResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CresheDatabaseResponceModel>>
      callCrecheForUploadEditDart() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tab_creche_response where is_edited=1 or is_edited=2');
    List<CresheDatabaseResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(CresheDatabaseResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CresheDatabaseResponceModel>> getCrecheResponceItem(
      int name) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from tab_creche_response where name=?', [name]);
    List<CresheDatabaseResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(CresheDatabaseResponceModel.fromJson(itemMap));
    });

    return items;
  }
}

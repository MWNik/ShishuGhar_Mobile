import 'dart:convert';

import 'package:shishughar/utils/globle_method.dart';
import 'package:sqflite/sqflite.dart';

import '../../../custom_widget/custom_text.dart';
import '../../../model/dynamic_screen_model/checkIn_response_model.dart';
import '../../../utils/validate.dart';
import '../../database_helper.dart';
import '../image_file_tab_responce_helper.dart';


class CheckInResponseHelper {
  Future<List<CheckInResponseModel>> getCheckInList() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .query('check_in_response', orderBy: 'created_at ASC');

    List<CheckInResponseModel> checkIns = [];

    for (var element in result) {
      CheckInResponseModel state = CheckInResponseModel.fromJson(element);
      checkIns.add(state);
    }
    return checkIns;
  }

  Future<void> inserts(CheckInResponseModel items) async {
    await DatabaseHelper.database!.insert('check_in_response', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertCheckIns(List<CheckInResponseModel> checkins) async {
    await DatabaseHelper.database!.delete('check_in_response');
    if (checkins.isNotEmpty) {
      for (var element in checkins) {
        await DatabaseHelper.database!
            .insert('check_in_response', element.toJson());
      }
    }
  }

  Future<List<CheckInResponseModel>> getCheckinsItem(String crecheId) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        // 'select * from check_in_response where creche_id=? ORDER BY DATE(date_of_checkin) DESC',
        'select * from check_in_response where creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC',
        [crecheId]);
    List<CheckInResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CheckInResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CheckInResponseModel>> getCheckinsByGUIDItem(String GUID) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from check_in_response where ccinguid=?', [GUID]);
    List<CheckInResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CheckInResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<CheckInResponseModel>> callCrecheCheckInResponses() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from check_in_response where is_edited = 1');

    List<CheckInResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(CheckInResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedCrecheCheckInResponce(
      Map<String, dynamic> item) async {
    Map<String, dynamic> CiData = item['data'];
    var name = CiData['name'];
    var ccinguid = CiData['ccinguid'];
    await DatabaseHelper.database!.rawQuery(
        'UPDATE check_in_response SET is_uploaded=1 , is_edited=0 , name=? where ccinguid =?',
        [name, ccinguid]);

    var childImage = await ImageFileTabHelper()
        .getImageByDoctypeIdAndImbeNotNull(ccinguid, CustomText.checkInsCrech);
    if (childImage.length > 0) {
      childImage.forEach((element) async {
        if (Global.validToInt(element.name) == 0) {
          await DatabaseHelper.database!.rawQuery(
              'UPDATE tab_image_file SET name = ?  where doctype_guid=? and doctype=?',
              [name, element.doctype_guid, CustomText.checkInsCrech]);
        }
      });
    }
  }

  Future<void> crecheCheckInDwownload(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> checkIns =
        List<Map<String, dynamic>>.from(item['Data']);
    checkIns.forEach((element) async {
      // for (var element in checkIns) {
      var chechIn = element['Creche Check In'];

      var checkinitems = CheckInResponseModel(
          ccinguid: chechIn['ccinguid'],
          creche_id: Global.stringToInt(chechIn['creche_id']),
          name: Global.stringToInt(chechIn['name'].toString()),
          is_uploaded: 1,
          is_edited: 0,
          is_deleted: 0,
          created_by: chechIn['owner'],
          created_at: chechIn['creation'],
          update_at: chechIn['modified'],
          updated_by: chechIn['modified_by'],
          responces: jsonEncode(Validate().keyesFromResponce(chechIn)));
      print('Success');
      await inserts(checkinitems);
    });
    // }
  }
}

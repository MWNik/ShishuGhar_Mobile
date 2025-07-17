import 'dart:convert';

import 'package:shishughar/database/helper/enrolled_children/enrolled_children_responce_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/dynamic_screen_model/house_hold_children_model.dart';
import '../../database_helper.dart';
import 'house_hold_tab_responce.dart';

class HouseHoldChildrenHelperHelper {
  Future<void> inserts(HouseHoldChildrenModel items) async {
    await DatabaseHelper.database!
        .insert('house_hold_children', items.toJson());
  }

  Future<void> insertUpdate(
      String hhGuid,
      String CHHGUID,
      String responces,
      String userId,
      int? name,
      int? parent,
      String? createdOn,
      String? updatedOn) async {
    var item = HouseHoldChildrenModel(
      HHGUID: hhGuid,
      CHHGUID: CHHGUID,
      responces: responces,
      is_uploaded: 0,
      is_edited: 1,
      is_deleted: 0,
      name: name,
      parent: parent,
      created_by: userId,
      updated_by: userId,
      created_at: createdOn,
      update_at: updatedOn,
    );
    await DatabaseHelper.database!.insert('house_hold_children', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<HouseHoldChildrenModel>> getHouseHoldChildren(
      String hhGuid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from house_hold_children where HHGUID=? ORDER BY LOWER( SUBSTR(responces, INSTR(responces, ?) + LENGTH(?) ) ) asc',
        [hhGuid, 'child_name":"', 'child_name":"']);
    List<HouseHoldChildrenModel> items = [];

    result.forEach((itemMap) {
      items.add(HouseHoldChildrenModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<HouseHoldChildrenModel>> getHouseHoldChildrenItem(
      String hhGuid, String CHHGUID) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from house_hold_children where HHGUID=? and CHHGUID=?',
        [hhGuid, CHHGUID]);
    List<HouseHoldChildrenModel> items = [];

    result.forEach((itemMap) {
      items.add(HouseHoldChildrenModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<HouseHoldChildrenModel>> callHouseHoldChildrenItem(
      String CHHGUID) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from house_hold_children where  CHHGUID=?', [CHHGUID]);
    List<HouseHoldChildrenModel> items = [];

    result.forEach((itemMap) {
      items.add(HouseHoldChildrenModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<String>> getResponceHouseHoldChildren(String hhGuid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select responces from house_hold_children where HHGUID=? and is_edited=1',
        [hhGuid]);
    List<String> items =
        result.map((map) => map['responces'].toString()).toList();

    return items;
  }

  Future<void> isUpdateEdit(String CHHGUID, String responces) async {
    var res = jsonDecode(responces);

    var result = await HouseHoldChildrenHelperHelper()
        .callHouseHoldChildrenItem(CHHGUID);
    var childProfile = await EnrolledChilrenResponceHelper()
        .callEnrolledChildByHHGUID(CHHGUID);

    if (result.length > 0) {
      var response = jsonDecode(result[0].responces!);

      // if (res['is_dob_available'] != 0) {
      if (result[0].name != null) {
        response['name'] = result[0].name;
      }
      response['is_dob_available'] = 1;
      response['child_dob'] = res['child_dob'];
      response['child_age'] = res['age_at_enrollment_in_months'];
      response['child_name'] = res['child_name'];
      response['gender_id'] = res['gender_id'];
      // }

      var resp = jsonEncode(response);
      print("success");

      await DatabaseHelper.database!.rawQuery(
          'update house_hold_children set responces=? , is_edited=1 where CHHGUID=? ',
          [resp, CHHGUID]);

      //ChildProfile
      if (childProfile.length > 0) {
        var childProfileResponse = jsonDecode(childProfile.first.responces!);
        childProfileResponse['child_dob'] = res['child_dob'];
        childProfileResponse['child_name'] = res['child_name'];
        childProfileResponse['gender_id'] = res['gender_id'];
        var chpJson = jsonEncode(childProfileResponse);
        await DatabaseHelper.database!.rawQuery(
            'update enrollred_chilren_responce set responces=? , is_edited=1 where CHHGUID=? ',
            [chpJson, CHHGUID]);
      }

      //HH update
      var hhItem = await HouseHoldTabResponceHelper()
          .getHouseHoldResponceByCHHGUID(CHHGUID);
      if (hhItem.length > 0) {
        var HHresponse = jsonDecode(hhItem[0].responces!);
        if (hhItem[0].name != null) {
          HHresponse['name'] = hhItem[0].name;
        }

        var resp = jsonEncode(HHresponse);
        await HouseHoldTabResponceHelper()
            .updateResponceWithAddUpload(resp, hhItem[0].HHGUID!);
      }
    }
  }

  Future<void> UpdateCrecheId(String CHHGUID, int creche_id) async {
    var result = await HouseHoldChildrenHelperHelper()
        .callHouseHoldChildrenItem(CHHGUID);
    if (result.length > 0) {
      if (result[0].creche_id == null) {
        var response = jsonDecode(result[0].responces!);
        if (result[0].name != null) {
          response['name'] = result[0].name;
        }
        response['current_creche'] = creche_id;

        var resp = jsonEncode(response);

        await DatabaseHelper.database!.rawQuery(
            'update house_hold_children set responces=? ,creche_id=? , is_edited=1 where CHHGUID=? ',
            [resp, creche_id, CHHGUID]);
      }
    }
  }
}

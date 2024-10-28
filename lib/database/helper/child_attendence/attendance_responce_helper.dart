import 'dart:convert';

import 'package:shishughar/utils/globle_method.dart';
import 'package:sqflite/sqflite.dart';

import '../../../database/database_helper.dart';
import '../../../database/helper/child_attendence/child_attendence_helper.dart';
import '../../../model/databasemodel/child_attendance_responce_model.dart';
import '../../../model/databasemodel/child_for_attendence_model.dart';
import '../../../utils/validate.dart';

class AttendanceResponnceHelper {
  Future<void> inserts(ChildAttendanceResponceModel items) async {
    await DatabaseHelper.database!.insert('child_attendance_responce', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertUpdate(String markedChildGuid, int creche_nameId,
      String responce, int? name, String userId) async {
    var item = ChildAttendanceResponceModel(
        childattenguid: markedChildGuid,
        creche_id: creche_nameId,
        responces: responce,
        is_uploaded: 0,
        is_edited: 1,
        is_deleted: 0,
        name: name,
        created_by: userId,
        created_at: Validate().currentDateTime());
    await DatabaseHelper.database!.insert(
        'child_attendance_responce', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ChildAttendanceResponceModel>> callChildrenResponce(
      String markedChildGuid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_attendance_responce where childattenguid=?',
        [markedChildGuid]);
    List<ChildAttendanceResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildAttendanceResponceModel.fromJson(itemMap));
    });

    return items;
  }


  Future<List<ChildAttendanceResponceModel>> callUpdaeAttendesResponce(
      String childattenguid,String responces) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'UPDATE  child_attendance_responce set responces =? where childattenguid=?',
        [responces,childattenguid]);
    List<ChildAttendanceResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildAttendanceResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildAttendanceResponceModel>> callChildAttendences(int creche_id) async {
    var query = 'select * from child_attendance_responce WHERE creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query,[creche_id]);

    List<ChildAttendanceResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildAttendanceResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> childAttendanceData(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> attendence = List<Map<String, dynamic>>.from(item['Data']);
    attendence.forEach((element) async {
      var ACData =element['Child Attendance'];
      var name = ACData['name'];
      var creche_id = ACData['creche_id'];
      var ChildAttenGUID = ACData['childattenguid'];
      var appCreatedOn = ACData['app_created_on'];
      var appcreated_by = ACData['app_created_by'];
      var app_updated_by = ACData['app_updated_by'];
      var app_updated_on = ACData['app_updated_on'];
      var date_of_attendance = ACData['date_of_attendance'];
      var finalHHData = Validate().keyesFromResponce(ACData);
      List<Map<String, dynamic>> children = List<Map<String, dynamic>>.from(ACData['childattendancelist']);
      ACData.remove('childattendancelist');
      var hhDtaResponce = jsonEncode(finalHHData);
      var items = ChildAttendanceResponceModel(
          responces: hhDtaResponce,
          is_uploaded: 1,
          is_edited: 0,
          is_deleted: 0,
          name: name,
          creche_id: Global.stringToInt(creche_id),
          childattenguid: ChildAttenGUID,
          update_at: app_updated_on,
          updated_by: app_updated_by,
          created_by: appcreated_by,
          created_at: appCreatedOn,
          date_of_attendance: date_of_attendance
      );
      await inserts(items);
      children.forEach((element) async {
        var ChildAttenGUID = element['childattenguid'];
        var child_profile_id = element['child_profile_id'];
        var attendance = element['attendance'];
        var enrolled_guid = element['childenrolledguid'];
        var date_of_attendance = element['date_of_attendance'];
        var name = element['name'];
        var name_of_child = element['name_of_child'];
        var item =ChildForAttendenceModel( childattenguid:ChildAttenGUID,
            child_profile_id:Global.stringToInt(child_profile_id),
            attendance:attendance,
            date_of_attendance:date_of_attendance,
            name:name,
            name_of_child:name_of_child,
            childenrolledguid:enrolled_guid);
        await ChildAttendenceHelper().inserts(item);
      });
    });


  }
}

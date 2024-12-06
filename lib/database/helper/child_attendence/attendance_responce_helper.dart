import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:sqflite/sqflite.dart';

import '../../../database/database_helper.dart';
import '../../../database/helper/child_attendence/child_attendence_helper.dart';
import '../../../model/databasemodel/child_attendance_responce_model.dart';
import '../../../model/databasemodel/child_for_attendence_model.dart';
import '../../../utils/validate.dart';

class AttendanceResponnceHelper {
  Future<void> inserts(ChildAttendanceResponceModel items) async {
    await DatabaseHelper.database!.insert(
        'child_attendance_responce', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteDraftRecords(ChildAttendanceResponceModel record) async {
    try {
      await DatabaseHelper.database!.delete('child_attendance_responce',
          where: 'is_edited = ? AND name IS NULL AND childattenguid =?',
          whereArgs: [2, record.childattenguid]);
      await ChildAttendenceHelper().deleteDraftRecord(record.childattenguid!);
    } catch (e) {
      debugPrint("Error deleting draft record : $e");
    }
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
      String childattenguid, String responces) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'UPDATE  child_attendance_responce set responces =? where childattenguid=?',
        [responces, childattenguid]);
    List<ChildAttendanceResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildAttendanceResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildAttendanceResponceModel>> callChildAttendences(
      int creche_id) async {
    var query =
        'select * from child_attendance_responce WHERE creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [creche_id]);

    List<ChildAttendanceResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildAttendanceResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> childAttendanceData(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> attendance =
        List<Map<String, dynamic>>.from(item['Data']);

    // Lists to hold parent and child attendance models
    List<ChildAttendanceResponceModel> parentItems = [];
    List<ChildForAttendenceModel> childItems = [];

    // Prepare data
    for (var element in attendance) {
      var ACData = element['Child Attendance'];
      var name = ACData['name'];
      var creche_id = ACData['creche_id'];
      var childAttenGUID = ACData['childattenguid'];
      var appCreatedOn = ACData['app_created_on'];
      var appCreatedBy = ACData['app_created_by'];
      var appUpdatedBy = ACData['app_updated_by'];
      var appUpdatedOn = ACData['app_updated_on'];
      var dateOfAttendance = ACData['date_of_attendance'];
      var finalHHData = Validate().keyesFromResponce(ACData);
      List<Map<String, dynamic>> children =
          List<Map<String, dynamic>>.from(ACData['childattendancelist']);
      ACData.remove('childattendancelist');
      var hhDataResponse = jsonEncode(finalHHData);

      // Add to parent list
      parentItems.add(
        ChildAttendanceResponceModel(
          responces: hhDataResponse,
          is_uploaded: 1,
          is_edited: 0,
          is_deleted: 0,
          name: name,
          creche_id: Global.stringToInt(creche_id),
          childattenguid: childAttenGUID,
          update_at: appUpdatedOn,
          updated_by: appUpdatedBy,
          created_by: appCreatedBy,
          created_at: appCreatedOn,
          date_of_attendance: dateOfAttendance,
        ),
      );

      // Add child data to child list
      for (var childElement in children) {
        var childAttenGUID = childElement['childattenguid'];
        var childProfileId = childElement['child_profile_id'];
        var attendance = childElement['attendance'];
        var enrolledGuid = childElement['childenrolledguid'];
        var dateOfAttendance = childElement['date_of_attendance'];
        var name = childElement['name'];
        var nameOfChild = childElement['name_of_child'];

        childItems.add(
          ChildForAttendenceModel(
            childattenguid: childAttenGUID,
            child_profile_id: Global.stringToInt(childProfileId),
            attendance: attendance,
            date_of_attendance: dateOfAttendance,
            name: name,
            name_of_child: nameOfChild,
            childenrolledguid: enrolledGuid,
          ),
        );
      }
    }

    // Insert in batches of 500
    try {
      await DatabaseHelper.database!.transaction((txn) async {
        // Insert parent items in batches of 500
        for (int i = 0; i < parentItems.length; i += 500) {
          var batchChildAttendance = txn.batch();
          var batchItems = parentItems.sublist(i,
              (i + 500) > parentItems.length ? parentItems.length : (i + 500));

          for (var item in batchItems) {
            batchChildAttendance.insert(
              'child_attendance_responce',
              item.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          await batchChildAttendance.commit(noResult: true);
        }

        // Insert child items in batches of 500
        for (int i = 0; i < childItems.length; i += 500) {
          var batchAttendance = txn.batch();
          var batchItems = childItems.sublist(
              i, (i + 500) > childItems.length ? childItems.length : (i + 500));

          for (var item in batchItems) {
            batchAttendance.insert(
              'child_attendence',
              item.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          await batchAttendance.commit(noResult: true);
        }

        // Commit the batch
      });
    } catch (e) {
      debugPrint("Error inserting attendance data -> ${e.toString()}");
    }
  }

  // Future<void> childAttendanceData(Map<String, dynamic> item) async {
  //   List<Map<String, dynamic>> attendence =
  //       List<Map<String, dynamic>>.from(item['Data']);
  //   attendence.forEach((element) async {
  //     var ACData = element['Child Attendance'];
  //     var name = ACData['name'];
  //     var creche_id = ACData['creche_id'];
  //     var ChildAttenGUID = ACData['childattenguid'];
  //     var appCreatedOn = ACData['app_created_on'];
  //     var appcreated_by = ACData['app_created_by'];
  //     var app_updated_by = ACData['app_updated_by'];
  //     var app_updated_on = ACData['app_updated_on'];
  //     var date_of_attendance = ACData['date_of_attendance'];
  //     var finalHHData = Validate().keyesFromResponce(ACData);
  //     List<Map<String, dynamic>> children =
  //         List<Map<String, dynamic>>.from(ACData['childattendancelist']);
  //     ACData.remove('childattendancelist');
  //     var hhDtaResponce = jsonEncode(finalHHData);
  //     var items = ChildAttendanceResponceModel(
  //         responces: hhDtaResponce,
  //         is_uploaded: 1,
  //         is_edited: 0,
  //         is_deleted: 0,
  //         name: name,
  //         creche_id: Global.stringToInt(creche_id),
  //         childattenguid: ChildAttenGUID,
  //         update_at: app_updated_on,
  //         updated_by: app_updated_by,
  //         created_by: appcreated_by,
  //         created_at: appCreatedOn,
  //         date_of_attendance: date_of_attendance);
  //     await inserts(items);
  //     children.forEach((element) async {
  //       var ChildAttenGUID = element['childattenguid'];
  //       var child_profile_id = element['child_profile_id'];
  //       var attendance = element['attendance'];
  //       var enrolled_guid = element['childenrolledguid'];
  //       var date_of_attendance = element['date_of_attendance'];
  //       var name = element['name'];
  //       var name_of_child = element['name_of_child'];
  //       var item = ChildForAttendenceModel(
  //           childattenguid: ChildAttenGUID,
  //           child_profile_id: Global.stringToInt(child_profile_id),
  //           attendance: attendance,
  //           date_of_attendance: date_of_attendance,
  //           name: name,
  //           name_of_child: name_of_child,
  //           childenrolledguid: enrolled_guid);
  //       await ChildAttendenceHelper().inserts(item);
  //     });
  //   });
  // }
}

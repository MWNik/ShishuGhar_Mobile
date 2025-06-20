import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../../model/databasemodel/child_for_attendence_model.dart';
import '../../database_helper.dart';

class ChildAttendenceHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<void> inserts(ChildForAttendenceModel items) async {
    await DatabaseHelper.database!.insert('child_attendence', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteDraftRecord(String childAttenGuid) async {
    try {
      await DatabaseHelper.database!.delete('child_attendence',
          where: 'childattenguid = ? AND name IS NULL',
          whereArgs: [childAttenGuid]);
    } catch (e) {
      debugPrint("Error deleting draft records");
    }
  }

  Future<void> deleteAttendeceBYGUID(
      String ChildAttenGUID, String date_of_attendance) async {
    await DatabaseHelper.database!.delete(
      'child_attendence',
      where: 'childattenguid = ? AND date_of_attendance = ?',
      whereArgs: [ChildAttenGUID, date_of_attendance],
    );
  }

  Future<void> insertOrUpdateItem(ChildForAttendenceModel item) async {
    // Check if a row with the same ChildAttenGUID exists
    List<Map<String, dynamic>> rows = await DatabaseHelper.database!.rawQuery(
      'select * from child_attendence where childattenguid =? and date_of_attendance=? '
      'and child_profile_id=?',
      [item.childattenguid, item.date_of_attendance, item.child_profile_id],
    );

    if (rows.isNotEmpty) {
      // Row with the same ChildAttenGUID exists, update it
      await DatabaseHelper.database!.update(
        'child_attendence',
        item.toJson(),
        where: 'childattenguid = ?',
        whereArgs: [item.childattenguid],
      );
    } else {
      // Row with the same ChildAttenGUID does not exist, insert a new row
      await DatabaseHelper.database!.insert(
        'child_attendence',
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm
            .ignore, // Use ConflictAlgorithm.ignore to avoid conflicts
      );
    }
  }

  Future<void> insertAll(
      List<ChildForAttendenceModel> childForAttendence) async {
    await DatabaseHelper.database!.delete(
      'child_attendence',
      where: 'childattenguid = ?',
      whereArgs: [childForAttendence[0].childattenguid],
    );
    if (childForAttendence.isNotEmpty) {
      for (var element in childForAttendence) {
        await inserts(element);
      }
    }
  }

  Future<List<ChildForAttendenceModel>> callChildAttendences() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from child_attendence');

    List<ChildForAttendenceModel> childAttendanceFieldItem = [];

    for (var element in result) {
      ChildForAttendenceModel state = ChildForAttendenceModel.fromJson(element);
      childAttendanceFieldItem.add(state);
    }
    return childAttendanceFieldItem;
  }

  Future<List<ChildForAttendenceModel>> callChildAttendencesByGuid(
      String ChildAttenGUID) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_attendence where childattenguid=?',
        [ChildAttenGUID]);

    List<ChildForAttendenceModel> childAttendanceFieldItem = [];

    for (var element in result) {
      ChildForAttendenceModel state = ChildForAttendenceModel.fromJson(element);
      childAttendanceFieldItem.add(state);
    }
    return childAttendanceFieldItem;
  }

  Future<List<ChildForAttendenceModel>> callChildAttendecsByEnrollGUID(
      String childenrolledguid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_attendence where childenrolledguid=?',
        [childenrolledguid]);

    List<ChildForAttendenceModel> childAttendanceFieldItem = [];

    for (var element in result) {
      ChildForAttendenceModel state = ChildForAttendenceModel.fromJson(element);
      childAttendanceFieldItem.add(state);
    }
    return childAttendanceFieldItem;
  }

  Future<List<Map<String, dynamic>>> callChildAttendencesForUpload(
      String? ChildAttenGUID, String? date_of_attendance) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_attendence where childattenguid=? and date_of_attendance=?',
        [ChildAttenGUID, date_of_attendance]);

    return result;
  }

  Future updateAttendenceHelper(
      String? ChildAttenGUID, String? date_of_attendance) async {
    await DatabaseHelper.database!.rawQuery(
        'UPDATE child_attendence SET date_of_attendance = ? where childattenguid=?',
        [date_of_attendance, ChildAttenGUID]);
  }

  Future<List<Map<String, dynamic>>> excuteIsNotSubmitedDate() async {
    return await DatabaseHelper.database!.rawQuery(
        '''select * from (SELECT creche_id,MIN(max_date_of_records) AS min_of_max_dates FROM (   SELECT   creche_id,  MAX(date_of_attendance) AS max_date_of_records  FROM    child_attendance_responce   GROUP BY     creche_id) WHERE max_date_of_records < DATE('now')) as date_records left join tab_creche_response as creche on date_records.creche_id=creche.name''',
        );
  }
}

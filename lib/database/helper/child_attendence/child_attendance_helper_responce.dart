import 'dart:convert';

import 'package:shishughar/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../../model/databasemodel/child_attendance_responce_model.dart';
import '../../../utils/validate.dart';

class ChildAttendanceResponceHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();


  Future<List<ChildAttendanceResponceModel>> callAttendanceResponce(
      String ChildAttenGUID) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_attendance_responce where ChildAttenGUID=?',
        [ChildAttenGUID]);
    List<ChildAttendanceResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildAttendanceResponceModel.fromJson(itemMap));
    });

    return items;
  }


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

  Future<List<ChildAttendanceResponceModel>> callChildAttendencesAllForUpoad() async {

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery('select * from child_attendance_responce where is_edited=1');

    List<ChildAttendanceResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildAttendanceResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedChildAttendanceItem(
      Map<String, dynamic> item) async {
    var cProfileItm = item['data'];
    var name = cProfileItm['name'];
    var guid = cProfileItm['childattenguid'];

    await DatabaseHelper.database!.rawQuery(
        'UPDATE child_attendance_responce SET name = ?  , is_uploaded=1 , is_edited=0 where childattenguid=?',
        [name,guid]);
  }

  Future<List<ChildAttendanceResponceModel>>
  callChilsAttendanceAllResponces() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from child_attendance_responce');

    List<ChildAttendanceResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildAttendanceResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildAttendanceResponceModel>> callMaxChilsAttendanceAllResponces(
      int? crecheid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_attendance_responce where creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC',
        [crecheid]);

    List<ChildAttendanceResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildAttendanceResponceModel.fromJson(itemMap));
    });

    return items;
  }

}

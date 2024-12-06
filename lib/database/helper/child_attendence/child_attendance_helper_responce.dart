import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shishughar/database/database_helper.dart';
import 'package:shishughar/database/helper/dynamic_screen_helper/options_model_helper.dart';
import 'package:shishughar/utils/globle_method.dart';
import 'package:sqflite/sqflite.dart';
import '../../../model/databasemodel/child_attendance_responce_model.dart';
import '../../../utils/validate.dart';

class ChildAttendanceResponceHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();
  NumberFormat formatter = NumberFormat("00");

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
    await DatabaseHelper.database!.insert(
        'child_attendance_responce', items.toJson(),
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

  Future<List<ChildAttendanceResponceModel>>
      callChildAttendencesAllForUpoad() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from child_attendance_responce where is_edited=1');

    List<ChildAttendanceResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildAttendanceResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildAttendanceResponceModel>>
      callChildAttendencesAllForUpoadEditDarft() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_attendance_responce where is_edited=1 or is_edited=2');

    List<ChildAttendanceResponceModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildAttendanceResponceModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedChildAttendanceItem(
      Map<String, dynamic> item) async {
    var cProfileItm = item['Data'];
    int? name = cProfileItm['name'] ?? null;
    var guid = cProfileItm['childattenguid'];

    await DatabaseHelper.database!.rawQuery(
        'UPDATE child_attendance_responce SET name = ? ,is_uploaded=1 , is_edited=0 where childattenguid=?',
        [name, guid]);
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

  Future<List<Map<String, dynamic>>> fetchMostAttendancerecord(
      int creche_id, int month, int year) async {
    String Year = '';
    String Month = formatter.format(month);
    var years = await OptionsModelHelper().getYearOptions();
    years.forEach((element) {
      if (Global.stringToInt(element.name) == year) {
        Year = element.values!;
      }
    });
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'SELECT atre.*, COALESCE(chilAt.max_atn_count, 0) AS children_count FROM child_attendance_responce atre LEFT JOIN ( SELECT childattenguid, MAX(atn_count) AS max_atn_count FROM ( SELECT childattenguid, COUNT(*) AS atn_count FROM child_attendence GROUP BY childattenguid ) AS atn_counts GROUP BY childattenguid ) AS chilAt ON chilAt.childattenguid = atre.childattenguid WHERE chilAt.max_atn_count IS NOT NULL and atre.creche_id=? AND substr(atre.date_of_attendance, 6, 2) = ? AND substr(atre.date_of_attendance, 1, 4) = ? ORDER BY chilAt.max_atn_count DESC LIMIT 1;',
        [creche_id, Month, Year]);

    // List<ChildAttendanceResponceModel> items = [];

    // result.forEach((itemMap) {
    //   items.add(ChildAttendanceResponceModel.fromJson(itemMap));
    // });

    return result;
  }

  Future<List<Map<String, dynamic>>> callLastAttendenceMaxChildCount(
      int creche_id, int month, int year) async {
    String Year = '';
    String Month = formatter.format(month);
    var years = await OptionsModelHelper().getYearOptions();
    years.forEach((element) {
      if (Global.stringToInt(element.name) == year) {
        Year = element.values!;
      }
    });

    var selctedDate = '$Year-$Month-01';
    var dateformate = '%Y-%m';
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'SELECT atre.*,max(COALESCE(chilAt.atn_count, 0)) AS children_count FROM child_attendance_responce atre LEFT JOIN (SELECT childattenguid, COUNT(*) AS atn_count,date_of_attendance FROM child_attendence where attendance=1 GROUP BY childattenguid) AS chilAt ON chilAt.childattenguid = atre.childattenguid  WHERE chilAt.atn_count IS NOT NULL and atre.creche_id=? and strftime(?, atre.date_of_attendance) = ( SELECT strftime(?, date_of_attendance)  FROM child_attendance_responce  WHERE date_of_attendance <strftime(?, ?) ORDER BY date_of_attendance DESC  LIMIT 1)',
        [creche_id, dateformate, dateformate, dateformate, selctedDate]);

    return result;
  }
}

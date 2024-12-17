import 'package:shishughar/database/database_helper.dart';
import 'package:shishughar/model/apimodel/translation_language_api_model.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';

class TranslationDataHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<Translation>> getTranslationLanguageList() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .query('translation_language', orderBy: 'value ASC');

    List<Translation> translationList = [];

    for (var element in result) {
      Translation state = Translation.fromJson(element);
      translationList.add(state);
    }
    return translationList;
  }

  Future<void> insertTranslationLanguage(
      List<Translation> translationList) async {
    await DatabaseHelper.database!.delete('translation_language');
    if (translationList.isNotEmpty) {
      await DatabaseHelper.database!.transaction((txn) async {
        var batch = txn.batch();
        for (var element in translationList) {
          batch.insert('translation_language', element.toJson());
        }
        await batch.commit(noResult: true);
      });
      // for (var element in translationList) {
      //   await DatabaseHelper.database!
      //       .insert('translation_language', element.toJson());
      // }
    }
  }

  Future<List<Translation>> callTranslate() async {
    String sql =
        "select * from translation_language where value_name in(Select trim(label) from tabhouseholdfield where label IS NOT NULL and LENGTH(label) > 0)";
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(sql);

    List<Translation> translationList = [];

    for (var element in result) {
      var item = new Translation(
          name: element['value_name'].toString(),
          english: element['value_en'].toString(),
          hindi: element['value_hi'].toString(),
          odia: element['value_od'].toString());
      translationList.add(item);
    }
    return translationList;
  }

  Future<List<Translation>> callCresheTranslate() async {
    String sql =
        "select * from translation_language where value_name in(Select trim(label) from tabCrechefield where label IS NOT NULL and LENGTH(label) > 0)";
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(sql);

    List<Translation> translationList = [];

    for (var element in result) {
      var item = new Translation(
          name: element['value_name'].toString(),
          english: element['value_en'].toString(),
          hindi: element['value_hi'].toString(),
          odia: element['value_od'].toString());
      translationList.add(item);
    }
    return translationList;
  }

  Future<String> getTranslation(String valueName, String languageId) async {
    // Database db = await openDatabase('sishughar.db');
    List<Map<String, dynamic>> result =
        await await DatabaseHelper.database!.rawQuery(
      '''
  SELECT 
      CASE
          WHEN ? = 'en' THEN value_en
          WHEN ? = 'hi' THEN value_hi
          WHEN ? = 'od' THEN value_od
          ELSE value_en
      END AS translation
  FROM 
      translation_language
  WHERE 
      value_name = ?
  ''',
      [languageId, languageId, languageId, valueName],
    );
    // await db.close();
    return result.isNotEmpty ? result.first['translation'] : valueName;
  }

  Future<List<Translation>> callTranslateString(List<String> valueNames) async {
    List<String> lowerCaseNames =
        valueNames.map((name) => name.toLowerCase()).toList();
    print("startTime ${Validate().currentDateTime()}");
    String placeholders = List.filled(lowerCaseNames.length, '?').join(',');

    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
      'SELECT value_name, value_en, value_hi, value_od FROM translation_language WHERE LOWER(value_name) IN ($placeholders)',
      lowerCaseNames,
    );
    print("endTime ${Validate().currentDateTime()}");
    return result.map((element) {
      return Translation(
        name: element['value_name'].toString(),
        english: element['value_en'].toString(),
        hindi: element['value_hi'].toString(),
        odia: element['value_od'].toString(),
      );
    }).toList();
  }


  // Future<List<Translation>> callTranslateString(List<String> valueNames) async {
  //   String valueNameString =
  //       valueNames.map((name) => "'${name.toLowerCase()}'").join(',');

  //   List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
  //       'select * from translation_language where LOWER(value_name) in($valueNameString)');

  //   List<Translation> translationList = [];

  //   for (var element in result) {
  //     var item = new Translation(
  //         name: element['value_name'].toString(),
  //         english: element['value_en'].toString(),
  //         hindi: element['value_hi'].toString(),
  //         odia: element['value_od'].toString());
  //     translationList.add(item);
  //   }
  //   return translationList;
  // }

  Future<List<Translation>> callTranslateCreche() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from translation_language where value_name in(Select label from tabCrechefield where label IS NOT NULL and LENGTH(label) > 0)');

    List<Translation> translationList = [];

    for (var element in result) {
      var item = new Translation(
          name: element['value_name'].toString(),
          english: element['value_en'].toString(),
          hindi: element['value_hi'].toString(),
          odia: element['value_od'].toString());
      translationList.add(item);
    }
    return translationList;
  }

  Future<List<Translation>> callTranslateEnrolledChildren() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from translation_language where value_name in(Select label from tabchildprofilefield where label IS NOT NULL and LENGTH(label) > 0)');

    List<Translation> translationList = [];

    for (var element in result) {
      var item = new Translation(
          name: element['value_name'].toString(),
          english: element['value_en'].toString(),
          hindi: element['value_hi'].toString(),
          odia: element['value_od'].toString());
      translationList.add(item);
    }
    return translationList;
  }
}

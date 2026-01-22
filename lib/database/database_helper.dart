import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shishughar/database/helper/child_attendence/child_attendance_helper_responce.dart';
import 'package:shishughar/model/apimodel/auth_login_model.dart';
import 'package:shishughar/model/apimodel/login_model.dart';
import 'package:shishughar/model/databasemodel/child_attendance_responce_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? database;

  Future openDb() async {
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, 'sishughar.db');
    var exists = await databaseExists(path);
    if (!exists) {
      print("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets/db", "sishughar.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    database = await openDatabase(path,
        version: 7,
        onUpgrade: (db, oldVersion, newVersion) =>
            upgradeVersion(db, oldVersion, newVersion));

    return database;
  }

  Future<void> upgradeVersion(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion > 0) {
      if (oldVersion == 1 && newVersion > 1) {
        try {
          await db.execute(
              'ALTER TABLE child_attendance_responce ADD COLUMN date_of_attendance TEXT');
        } catch (e) {}
      }
      if (oldVersion == 2 && newVersion > 2) {
        try {
          await updateColoumnName(
              db, 'tabWeightforAgeGirls', 'age_in_days', 'age_in_months');
          await updateColoumnName(
              db, 'tabWeightforAgeBoys', 'age_in_days', 'age_in_months');
          await updateColoumnName(
              db, 'tabHeightforAgeBoys', 'age_in_days', 'age_in_months');
          await updateColoumnName(
              db, 'tabHeightforAgeGirls', 'age_in_days', 'age_in_months');

          await db.execute('''CREATE TABLE tabPartner_Stock (
            name INTEGER PRIMARY KEY,
            items TEXT,
            odia TEXT,
            hindi TEXT,
            stock_type TEXT,
            partner_id TEXT,
            item_required_per_child_per_months TEXT,
            is_active INTEGER,
            seq_id INTEGER
          );''');

          await db.execute('''CREATE TABLE tabMaster_Stock (
            name INTEGER PRIMARY KEY,
            stock TEXT,
            odia TEXT,
            hindi TEXT,
            is_active INTEGER,
            seq_id INTEGER
          );''');
        } catch (e) {
          print("$e");
        }
      }
      if (oldVersion == 3 && newVersion > 3) {
        try {
          Map<String, String> newColumns = {
            "l": "NUMERIC",
            "m": "NUMERIC",
            "s": "NUMERIC",
            "sd4neg": "NUMERIC",
            "sd3neg": "NUMERIC",
            "sd2neg": "NUMERIC",
            "sd1neg": "NUMERIC",
            "sd0": "NUMERIC",
            "sd1": "NUMERIC",
            "sd2": "NUMERIC",
            "sd3": "NUMERIC",
            "sd4": "NUMERIC",
          };
          // table tabWeightforAgeGirls
          await addColumnsToTable(db, 'tabWeightforAgeGirls', newColumns);

          // table tabWeightforAgeBoys
          await addColumnsToTable(db, 'tabWeightforAgeBoys', newColumns);

          // table tabHeightforAgeBoys
          await addColumnsToTable(db, 'tabHeightforAgeBoys', newColumns);

          // table tabHeightforAgeGirls
          await addColumnsToTable(db, 'tabHeightforAgeGirls', newColumns);

          // table tabWeightToHeightBoys
          await addColumnsToTable(db, 'tabWeightToHeightBoys', newColumns);

          // table tabWeightToHeightGirls
          await addColumnsToTable(db, 'tabWeightToHeightGirls', newColumns);

          // table tabWeightToHeightBoys
          await addNewColoumn(
              db, 'tabWeightToHeightBoys', 'age_type', 'INTEGER');

          // table tabWeightToHeightGirls
          await addNewColoumn(
              db, 'tabWeightToHeightGirls', 'age_type', 'INTEGER');

          await db.execute('''CREATE TABLE "backdated_configiration" (
	"name"	INTEGER,
	"unique_id"	TEXT,
	"supervisor_id"	TEXT,
	"doctype"	TEXT,
	"back_dated_data_entry_allowed"	INTEGER,
	"partner_id"	INTEGER,
	"data_edit_allowed"	INTEGER,
	"creation"	TEXT,
	"module"	TEXT,
	"type"	TEXT,
	"date"	TEXT,
	PRIMARY KEY("unique_id","type")
);''');
        } catch (e) {
          print("$e");
        }
      }
      if (oldVersion == 4 && newVersion > 4) {
        try {
          // table enrollred_exit_child_responce
          await addNewColoumn(db, 'enrollred_exit_child_responce',
              'reason_for_exit', 'INTEGER');
        } catch (e) {
          print("$e");
        }
      }
      if (oldVersion == 5 && newVersion > 5) {
        try {
          await db.execute('''CREATE TABLE "tabNativState" (
	                                                      "name"	INTEGER,
	                                                      "state_code"	TEXT,
	                                                      "value"	TEXT,
	                                                      "state_od"	TEXT,
	                                                      "state_hi"	TEXT
                                                      );''');

          await db.execute('''CREATE TABLE "tabNativeDistrict" (
                                            	"name"	INTEGER,
	                                            "state_id"	TEXT,
                                             	"district_code"	TEXT,
	                                            "value"	TEXT,
	                                            "district_od"	TEXT,
                                             	"district_hi"	TEXT
                                              );''');
        } catch (e) {
          print("$e");
        }
      }
      if (oldVersion == 6 && newVersion > 6) {
        try {
          await db.execute('''CREATE TABLE "tabCreche_Monitering_CheckList_SM" (
	"name"	TEXT,
	"idx"	INTEGER,
	"fieldtype"	TEXT,
	"fieldname"	TEXT,
	"reqd"	INTEGER,
	"label"	TEXT,
	"options"	TEXT,
	"parent"	TEXT,
	"hidden"	INTEGER,
	"length"	INTEGER,
	"depends_on"	TEXT,
	"mandatory_depends_on"	TEXT,
	"read_only_depends_on"	TEXT,
	"ismultiselect"	INTEGER,
	"multiselectlink"	TEXT
);''');

          await db.execute('''CREATE TABLE "tabCreche_Monitering_Checklist_SM_response" (
	"smguid"	TEXT,
	"name"	INTEGER,
	"responces"	TEXT,
	"is_edited"	INTEGER,
	"is_deleted"	INTEGER,
	"created_at"	TEXT,
	"created_by"	TEXT,
	"update_at"	TEXT,
	"updated_by"	TEXT,
	"is_uploaded"	INTEGER,
	"creche_id"	INTEGER,
	PRIMARY KEY("smguid")
);''');

          await db.execute(
              'ALTER TABLE translation_language ADD COLUMN value_kn TEXT');
          await db.execute(
              'ALTER TABLE mstCommon ADD COLUMN kannada TEXT');
          await db.execute(
              'ALTER TABLE tabNativState ADD COLUMN state_kn TEXT');
          await db.execute(
              'ALTER TABLE tabNativeDistrict ADD COLUMN district_kn TEXT');
          await db.execute(
              'ALTER TABLE tabState ADD COLUMN state_kn TEXT');
          await db.execute(
              'ALTER TABLE tabDistrict ADD COLUMN district_kn TEXT');
          await db.execute(
              'ALTER TABLE tabBlock ADD COLUMN block_kn TEXT');
          await db.execute(
              'ALTER TABLE tabGramPanchayat ADD COLUMN gp_kn TEXT');
          await db.execute(
              'ALTER TABLE tabVillage ADD COLUMN village_kn TEXT');
          await db.execute(
              'ALTER TABLE tabPartner_Stock ADD COLUMN kannada TEXT');
          await db.execute(
              'ALTER TABLE tabMaster_Stock ADD COLUMN kannada TEXT');
        } catch (e) {
          print("$e");
        }
      }
    }
  }

  Future insertLoginAuthModel(Auth tabUser) async {
    Database? db = await database;
    if (db != null) {
      print('Succesfull: Database is no null.');
      await db.insert('tabUser', tabUser.toJson());
    } else {
      print('Error: Database is null.');
    }
  }

  Future<List<LoginApiModel>> getLoginAuthdata() async {
    final List<Map<String, dynamic>> maps = await database!.query('tabUser');

    return List.generate(maps.length, (i) {
      return LoginApiModel.fromJson(maps[i]);
    });
  }

  Future deleteAllUsynchedRecords() async {
    await openDb();
    try {
      await database!.transaction((txn) async {
        await txn.delete('child_anthormentry_responce',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);
        await txn.delete('child_attendance_responce',
            where: "(is_edited = ? OR is_edited = ?)AND is_uploaded = ?",
            whereArgs: [1, 2, 0]);

        List<ChildAttendanceResponceModel> chilAttendence =
            await ChildAttendanceResponceHelper()
                .callChildAttendencesAllForUpoad();
        for (ChildAttendanceResponceModel element in chilAttendence) {
          await txn.delete('child_attendence',
              where: "childattenguid = ?", whereArgs: [element.childattenguid]);
        }

        await txn.delete('child_event_responce',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);

        await txn.delete('child_exit_responce',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);

        await txn.delete('grievances_responce',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);

        await txn.delete('child_referral_responce',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);

        await txn.delete('creche_committie_responce',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);

        await txn.delete('child_health_responce',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);
        await txn.delete('child_immunization_responce',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);

        await txn.delete('tab_creche_response',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);
        await txn.delete('tab_caregiver_response',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);
        await txn.delete('child_followup_responce',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);
        await txn.delete('house_hold_children',
            where: "is_edited = ? AND is_uploaded = ?", whereArgs: [1, 0]);
        await txn.delete('house_hold_responce',
            where: "(is_edited = ? OR is_edited = ?) AND is_uploaded = ?",
            whereArgs: [1, 2, 0]);

        await txn.delete('enrollred_chilren_responce',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);

        await txn.delete('check_in_response',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);

        await txn.delete('tabCreche_Monitering_Checklist_ALM_response',
            where: '(is_edited = ? OR is_edited = ?) AND is_uploaded = ?',
            whereArgs: [1, 2, 0]);
        await txn.delete('tabCreche_Monitering_Checklist_CBM_response',
            where: '(is_edited = ? OR is_edited = ?) AND is_uploaded = ?',
            whereArgs: [1, 0]);

        await txn.delete('tab_cashbook_expences_response',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);
        await txn.delete('tab_cashbook_receipt_response',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);

        await txn.delete('tab_creche_monitoring_response',
            where: '(is_edited = ? OR is_edited = ?) AND is_uploaded = ?',
            whereArgs: [1, 2, 0]);

        await txn.delete('tabCreche_Monitering_Checklist_CC_response',
            where: '(is_edited = ? OR is_edited = ?) AND is_uploaded = ?',
            whereArgs: [1, 2, 0]);
        // await txn.delete('tab_image_file');

        await txn.delete('tabVillage_response',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);
        await txn.delete('enrollred_exit_child_responce',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);

        await txn.delete('tabCreche_requisition_response',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);
        await txn.delete('tabCreche_stock_response',
            where: 'is_edited = ? AND is_uploaded = ?', whereArgs: [1, 0]);
      });
      print("Successfullt deleted Usynched records");
    } catch (e) {
      print("Failed deleting usynched records - $e");
    }
  }

  Future deleteAllRecords() async {
    await openDb();
    await database!.delete('sqlite_sequence');
    await database!.delete('tabChildGrowthMeta');
    await database!.delete('child_anthormentry_responce');
    await database!.delete('child_attendence');
    await database!.delete('tabChildAttendance');
    await database!.delete('child_attendance_responce');
    await database!.delete('child_event_responce');
    await database!.delete('tab_child_event');
    await database!.delete('child_exit_responce');
    await database!.delete('tab_child_exit');
    await database!.delete('grievances_responce');
    await database!.delete('tab_child_grievances');
    await database!.delete('child_referral_responce');
    await database!.delete('tab_creche_committe');
    await database!.delete('tab_child_referral');
    await database!.delete('tab_child_followup');
    await database!.delete('creche_committie_responce');
    await database!.delete('tab_child_health');
    await database!.delete('child_health_responce');
    await database!.delete('child_immunization_responce');
    await database!.delete('tab_child_immunization');
    await database!.delete('tab_creche_response');
    await database!.delete('tab_caregiver_response');
    await database!.delete('child_followup_responce');
    await database!.delete('house_hold_children');
    await database!.delete('house_hold_responce');
    await database!.delete('tabchildprofilefield');
    await database!.delete('enrollred_chilren_responce');
    await database!.delete('tabBlock');
    await database!.delete('tab_checkin_meta');
    await database!.delete('check_in_response');
    await database!.delete('tabCrechefield');
    await database!.delete('tabDistrict');
    await database!.delete('tabformsLogic');
    await database!.delete('tabGramPanchayat');
    await database!.delete('tabHeightforAgeBoys');
    await database!.delete('tabHeightforAgeGirls');
    await database!.delete('tabWeightforAgeBoys');
    await database!.delete('tabWeightforAgeGirls');
    await database!.delete('tabWeightToHeightBoys');
    await database!.delete('tabWeightToHeightGirls');
    await database!.delete('tabhouseholdfield');
    await database!.delete('modified_data');
    await database!.delete('mapping');
    await database!.delete('mst_supervisor_item');
    await database!.delete('tabState');
    await database!.delete('tabUser');
    await database!.delete('tabGender');
    await database!.delete('tabPartner');
    await database!.delete('tabPrimaryOccupation');
    await database!.delete('tabSocialCategory');
    await database!.delete('translation_language');
    await database!.delete('tabVerificationStatus');
    await database!.delete('tabVaccines');
    await database!.delete('tabVillage');
    await database!.delete('mstCommon');
    await database!.delete('tabCreche_Monitering_CheckList_ALM');
    await database!.delete('tabCreche_Monitering_CheckList_CMB');
    await database!.delete('tabCreche_Monitering_CheckList_SM');
    await database!.delete('tabCreche_Monitering_Checklist_ALM_response');
    await database!.delete('tabCreche_Monitering_Checklist_CBM_response');
    await database!.delete('tabCreche_Monitering_Checklist_SM_response');
    await database!.delete('tab_cashbook_expences_fields');
    await database!.delete('tab_cashbook_expences_response');
    await database!.delete('tab_cashbook_receipt_response');
    await database!.delete('tab_cashbook_receipts_fields');
    await database!.delete('tab_creche_monitoring_response');
    await database!.delete('tabCrecheMonitorMeta');
    await database!.delete('tabCreche_Monitering_CheckList_CC');
    await database!.delete('tabCreche_Monitering_Checklist_CC_response');
    await database!.delete('tab_image_file');
    await database!.delete('tab_village_profile_meta');
    await database!.delete('tabVillage_response');
    await database!.delete('enrollred_exit_child_responce');
    await database!.delete('tab_enrolled_exit_meta');
    await database!.delete('tabCreche_requisition_response');
    await database!.delete('tabCreche_stock_response');
    await database!.delete('tabCreche_stock_fields');
    await database!.delete('tabCreche_requisition_fields');
    await database!.delete('tabPartner_Stock');
    await database!.delete('tabMaster_Stock');
  }

  Future updateColoumnName(Database db, String tableName, String columnName,
      String oldColmnName) async {
    try {
      var tempTableName = '$tableName' + 'New';
      await db.execute('''CREATE TABLE $tempTableName (
          name INTEGER PRIMARY KEY,
          $columnName INTEGER,
          green NUMERIC,
          red NUMERIC,
          yellow_max NUMERIC,
          yellow_min NUMERIC
          );''');

      await db.execute(
          'INSERT INTO $tempTableName (name, $columnName, green,red,yellow_max,yellow_min) SELECT name, $oldColmnName, green,red,yellow_max,yellow_min FROM $tableName');
      await db.execute('DROP TABLE $tableName');
      await db.execute('ALTER TABLE $tempTableName RENAME TO $tableName');
    } catch (e) {
      print(e);
    }
  }

  Future addNewColoumn(Database db, String tableName, String columnName,
      String columnType) async {
    try {
      await db
          .execute('ALTER TABLE $tableName ADD COLUMN $columnName $columnType');
    } catch (e) {
      print(e);
    }
  }

  Future<void> addColumnsToTable(
      Database db, String tableName, Map<String, String> columns) async {
    // String query = "ALTER TABLE $tableName";
    //
    // // Convert the map into SQL statements
    // List<String> columnStatements = columns.entries
    //     .map((entry) => "ADD COLUMN ${entry.key} ${entry.value}")
    //     .toList();
    //
    // // Join columns with commas and append to query
    // query += " " + columnStatements.join(", ") + ";";
    // print(query);
    // try {
    //   await db.execute(query);
    // } catch (e) {
    //   print(e);
    // }
    for (var entry in columns.entries) {
      String query =
          "ALTER TABLE $tableName ADD COLUMN ${entry.key} ${entry.value};";
      try {
        await db.execute(query);
        print("Added column: ${entry.key} ${entry.value}");
      } catch (e) {
        print("Error adding column ${entry.key}: $e");
      }
    }
    // Print the query (for debugging)
  }
}

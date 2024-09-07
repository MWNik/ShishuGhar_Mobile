import 'dart:io';

import 'package:flutter/services.dart';
import 'package:shishughar/model/apimodel/auth_login_model.dart';
import 'package:shishughar/model/apimodel/login_model.dart';
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
        version: 2,
        onUpgrade: (db, oldVersion, newVersion) =>
            upgradeVersion(db, oldVersion, newVersion));

    return database;
  }

  Future<void> upgradeVersion(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion > 0) {
       if (oldVersion==1 && newVersion == 2) {
         try {
           await db.execute(
               'ALTER TABLE child_attendance_responce ADD COLUMN date_of_attendance TEXT');
         }catch(e){

         }
       }
      //   await db.execute(
      //     'CREATE TABLE tabMaster_Stock(name	INTEGER PRIMARY KEY,stock	TEXT,odia	TEXT,hindi	TEXT,is_active	INTEGER, seq_id	INTEGER)',
      //   );

      //   // await db.execute(
      //   //   'CREATE TABLE tabPartner_Stock(name INTEGER PRIMARY KEY,items	TEXT,odia	TEXT,hindi	TEXT,stock_type	INTEGER,partner_id	INTEGER,item_required_per_child_per_months	INTEGER,is_active	INTEGER, seq_id	INTEGER)',
      //   // );
      //   // await db.execute(
      //   //   'CREATE TABLE tabCreche_requisition_fields (name	TEXT,idx	INTEGER,fieldtype	TEXT,fieldname	TEXT,reqd	INTEGER,label	TEXT,options	TEXT,parent	TEXT,hidden	INTEGER,length	INTEGER,depends_on	TEXT,mandatory_depends_on	TEXT,read_only_depends_on	TEXT,ismultiselect	INTEGER,multiselectlink	TEXT)',
      //   // );
      //   //
      //   // await db.execute(
      //   //   'CREATE TABLE tabCreche_stock_fields (name	TEXT,idx	INTEGER,fieldtype	TEXT,fieldname	TEXT,reqd	INTEGER,label	TEXT,options	TEXT,parent	TEXT,hidden	INTEGER,length	INTEGER,depends_on	TEXT,mandatory_depends_on	TEXT,read_only_depends_on	TEXT,ismultiselect	INTEGER,multiselectlink	TEXT)',
      //   // );
      //   //
      //   // await db.execute(
      //   //   'CREATE TABLE tabCreche_requisition_response (rguid	TEXT PRIMARY KEY,name	INTEGER,responces	TEXT,is_edited	INTEGER,is_deleted	INTEGER,created_at	TEXT,created_by	TEXT,update_at	TEXT,updated_by	TEXT,is_uploaded	INTEGER,creche_id	INTEGER,month	INTEGER,year	INTEGER,item_id	INTEGER)',
      //   // );
      //   //
      //   // await db.execute(
      //   //   'CREATE TABLE tabCreche_stock_response (sguid	TEXT PRIMARY KEY,name	INTEGER,responces	TEXT,is_edited	INTEGER,is_deleted	INTEGER,created_at	TEXT,created_by	TEXT,update_at	TEXT,updated_by	TEXT,is_uploaded	INTEGER,creche_id	INTEGER,month	INTEGER,year	INTEGER,item_id	INTEGER)',
      //   // );
      // }
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
    await database!.delete('tabCreche_Monitering_Checklist_ALM_response');
    await database!.delete('tabCreche_Monitering_Checklist_CBM_response');
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
    // await database!.delete('tabCreche_stock_fields');
    // await database!.delete('tabCreche_stock_response');
    // await database!.delete('tabCreche_requisition_fields');
    // await database!.delete('tabCreche_requisition_response');
  }
}

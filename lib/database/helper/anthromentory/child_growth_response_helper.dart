import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../../model/apimodel/house_hold_field_item_model_api.dart';
import '../../../model/databasemodel/child_growth_responce_model.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import '../../database_helper.dart';

class ChildGrowthResponseHelper {
  Future<void> inserts(ChildGrowthMetaResponseModel items) async {
    await DatabaseHelper.database!.insert(
        'child_anthormentry_responce', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<HouseHoldFielItemdModel>> getChildHHFieldsForm(
      String parents) async {
    String query =
        'select * from tabChildGrowthMeta where  hidden=0 ORDER by idx asc';
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query);

    List<HouseHoldFielItemdModel> houseHoldFieldItem = [];

    for (var element in result) {
      HouseHoldFielItemdModel state = HouseHoldFielItemdModel.fromJson(element);
      houseHoldFieldItem.add(state);
    }
    return houseHoldFieldItem;
  }

  Future<List<ChildGrowthMetaResponseModel>> anthormentryByCreche(
      int creche_id) async {
    var query =
        'Select * from  child_anthormentry_responce  where creche_id=? ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [creche_id]);

    List<ChildGrowthMetaResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildGrowthMetaResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildGrowthMetaResponseModel>> anthormentryByCrecheLimit12(
      int creche_id) async {
    var query =
        'Select * from  child_anthormentry_responce  where creche_id=?  ORDER by created_at  DESC limit 12';//

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query, [creche_id]);

    List<ChildGrowthMetaResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildGrowthMetaResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildGrowthMetaResponseModel>> anthormentryByCrecheINChild(
      int creche_id) async {
    var query =
        'Select * from  child_anthormentry_responce  where creche_id=? and responces NOTNULL ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [creche_id]);

    List<ChildGrowthMetaResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildGrowthMetaResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildGrowthMetaResponseModel>> anthormentryByCrecheIdAsc(
      int creche_id) async {
    var query =
        'Select * from  child_anthormentry_responce  where creche_id=? and responces NOTNULL ORDER BY strftime(?, measurement_date)  Asc';

    List<Map<String, dynamic>> result =
    await DatabaseHelper.database!.rawQuery(query, [creche_id,'%Y-%m-%d']);

    List<ChildGrowthMetaResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildGrowthMetaResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildGrowthMetaResponseModel>> callAnthropometryByGuid(
      String cgmGuid) async
  {
    var query = 'Select * from  child_anthormentry_responce where cgmguid=?';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [cgmGuid]);

    List<ChildGrowthMetaResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildGrowthMetaResponseModel.fromJson(itemMap));
    });

    return items;
  }


Future<ChildGrowthMetaResponseModel?> callMaxAnthroResponce(
      int creche_id,String mesurementDate) async
  {
    // var query = 'select * from child_anthormentry_responce where creche_id=? and responces NOTNULL ORDER by measurement_date DESC LIMIT 1';
    var query = 'SELECT *FROM child_anthormentry_responce WHERE creche_id = ? AND responces IS NOT NULL AND measurement_date IS NOT NULL AND strftime(?, measurement_date) < ? ORDER BY strftime(?, measurement_date) DESC limit 1;';

    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(query, [creche_id,'%Y-%m-%d',mesurementDate,'%Y-%m-%d']);
    if(result.length>0){
    return ChildGrowthMetaResponseModel.fromJson(result.first);
    }else null;
    return null;
  }

  Future<List<ChildGrowthMetaResponseModel>>
      callChildGrowthResponsesForUpload() async {
    var query =
        'Select * from  child_anthormentry_responce where is_edited=1 and responces NOTNULL';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query);

    List<ChildGrowthMetaResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildGrowthMetaResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> insertUpdate(
      String cgmguid,
      String? measurementDate,
      int? name,
      int? creche_name,
      String? responces,
      String? created_by,
      String? created_at,String? update_at,String? updated_by) async {
    var item = ChildGrowthMetaResponseModel(
        cgmguid: cgmguid,
        responces: responces,
        is_uploaded: 0,
        is_edited: 1,
        is_deleted: 0,
        name: name,
        creche_id: creche_name,
        created_by: created_by,
        measurement_date: measurementDate,
        update_at:update_at,
        updated_by:updated_by,
        created_at: created_at);
    await DatabaseHelper.database!.insert(
        'child_anthormentry_responce', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> childGrowthMetaData(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> growth =
        List<Map<String, dynamic>>.from(item['Data']);

    // List to hold child growth data models
    List<ChildGrowthMetaResponseModel> growthItems = [];

    // Prepare data
    for (var element in growth) {
      var growthData = element['Child Growth Monitoring'];

      var name = growthData['name'];
      var crecheId = growthData['creche_id'];
      var cgmguid = growthData['cgmguid'];
      var appCreatedOn = growthData['created_on'];
      var appCreatedBy = growthData['created_by'];
      var appUpdatedBy = growthData['updated_by'];
      var appUpdatedOn = growthData['updated_on'];
      var measurementDate = growthData['measurement_date'];
      var finalHHData = Validate().keyesFromResponce(growthData);
      var hhDataResponse = jsonEncode(finalHHData);

      // Add the growth data model to the list
      growthItems.add(
        ChildGrowthMetaResponseModel(
          cgmguid: cgmguid,
          name: name,
          is_uploaded: 1,
          is_edited: 0,
          is_deleted: 0,
          creche_id: Global.stringToInt(crecheId),
          update_at: appUpdatedOn,
          updated_by: appUpdatedBy,
          created_at: appCreatedOn,
          created_by: appCreatedBy,
          measurement_date: measurementDate,
          responces: hhDataResponse,
        ),
      );
    }

    // Commit data in a transaction using batch
    await DatabaseHelper.database!.transaction((txn) async {
      var batch = txn.batch();

      // Add all growth items to the batch
      for (var item in growthItems) {
        batch.insert(
          'child_anthormentry_responce',
          item.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Commit the batch
      await batch.commit(noResult: true);
    });

    print('Child Growth Meta data successfully inserted.');
  }

  // Future<void> childGrowthMetaData(Map<String, dynamic> item) async {
  //   List<Map<String, dynamic>> growth =
  //   List<Map<String, dynamic>>.from(item['Data']);
  //   print(growth);
  //   growth.forEach((element) async {
  //     var growthData = element['Child Growth Monitoring'];

  //     var name = growthData['name'];
  //     var creche_id = growthData['creche_id'];
  //     var cgmguid = growthData['cgmguid'];
  //     var appCreatedOn = growthData['created_on'];
  //     var appcreated_by = growthData['created_by'];
  //     var app_updated_by = growthData['updated_by'];
  //     var app_updated_on = growthData['updated_on'];
  //     var measurement_date = growthData['measurement_date'];
  //     var finalHHData = Validate().keyesFromResponce(growthData);
  //     var hhDtaResponce = jsonEncode(finalHHData);

  //     var items = ChildGrowthMetaResponseModel(
  //       cgmguid: cgmguid,
  //       name: name,
  //       is_uploaded: 1,
  //       is_edited: 0,
  //       is_deleted: 0,
  //       creche_id: Global.stringToInt(creche_id),
  //       update_at: app_updated_on,
  //       updated_by: app_updated_by,
  //       created_at: appCreatedOn,
  //       created_by: appcreated_by,
  //       measurement_date: measurement_date,
  //       responces: hhDtaResponce,
  //     );
  //     await inserts(items);
  //   });
  // }

  Future<List<ChildGrowthMetaResponseModel>> callChildGrowthResponses() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_anthormentry_responce where is_edited = 1 and responces NOTNULL');

    List<ChildGrowthMetaResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildGrowthMetaResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildGrowthMetaResponseModel>> getChildGrowthResponceItem(
      int name) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from child_anthormentry_responce where name=?', [name]);
    List<ChildGrowthMetaResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(ChildGrowthMetaResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<void> updateUploadedChildGrowthResponce(
      Map<String, dynamic> item, String dataResponce) async {
    Map<String, dynamic> CiData = item['Data'];

    var name = CiData['name'];
    var cgmguid = CiData['cgmguid'];
    List<Map<String, dynamic>> children =
        List<Map<String, dynamic>>.from(CiData['anthropromatic_details']);
    Map<String, dynamic> uploadeData = jsonDecode(dataResponce);
    List<Map<String, dynamic>> uploadedChild =
        List<Map<String, dynamic>>.from(uploadeData['anthropromatic_details']);
    uploadeData['name'] = name;
    List<dynamic> finalChild = [];
    children.forEach((element) {
      var childName = element['name'];
      var childenrollguid = element['childenrollguid'];
      var filChildItem = uploadedChild
          .where((element) => element['childenrollguid'] == childenrollguid)
          .toList();
      if (filChildItem.length > 0) {
        var childMap = filChildItem[0];
        childMap['name'] = childName;
        finalChild.add(childMap);
      }
    });
    uploadeData['anthropromatic_details'] = finalChild;
    var jsonF = jsonEncode(uploadeData);
    print('uploadReturnJson $jsonF');

    await DatabaseHelper.database!.rawQuery(
        'UPDATE child_anthormentry_responce SET name = ?  ,responces = ?  , is_uploaded=1 , is_edited=0 where cgmguid=?',
        [name, jsonF, cgmguid]);
  }

  Future<List<ChildGrowthMetaResponseModel>> allAnthormentry() async {
    var query =
        'Select * from  child_anthormentry_responce where responces NOTNULL';

    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
      query,
    );

    List<ChildGrowthMetaResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildGrowthMetaResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildGrowthMetaResponseModel>> allAnthormentryOrderBy(int creche_id) async {
    var query =
        'Select * from  child_anthormentry_responce where responces NOTNULL and creche_id =? ORDER by measurement_date ';

    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
      query,[creche_id]
    );

    List<ChildGrowthMetaResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildGrowthMetaResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildGrowthMetaResponseModel>> allAnthormentryDisableOCT() async {
    var query =
        'Select * from  child_anthormentry_responce where responces NOTNULL and measurement_date >=?';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, ['2024-10-01']);

    List<ChildGrowthMetaResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildGrowthMetaResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildGrowthMetaResponseModel>> anthroByReferral(
      String child_referral_guid)
  async {
    var query =
        'select * from child_anthormentry_responce where cgmguid = (select cgmguid from child_referral_responce where child_referral_guid=?) ORDER BY CASE  WHEN update_at IS NOT NULL AND length(RTRIM(LTRIM(update_at))) > 0 THEN update_at ELSE created_at END DESC';

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.rawQuery(query, [child_referral_guid]);

    List<ChildGrowthMetaResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildGrowthMetaResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildGrowthMetaResponseModel>> lastAnthroRecord(
      String childenrolledguid, String lastRecordDate) async {
    var query =
        '''select * from child_anthormentry_responce where cgmguid =(select cgmguid from child_referral_responce WHERE strftime('%Y-%m-%d', date_of_referral) < ? and childenrolledguid=?  ORDER BY strftime('%Y-%m-%d', date_of_referral) DESC limit 1)''';

    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery(query, [lastRecordDate, childenrolledguid]);

    List<ChildGrowthMetaResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildGrowthMetaResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<ChildGrowthMetaResponseModel>> anthroDataForEnrolledAdd(
      String selectedDate, int crecheId) async {

    var query =
    'SELECT * FROM child_anthormentry_responce WHERE strftime(?, measurement_date) = ? AND creche_id = ? and responces NOTNULL ORDER BY measurement_date DESC limit 1';

    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery(query, ['%Y-%m', selectedDate,crecheId]);

    List<ChildGrowthMetaResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildGrowthMetaResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<Map<String, dynamic>>> excuteIsNotSubmitedDate() async {
    return await DatabaseHelper.database!.rawQuery(
      '''SELECT * FROM ( SELECT    creche_id,    MIN(max_month) AS min_of_max_months  FROM ( SELECT  creche_id,    MAX(strftime('%Y-%m', date(measurement_date))) AS max_month FROM  child_anthormentry_responce GROUP BY creche_id ) WHERE max_month < strftime('%Y-%m', 'now')) AS date_records LEFT JOIN tab_creche_response AS creche  ON date_records.creche_id = creche.name''',
    );
  }

  Future<List<ChildGrowthMetaResponseModel>> excuteGrowthMonitoring(String enrollmentGuid) async {
    var query =
    'select *  from child_anthormentry_responce where responces like ? ';

    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery(query, ['%childenrollguid":"$enrollmentGuid%']);

    List<ChildGrowthMetaResponseModel> items = [];
    result.forEach((itemMap) {
      items.add(ChildGrowthMetaResponseModel.fromJson(itemMap));
    });

    return items;
  }
}

import 'dart:convert';

import 'package:shishughar/model/dynamic_screen_model/stock_response_model.dart';

import 'package:shishughar/utils/globle_method.dart';
import 'package:shishughar/utils/validate.dart';
import 'package:sqflite/sqflite.dart';

import '../../database_helper.dart';

class StockResponseHelper {
  Future<void> inserts(StockResponseModel items) async {
    await DatabaseHelper.database!.insert(
        'tabCreche_stock_response', items.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    print("object");
  }

  Future<List<StockResponseModel>> getStockByName(int vName) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_stock_response where name=?', [vName]);
    List<StockResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(StockResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<StockResponseModel>> getAllStockRecords() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
      'select * from tabCreche_stock_response',
    );
    List<StockResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(StockResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<StockResponseModel>> getStockForUpload() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from tabCreche_stock_response where is_edited=1');
    List<StockResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(StockResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<StockResponseModel>> gteStockByGuid(String SGuid) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_stock_response where sguid=?', [SGuid]);
    List<StockResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(StockResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<StockResponseModel>> gteStockByGuidMonthYear(
      String SGuid, int month, int year) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_stock_response where sguid=? and month =? and year=?',
        [SGuid]);
    List<StockResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(StockResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<StockResponseModel>> getStockByCreche(int creche_id) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_stock_response where creche_id=?',
        [creche_id]);
    List<StockResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(StockResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<StockResponseModel>> getStockByMonth(int creche_id) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select DISTINCT month,year from tabCreche_stock_response where creche_id =?',
        [creche_id]);
    List<StockResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(StockResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<StockResponseModel>> getStockByYearnMonth(
      int creche_id, int month, int year) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabCreche_stock_response where creche_id =? and month=? and year=?',
        [creche_id, month, year]);
    List<StockResponseModel> items = [];

    result.forEach((itemMap) {
      items.add(StockResponseModel.fromJson(itemMap));
    });

    return items;
  }

  Future<List<Map<String, dynamic>>> getStockresponseByYearMonth(
    int creche_id,
  ) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'SELECT stock.*,requ.responces as RResponce FROM tabCreche_requisition_response requ left join tabCreche_stock_response as stock on requ.year=stock.year and requ.month=stock.month and requ.creche_id=stock.creche_id where requ.creche_id=? ORDER BY requ.year DESC, requ.month DESC',
        [creche_id]);

    return result;
  }
  Future<List<Map<String, dynamic>>> getPrevStockresponseByYearMonth(
    int creche_id,int year,int month
  ) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select s.* from (select *,((year*12)+month) as f from tabCreche_stock_response) s INNER join (SELECT creche_id,Max(((year*12)+month))  as d from tabCreche_stock_response where creche_id =? and ((year*12)+month)<((?*12)+?))d on s.creche_id=d.creche_id and s.f=d.d',
        [creche_id,year,month]);

    return result;
  }

  Future<void> updateUploadedItem(Map<String, dynamic> item) async {
    var hhData = item['data'];
    var cename = hhData['name'];
    var guid = hhData['sguid'];
    await DatabaseHelper.database!.rawQuery(
        'UPDATE tabCreche_stock_response SET  name=?, is_uploaded=1 , is_edited=0 where sguid = ?',
        [cename, guid]);
  }

  Future<void> StockDataDownload(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> growth =
        List<Map<String, dynamic>>.from(item['Data']);
    print(growth);
    growth.forEach((element) async {
      var growthData = element['Creche Stock'];

      var items = StockResponseModel(
          sguid: growthData['sguid'],
          creche_id: Global.stringToInt(growthData['creche_id']),
          name: growthData['name'],
          is_uploaded: 1,
          is_edited: 0,
          is_deleted: 0,
          update_at: growthData['app_updated_on'],
          updated_by: growthData['app_updated_by'],
          created_at: growthData['appcreated_on'],
          created_by: growthData['appcreated_by'],
          item_id: Global.stringToInt(growthData['stock_item'].toString()),
          responces: await jsonEncode(Validate().keyesFromResponce(growthData)),
          year: Global.stringToInt(growthData['year'].toString()),
          month: Global.stringToInt(growthData['month'].toString()));
      await inserts(items);
    });
  }
}

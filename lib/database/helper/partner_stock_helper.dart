import 'package:shishughar/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/apimodel/partner_stock_model.dart';

class PartnerStockHelper {
  DatabaseHelper database = DatabaseHelper();

  Future insert(List<PartnerStockModel> PartnerStockModel) async {
    await DatabaseHelper.database!.delete('tabPartner_Stock');
    if (PartnerStockModel.isNotEmpty) {
      for (var element in PartnerStockModel) {
        await DatabaseHelper.database!.insert(
            'tabPartner_Stock', element.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  Future<List<PartnerStockModel>> getAllRecords() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from tabPartner_Stock order by seq_id asc');

    List<PartnerStockModel> itemsList = [];

    for (var elements in result) {
      PartnerStockModel data = PartnerStockModel.fromJson(elements);
      itemsList.add(data);
    }

    return itemsList;
  }

  Future<List<PartnerStockModel>> getNotAddedItems(
      int creche_id, int year, int month) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabPartner_Stock where name not in(select item_id from tabCreche_requisition_response where creche_id=? and item_id NOTNULL  and year=? and month=?) order By seq_id ASC',
        [creche_id, year, month]);

    List<PartnerStockModel> itemsList = [];

    for (var element in result) {
      PartnerStockModel data = PartnerStockModel.fromJson(element);
      itemsList.add(data);
    }
    return itemsList;
  }

  Future<List<PartnerStockModel>> getItemnyName(int name) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from tabPartner_Stock where name = ? and item_required_per_child_per_months is NOT NULL',
        [name]);

    List<PartnerStockModel> itemsList = [];

    for (var element in result) {
      PartnerStockModel data = PartnerStockModel.fromJson(element);
      itemsList.add(data);
    }
    return itemsList;
  }
}

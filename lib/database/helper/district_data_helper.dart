

import 'package:shishughar/model/databasemodel/tabDistrict_model.dart';

import '../database_helper.dart';

class DistrictDataHelper {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<TabDistrict>> getTabDistrictList() async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.query('tabDistrict',orderBy: 'value ASC');

    List<TabDistrict> tabDistrictList = [];

    for (var element in result) {
      TabDistrict district = TabDistrict.fromJson(element);
      tabDistrictList.add(district);
    }
    return tabDistrictList;
  }


  Future<List<TabDistrict>> getDistrictListByDistrictId(List<int>districtId) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery('Select * from tabDistrict where name in(${districtId.join(', ')}) order By value ASC');

    List<TabDistrict> tabDistrictList = [];

    for (var element in result) {
      TabDistrict district = TabDistrict.fromJson(element);
      tabDistrictList.add(district);
    }
    return tabDistrictList;
  }

  Future<void> insertMasterDistrict(
      List<TabDistrict> districtList) async {
    await DatabaseHelper.database!.delete('tabDistrict');
    if (districtList.isNotEmpty) {
      for (var element in districtList) {
        await DatabaseHelper.database!.insert('tabDistrict', element.toJson());
      }
    }
  }

}

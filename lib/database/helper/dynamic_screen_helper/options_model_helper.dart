import 'dart:convert';



import 'package:shishughar/database/helper/partner_stock_helper.dart';
import 'package:shishughar/model/apimodel/partner_stock_model.dart';

import '../../../model/dynamic_screen_model/house_hold_tab_responce_model.dart';
import '../../../model/dynamic_screen_model/options_model.dart';
import '../../../utils/globle_method.dart';
import '../../../utils/validate.dart';
import '../../database_helper.dart';
import '../creche_helper/creche_data_helper.dart';

class OptionsModelHelper {
  // DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<OptionsModel>> getOptions(String tableName) async {
    var tabName = 'tab$tableName'.replaceAll(" ", "");

    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.query(tabName, orderBy: 'value ASC');

    List<OptionsModel> optionsModel = [];

    for (var element in result) {
      print(element);
      var item = new OptionsModel(
          name: element['name'].toString(),
          values: element['value'].toString(),
          flag: 'tab$tableName');
      optionsModel.add(item);
      print("it ${item.name}");
    }

    return optionsModel;
  }

  Future<List<OptionsModel>> getLocationData(
      String tableName, Map<String, dynamic> responseData, String lng) async {
    var tabName = 'tab$tableName'.replaceAll(" ", "");
    int? selectedLocation;
    String? selectedLocationID;
    if (responseData.isNotEmpty) {
      if (tableName == "State") {
        selectedLocationID = responseData['state_id'];
      } else if (tableName == "District") {
        selectedLocationID = responseData['district_id'];
      } else if (tableName == "Block") {
        selectedLocationID = responseData['block_id'];
      } else if (tableName == "Gram Panchayat") {
        selectedLocationID = responseData['gp_id'];
      } else if (tableName == "Village") {
        selectedLocationID = responseData['village_id'];
      }
    } else {
      if (tableName == "State") {
        selectedLocation = await Validate().readInt(Validate.stateID);
      } else if (tableName == "District") {
        selectedLocation = await Validate().readInt(Validate.districtID);
      } else if (tableName == "Block") {
        selectedLocation = await Validate().readInt(Validate.blockID);
      } else if (tableName == "Gram Panchayat") {
        selectedLocation = await Validate().readInt(Validate.gramPanchayatID);
      } else if (tableName == "Village") {
        selectedLocation = await Validate().readInt(Validate.villageId);
      }
    }

    List<Map<String, dynamic>> result;
    if (selectedLocation != null) {
      result = await DatabaseHelper.database!.rawQuery(
          'select * from $tabName WHERE name=? ORDER BY value ASC',
          [selectedLocation]);
    } else if (selectedLocationID != null) {
      result = await DatabaseHelper.database!.rawQuery(
          'select * from $tabName WHERE name=? '
          'ORDER BY value ASC',
          [selectedLocationID]);
    } else {
      result = await DatabaseHelper.database!.query(tabName);
    }

    List<OptionsModel> optionsModel = [];
    if (result.isNotEmpty) {
      for (var element in result) {
        print(element);
        var item = new OptionsModel(
            name: element['name'].toString(),
            values: callLocationTranlateValue(tableName, element, lng),
            flag: 'tab$tableName');
        optionsModel.add(item);
        print("it ${item.name}");
      }
    }
    return optionsModel;
  }

  Future<List<OptionsModel>> getDistrict(String tableName) async {
    var tabName = 'tab$tableName'.replaceAll(" ", "");
    List<Map<String, dynamic>> result =
        await DatabaseHelper.database!.query(tabName, orderBy: 'value ASC');

    List<OptionsModel> optionsModel = [];

    for (var element in result) {
      print(element);
      var item = new OptionsModel(
          name: element['name'].toString(),
          values: element['value'].toString(),
          flag: 'tab$tableName');
      optionsModel.add(item);
      print("it ${item.name}");
    }
    return optionsModel;
  }
  Future<List<OptionsModel>> getYearOptions() async {
    String flag = 'tabYear';
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery('select * from mstCommon where flag=? order by seq_id  ASC',[flag]);

    List<OptionsModel> options = [];
    for(var element in result){
      var item = new OptionsModel(name: element['name'].toString(),values: element['value'].toString(),flag: flag);
      options.add(item);
    }
    return options;
  }

  Future<List<OptionsModel>> getMstCommonOptions(
      String tableName, String lang) async {
    // var tabName='tab$tableName'.replaceAll(" ", "");
    var tabName = 'tab$tableName';
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from mstCommon where flag=? order by CASE WHEN value LIKE ? THEN 1 ELSE 0 END,  seq_id  ASC',
        [tabName, '%other%']);

    List<OptionsModel> optionsModel = [];

    for (var element in result) {
      print(element);
      var value = element['value'].toString();
      if (lang == 'hi' && Global.validString(element['hindi'].toString())) {
        value = element['hindi'].toString();
      } else if (lang == 'od' &&
          Global.validString(element['oidya'].toString())) {
        value = element['oidya'].toString();
      }
      var item = new OptionsModel(
          name: element['name'].toString(),
          values: value,
          flag: element['flag'].toString());
      optionsModel.add(item);
      print("it ${item.name}");
    }
    return optionsModel;
  }

  Future<List<OptionsModel>> callDayOfWeekMstCommonOptions(
      String tableName, String lang) async {
    // var tabName='tab$tableName'.replaceAll(" ", "");
    var tabName = 'tab$tableName';
    List<Map<String, dynamic>> result = await DatabaseHelper.database!
        .rawQuery('select * from mstCommon where flag=?', [tabName]);

    List<OptionsModel> optionsModel = [];

    for (var element in result) {
      print(element);
      var value = element['value'].toString();
      if (lang == 'hi' && Global.validString(element['hindi'].toString())) {
        value = element['hindi'].toString();
      } else if (lang == 'od' &&
          Global.validString(element['oidya'].toString())) {
        value = element['oidya'].toString();
      }
      var item = new OptionsModel(
          name: element['name'].toString(),
          values: value,
          flag: element['flag'].toString());
      optionsModel.add(item);
      print("it ${item.name}");
    }
    return optionsModel;
  }

  Future<List<OptionsModel>> getAllMstCommonOptions(String lang) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'SELECT * FROM mstCommon WHERE flag NOT IN (?) order by CASE WHEN value LIKE ? THEN 1 ELSE 0 END,  seq_id  ASC',
        ['tabPartner', '%other%']);

    List<OptionsModel> optionsModel = [];

    for (var element in result) {
      var value = element['value'].toString();
      if (lang == 'hi' && Global.validString(element['hindi'].toString())) {
        value = element['hindi'].toString();
      } else if (lang == 'od' &&
          Global.validString(element['oidya'].toString())) {
        value = element['oidya'].toString();
      }
      print(element);
      var item = new OptionsModel(
          name: element['name'].toString(),
          values: value,
          flag: element['flag'].toString());
      optionsModel.add(item);
      print("it ${item.name}");
    }
    return optionsModel;
  }

  Future<List<OptionsModel>> getAllMstCommonNotINOptions(
      List<String> defaultCommon, String lang) async {
    String questionMarks = List.filled(defaultCommon.length, '?').join(',');
    List<dynamic> parameters = [...defaultCommon, '%other%'];
    print(defaultCommon);
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'SELECT * FROM mstCommon WHERE flag  IN ($questionMarks) order by CASE WHEN value LIKE ? THEN 1 ELSE 0 END,  seq_id  ASC',
        parameters);

    List<OptionsModel> optionsModel = [];

    for (var element in result) {
      var value = element['value'].toString();
      if (lang == 'hi' && Global.validString(element['hindi'].toString())) {
        value = element['hindi'].toString();
      } else if (lang == 'od' &&
          Global.validString(element['oidya'].toString())) {
        value = element['oidya'].toString();
      }
      print(element);
      var item = new OptionsModel(
          name: element['name'].toString(),
          values: value,
          flag: element['flag'].toString());
      optionsModel.add(item);
      print("it ${item.name}");
    }
    return optionsModel;
  }

  Future<List<OptionsModel>> getAllMstCommonNotINPartenerStock(String flag,
      int crechId, String rguid, int year, int month, String lang) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from mstCommon WHERE flag=? and  name not in(select item_id from tabCreche_requisition_response where creche_id=? and item_id NOTNULL and rguid!=? and year=? and month=?) order by CASE WHEN value LIKE ? THEN 1 ELSE 0 END,  seq_id  ASC',
        [flag, crechId, rguid, year, month, '%other%']);

    List<OptionsModel> optionsModel = [];

    for (var element in result) {
      var value = element['value'].toString();
      if (lang == 'hi' && Global.validString(element['hindi'].toString())) {
        value = element['hindi'].toString();
      } else if (lang == 'od' &&
          Global.validString(element['oidya'].toString())) {
        value = element['oidya'].toString();
      }
      print(element);
      var item = new OptionsModel(
          name: element['name'].toString(),
          values: value,
          flag: element['flag'].toString());
      optionsModel.add(item);
      print("it ${item.name}");
    }
    return optionsModel;
  }

  Future<List<OptionsModel>> getAllMstCommonNotINPartenerStockWithoyExisting(
      String flag, int crechId, int year, int month, String lang) async {
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'select * from mstCommon WHERE flag=? and  name not in(select item_id from tabCreche_requisition_response where creche_id=? and item_id NOTNULL  and year=? and month=?) order by CASE WHEN value LIKE ? THEN 1 ELSE 0 END,  seq_id  ASC',
        [flag, crechId, year, month, '%other%']);

    List<OptionsModel> optionsModel = [];

    for (var element in result) {
      var value = element['value'].toString();
      if (lang == 'hi' && Global.validString(element['hindi'].toString())) {
        value = element['hindi'].toString();
      } else if (lang == 'od' &&
          Global.validString(element['oidya'].toString())) {
        value = element['oidya'].toString();
      }
      print(element);
      var item = new OptionsModel(
          name: element['name'].toString(),
          values: value,
          flag: element['flag'].toString());
      optionsModel.add(item);
      print("it ${item.name}");
    }
    return optionsModel;
  }

  Future<List<OptionsModel>> getAllMstCommonNotINOptionsWthouASC(
      List<String> defaultCommon, String lang) async {
    String questionMarks = List.filled(defaultCommon.length, '?').join(',');
    List<dynamic> parameters = [...defaultCommon];
    print(defaultCommon);
    List<Map<String, dynamic>> result = await DatabaseHelper.database!.rawQuery(
        'SELECT * FROM mstCommon WHERE flag  IN ($questionMarks)', parameters);

    List<OptionsModel> optionsModel = [];

    for (var element in result) {
      print(element);
      var value = element['value'].toString();
      if (lang == 'hi' && Global.validString(element['hindi'].toString())) {
        value = element['hindi'].toString();
      } else if (lang == 'od' &&
          Global.validString(element['oidya'].toString())) {
        value = element['oidya'].toString();
      }
      var item = new OptionsModel(
          name: element['name'].toString(),
          values: value,
          flag: element['flag'].toString());
      optionsModel.add(item);
      print("it ${item.name}");
    }
    return optionsModel;
  }

  Future<List<OptionsModel>> getPartnerMstCommonOptions(
      String tableName, Map<String, dynamic> items) async {
    var tabName = 'tab$tableName';
    List<OptionsModel> optionsModel = [];
    if (tableName == 'Partner') {
      var userName = await Validate().readString(Validate.userName);
      List<
          Map<String,
              dynamic>> result = await DatabaseHelper.database!.rawQuery(
          'select * from mstCommon where flag=? and name=(select partner from tabUser where username=?)',
          [tabName, userName]);

      for (var element in result) {
        print(element);
        var item = new OptionsModel(
            name: element['name'].toString(),
            values: element['value'].toString(),
            flag: element['flag'].toString());
        optionsModel.add(item);
        print("it ${item.name}");
      }
    } else if (tableName == 'User') {
      String? supId = items['supervisor_id'];
      List<Map<String, dynamic>> result = [];
      if (Global.validString(supId)) {
        result = await DatabaseHelper.database!.rawQuery(
            'select * from mst_supervisor_item where email=?', [supId]);
      } else {
        result = await DatabaseHelper.database!
            .rawQuery('select * from mst_supervisor_item');
      }

      for (var element in result) {
        print(element);
        var item = new OptionsModel(
            name: element['email'].toString(),
            values: element['full_name'].toString(),
            flag: tabName);
        optionsModel.add(item);
        print("it ${item.name}");
      }
    }
    return optionsModel;
  }
   Future<List<OptionsModel>> callPartnerStockOptions(String tableName,
      String lang, String parent, int creche_id, int month, int year) async {
    var tabName = 'tab$tableName';
    List<OptionsModel> options = [];
    List<PartnerStockModel> partnetStock = [];

    if (parent == 'Stock Child table') {
      partnetStock = await PartnerStockHelper().getAllRecords();
    } else
      partnetStock =
          await PartnerStockHelper().getNotAddedItems(creche_id, year, month);
    for (var elements in partnetStock) {
      var value = elements.items.toString().trim();
      if (lang == 'hi' && Global.validString(elements.hindi.toString())) {
        value = elements.hindi.toString().trim();
      } else if (lang == 'od' && Global.validString(elements.odia.toString())) {
        value = elements.odia.toString().trim();
      }
      var itemModel = new OptionsModel(
          name: elements.name.toString(), flag: tabName, values: value);
      options.add(itemModel);
    }
    return options;
  }

  Future<List<OptionsModel>> callCrechInOption(
      String tableName, int creche_id) async {
    var tabName = 'tab$tableName';
    List<OptionsModel> optionsModel = [];
    var crecheLocationWise =
        await CrecheDataHelper().getCrecheResponceItem(creche_id);
    if (crecheLocationWise.length > 0) {
      crecheLocationWise.forEach((element) {
        var item = OptionsModel(
            name: element.name.toString(),
            values: Global.getItemValues(element.responces!, 'creche_name'),
            flag: tabName);
        optionsModel.add(item);
      });
    }

    return optionsModel;
  }

 
  Future<List<OptionsModel>> callCrechInOptionID(
      String tableName, int crecheNameId) async {
    var tabName = 'tab$tableName';
    List<OptionsModel> optionsModel = [];
    var crecheLocationWise =
        await CrecheDataHelper().getCrecheResponceItem(crecheNameId);
    if (crecheLocationWise.length > 0) {
      crecheLocationWise.forEach((element) {
        var item = OptionsModel(
            name: element.name.toString(),
            values: Global.getItemValues(element.responces!, 'creche_name'),
            flag: tabName);
        optionsModel.add(item);
      });
    }

    return optionsModel;
  }

  Future<List<OptionsModel>> callCrechInOptionAll(String tableName) async {
    var tabName = 'tab$tableName';
    List<OptionsModel> optionsModel = [];
    var crecheLocationWise = await CrecheDataHelper().getCrecheResponce();
    if (crecheLocationWise.length > 0) {
      crecheLocationWise.forEach((element) {
        var item = OptionsModel(
            name: element.name.toString(),
            values: Global.getItemValues(element.responces!, 'creche_name'),
            flag: tabName);
        optionsModel.add(item);
      });
    }

    return optionsModel;
  }

  String callLocationTranlateValue(
      String tabName, Map<String, Object?> item, String lng) {
    String value = '';
    if (tabName == 'State') {
      if (lng == 'hi' && Global.validString(item['state_hi'].toString())) {
        value = item['state_hi'].toString();
      } else if (lng == 'od' &&
          Global.validString(item['state_od'].toString())) {
        value = item['state_od'].toString();
      } else
        value = item['value'].toString();
    } else if (tabName == 'District') {
      if (lng == 'hi' && Global.validString(item['district_hi'].toString())) {
        value = item['district_hi'].toString();
      } else if (lng == 'od' &&
          Global.validString(item['district_od'].toString())) {
        value = item['district_od'].toString();
      } else
        value = item['value'].toString();
    } else if (tabName == 'Block') {
      if (lng == 'hi' && Global.validString(item['block_hi'].toString())) {
        value = item['block_hi'].toString();
      } else if (lng == 'od' &&
          Global.validString(item['block_od'].toString())) {
        value = item['block_od'].toString();
      } else
        value = item['value'].toString();
    } else if (tabName == 'Gram Panchayat') {
      if (lng == 'hi' && Global.validString(item['gp_hi'].toString())) {
        value = item['gp_hi'].toString();
      } else if (lng == 'od' && Global.validString(item['gp_od'].toString())) {
        value = item['gp_od'].toString();
      } else
        value = item['value'].toString();
    } else if (tabName == 'Village') {
      if (lng == 'hi' && Global.validString(item['village_hi'].toString())) {
        value = item['village_hi'].toString();
      } else if (lng == 'od' &&
          Global.validString(item['village_od'].toString())) {
        value = item['village_od'].toString();
      } else
        value = item['value'].toString();
    }
    return value;
  }
}

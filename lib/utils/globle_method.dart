import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../model/apimodel/translation_language_api_model.dart';
import '../model/databasemodel/tabBlock_model.dart';
import '../model/databasemodel/tabDistrict_model.dart';
import '../model/databasemodel/tabGramPanchayat_model.dart';
import '../model/databasemodel/tabVillage_model.dart';
import '../model/databasemodel/tabstate_model.dart';
import '../model/dynamic_screen_model/options_model.dart';

class Global {
  static validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter valid E-Mail Address';
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Your User Id';
    }

    return null;
  }

  static double callPercentage(int totalValue, int percentage) {
    return (percentage / totalValue) * 100;
  }

  static validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Your Mobile no.';
    }
    if (value.trim().length < 10) {
      return 'Mobile must be at least 10 digits';
    }
    return null;
  }

  static validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'enter your password';
    }
    if (value.trim().length < 8) {
      return "Password must be at least 8 Numbers in length";
    }
    return null;
  }

  static bool validString(String? value) {
    if (value == null || value.isEmpty || value == 'null')
      return false;
    else
      return true;
  }

  static String validToString(String? value) {
    if (value != null) {
      if (value == 'null' || value.isEmpty) {
        return '';
      } else {
        return value.toString();
      }
    } else {
      return '';
    }
  }

  static bool validToBool(bool? isSelected) {
    if (isSelected != null) {
      return isSelected;
    } else {
      return false;
    }
  }

  static int validToInt(int? value) {
    if (value != null) {
      return value;
    } else {
      return 0;
    }
  }

  static String getItemValues(String? response, String key) {
    String returnValue = "";
    if (validString(response)) {
      Map<String, dynamic> itemresponse = jsonDecode(response!);
      var value = itemresponse[key];
      if (value != null) {
        returnValue = value.toString();
        print(" keyvalue $key $returnValue");
      }
    }
    return returnValue;
  }

  static int stringToInt(String? value) {
    try {
      if (Global.validString(value))
        return int.parse(value!);
      else
        return 0;
    } on Exception {
      return 0;
    }
  }

  static int? stringToIntNull(String? value) {
    try {
      if (Global.validString(value))
        return int.parse(value!);
      else
        return null;
    } on Exception {
      return null;
    }
  }

  static double stringToDouble(String? value) {
    try {
      if (Global.validString(value))
        return double.parse(value!);
      else
        return 0;
    } on Exception {
      return 0;
    }
  }

  static double roundToNearestHalf(double number) {
    return (number * 2).ceil() / 2;
  }
  static double roundToNearest(double number) {
    print(double.parse(number.toStringAsFixed(1)));
    return double.parse(number.toStringAsFixed(1));
  }

  static String intToString(int? value) {
    try {
      return validToString('$value');
    } on Exception {
      return "";
    }
  }

  static double validNum(String? values) {
    try {
      print(double.parse(values.toString()));
      return double.parse(values.toString());
    } on Exception {
      return 0;
    }
  }

  static List<String> splitData(String? values, String rejex) {
    if (validString(values)) {
      return values!.split(rejex);
    } else {
      return [];
    }
  }

  static num retrunValidNum(num? values) {
    try {
      if (values != null) {
        return values;
      } else
        return 0;
    } on Exception {
      return 0;
    }
  }

  static String returnTrLable(
      List<Translation> translats, String? key, String lang) {
    String retuValue = '';
    if (key != null) {
      retuValue = key;
      if (Global.validString(lang)) {
        //  if (!(lang == 'en')) {
        var trs = translats
            .where(
                (element) => element.name!.toLowerCase() == key.toLowerCase())
            .toList();
        if (trs.length > 0) {
          if (lang == "hi") {
            retuValue = trs[0].hindi!;
          } else if (lang == "od") {
            retuValue = trs[0].odia!;
          } else if (lang == "en") {
            retuValue = trs[0].english!;
          }
        } else {
          retuValue = key;
        }
        // }else{retuValue = key;}
      }
    } else
      retuValue = '';
    return retuValue;
  }

  static String errorBodyToString(String? errorBody, String key) {
    try {
      if (errorBody != null) {
        var mesg = jsonDecode(errorBody);
        var msg = mesg[key];
        if (Global.validString(msg)) {
          return msg;
        } else
          return "Server error!";
      } else
        return "Server error!";
    } on Exception {
      return "Server error!";
    }
  }

  static String errorBodyToStringFromList(String? errorBody) {
    if (errorBody != null) {
      try {
        var mesg = jsonDecode(errorBody);
        if (mesg != null && mesg is Map) {
          String jsonString = mesg["_server_messages"];
          List<dynamic> messageList = jsonDecode(jsonString);
          if (messageList.isNotEmpty) {
            var message = jsonDecode(messageList[0]);
            var msg = message['message'];
            print("Message: $msg");
            return msg;
          } else {
            return 'Something Went wrong!.';
          }
        } else {
          return 'Something Went wrong!.';
        }
      } catch (e) {
        print("Error decoding JSON: $e");
        return 'Something Went wrong!.';
      }
    } else {
      return 'Something Went wrong!.';
    }
  }

  static DateTime? stringToDate(String? date) {
    try {
      if (Global.validString(date)) {
        var split = date!.split('-');
        if (split.length == 3) {
          int year = int.parse(split[0]);
          int month = int.parse(split[1]);
          int day = int.parse(split[2]);
          return DateTime(year, month, day);
        }
        return null;
      } else
        return null;
    } on Exception {
      return null;
    }
  }

  static String initCurrentDate() {
    String currentDate = "";
    currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return currentDate;
  }

  static List<OptionsModel> callFiltersVillages(
      List<TabVillage> villages, String lng, OptionsModel? parentItem) {
    List<OptionsModel> teVillage = [];
    if (parentItem != null && villages.length > 0) {
      villages =
          villages.where((element) => element.gpId == parentItem.name).toList();
      villages.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabVillage";
        var value = "${element.value}";
        if (lng == 'hi' && Global.validString(element.village_hi.toString())) {
          value = element.village_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(element.village_od.toString())) {
          value = element.village_od.toString();
        }
        item.values = value;
        teVillage.add(item);
      });
    }
    return teVillage;
  }

  static List<OptionsModel> callGramPanchyats(
      List<TabGramPanchayat> gp, String lng, OptionsModel? parentItem) {
    List<OptionsModel> teGramP = [];
    if (parentItem != null && gp.length > 0) {
      gp = gp.where((element) => element.blockId == parentItem.name).toList();
      gp.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabGram Panchayat";
        var value = "${element.value}";
        if (lng == 'hi' && Global.validString(element.gp_hi.toString())) {
          value = element.gp_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(element.gp_od.toString())) {
          value = element.gp_od.toString();
        }
        item.values = value;
        teGramP.add(item);
      });
    }
    return teGramP;
  }

  static List<OptionsModel> callBlocks(
      List<TabBlock> bloks, String lng, OptionsModel? parentItem) {
    List<OptionsModel> teBlock = [];
    if (parentItem != null && bloks.length > 0) {
      bloks = bloks
          .where((element) => element.districtId == parentItem.name)
          .toList();
      bloks.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabBlock";
        var value = "${element.value}";
        if (lng == 'hi' && Global.validString(element.block_hi.toString())) {
          value = element.block_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(element.block_od.toString())) {
          value = element.block_od.toString();
        }
        item.values = value;
        teBlock.add(item);
      });
    }
    return teBlock;
  }

  static List<OptionsModel> callDistrict(
      List<TabDistrict> districts, String lng, OptionsModel? parentItem) {
    List<OptionsModel> teDistrict = [];
    if (parentItem != null && districts.length > 0) {
      districts = districts
          .where((element) => element.stateId == parentItem.name)
          .toList();
      districts.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabDistrict";
        var value = "${element.value}";
        if (lng == 'hi' && Global.validString(element.district_hi.toString())) {
          value = element.district_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(element.district_od.toString())) {
          value = element.district_od.toString();
        }
        item.values = value;
        teDistrict.add(item);
      });
    }
    return teDistrict;
  }

  static List<OptionsModel> callSatates(List<TabState> states, String lng) {
    List<OptionsModel> teStates = [];
    if (states.length > 0) {
      states.forEach((element) {
        var item = OptionsModel();
        item.name = "${element.name}";
        item.flag = "tabState";
        var value = "${element.value}";
        if (lng == 'hi' && Global.validString(element.state_hi.toString())) {
          value = element.state_hi.toString();
        } else if (lng == 'od' &&
            Global.validString(element.state_od.toString())) {
          value = element.state_od.toString();
        }
        item.values = value;
        teStates.add(item);
      });
    }
    return teStates;
  }
}
